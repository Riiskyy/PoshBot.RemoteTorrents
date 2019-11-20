#Enable TLS 1.2
[System.Net.ServicePointManager]::SecurityProtocol = (
    [System.Net.ServicePointManager]::SecurityProtocol -bor
    [System.Net.SecurityProtocolType]::Tls12
)

#Load functions
Get-ChildItem $PSScriptRoot\Public -Filter '*.ps1' | Foreach-Object {. $_.FullName}