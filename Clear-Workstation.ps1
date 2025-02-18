$filesOrfolders = @("nuclei", "nuclei-templates", "sqlmap", "Mozilla", "Mozilla Firefox", "Notepad++", "ffuf", "Chromium", "BurpSuiteCommunity", "BurpSuite")
$baseFolders =  @("$env:USERPROFILE", "$env:LOCALAPPDATA", "$env:APPDATA")
$foldersToClean = @("$env:TEMP", "$env:USERPROFILE\Downloads", "$env:USERPROFILE\Pictures", "$env:USERPROFILE\Documents")
foreach ($baseFolder in $baseFolders) {
	foreach ($fileOrfolder in $filesOrfolders) {
		$target = "$baseFolder\$fileOrfolder"
		Write-Host "[>] Removing if exists file or folder '$target'..." -NoNewline
		if (Test-Path "$target" -PathType Leaf) {
			Remove-Item -Path "$target" -Force -ErrorAction SilentlyContinue
		}
		elseif (Test-Path "$target" -PathType Container) {
			Remove-Item -Path "$target" -Force -Recurse -ErrorAction SilentlyContinue
		}
		if (Test-Path "$target") {
			Write-Host "Failed!" -ForegroundColor Red
		}
		else {
			Write-Host "Done." -ForegroundColor Green
		}    
	}
}
foreach ($folderToClean in $foldersToClean) {
	Write-Host "[>] Cleaning folder '$folderToClean'..." -NoNewline
	Remove-Item -Path "$folderToClean\*" -Force -Recurse -ErrorAction SilentlyContinue 
	Write-Host "Done." -ForegroundColor Green
}
Write-Host "[>] Search any BurpSuite local CA installed in the Windows certificate store..."
Get-ChildItem Cert:\ -Recurse | Where-Object { $_.Issuer -like "*PortSwigger*" }
