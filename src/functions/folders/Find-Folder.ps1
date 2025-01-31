function Find-Folder {
    <#
    .SYNOPSIS
    Find secret folders

    .DESCRIPTION
    Find secret folders returning Folder ID and Name only

    .EXAMPLE
    $session = New-TssSession -SecretServer https://alpha -Credential $ssCred
    Find-TssFolder -TssSession $session -ParentFolderId 56

    Return folders with Parent Folder ID of 56

    .LINK
    https://thycotic-ps.github.io/thycotic.secretserver/commands/Find-TssFolder

    .LINK
    https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/folders/Find-Folder.ps1

    .NOTES
    Requires TssSession object returned by New-TssSession
    #>
    [CmdletBinding()]
    [OutputType('TssFolderLookup')]
    param (
        # TssSession object created by New-TssSession for auth
        [Parameter(Mandatory,ValueFromPipeline,Position = 0)]
        [TssSession]
        $TssSession,

        # Parent Folder Id
        [Alias("FolderId")]
        [int]
        $ParentFolderId,

        # Search by text value
        [string]
        $SearchText,

        # Filter based on folder permission (Owner, Edit, AddSecret, View). Default: View
        [ValidateSet('Owner','Edit','AddSecret','View')]
        [string]
        $PermissionRequired,

        # Sort by specific property (Id, FolderName). Default: FolderName
        [ValidateSet('FolderId','FolderName')]
        [string]
        $SortBy = 'FolderName'
    )
    begin {
        $tssParams = $PSBoundParameters
        $invokeParams = . $GetInvokeTssParams $TssSession
    }

    process {
        Write-Verbose "Provided command parameters: $(. $GetInvocation $PSCmdlet.MyInvocation)"
        if ($tssParams.ContainsKey('TssSession') -and $TssSession.IsValidSession()) {
            . $CheckVersion $TssSession '10.9.000000' $PSCmdlet.MyInvocation
            $restResponse = $null
            $uri = $TssSession.ApiUrl, 'folders/lookup' -join '/'

            switch ($SortBy) {
                'FolderName' { $sortByValue = 'value' }
                'FolderId' { $sortByValue = 'id' }
            }

            $uri = $uri, "sortBy[0].direction=asc&sortBy[0].name=$sortByValue&take=$($TssSession.Take)&filter.folderTypeId=1" -join '?'

            $filters = @()
            if ($tssParams.ContainsKey('ParentFolderId')) {
                $filters += "filter.parentFolderId=$ParentFolderId"
            }
            if ($tssParams.ContainsKey('SearchText')) {
                $filters += "filter.searchText=$SearchText"
            }
            if ($tssParams.ContainsKey('Permission')) {
                $filters += "filter.permissionRequired=$PermissionRequired"
            }
            if ($filters) {
                $uriFilter = $filters -join '&'
                Write-Verbose "Filters: $uriFilter"
                $uri = $uri, $uriFilter -join '&'
            }

            $invokeParams.Uri = $uri
            $invokeParams.Method = 'GET'


            Write-Verbose "$($invokeParams.Method) $uri with $body"
            try {
                $restResponse = . $InvokeApi @invokeParams
            } catch {
                Write-Warning "Issue on search request"
                $err = $_
                . $ErrorHandling $err
            }

            if ($restResponse.records.Count -le 0 -and $restResponse.records.Length -eq 0) {
                Write-Warning "No Folder found"
            }
            if ($restResponse.records) {
                [TssFolderLookup[]]$restResponse.records
            }
        } else {
            Write-Warning "No valid session found"
        }
    }
}