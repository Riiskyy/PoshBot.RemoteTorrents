# TorrentSlackBot

This is a PowerShell plugin for the PowerShell Slack bot, [PoshBot](https://github.com/poshbotio/PoshBot).

I put this together in order to have the ability to search for and add torrents to rTorrent.

## Requirements

This has a couple of dependencies in order to function.

- Obviously [PoshBot](https://github.com/poshbotio/PoshBot) is a requirement.
- You will also need to see the docs for PoshBot for how to create your own configuration file and how to run the bot as a service.
- This was written with using Jackett as an indexer to get the torznab feed, so you will need Jackett in order to use this as is.
- The 'C:\Sync' folder is the 'watch' folder used by rTorrent, adjust accordingly for your needs.

## Notes

My original idea was to use Deluge as the download client and use the [deluge-webapi](https://github.com/idlesign/deluge-webapi) to add torrents using the bot.
However it seems to struggle with adding torrents using the URLs from Jackett see [issue](https://github.com/idlesign/deluge-webapi/issues/26).
I will continue to look in to this option but I'm not sure how to proceed, so I have included the file but it is not an available command and is non-functional with Jackett.
If you are using urls that end with a '.torrent' then I believe it will function.