function Remove-FolderPermission {
    <#
    .SYNOPSIS
    Delete a folder permissions

    .DESCRIPTION
    Delete a folder permissions

    .EXAMPLE
    PS> $session = New-TssSession -SecretServer https://alpha -Credential $ssCred
    PS> Remove-TssFolderPermission -TssSession $session -Id 9

    Delete Folder Permission ID 9

    .NOTES
    Requires TssSession object returned by New-TssSession
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('TssDelete')]
    param (
        # TssSession object created by New-TssSession for auth
        [Parameter(Mandatory,
            ValueFromPipeline,
            Position = 0)]
        [TssSession]$TssSession,

        # Folder Permission ID
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [Alias("FolderPermissionId")]
        [int[]]
        $Id,

        # Include to remove permission inheritance
        [switch]
        $BreakInheritance
    )
    begin {
        $tssParams = $PSBoundParameters
        $invokeParams = . $GetInvokeTssParams $TssSession
    }

    process {
        Write-Verbose "Provided command parameters: $(. $GetInvocation $PSCmdlet.MyInvocation)"
        if ($tssParams.ContainsKey('TssSession') -and $TssSession.IsValidSession()) {
            foreach ($folderPermission in $Id) {
                $restResponse = $null
                $uri = $TssSession.ApiUrl, 'folder-permissions', $folderPermission -join '/'

                if ($tssParams.ContainsKey('BreakInheritance')) {
                    $uri = $uri, "breakInheritance=$([boolean]$BreakInheritance)" -join '?'
                }
                $invokeParams.Uri = $uri
                $invokeParams.Method = 'DELETE'

                if (-not $PSCmdlet.ShouldProcess("FolderPermissionId: $folderPermission","$($invokeParams.Method) $uri")) { return }
                Write-Verbose "$($invokeParams.Method) $uri"
                try {
                    $restResponse = Invoke-TssRestApi @invokeParams
                } catch {
                    Write-Warning "Issue removing [$folderPermission]"
                    $err = $_
                    . $ErrorHandling $err
                }

                if ($restResponse) {
                    [TssDelete]@{
                        Id = $restResponse.id
                        ObjectType = $restResponse.objectType
                    }
                }
            }
        } else {
            Write-Warning "No valid session found"
        }
    }
}