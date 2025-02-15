$filesAndfolders = @("$env:APPDATA\BurpSuite", "$env:APPDATA\nuclei", "$env:USERPROFILE\nuclei-templates", "$env:LOCALAPPDATA\sqlmap")
foreach ($item in $filesAndfolders) {
    Write-Host "[>] Removing item '$item'..." -NoNewline
    if (Test-Path "$item" -PathType Leaf) {
        Remove-Item -Path "$item" -Force -ErrorAction SilentlyContinue
    }
    elseif (Test-Path "$item" -PathType Container) {
        Remove-Item -Path "$item" -Force -Recurse -ErrorAction SilentlyContinue
    }
    if (Test-Path "$item") {
        Write-Host "Failed!" -ForegroundColor Red
    }
    else {
        Write-Host "Done." -ForegroundColor Green
    }    
}
Write-Host "[>] Cleaning folder TEMP '$env:TEMP'..." -NoNewline
Remove-Item -Path "$env:TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue 
Write-Host "Done." -ForegroundColor Green
Write-Host "[>] Cleaning folder DOWNLOADS '$env:USERPROFILE\Downloads'..." -NoNewline
Remove-Item -Path "$env:USERPROFILE\Downloads\*" -Force -Recurse -ErrorAction SilentlyContinue 
Write-Host "Done." -ForegroundColor Green
Write-Host "[>] Search any BurpSuite local CA installed in the Windows certificate store..."
Get-ChildItem Cert:\ -Recurse | Where-Object { $_.Issuer -like "*PortSwigger*" }