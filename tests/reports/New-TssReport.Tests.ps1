BeforeDiscovery {
    $commandName = Split-Path ($PSCommandPath.Replace('.Tests.ps1','')) -Leaf
    . ([IO.Path]::Combine([string]$PSScriptRoot,'..','constants.ps1'))
}
Describe "$commandName verify parameters" {
    BeforeDiscovery {
        [object[]]$knownParameters = 'TssSession', 'ReportName', 'CategoryId', 'ReportSql', 'Description', 'ChartType', 'Is3DReport', 'PageSize', 'Paging'
        [object[]]$currentParams = ([Management.Automation.CommandMetaData]$ExecutionContext.SessionState.InvokeCommand.GetCommand($commandName,'Function')).Parameters.Keys
        [object[]]$commandDetails = [System.Management.Automation.CommandInfo]$ExecutionContext.SessionState.InvokeCommand.GetCommand($commandName,'Function')
        $unknownParameters = Compare-Object -ReferenceObject $knownParameters -DifferenceObject $currentParams -PassThru
    }
    Context "Verify parameters" -Foreach @{currentParams = $currentParams} {
        It "$commandName should contain <_> parameter" -TestCases $knownParameters {
            $_ -in $currentParams | Should -Be $true
        }
        It "$commandName should not contain parameter: <_>" -TestCases $unknownParameters {
            $_ | Should -BeNullOrEmpty
        }
    }
    Context "Command specific details" {
        It "$commandName should set OutputType to TssReport" -TestCases $commandDetails {
            $_.OutputType.Name | Should -Be 'TssReport'
        }
    }
}
Describe "$commandName works" {
    BeforeDiscovery {
        $invokeParams = @{}
        $reportName = ("TssTestReport$(Get-Random)")
        if ($tssTestUsingWindowsAuth) {
            $session = New-TssSession -SecretServer $ss -UseWindowsAuth
            $invokeParams.UseDefaultCredentials = $true
        } else {
            $session = New-TssSession -SecretServer $ss -Credential $ssCred
            $invokeParams.PersonalAccessToken = $session.AccessToken
        }

        $categoryId = (Get-TssReportCategory -TssSession $session -All).Where({$_.Name -eq 'tssModuleTest'}).CategoryId
        if ($null -eq $categoryId) {
            $bodData = @{
                data = @{
                    reportCategoryDescription = 'tss Module test category'
                    reportCategoryName = 'tssModuleTest'
                }
            } | ConvertTo-Json
            # bug in endpoint where it won't return the Category ID properly
            $invokeParams.Uri = $($session.ApiUrl), "reports/categories" -join '/'
            Invoke-TssRestApi @invokeParams -Method 'POST' -Body $bodData > $null
            $categoryId = (Get-TssReportCategory -TssSession $session -All).Where({$_.Name -eq 'tssModuleTest'}).CategoryId
        }

        $newReport = @{
            TssSession = $session
            ReportName = $reportName
            CategoryId = $categoryId
            Description = "Tss Module Test report"
            ReportSql = "SELECT 1"
        }
        $object  = New-TssReport @newReport
        $props = 'ReportId', 'Id', 'CategoryId', 'Name', 'ReportSql'

        # delete report created
        $invokeParams.Uri = $session.ApiUrl, "reports/$($object.Id)" -join '/'
        $invokeParams.Remove('ExpandProperty') > $null
        Invoke-TssRestApi @invokeParams -Method DELETE > $null
        Remove-TssReportCategory -TssSession $session -ReportCategoryId $categoryId -Confirm:$false > $null

        if (-not $tssTestUsingWindowsAuth) {
            $session.SessionExpire()
        }
    }
    Context "Checking" -Foreach @{object = $object} {
        It "Should not be empty" {
            $object | Should -Not -BeNullOrEmpty
        }
        It "Should output <_> property" -TestCases $props {
            $object.PSObject.Properties.Name | Should -Contain $_
        }
    }
}