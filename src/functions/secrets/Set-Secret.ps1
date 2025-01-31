function Set-Secret {
    <#
    .SYNOPSIS
    Set various settings or fields for a given secret

    .DESCRIPTION
    Set various settings or fields for a given secret.

    .EXAMPLE
    $session = New-TssSession -SecretServer https://alpha -Credential $ssCred
    Set-TssSecret -TssSession $session -Id 345 -FolderId 3

    Move Secret 345 to folder ID 3

    .EXAMPLE
    $session = New-TssSession -SecretServer https://alpha -Credential $ssCred
    Set-TssSecret -TssSession $session -Id 113 -ForceCheckIn

    Sets secret 1455 disables emailing when changed

    .LINK
    https://thycotic-ps.github.io/thycotic.secretserver/commands/Set-TssSecret

    .LINK
    https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/secrets/Set-Secret.ps1

    .NOTES
    Requires TssSession object returned by New-TssSession
    #>
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = 'all')]
    param(
        # TssSession object created by New-TssSession for auth
        [Parameter(Mandatory,ValueFromPipeline,Position = 0)]
        [TssSession]
        $TssSession,

        # Secret Id to modify
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [Alias("SecretId")]
        [int[]]
        $Id,

        # Comment to provide for restricted secret (Require Comment is enabled)
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'restricted')]
        [string]
        $Comment,

        # Force check-in of the Secret
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'restricted')]
        [Parameter(ParameterSetName = 'checkIn')]
        [switch]
        $ForceCheckIn,

        # Associated Ticket Number
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'restricted')]
        [int]
        $TicketNumber,

        #Associated Ticket System ID
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'restricted')]
        [int]
        $TicketSystemId,

        # Set the secret active secret is active
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'general')]
        [switch]
        $Active,

        # Whether Auto Change is enabled
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'password')]
        [switch]
        $AutoChangeEnabled,

        # Manual password to use on next Auto Change
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'password')]
        [securestring]
        $AutoChangeNextPassword,

        # Whether the Secret inherits permissions from the containing folder
        [Parameter(ParameterSetName = 'all')]
        [Alias('EnableInheritPermissions')]
        [switch]
        $EnableInheritPermission,

        # Whether Secret Policy is inherited from containing folder
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'general')]
        [switch]
        $EnableInheritSecretPolicy,

        # Folder (ID)
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'general')]
        [Alias('Folder')]
        [int]
        $FolderId,

        # Generate new SSH Keys
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'general')]
        [switch]
        $GenerateSshKeys,

        # Heartbeat enabled
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'general')]
        [switch]
        $HeartbeatEnabled,

        # Secret out of sync
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'general')]
        [switch]
        $IsOutOfSync,

        # Secret name
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'general')]
        [string]
        $SecretName,

        # Secret Policy (ID)
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'general')]
        [int]
        $SecretPolicy,

        # Secret Site
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'general')]
        [Alias('Site')]
        [int]
        $SiteId,

        # Check-In a Secret, can be combined with ForceCheckIn to forcibly check the Secret in
        [Parameter(ParameterSetName = 'all')]
        [Parameter(ParameterSetName = 'checkIn')]
        [switch]
        $CheckIn
    )
    begin {
        $setSecretParams = $PSBoundParameters

        $generalParamSet = . $ParameterSetParams $PSCmdlet.MyInvocation.MyCommand.Name 'general'

        # Need to know if any of the params provided are in the specific parameter sets
        # if they are not we will null out the variable so the code below is not triggered
        $generalParams = @()
        foreach ($g in $generalParamSet) {
            if ($setSecretParams.ContainsKey($g)) {
                $generalParams += $g
            }
        }

        # Require Get-TssSecret and PUT /secrets/{id} endpoint
        $passwordParamSet = . $ParameterSetParams $PSCmdlet.MyInvocation.MyCommand.Name 'password'
        $folderParamSet = . $ParameterSetParams $PSCmdlet.MyInvocation.MyCommand.Name 'folder'
        $otherParams = @()
        foreach ($p in $passwordParamSet) {
            if ($setSecretParams.ContainsKey($p)) {
                $otherParams += $p
            }
        }
        foreach ($f in $folderParamSet) {
            if ($setSecretParams.ContainsKey($f)) {
                $otherParams += $f
            }
        }

        # restricted params
        $restrictedParamSet = . $ParameterSetParams $PSCmdlet.MyInvocation.MyCommand.Name 'restricted'
        $restrictedParams = @()
        foreach ($r in $restrictedParamSet) {
            if ($setSecretParams.ContainsKey($r)) {
                $restrictedParams += $r
            }
        }

        $invokeParamsGenearl = . $GetInvokeTssParams $TssSession
        $invokeParamsOther = . $GetInvokeTssParams $TssSession
        $invokeParamsCheckIn = . $GetInvokeTssParams $TssSession
    }
    process {
        Write-Verbose "Provided command parameters: $(. $GetInvocation $PSCmdlet.MyInvocation)"
        if ($setSecretParams.ContainsKey('TssSession') -and $TssSession.IsValidSession()) {
            . $CheckVersion $TssSession '10.9.000000' $PSCmdlet.MyInvocation
            foreach ($secret in $Id) {
                if ($otherParams.Count -gt 0) {
                    $uri = $TssSession.ApiUrl, 'secrets', $secret -join '/'
                    $invokeParamsOther.Uri = $uri
                    $invokeParamsOther.Method = 'PUT'

                    $whatIfProcessing = 0
                    if ($setSecretParams.ContainsKey('AutoChangeEnabled') -and -not $PSCmdlet.ShouldProcess("SecretId: $secret", "$($invokeParamsOther.Method) $uri updating AutoChangeEnabled to $AutoChangeEnabled")) {
                        $whatIfProcessing++
                    }
                    if ($setSecretParams.ContainsKey('AutoChangeNextPassword') -and -not $PSCmdlet.ShouldProcess("SecretId: $secret", "$($invokeParamsOther.Method) $uri updating AutoChangeNextPassword to $AutoChangeNextPassword")) {
                        $whatIfProcessing++
                    }
                    if ($setSecretParams.ContainsKey('EnableInheritPermission') -and -not $PSCmdlet.ShouldProcess("SecretId: $secret", "$($invokeParamsOther.Method) $uri updating Inherit Permission to $EnableInheritPermission")) {
                        $whatIfProcessing++
                    }

                    $getParams = @{
                        TssSession = $TssSession
                        Id         = $secret
                    }
                    if ($restrictedParams.Count -gt 0) {
                        $getParams.Add('ForceCheckIn', $ForceCheckIn)
                        $getParams.Add('TicketNumber', $TicketNumber)
                        $getParams.Add('TicketSystemId', $TicketSystemId)
                        $getParams.Add('Comment', $Comment)
                    }
                    if (-not $PSCmdlet.ShouldProcess("SecretId: $secret", "Getting Secret")) {
                        $whatIfProcessing++
                    }

                    if ($whatIfProcessing -eq 0) {
                        try {
                            Write-Verbose "Getting SecretID: [$secret]"
                            $getSecret = . $GetSecret $TssSession $secret $restrictedParams
                        } catch {
                            Write-Error "Issue getting Secret [$secret] details: $_"
                        }

                        if ($getSecret) {
                            if ($restrictedParams.Count -gt 0) {
                                $getSecret.Add('ForceCheckIn', $ForceCheckIn)
                                $getSecret.Add('TicketNumber', $TicketNumber)
                                $getSecret.Add('TicketSystemId', $TicketSystemId)
                                $getSecret.Add('Comment', $Comment)
                            }

                            if ($setSecretParams.ContainsKey('AutoChangeEnabled')) {
                                $getSecret.AutoChangeEnabled = [boolean]$AutoChangeEnabled
                            }
                            if ($setSecretParams.ContainsKey('AutoChangeNextPassword')) {
                                if ($setSecretParams.ContainsKey('AutoChangeEnabled') -and -not $AutoChangeEnabled) {
                                    Write-Warning "AutoChangeNextPassword requires AutoChange to be enabled. Please provide -AutoChangeEnabled parameter to enable it and set next manual password on secret [$secret]."
                                } elseif ($getSecret.AutoChangeEnabled -eq $false -and -not $AutoChangeEnabled) {
                                    Write-Warning "AutoChangeNextPassword require AutoChange to be enabled. AutoChange found disabled on secret [$secret]. Please provide -AutoChangeEnabled parameter to enable it and set next manual password."
                                } else {
                                    $getSecret.AutoChangeNextPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($AutoChangeNextPassword))
                                }
                            }
                            if ($setSecretParams.ContainsKey('EnableInheritPermission')) { $getSecret.EnableInheritPermissions = $EnableInheritPermission }
                            $invokeParamsOther.Body = $getSecret | ConvertTo-Json -Depth 5

                            Write-Verbose "$($invokeParamsOther.Method) $uri with:`t$($invokeParamsOther.Body)`n"
                            try {
                                $otherResponse = . $InvokeApi @invokeParamsOther
                            } catch {
                                Write-Warning "Issue setting property on secret [$secret]"
                                $err = $_
                                . $ErrorHandling $err
                            }

                            if ($otherResponse.PSObject.Properties.Name -contains 'AutoChangeEnabled' -and $setSecretParams.ContainsKey('AutoChangeEnabled')) {
                                if ($otherResponse.AutoChangeEnabled -eq $AutoChangeEnabled) {
                                    Write-Verbose "Secret [$secret] AutoChangeEnabled was set to $AutoChangeEnabled"
                                }
                            }
                            if ($otherResponse.PSObject.Properties.Name -contains 'AutoChangeNextPassword' -and $setSecretParams.ContainsKey('AutoChangeNextPassword')) {
                                if ($otherResponse.AutoChangeNextPassword -eq $AutoChangeNextPassword) {
                                    Write-Verbose "Secret [$secret] AutoChangeNextPassword was set to $AutoChangeNextPassword"
                                }
                            }
                            if ($otherResponse.PSObject.Properties.Name -contains 'EnableInheritPermissions' -and $setSecretParams.ContainsKey('EnableInheritPermission')) {
                                if ($otherResponse.EnableInheritPermissions -eq $EnableInheritPermission) {
                                    Write-Verbose "Secret [$secret] EnableInheritPermissions was set to $EnableInheritPermission"
                                }
                            }
                        }
                    }
                }
                if ($generalParams.Count -gt 0) {
                    Write-Verbose "Working on general parameter set values"
                    # data object for General Settings
                    # Each object added to data requires dirty (true) and value property
                    $generalBody = @{
                        data = @{ }
                    }

                    if ($setSecretParams.ContainsKey('Active')) {
                        $setActive = @{
                            dirty = $true
                            value = [boolean]$Active
                        }
                        $generalBody.data.Add('active',$setActive)
                    }
                    if ($setSecretParams.ContainsKey('EnableInheritSecretPolicy')) {
                        $setInheritance = @{
                            dirty = $true
                            value = [boolean]$EnableInheritSecretPolicy
                        }
                        $generalBody.data.Add('enableInheritSecretPolicy',$setInheritance)
                    }
                    if ($setSecretParams.ContainsKey('FolderId')) {
                        $setFolder = @{
                            dirty = $true
                            value = $FolderId
                        }
                        $generalBody.data.Add('folder',$setFolder)
                    }
                    if ($setSecretParams.ContainsKey('GenerateSshKeys')) {
                        #does not require dirty and value properties
                        $generalBody.data.Add('generateSshKeys', [boolean]$GenerateSshKeys)
                    }
                    if ($setSecretParams.ContainsKey('HeartbeatEnabled')) {
                        $setHb = @{
                            dirty = $true
                            value = "$HeartbeatEnabled"
                        }
                        $generalBody.data.Add('heartbeatEnabled',$setHb)
                    }
                    if ($setSecretParams.ContainsKey('SecretPolicy')) {
                        $setSecretPolicy = @{
                            dirty = $true
                            value = $SecretPolicy
                        }
                        $generalBody.data.Add('secretPolicy',$setSecretPolicy)
                    }
                    if ($setSecretParams.ContainsKey('SiteId')) {
                        $setSite = @{
                            dirty = $true
                            value = $SiteId
                        }
                        $generalBody.data.Add('site',$setSite)
                    }
                    if ($setSecretParams.ContainsKey('IsOutOfSync')) {
                        $setOutOfSync = @{
                            dirty = $true
                            value = [boolean]$IsOutOfSync
                        }
                        $generalBody.data.Add('isOutOfSync',$setOutOfSync)
                    }
                    if ($setSecretParams.ContainsKey('SecretName')) {
                        $setName = @{
                            dirty = $true
                            value = $SecretName
                        }
                        $generalBody.data.Add('name',$setName)
                    }

                    $uri = $TssSession.ApiUrl, 'secrets', $secret, 'general' -join '/'
                    $invokeParamsGenearl.Uri = $uri
                    $invokeParamsGenearl.Method = 'PATCH'
                    $invokeParamsGenearl.Body = $generalBody | ConvertTo-Json -Depth 5

                    if ($PSCmdlet.ShouldProcess("SecretId: $secret", "$($invokeParamsGenearl.Method) $uri with:`n$($invokeParamsGenearl.Body)`n")) {
                        Write-Verbose "$($invokeParamsGenearl.Method) $uri with:`n$($invokeParamsGenearl.Body)`n"
                        try {
                            $generalResponse = . $InvokeApi @invokeParamsGenearl
                        } catch {
                            Write-Warning "Issue configuring general settings on [$secret]"
                            $err = $_
                            . $ErrorHandling $err
                        }

                        if ($generalResponse.id -eq $secret -and $generalResponse.name.value -eq $SecretName) {
                            Write-Verbose "Secret [$secret] name set to [$($generalResponse.name.value)]"
                        }
                        if ($generalResponse.id -eq $secret -and $generalResponse.active.value -eq $Active) {
                            Write-Verbose "Secret [$secret] Active set to [$($generalResponse.active.value)]"
                        }
                    }
                }
                if ($setSecretParams.ContainsKey('CheckIn')) {
                    Write-Verbose "Working on check-in"
                    $uri = $TssSession.ApiUrl, 'secrets', $secret, 'check-in' -join '/'
                    $invokeParamsCheckIn.Uri = $uri
                    $invokeParamsCheckIn.Method = 'POST'

                    $checkInBody = @{}
                    if ($restrictedParams.Count -gt 0) {
                        switch ($restrictedParams) {
                            'Comment' { $checkInBody.Add('comment', $Comment) }
                            'ForceCheckIn' { $checkInBody.Add('forceCheckIn', [boolean]$ForceCheckIn) }
                            'TicketNumber' { $checkInBody.Add('ticketNumber', $TicketNumber) }
                            'TicketSystemId' { $checkInBody.Add('ticketSystemId', $TicketSystemId) }
                        }
                    }

                    $uri = $TssSession.ApiUrl, 'secrets', $secret, 'check-in' -join '/'
                    $invokeParamsCheckIn.Uri = $uri
                    $invokeParamsCheckIn.Method = 'POST'
                    $invokeParamsCheckIn.Body = $checkInBody | ConvertTo-Json -Depth 5

                    if ($PSCmdlet.ShouldProcess("SecretId: $secret", "$($invokeParamsCheckIn.Method) $uri with:`n$($invokeParamsCheckIn.Body)`n")) {
                        Write-Verbose "$($invokeParamsCheckIn.Method) $uri with:`n$checkInBody`n"
                        try {
                            $checkInResponse = . $InvokeApi @invokeParamsCheckIn
                        } catch {
                            Write-Warning "Issue performing check-in on secret [$secret]"
                            $err = $_
                            . $ErrorHandling $err
                        }
                    }

                    if ($checkInResponse.checkedOut) {
                        Write-Warning "Secret [$secret] not checked in"
                    } else {
                        Write-Verbose "Secret [$secret] checked in"
                    }
                }
            }
        } else {
            Write-Warning "No valid session found"
        }
    }
}