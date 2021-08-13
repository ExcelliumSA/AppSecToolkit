# Configure a PS shell for the tool kit usage
.\$WorkFolder\PythonEnv\Scripts\Activate.ps1
$env:JAVA_HOME = "${pwd}\jdk-11.0.12+7"
$env:PATH += "${pwd};${pwd}\Curl;${pwd}\Wget;${pwd}\PortScan;${pwd}\jdk-11.0.12+7\bin"
Write-Host "[+] Environement:"
python --version
java --version
javac --version
curl --version
wget --version
nmap --version