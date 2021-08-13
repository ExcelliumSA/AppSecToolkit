# Configure a PS shell for the tool kit usage
# Identity dynamically the tools path
Remove-Item alias:curl
Remove-Item alias:wget
$base=pwd
.\PythonEnv\Scripts\Activate.ps1
Set-Location .\jdk-*
$env:JAVA_HOME = "${pwd}"
Set-Location $base
$env:PATH += ";${pwd};${pwd}\PortScan;${pwd}\Wget\bin;${$env:JAVA_HOME}\bin;"
Set-Location $base
Set-Location .\Curl\curl-*\bin\
$env:PATH += ";${pwd};"
Set-Location $base
Write-Host "[+] Environement:" -ForegroundColor Yellow
python --version
java --version
javac --version
curl.exe --version
wget.exe --version
nmap --version
naabu -version
Write-Host "[+] Toolkit base:" -ForegroundColor Yellow
$base