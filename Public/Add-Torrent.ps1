function Add-Torrent {

    <#
        .SYNOPSIS
        Add torrent to rTorrent watch folder.

        .DESCRIPTION
        Add torrent to rTorrent watch folder.

        Uses the stateful data set in Search-Torrent to download the file from Jackett to the watch folder for rTorrent.

        .PARAMETER ID
        Supply the ID of the torrent to download.

        .EXAMPLE
        !Add-Torrent -ID 1

        .EXAMPLE
        !dl 4

        .EXAMPLE
        !add 2
    #>

    [PoshBot.BotCommand(
        CommandName = 'download',
        Aliases = ('dl', 'add')
    )]
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            HelpMessage = 'Enter the ID of the torrent to download'
        )]
        [int]$ID
    )

    begin {
        $JackettResults = Get-PoshBotStatefulData -Name Results -ValueOnly

        $Target = ($JackettResults | Where-Object { $_.ID -eq $ID })
        $DownloadPath = "C:\Sync"
        $Filename = $Target.Name -replace(" ",".")
    }

    process {

        $TargetUrl = $Target | Select-Object -ExpandProperty DownloadUrl

        Invoke-WebRequest -Uri $TargetUrl.ToString() -OutFile "$DownloadPath\$Filename.torrent"

        # Strip download url for response
        $Target = $Target | Select-Object * -ExcludeProperty DownloadUrl

        # Convert the target PSObject to a dictionary and post to slack
        $DataDict = [ordered]@{ }
        $Target.psobject.properties | ForEach-Object { $DataDict[$_.Name] = $_.Value }
        New-PoshBotCardResponse -Title "Torrent added: $($Target.Name)" -Fields $DataDict -Type Normal -Color '#30F498' -DM
    }

    end {
        # Cleanup stateful data
        Remove-PoshBotStatefulData -Name Results -Scope Module
    }
}