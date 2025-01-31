BeforeDiscovery {
    $commandName = Split-Path ($PSCommandPath.Replace('.Tests.ps1','')) -Leaf
    . ([IO.Path]::Combine([string]$PSScriptRoot, '..', 'constants.ps1'))
}
Describe "$commandName verify parameters" {
    BeforeDiscovery {
        [object[]]$knownParameters = 'TssSession', 'SortBy', 'Permission','Scope',
        # Folder param set
        'FolderId', 'IncludeSubFolders',
        # field param set
        'Field', 'SearchText', 'ExactMatch', 'FieldSlug', 'ExtendedField', 'ExtendedTypeId',
        # secret param set
        'SecretTemplateId', 'SiteId', 'HeartbeatStatus', 'IncludeInactive', 'ExcludeActive', 'RpcEnabled', 'SharedWithMe', 'PasswordTypeIds', 'ExcludeDoubleLock', 'DoubleLockId'
        [object[]]$currentParams = ([Management.Automation.CommandMetaData]$ExecutionContext.SessionState.InvokeCommand.GetCommand($commandName, 'Function')).Parameters.Keys
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
        It "$commandName should set OutputType to TssSecretSummary" -TestCases $commandDetails {
            $_.OutputType.Name | Should -Be 'TssSecretSummary'
        }
    }
}
Describe "$commandName works" {
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

        $getFolders = Invoke-TssRestApi @invokeParams
        $tssSecretFolder = $getFolders.Where({$_.folderPath -match '\tss_module_testing\SearchTssSecret'})

        $objectRpc = Search-TssSecret $session -RpcEnabled -SecretTemplateId 6001 -FolderId $tssSecretFolder.Id
        $object = Search-TssSecret $session -FolderId $tssSecretFolder.Id -IncludeSubFolders
        $props = 'SecretId','FolderId','SecretTemplateId','Name'

        if (-not $tssTestUsingWindowsAuth) {
            $session.SessionExpire()
        }
    }
    Context "Checking" -Foreach @{object = $object; objectRpc = $objectRpc} {
        It "Should not be empty" {
            $object | Should -Not -BeNullOrEmpty
        }
        It "Should find a secret with RPC enabled" {
            $objectRpc.Count | Should -BeGreaterOrEqual 1
        }
        It "Should return more than one secret" {
            $object.Count | Should -BeGreaterOrEqual 2
        }
        It "Should output <_> property" -TestCases $props {
            $object[0].PSObject.Properties.Name | Should -Contain $_
        }
    }
}