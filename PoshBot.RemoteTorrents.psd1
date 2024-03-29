@{
    RootModule = '.\PoshBot.RemoteTorrents.psm1'
    ModuleVersion = '0.1.0'
    GUID = 'b6108674-4180-42b9-b49f-fdad3dbdd620'
    Author = 'Tom'
    Copyright = '(c) 2019 Tom. All rights reserved.'
    Description = 'Slack bot used to download torrents for rTorrent'

    RequiredModules = @('poshbot')
    FunctionsToExport = @(
        'Search-Torrent',
        'Add-Torrent'
    )
    CmdletsToExport = @()
    VariablesToExport = '*'
    AliasesToExport = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @()

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            # ProjectUri = ''

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''
        }
    }
}

