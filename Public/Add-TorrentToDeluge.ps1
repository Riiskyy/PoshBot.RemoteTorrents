function Add-TorrentToDeluge
{

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
        [int]$ID,

        [Parameter(Mandatory = $true)]
        [PoshBot.FromConfig('DelugeCredential')]
        [string]$DelugeKey,

        [Parameter(Mandatory = $true)]
        [PoshBot.FromConfig('DelugeApi')]
        [string]$DelugeApi
    )

    begin
    {
        $Login = [ordered]@{
            id     = 1
            method = 'auth.login'
            params = @($DelugeKey)
        }

        $ConnectionCheck = [ordered]@{
            id     = 1
            method = 'auth.check_session'
            params = @()
        }

        $AddTorrent = [ordered]@{
            id     = 1
            method = 'webapi.add_torrent'
            params = @()
        }

        Invoke-RestMethod $DelugeApi -SessionVariable 'session' -Body ($Login | ConvertTo-Json) -Method Post -ContentType 'application/json' | Out-Null
    }

    process
    {
        # Check connection is established and locate target
        $TestConnection = Invoke-RestMethod $DelugeApi -WebSession $session -Body ($ConnectionCheck | ConvertTo-Json) -Method Post -ContentType 'application/json'

        if ($null -ne $TestConnection.error)
        {
            Write-Error "There was an error connecting to the download client, please try again.`n$TestConnection"
        }
        else
        {
            $Target = ($script:JackettResults | Where-Object { $_.ID -eq $ID })

            # Add the torrent parameters
            $AddTorrent.params += ($Target | Select-Object -ExpandProperty DownloadUrl)
            $AddTorrent.params += @{download_location = '/home1/riiskyy/ftproot/' }

            $JsonQuery = $AddTorrent | ConvertTo-Json | ForEach-Object { [Regex]::Unescape($_) }

            # Check the download is added successfully
            $Confirm = Invoke-RestMethod $DelugeApi -WebSession $session -Body $JsonQuery -Method Post -ContentType 'application/json'
            if ((-not $null -eq $Confirm.error) -or ($null -eq $Confirm.result)) {
                Write-Error "There was an issue adding the torrent to deluge.`n$Confirm"
            }

            # Convert the target PSObject to a dictionary and post to slack
            $DataDict = [ordered]@{ }
            $Target.psobject.properties | ForEach-Object { $DataDict[$_.Name] = $_.Value }
            New-PoshBotCardResponse -Title "Torrent added: $($Target.Name)" -Fields $DataDict -Type Normal -Color '#30F498' -DM
        }
    }

    end
    {
    }
}