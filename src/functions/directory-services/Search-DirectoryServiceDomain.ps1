function Search-DirectoryServiceDomain {
    <#
    .SYNOPSIS
    Search Directory Services domains

    .DESCRIPTION
    Search Directory Services domains

    .EXAMPLE
    $session = New-TssSession -SecretServer https://alpha -Credential $ssCred
    Search-TssDirectoryServiceDomain -TssSession $session -DomainName lab.local

    Return the domain lab.local information

    .LINK
    https://thycotic-ps.github.io/thycotic.secretserver/commands/Search-TssDirectoryServiceDomain

    .LINK
    https://github.com/thycotic-ps/thycotic.secretserver/blob/main/src/functions/directory-services/Search-DirectoryServiceDomain.ps1

    .NOTES
    Requires TssSession object returned by New-TssSession
    #>
    [CmdletBinding()]
    [OutputType('TssDomainSummary')]
    param (
        # TssSession object created by New-TssSession for auth
        [Parameter(Mandatory,ValueFromPipeline,Position = 0)]
        [TssSession]
        $TssSession,

        # Domain Name
        [Alias("Domain")]
        [int]
        $DomainName,

        # Include inactive domains
        [switch]
        $IncludeInactive,

        # Sort by specific property, default DomainName
        [string]
        $SortBy = 'DomainName'
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
            $uri = $TssSession.ApiUrl, 'directory-services', 'domains' -join '/'
            $uri = $uri, "sortBy[0].direction=asc&sortBy[0].name=$SortBy&take=$($TssSession.Take)" -join '?'

            $filters = @()
            if ($tssParams.ContainsKey('DomainName')) {
                $filters += "filter.DomainName=$DomainName"
            }
            if ($tssParams.ContainsKey('IncludeInactive')) {
                $filters += "filter.includeInactive=$([boolean]$IncludeInactive)"
            }
            if ($filters) {
                $uriFilter = $filters -join '&'
                Write-Verbose "Filters: $uriFilter"
                $uri = $uri, $uriFilter -join '&'
            }

            $invokeParams.Uri = $uri
            $invokeParams.Method = 'GET'

            Write-Verbose "Performing the operation $($invokeParams.Method) $uri"
            try {
                $restResponse = . $InvokeApi @invokeParams
            } catch {
                Write-Warning "Issue on search request"
                $err = $_
                . $ErrorHandling $err
            }

            if ($restResponse.records.Count -le 0 -and $restResponse.records.Length -eq 0) {
                Write-Warning "No Directory Domain found"
            }
            if ($restResponse.records) {
                [TssDomainSummary[]]$restResponse.records
            }
        } else {
            Write-Warning "No valid session found"
        }
    }
}