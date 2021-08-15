<#
    .SYNOPSIS
        Script to gather a collection of tools used by the AppSec team during different kind of assessments.
        All tools must be portable!
        Target machine is a WINDOWS
    .EXAMPLE
        Build-Tookit 
    .LINK
        https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands?view=powershell-5.1
#>
###############################
# Program constants
###############################
New-Variable -Name WorkFolder -Value "work" -Option Constant
New-Variable -Name TKArchiveName -Value "Toolkit.zip" -Option Constant

###############################
# Utility internal functions
###############################

function Get-RemoteFile {
    param(
        [String]
        $Uri,
        [String]
        $OutFile,
        [switch] 
        $UseClassicWay      
    )
    # See https://adamtheautomator.com/powershell-download-file/
    if ($UseClassicWay) {
        (New-Object Net.WebClient).Downloadfile($Uri, $OutFile)
    }
    else {
        Start-BitsTransfer -Source $Uri -Destination $OutFile -TransferType Download
    }
}

function Add-FFUF {
    Write-Host ">> Add FFUF..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/ffuf/ffuf/releases/download/v1.3.1/ffuf_1.3.1_windows_amd64.zip" -OutFile "$WorkFolder\ffuf.zip"
    Expand-Archive -LiteralPath "$WorkFolder\ffuf.zip" -DestinationPath "$WorkFolder"
    Remove-Item "$WorkFolder\ffuf.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-BurpCE {
    Write-Host ">> Add Burp Community Edition..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://portswigger.net/burp/releases/download?product=community&version=2021.8&type=Jar" -OutFile "$WorkFolder\burp.jar"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-JDK {
    Write-Host ">> Add Java JDK 64 bits..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.12%2B7/OpenJDK11U-jdk_x64_windows_hotspot_11.0.12_7.zip" -OutFile "$WorkFolder\jdk.zip"
    Expand-Archive -LiteralPath "$WorkFolder\jdk.zip" -DestinationPath "$WorkFolder"
    Remove-Item "$WorkFolder\jdk.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-SecListsRepoCopy {
    Write-Host ">> Add SecLists repo copy..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/danielmiessler/SecLists/archive/refs/heads/master.zip" -OutFile "$WorkFolder\seclists.zip" -UseClassicWay
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-DNSpy {
    Write-Host ">> Add DNSpy..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/dnSpy/dnSpy/releases/download/v6.1.8/dnSpy-net-win64.zip" -OutFile "$WorkFolder\dnspy.zip"
    Expand-Archive -LiteralPath "$WorkFolder\dnspy.zip" -DestinationPath "$WorkFolder\DNSpy"
    Remove-Item "$WorkFolder\dnspy.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-JDGUI {
    Write-Host ">> Add JDGUI..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-windows-1.6.6.zip" -OutFile "$WorkFolder\jdgui.zip"
    Expand-Archive -LiteralPath "$WorkFolder\jdgui.zip" -DestinationPath "$WorkFolder\JDGUI"
    Get-RemoteFile -Uri "https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-1.6.6.jar" -OutFile "$WorkFolder\JDGUI\jd-gui.jar"
    Remove-Item "$WorkFolder\jdgui.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-NotepadPP {
    Write-Host ">> Add Notepad++..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.1.2/npp.8.1.2.portable.x64.zip" -OutFile "$WorkFolder\npp.zip"
    Expand-Archive -LiteralPath "$WorkFolder\npp.zip" -DestinationPath "$WorkFolder\NotepadPP"
    Remove-Item "$WorkFolder\npp.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-VSCode {
    Write-Host ">> Add VS Code..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive" -OutFile "$WorkFolder\vscode.zip"
    Expand-Archive -LiteralPath "$WorkFolder\vscode.zip" -DestinationPath "$WorkFolder\VSCode"
    Remove-Item "$WorkFolder\vscode.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-Browsers {
    Write-Host ">> Add portable browsers and useful FF extensions..." -ForegroundColor Yellow
    New-Item -ItemType "directory" -Path "$WorkFolder\Browsers"
    Get-RemoteFile -Uri "https://portableapps.com/downloading/?a=FirefoxPortable&n=Mozilla%20Firefox,%20Portable%20Edition&s=s&p=&d=pa&f=FirefoxPortable_91.0_English.paf.exe" -OutFile "$WorkFolder\Browsers\firefox-portable.exe" -UseClassicWay
    Get-RemoteFile -Uri "https://download-chromium.appspot.com/dl/Win_x64?type=snapshots" -OutFile "$WorkFolder\Browsers\chromium-portable.zip" -UseClassicWay
    Get-RemoteFile -Uri "https://addons.mozilla.org/firefox/downloads/file/3616824/foxyproxy_standard-7.5.1-an+fx.xpi" -OutFile "$WorkFolder\Browsers\FF-FoxyProxyStandard.xpi" -UseClassicWay
    Get-RemoteFile -Uri "https://addons.mozilla.org/firefox/downloads/file/3811501/tab_reloader_page_auto_refresh-0.3.7-fx.xpi" -OutFile "$WorkFolder\Browsers\FF-TabReloader.xpi" -UseClassicWay
    Get-RemoteFile -Uri "https://addons.mozilla.org/firefox/downloads/file/3821991/firefox_multi_account_containers-7.4.0-fx.xpi" -OutFile "$WorkFolder\Browsers\FF-MultiAccountContainer.xpi" -UseClassicWay
    Expand-Archive -LiteralPath "$WorkFolder\Browsers\chromium-portable.zip" -DestinationPath "$WorkFolder\Browsers\Chromium"
    Remove-Item "$WorkFolder\Browsers\chromium-portable.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-KeyStoreExplorer {
    Write-Host ">> Add KeyStoreExplorer..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/kaikramer/keystore-explorer/releases/download/v5.4.4/kse-544.zip" -OutFile "$WorkFolder\kse.zip"
    Expand-Archive -LiteralPath "$WorkFolder\kse.zip" -DestinationPath "$WorkFolder\KeyStoreExplorer"
    Remove-Item "$WorkFolder\kse.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-GitPortable {
    Write-Host ">> Add GitPortable..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/git-for-windows/git/releases/download/v2.32.0.windows.2/MinGit-2.32.0.2-64-bit.zip" -OutFile "$WorkFolder\gitportable.zip"
    Expand-Archive -LiteralPath "$WorkFolder\gitportable.zip" -DestinationPath "$WorkFolder\GitPortable"
    Remove-Item "$WorkFolder\gitportable.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-Sysinternals {
    Write-Host ">> Add Sysinternals..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://download.sysinternals.com/files/SysinternalsSuite.zip" -OutFile "$WorkFolder\sysint.zip"
    Expand-Archive -LiteralPath "$WorkFolder\sysint.zip" -DestinationPath "$WorkFolder\Sysinternals"
    Remove-Item "$WorkFolder\sysint.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-Wireshark {
    Write-Host ">> Add Wireshark..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://1.eu.dl.wireshark.org/win32/WiresharkPortable_3.4.7.paf.exe" -OutFile "$WorkFolder\wireshark-portable.exe"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-CyberChef {
    Write-Host ">> Add CyberChef..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://gchq.github.io/CyberChef/CyberChef_v9.30.0.zip" -OutFile "$WorkFolder\cc.zip"
    Expand-Archive -LiteralPath "$WorkFolder\cc.zip" -DestinationPath "$WorkFolder\CyberChef"
    Remove-Item "$WorkFolder\cc.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-PythonEnv {
    # See https://docs.python.org/3/library/venv.html
    # See https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/#creating-a-virtual-environment
    Write-Host ">> Add PythonEnv..." -ForegroundColor Yellow
    Write-Host ">>>> Create Env..." -ForegroundColor Yellow
    python -m venv "$WorkFolder\PythonEnv"
    Write-Host ">>>> Activate Env..." -ForegroundColor Yellow
    Invoke-Expression -Command ".\$WorkFolder\PythonEnv\Scripts\Activate.ps1"
    Write-Host ">>>> Add external modules to Env..." -ForegroundColor Yellow
    pip install requests
    pip install httpie
    pip install pyjwt
    pip install droopescan
    pip install tabulate
    pip install colorama
    pip install termcolor
    pip install requests-pkcs12 
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-PortScanTools {
    Write-Host ">> Add PortScanTools..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/projectdiscovery/naabu/releases/download/v2.0.4/naabu_2.0.4_windows_amd64.zip" -OutFile "$WorkFolder\nb.zip"
    Expand-Archive -LiteralPath "$WorkFolder\nb.zip" -DestinationPath "$WorkFolder\PortScan"
    Remove-Item "$WorkFolder\nb.zip"
    Get-RemoteFile -Uri "https://nmap.org/dist/nmap-7.92-win32.zip" -OutFile "$WorkFolder\nmap.zip"
    Expand-Archive -LiteralPath "$WorkFolder\nmap.zip" -DestinationPath "$WorkFolder\PortScan"
    Remove-Item "$WorkFolder\nmap.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}


function Add-Nuclei {
    Write-Host ">> Add Nuclei and its templates..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/projectdiscovery/nuclei/releases/download/v2.4.3/nuclei_2.4.3_windows_amd64.zip" -OutFile "$WorkFolder\nuclei.zip"
    Expand-Archive -LiteralPath "$WorkFolder\nuclei.zip" -DestinationPath "$WorkFolder"
    Remove-Item "$WorkFolder\nuclei.zip"
    Get-RemoteFile -Uri "https://github.com/projectdiscovery/nuclei-templates/archive/refs/heads/master.zip" -OutFile "$WorkFolder\nuclei-tpl.zip" -UseClassicWay 
    Expand-Archive -LiteralPath "$WorkFolder\nuclei-tpl.zip" -DestinationPath "$WorkFolder\NucleiTemplates"
    Remove-Item "$WorkFolder\nuclei-tpl.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-Cmder {
    Write-Host ">> Add Cmder (full)..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/cmderdev/cmder/releases/download/v1.3.18/cmder.zip" -OutFile "$WorkFolder\cmder.zip"
    Expand-Archive -LiteralPath "$WorkFolder\cmder.zip" -DestinationPath "$WorkFolder\Cmder"
    Remove-Item "$WorkFolder\cmder.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow      
}

function Add-MiscTools {
    Write-Host ">> Add MiscTools..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe" -OutFile "$WorkFolder\jq.exe"
    Get-RemoteFile -Uri "https://curl.se/windows/dl-7.78.0/curl-7.78.0-win64-mingw.zip" -OutFile "$WorkFolder\curl.zip"
    Expand-Archive -LiteralPath "$WorkFolder\curl.zip" -DestinationPath "$WorkFolder\Curl"
    Remove-Item "$WorkFolder\curl.zip"
    Get-RemoteFile -Uri "http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-bin.zip" -OutFile "$WorkFolder\wg.zip"
    Expand-Archive -LiteralPath "$WorkFolder\wg.zip" -DestinationPath "$WorkFolder\Wget"
    Remove-Item "$WorkFolder\wg.zip"
    Get-RemoteFile -Uri "https://github.com/rbsec/sslscan/releases/download/2.0.10/sslscan-win-2.0.10.zip" -OutFile "$WorkFolder\sslscan.zip"
    Expand-Archive -LiteralPath "$WorkFolder\sslscan.zip" -DestinationPath "$WorkFolder\SSLScan"
    Remove-Item "$WorkFolder\sslscan.zip"
    Get-RemoteFile -Uri "https://github.com/nabla-c0d3/sslyze/releases/download/4.1.0/sslyze-4.1.0-exe.zip" -OutFile "$WorkFolder\sslyze.zip"
    Expand-Archive -LiteralPath "$WorkFolder\sslyze.zip" -DestinationPath "$WorkFolder\SSLyze"
    Remove-Item "$WorkFolder\sslyze.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-7zip {
    # No portable version of 7zip with GUI provided so instruction are provided to install it as USER on the target machine
    Write-Host ">> Add 7zip..." -ForegroundColor Yellow
    New-Item -ItemType "directory" -Path "$WorkFolder\7zip"    
    "msiexec /i 7z1900-x64.msi INSTALLDIR=%USERPROFILE%\7-Zip\ MSIINSTALLPERUSER=1" | Out-File -FilePath "$WorkFolder\7zip\Install-Instruction.txt" -Encoding "utf8" 
    Get-RemoteFile -Uri "https://www.7-zip.org/a/7z1900-x64.msi" -OutFile "$WorkFolder\7zip\7z1900-x64.msi"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-WindowsTerminal {
    # Provide the file to install it as user on the target machine because no portable mode is provided
    Write-Host ">> Add WindowsTerminal..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/microsoft/terminal/releases/download/v1.9.1942.0/Microsoft.WindowsTerminal_1.9.1942.0_8wekyb3d8bbwe.msixbundle" -OutFile "$WorkFolder\WindowsTerminal.msixbundle"
    Write-Host "<< Added!" -ForegroundColor Yellow   
}

function Add-Interactsh {
    Write-Host ">> Add Interactsh..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/projectdiscovery/interactsh/releases/download/v0.0.4/interactsh_0.0.4_windows_amd64.zip" -OutFile "$WorkFolder\int.zip"
    Expand-Archive -LiteralPath "$WorkFolder\int.zip" -DestinationPath "$WorkFolder\Interactsh"
    "interactsh-client.exe -n 1 -json -o call.json" | Out-File -FilePath "$WorkFolder\Interactsh\ClientUsage-Instruction.txt" -Encoding "utf8" 
    Remove-Item "$WorkFolder\int.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

###############################
# Main section
###############################
Clear-Host
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
Write-Host "[+] Init..." -ForegroundColor Yellow
Remove-Item $WorkFolder -ErrorAction Ignore -Force -Recurse
Remove-Item $TKArchiveName -ErrorAction Ignore -Force
New-Item -ItemType "directory" -Path $WorkFolder
Write-Host "[+] Add tools:" -ForegroundColor Yellow
Add-PythonEnv
Add-FFUF
Add-BurpCE
Add-JDK
Add-DNSpy
Add-JDGUI
Add-NotepadPP
Add-VSCode
Add-Browsers
Add-KeyStoreExplorer
Add-GitPortable
Add-Sysinternals
Add-Wireshark
Add-CyberChef
Add-PortScanTools
Add-SecListsRepoCopy
Add-MiscTools
Add-Nuclei
Add-Cmder
Add-7zip
Add-WindowsTerminal
Add-Interactsh
Write-Host "[+] Little cleanup prior to create the archive..." -ForegroundColor Yellow
Remove-Item $WorkFolder\*.md -ErrorAction Ignore -Force
Remove-Item $WorkFolder\LICENSE -ErrorAction Ignore -Force
Write-Host "[+] Create the archive..." -ForegroundColor Yellow
Copy-Item "shell.ps1" -Destination "$WorkFolder"
Compress-Archive -Path $WorkFolder -DestinationPath $TKArchiveName -CompressionLevel Optimal
Write-Host "[+] Cleanup..." -ForegroundColor Yellow
Remove-Item $WorkFolder -ErrorAction Ignore -Force -Recurse
$stopwatch.Stop()
$processingTime = $stopwatch.Elapsed.Minutes
Write-Host "[+] Processing finished in $processingTime minutes!" -ForegroundColor Yellow
Get-FileHash -Algorithm SHA256 $TKArchiveName