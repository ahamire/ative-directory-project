#Requires -Version 5.1
[CmdletBinding()]
param(
    [ValidateSet('Client','FileServer')][string]$Role = 'Client',
    [string]$ShareName = 'IT',
    [string]$FolderPath = 'C:\shares\IT',
    [string]$OutputDirectory = '.\collected-evidence'
)
$ErrorActionPreference = 'Stop'
# A new subdirectory prevents replacing existing reports.
$runName = 'run-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N')
$destination = New-Item -ItemType Directory -Path (Join-Path $OutputDirectory $runName) -Force
function Save-Query {
    param([string]$Name, [scriptblock]$Query)
    try {
        $result = & $Query | Out-String -Width 240
        $result | Set-Content -LiteralPath (Join-Path $destination.FullName ($Name + '.txt')) -Encoding UTF8
    } catch {
        $message = $_.Exception.Message
        Write-Warning ($Name + ': ' + $message)
        $message | Set-Content -LiteralPath (Join-Path $destination.FullName ($Name + '.error.txt')) -Encoding UTF8
    }
}
Save-Query 'computer' { Get-CimInstance Win32_ComputerSystem | Select-Object Name, Domain, PartOfDomain | Format-List }
Save-Query 'identity' { & whoami.exe /all; if ($LASTEXITCODE -ne 0) { throw 'whoami failed' } }
Save-Query 'computer-policy' { & gpresult.exe /scope computer /r; if ($LASTEXITCODE -ne 0) { throw 'gpresult failed; try an elevated shell' } }
if ($Role -eq 'FileServer') {
    Save-Query 'share' { Get-SmbShare -Name $ShareName | Select-Object Name, Path | Format-List }
    Save-Query 'share-acl' { Get-SmbShareAccess -Name $ShareName | Format-List * }
    Save-Query 'ntfs-acl' { Get-Acl -LiteralPath $FolderPath | Format-List Path, Owner, Sddl, AccessToString }
    Save-Query 'ntfs-entries' { (Get-Acl -LiteralPath $FolderPath).Access | Format-List * }
}
Write-Output ('Reports saved to ' + $destination.FullName)
