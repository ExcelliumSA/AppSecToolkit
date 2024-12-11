<#
    .SYNOPSIS
        Script update the JSON file containing the metadata information about the tooklit.
    .EXAMPLE
        Update-ToolkitMetadata
    .LINK
        https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands?view=powershell-5.1
#>
###############################
# Program constants
###############################
New-Variable -Name MetadataFile -Value "Metadata.json" -Option Constant
New-Variable -Name BuildScriptSourceFile -Value "Build-Toolkit.ps1" -Option Constant
New-Variable -Name WorkFolder -Value "work" -Option Constant

###############################
# Main section
###############################
Clear-Host
Write-Host "[+] Updating file '$MetadataFile'..." -ForegroundColor Yellow
$metadata = [PSCustomObject]@{ SourcesURL = @(); ExecutableFiles = @() }
# Extract source URL of all tools
$urls = Get-Content -Path $BuildScriptSourceFile | Select-String -Pattern '"http.*?"'
$urls.Matches | Foreach-Object {
    $u = $_.Value
    $u = $u.Replace('"', '')
    $metadata.SourcesURL += $u
}
# List all executables files
$executableExtensions = @("*.exe", "*.bat", "*.ps1", "*.jar")
Get-ChildItem -Path $WorkFolder -Include $executableExtensions -Recurse -File -Depth 30  | Get-FileHash -Algorithm SHA256 | ForEach-Object -Process {
    $fName = $_.Path.Split("\")[-1]
    if ($fName.Contains("[") -or $fName.Contains("]")) {
        continue
    }
    $alg = $_.Algorithm
    $hash = $_.Hash
    $vtReport = "https://www.virustotal.com/gui/file/$hash"
    $metadata.ExecutableFiles += [PSCustomObject]@{Alg = $alg; Hash = $hash; FileName = $fName; VirusTotalScanReportURL = $vtReport }			
}
$metadata | ConvertTo-Json -Compress -Depth 100 | Out-File -FilePath $MetadataFile -Encoding "utf8"
Write-Host "[+] File updated." -ForegroundColor Yellow