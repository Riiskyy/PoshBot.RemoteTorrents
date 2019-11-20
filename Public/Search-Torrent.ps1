function Search-Torrent {

    <#
        .SYNOPSIS
        Searches Jackett for torents.

        .DESCRIPTION
        Searches Jackett for torents.

        Adds results to PoshBot stateful data to be used with Add-Torrent

        .PARAMETER Name
        Enter the search term.

        If you are searching for multiple words enclode in ''.

        .PARAMETER MinSeeders
        Optional: Filter results to torrents with a minimum number of seeders

        .EXAMPLE
        !Search-Torrent manjaro

        .EXAMPLE
        !s 'Manjaro i3' -MinSeeders 20

        .EXAMPLE
        !find -m 'Manjaro i3'
    #>

    [PoshBot.BotCommand(
        CommandName = 'search',
        Aliases     = ('s', 'find')
    )]
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory   = $true,
            HelpMessage = 'Enter your search term.'
        )]
        [string]$Name,

        [Parameter(HelpMessage = 'Set the minimum amount of seeders for results.')]
        [int]$MinSeeders,

        [Parameter(Mandatory = $true)]
        [PoshBot.FromConfig('JackettApiKey')]
        [string]$ApiKey,

        [Parameter(Mandatory = $true)]
        [PoshBot.FromConfig('JacketApi')]
        [string]$ApiUrl
    )

    begin {
        $JackettSearch = Invoke-RestMethod -Method Get -Uri "$ApiUrl/torznab/api?apikey=$ApiKey&t=search&cat=&q=$Name"

        $JackettResults = @()
    }

    process {
        $ID = 0
        foreach ($Torrent in $JackettSearch) {
            $JackettResults += [PSCustomObject]@{
                ID           = $ID
                Name         = $Torrent.title
                DateAddedUTC = $Torrent.pubDate.Substring(5, 11)
                Seeders      = [int]($Torrent | Select-Object -ExpandProperty attr | Where-Object { $_.Name -like 'seeders' }).value
                Peers        = [int]($Torrent | Select-Object -ExpandProperty attr | Where-Object { $_.Name -like 'peers' }).value
                SizeGB       = [math]::Round($Torrent.size / 1GB, 2)
                DownloadUrl  = $Torrent.link
            }
            $ID++
        }

        $JackettResults = $JackettResults | Where-Object{ $_.Seeders -ge $MinSeeders } | Sort-Object Seeders -Descending

        foreach ($Result in $JackettResults) {
            # Strip download url + name to prevent duplicate in output & mask url
            $data = $Result | Select-Object * -ExcludeProperty Name, DownloadUrl

            #Convert object to iDictionary
            $DataDict = [ordered]@{}
            $data.psobject.properties | ForEach-Object { $DataDict[$_.Name] = $_.Value }

            New-PoshBotCardResponse -Title "Torrent found: $($Result.Name)" -Fields $DataDict -Type Normal -Color '#0999DD' -DM
        }

        New-PoshBotTextResponse -Text "Run '!download' followed by the ID of the torrent you want to download" -DM

    }

    end {
        # Save the results for later
        Set-PoshBotStatefulData -Name Results -Value $JackettResults -Scope Module
    }
}