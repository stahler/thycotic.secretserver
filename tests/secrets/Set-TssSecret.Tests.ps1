BeforeDiscovery {
    $commandName = Split-Path ($PSCommandPath.Replace('.Tests.ps1','')) -Leaf
    . ([IO.Path]::Combine([string]$PSScriptRoot, '..', 'constants.ps1'))
}
Describe "$commandName verify parameters" {
    BeforeDiscovery {
        [object[]]$knownParameters = 'TssSession', 'Id',
        <# Restricted params #>
        'Comment', 'ForceCheckIn', 'TicketNumber', 'TicketSystemId',

        <# CheckIn #>
        'CheckIn',

        <# General settings #>
        'Active', 'EnableInheritSecretPolicy', 'FolderId', 'GenerateSshKeys', 'HeartbeatEnabled', 'SecretPolicy', 'Site', 'Template','IsOutOfSync', 'SecretName',

        <# Other params for PUT /secrets/{id} endpoint #>
        'AutoChangeEnabled', 'AutoChangeNextPassword', 'EnableInheritPermission'

        [object[]]$currentParams = ([Management.Automation.CommandMetaData]$ExecutionContext.SessionState.InvokeCommand.GetCommand($commandName, 'Function')).Parameters.Keys
        [object[]]$commandDetails = [System.Management.Automation.CommandInfo]$ExecutionContext.SessionState.InvokeCommand.GetCommand($commandName,'Function')
        $unknownParameters = Compare-Object -ReferenceObject $knownParameters -DifferenceObject $currentParams -PassThru
    }
    Context "Verify parameters" -ForEach @{currentParams = $currentParams } {
        It "$commandName should contain <_> parameter" -TestCases $knownParameters {
            $_ -in $currentParams | Should -Be $true
        }
        It "$commandName should not contain parameter: <_>" -TestCases $unknownParameters {
            $_ | Should -BeNullOrEmpty
        }
    }
    Context "Command specific details" {
        # This command is written to not output an object. Nothing if successful, else it writes out the error
    }
}

Describe "$commandName works" -Skip:$tssTestUsingWindowsAuth {
    BeforeDiscovery {
        $invokeParams = @{}
        if ($tssTestUsingWindowsAuth) {
            $session = New-TssSession -SecretServer $ss -UseWindowsAuth
            $invokeParams.UseDefaultCredentials = $true
        } else {
            $session = New-TssSession -SecretServer $ss -Credential $ssCred
            $invokeParams.PersonalAccessToken = $session.AccessToken
        }

        $invokeParams.Uri = $session.ApiUrl, "folders?take=$($session.take)" -join '/'
        $invokeParams.ExpandProperty = 'records'
        $getFolder = Invoke-TssRestApi @invokeParams | Where-Object Folderpath -EQ '\tss_module_testing\SetTssSecret'

        $getSecrets = Find-TssSecret -TssSession $session -FolderId $getFolder.id -IncludeInactive:$false

        $secretId = $getSecrets.Where( { $_.SecretName -match 'Test Setting General Settings' }).SecretId
        $setGeneral = Get-TssSecret -TssSession $session -Id $secretId
        $secretId = $getSecrets.Where( { $_.SecretName -match 'Test Setting Restricted General Settings' }).SecretId
        $setRestrictedGeneral = Get-TssSecret -TssSession $session -Id $secretId -Comment "tssModule Test execution"

        $secretId = $getSecrets.Where( { $_.SecretName -eq 'Test Setting AutoChangeEnabled AutoChangeNextPassword EnableInheritPermissions' }).SecretId
        $setOther = Get-TssSecret -TssSession $session -Id $secretId
    }
    Context "Sets general settings of a secret" -ForEach @{setGeneral = $setGeneral;setRestrictedGeneral = $setRestrictedGeneral; session = $session } {
        AfterAll {
            $invokeParams = @{}
            if ($tssTestUsingWindowsAuth) {
                $session = New-TssSession -SecretServer $ss -UseWindowsAuth
                $invokeParams.UseDefaultCredentials = $true
            } else {
                $session = New-TssSession -SecretServer $ss -Credential $ssCred
                $invokeParams.PersonalAccessToken = $session.AccessToken
            }
            $invokeParams.Uri = $session.ApiUrl, 'secrets', $setRestrictedGeneral.Id, 'check-in' -join '/'
            $invokeParams.Method = 'POST'
            $invokeParams.Remove('ExpandProperty')
            Invoke-TssRestApi @invokeParams
        }
        <# not going to test all of them, just enough #>
        It "Should set Name" {
            $newName = "Test Setting General Settings $(Get-Random)"
            Set-TssSecret -TssSession $session -Id $setGeneral.Id -SecretName $newName | Should -BeNullOrEmpty
        }
        It "Should set HeartbeatEnabled" {
            Set-TssSecret -TssSession $session -Id $setGeneral.Id -HeartbeatEnabled:$false | Should -BeNullOrEmpty
        }
        It "Should set Active" {
            Set-TssSecret -TssSession $session -Id $setGeneral.Id -Active | Should -BeNullOrEmpty
        }
        It "Should set Name on Restricted Secret (require checkout/comment)" {
            $newRestrictedName = "Test Setting Restricted General Settings $(Get-Random)"
            Set-TssSecret -TssSession $session -Id $setRestrictedGeneral.Id -SecretName $newRestrictedName
        }
    }
    Context "Sets other settings of a secret" -ForEach @{setOther = $setOther;session = $session } {
        It "Should set AutoChangeEnabled" {
            Set-TssSecret -TssSession $session -Id $setOther.Id -AutoChangeEnabled | Should -BeNullOrEmpty
        }
        It "Should set AutoChangeNextPassword" {
            $secureString = ConvertTo-SecureString -String ("tssModuleWasHere$((New-Guid).Guid)") -AsPlainText -Force
            Set-TssSecret -TssSession $session -Id $setOther.Id -AutoChangeNextPassword $secureString | Should -BeNullOrEmpty
        }
        It "Should set EnableInheritPermissions" {
            Set-TssSecret -TssSession $session -Id $setOther.Id -EnableInheritPermission | Should -BeNullOrEmpty
        }
    }
}