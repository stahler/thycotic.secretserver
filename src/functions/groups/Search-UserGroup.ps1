﻿function Search-UserGroup {
    <#
    .SYNOPSIS
    Search for user management groups

    .DESCRIPTION
    Search for user management groups

    .EXAMPLE
    $session = New-TssSession -SecretServer https://alpha -Credential $ssCred
    Search-UserGroup -TssSession $session

    Return list of all groups found in Secret Server that account has access to manage

    .LINK
    https://thycotic.secretserver.github.io/commands/Search-TssUserGroup

    .NOTES
    Requires TssSession object returned by New-TssSession
    #>
    [CmdletBinding()]
    [OutputType('TssGroupSummary')]
    param (
        # TssSession object created by New-TssSession for auth
        [Parameter(Mandatory,
            ValueFromPipeline,
            Position = 0)]
        [TssSession]$TssSession,

        # Active Directory Domain Id
        [int]
        $DomainId,

        # Include inactive groups in results
        [switch]
        $IncludeInactive,

        # Text to search for group name
        [string]
        $SearchText,

        # Sort by specific property, default Name
        [string]
        $SortBy = 'Name',

        # Output the raw response from the API endpoint
        [switch]
        $Raw
    )
    begin {
        $tssParams = $PSBoundParameters
        $invokeParams = @{ }
    }

    process {
        Write-Verbose "Provided command parameters: $(. $GetInvocation $PSCmdlet.MyInvocation)"
        if ($tssParams.ContainsKey('TssSession') -and $TssSession.IsValidSession()) {
            $uri = $TssSession.ApiUrl, 'groups' -join '/'
            $uri += "?sortBy[0].direction=asc&sortBy[0].name=$SortBy&take=$($TssSession.Take)"

            $filters = @()
            if ($tssParams.ContainsKey('DomainId')) {
                $filters += "filter.domainId=$DomainId"
            }
            if ($tssParams.ContainsKey('IncludeInactive')) {
                $filters += "filter.includeInactive=$IncludeInactive"
            }
            if ($tssParams.ContainsKey('SearchText')) {
                $filters += "filter.searchText=$SearchText"
            }
            if ($filters) {
                $uriFilter = $filters -join '&'
                Write-Verbose "Filters: $uriFilter"
                $uri = $uri, $uriFilter -join '&'
            }

            $invokeParams.Uri = $uri
            $invokeParams.PersonalAccessToken = $TssSession.AccessToken
            $invokeParams.Method = 'GET'
            Write-Verbose "$($invokeParams.Method) $uri"
            try {
                $restReponse = Invoke-TssRestApi @invokeParams
            } catch {
                Write-Warning "Issue on search request"
                $err = $_.ErrorDetails.Message
                Write-Error $err
            }

            if ($tssParams['Raw']) {
                return $restReponse
            }
            if ($restReponse.records.Count -le 0 -and $restReponse.records.Length -eq 0) {
                Write-Warning "No groups found"
            }
            if ($restReponse.records) {
                . $TssGroupSummaryObject $restReponse.records
            }
        } else {
            Write-Warning "No valid session found"
        }
    }
}