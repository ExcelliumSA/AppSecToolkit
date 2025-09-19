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
    Get-RemoteFile -Uri "https://github.com/ffuf/ffuf/releases/download/v2.1.0/ffuf_2.1.0_windows_amd64.zip" -OutFile "$WorkFolder\ffuf.zip"
    Expand-Archive -LiteralPath "$WorkFolder\ffuf.zip" -DestinationPath "$WorkFolder"
    Remove-Item "$WorkFolder\ffuf.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-BurpCE {
    Write-Host ">> Add Burp Community Edition..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://portswigger-cdn.net/burp/releases/download?product=community&version=2023.11.1.4&type=Jar" -OutFile "$WorkFolder\burp.jar" -UseClassicWay
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-JDK {
    Write-Host ">> Add Java JDK 64 bits..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.6%2B10/OpenJDK17U-jdk_x64_windows_hotspot_17.0.6_10.zip" -OutFile "$WorkFolder\jdk.zip"
    Expand-Archive -LiteralPath "$WorkFolder\jdk.zip" -DestinationPath "$WorkFolder"
    Remove-Item "$WorkFolder\jdk.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-SecListsRepoCopy {
    Write-Host ">> Add SecLists repo copy..." -ForegroundColor Yellow
    # Only cherry pick some dicts to decrease the final size of the archive
    $baseUrl = "https://raw.githubusercontent.com/danielmiessler/SecLists/master"
    $dictsUrls = @("Discovery/Web-Content/common.txt", "Discovery/Web-Content/big.txt", "Discovery/Web-Content/web-mutations.txt", "Discovery/Web-Content/raft-large-words.txt", "Discovery/Web-Content/raft-large-extensions.txt")
    New-Item -Path "$WorkFolder" -Name "SecLists" -ItemType "directory"
    Foreach ($dictUrls in $dictsUrls) {
        $destName = "$WorkFolder\SecLists\" + $dictUrls.split("/")[-1]
        Write-Host ">>>> Add dict $dictUrls to $destName"
        Get-RemoteFile -Uri "$baseUrl/$dictUrls" -OutFile $destName -UseClassicWay
    }    
    Write-Host "<< Added!" -ForegroundColor Yellow
    Write-Host ">> Add fuzzing dictionaries from 'param-miner'..." -ForegroundColor Yellow
    $baseUrl = "https://raw.githubusercontent.com/PortSwigger/param-miner/refs/heads/master/resources"
    $dictsUrls = @("headers", "params")
    Foreach ($dictUrls in $dictsUrls) {
        $destName = "$WorkFolder\SecLists\" + $dictUrls + ".txt"
        Write-Host ">>>> Add dict $dictUrls to $destName"
        Get-RemoteFile -Uri "$baseUrl/$dictUrls" -OutFile $destName -UseClassicWay
    }    
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
    Get-RemoteFile -Uri "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.7.7/npp.8.7.7.portable.x64.zip" -OutFile "$WorkFolder\npp.zip"
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
    # Cannot add the FF portable bundle because it cause the final archive to be bigger than the accepted size for an release artefact.
    New-Item -ItemType "directory" -Path "$WorkFolder\Browsers"
    Get-RemoteFile -Uri "https://storage.googleapis.com/chromium-browser-snapshots/Win_x64/913064/chrome-win.zip" -OutFile "$WorkFolder\Browsers\chromium-portable.zip" -UseClassicWay
    Get-RemoteFile -Uri "https://addons.mozilla.org/firefox/downloads/file/3616824/foxyproxy_standard-7.5.1-an+fx.xpi" -OutFile "$WorkFolder\Browsers\FF-FoxyProxyStandard.xpi" -UseClassicWay
    Get-RemoteFile -Uri "https://addons.mozilla.org/firefox/downloads/file/3811501/tab_reloader_page_auto_refresh-0.3.7-fx.xpi" -OutFile "$WorkFolder\Browsers\FF-TabReloader.xpi" -UseClassicWay
    Get-RemoteFile -Uri "https://addons.mozilla.org/firefox/downloads/file/3821991/firefox_multi_account_containers-7.4.0-fx.xpi" -OutFile "$WorkFolder\Browsers\FF-MultiAccountContainer.xpi" -UseClassicWay
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-KeyStoreExplorer {
    Write-Host ">> Add KeyStoreExplorer..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/kaikramer/keystore-explorer/releases/download/v5.5.3/kse-553.zip" -OutFile "$WorkFolder\kse.zip"
    Expand-Archive -LiteralPath "$WorkFolder\kse.zip" -DestinationPath "$WorkFolder\KeyStoreExplorer"
    Remove-Item "$WorkFolder\kse.zip"
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
    $WSUrl = (Invoke-WebRequest "https://www.wireshark.org/").Content | Select-String -CaseSensitive -Pattern '(https:\/\/[a-z0-9\./]+WiresharkPortable[0-9\._]+\.paf\.exe)'
    Get-RemoteFile -Uri $WSUrl.Matches.Value -OutFile "$WorkFolder\wireshark-portable.exe"
    Get-RemoteFile -Uri "https://nmap.org/npcap/dist/npcap-1.75.exe" -OutFile "$WorkFolder\npcap.exe"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-CyberChef {
    Write-Host ">> Add CyberChef..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/gchq/CyberChef/releases/download/v10.19.4/CyberChef_v10.19.4.zip" -OutFile "$WorkFolder\cc.zip"
    Expand-Archive -LiteralPath "$WorkFolder\cc.zip" -DestinationPath "$WorkFolder\CyberChef"
    Remove-Item "$WorkFolder\cc.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-Python {
    Write-Host ">> Add Python..." -ForegroundColor Yellow
    Write-Host ">>>> Add external modules..." -ForegroundColor Yellow
    pip install requests
    pip install pyjwt
    pip install tabulate
    pip install colorama
    pip install termcolor
    pip install requests-pkcs12
    pip install pyodbc
    pip install httpie
    # Add the version of Python used to perform the operation above:
    # See https://github.com/actions/virtual-environments/blob/main/images/win/Windows2019-Readme.md#language-and-runtime
    Write-Host ">>>> Add Python version to the kit..." -ForegroundColor Yellow
    New-Item -ItemType "directory" -Path "$WorkFolder\Python"
    Copy-Item -Path "C:\hostedtoolcache\windows\Python\3.9.13\x64\*" -Destination "$WorkFolder\Python" -Recurse
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-PortScanTools {
    Write-Host ">> Add PortScanTools..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/projectdiscovery/naabu/releases/download/v2.3.5/naabu_2.3.5_windows_amd64.zip" -OutFile "$WorkFolder\nb.zip"
    Expand-Archive -LiteralPath "$WorkFolder\nb.zip" -DestinationPath "$WorkFolder\PortScan"
    Remove-Item "$WorkFolder\nb.zip"
    Get-RemoteFile -Uri "https://nmap.org/dist/nmap-7.92-win32.zip" -OutFile "$WorkFolder\nmap.zip"
    Expand-Archive -LiteralPath "$WorkFolder\nmap.zip" -DestinationPath "$WorkFolder\PortScan"
    Remove-Item "$WorkFolder\nmap.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-Nuclei {
    Write-Host ">> Add Nuclei and its templates..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/projectdiscovery/nuclei/releases/download/v3.4.10/nuclei_3.4.10_windows_amd64.zip" -OutFile "$WorkFolder\nuclei.zip"
    Expand-Archive -Force -LiteralPath "$WorkFolder\nuclei.zip" -DestinationPath "$WorkFolder"
    Remove-Item "$WorkFolder\nuclei.zip"
    Get-RemoteFile -Uri "https://github.com/projectdiscovery/nuclei-templates/archive/refs/heads/master.zip" -OutFile "$WorkFolder\nuclei-tpl.zip" -UseClassicWay 
    Expand-Archive -LiteralPath "$WorkFolder\nuclei-tpl.zip" -DestinationPath "$WorkFolder\NucleiTemplates"
    Remove-Item "$WorkFolder\nuclei-tpl.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-Cmder {
    Write-Host ">> Add Cmder (full - include Git portable too)..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/cmderdev/cmder/releases/download/v1.3.25/cmder.zip" -OutFile "$WorkFolder\cmder.zip"
    Expand-Archive -LiteralPath "$WorkFolder\cmder.zip" -DestinationPath "$WorkFolder\Cmder"
    Remove-Item "$WorkFolder\cmder.zip"
    Write-Host ">>>> Add Powershell profile file" -ForegroundColor Yellow
    Copy-Item -Path ".\user_profile.ps1" -Destination "$WorkFolder\Cmder\config" -Force
    Write-Host ">>>> Add Bash profile file" -ForegroundColor Yellow
    Copy-Item -Path ".\user_profile.sh" -Destination "$WorkFolder\Cmder\config" -Force    
    Write-Host "<< Added!" -ForegroundColor Yellow      
}

function Add-MiscTools {
    Write-Host ">> Add MiscTools..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe" -OutFile "$WorkFolder\jq.exe"
    Get-RemoteFile -Uri "https://curl.se/windows/dl-8.2.1_11/curl-8.2.1_11-win64-mingw.zip" -OutFile "$WorkFolder\curl.zip"
    Expand-Archive -LiteralPath "$WorkFolder\curl.zip" -DestinationPath "$WorkFolder\Curl"
    Remove-Item "$WorkFolder\curl.zip"
    Get-RemoteFile -Uri "https://github.com/rbsec/sslscan/releases/download/2.1.6/sslscan-2.1.6.zip" -OutFile "$WorkFolder\sslscan.zip"
    Expand-Archive -LiteralPath "$WorkFolder\sslscan.zip" -DestinationPath "$WorkFolder\SSLScan"
    Remove-Item "$WorkFolder\sslscan.zip"
    Get-RemoteFile -Uri "https://github.com/nabla-c0d3/sslyze/releases/download/6.1.0/sslyze-6.1.0-exe.zip" -OutFile "$WorkFolder\sslyze.zip"
    Expand-Archive -LiteralPath "$WorkFolder\sslyze.zip" -DestinationPath "$WorkFolder\SSLyze"
    Remove-Item "$WorkFolder\sslyze.zip"
    Get-RemoteFile -Uri "https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.2/Git-2.47.1.2-64-bit.exe"  -OutFile "$WorkFolder\git-portable-bundle.exe"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-7zip {
    # No portable version of 7zip with GUI provided so instruction are provided to install it as USER on the target machine
    Write-Host ">> Add 7zip..." -ForegroundColor Yellow
    New-Item -ItemType "directory" -Path "$WorkFolder\7zip"    
    "msiexec /i 7z.exe INSTALLDIR=$pwd\7-Zip\ MSIINSTALLPERUSER=1" | Out-File -FilePath "$WorkFolder\7zip\Install-Instruction.txt" -Encoding "utf8" 
    Get-RemoteFile -Uri "https://www.7-zip.org/a/7z2409-x64.exe" -OutFile "$WorkFolder\7zip\7z.msi"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-Interactsh {
    Write-Host ">> Add Interactsh..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/projectdiscovery/interactsh/releases/download/v1.2.3/interactsh-client_1.2.3_windows_amd64.zip" -OutFile "$WorkFolder\int.zip"
    Expand-Archive -LiteralPath "$WorkFolder\int.zip" -DestinationPath "$WorkFolder\Interactsh"
    "interactsh-client.exe -n 1 -json -o call.json" | Out-File -FilePath "$WorkFolder\Interactsh\ClientUsage-Instruction.txt" -Encoding "utf8" 
    Remove-Item "$WorkFolder\int.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-SQLiteBrowser {
    Write-Host ">> Add SQLiteBrowser..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/sqlitebrowser/sqlitebrowser/releases/download/v3.12.2/DB.Browser.for.SQLite-3.12.2-win64.zip" -OutFile "$WorkFolder\sqlite.zip"
    Expand-Archive -LiteralPath "$WorkFolder\sqlite.zip" -DestinationPath "$WorkFolder"
    Remove-Item "$WorkFolder\sqlite.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-Greenshot {
    Write-Host ">> Add Greenshot..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/greenshot/greenshot/releases/download/Greenshot-RELEASE-1.2.10.6/Greenshot-NO-INSTALLER-1.2.10.6-RELEASE.zip" -OutFile "$WorkFolder\grsh.zip"
    Expand-Archive -LiteralPath "$WorkFolder\grsh.zip" -DestinationPath "$WorkFolder\Greenshot"
    Remove-Item "$WorkFolder\grsh.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-SoapUI {
    Write-Host ">> Add SoapUI..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://dl.eviware.com/soapuios/5.7.2/SoapUI-5.7.2-windows-bin.zip" -OutFile "$WorkFolder\sip.zip" -UseClassicWay
    Expand-Archive -LiteralPath "$WorkFolder\sip.zip" -DestinationPath "$WorkFolder"
    Remove-Item "$WorkFolder\sip.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-PythonSecurityUtilityTools {
    Write-Host ">> Add PythonSecurityUtilityTools..." -ForegroundColor Yellow
    Write-Host ">>>> Add SQLMap..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/sqlmapproject/sqlmap/archive/refs/heads/master.zip" -OutFile "$WorkFolder\sqlmap.zip" -UseClassicWay
    Expand-Archive -LiteralPath "$WorkFolder\sqlmap.zip" -DestinationPath "$WorkFolder"
    Remove-Item "$WorkFolder\sqlmap.zip"
    Write-Host ">>>> Add MaliciousPDFGenerator..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/jonaslejon/malicious-pdf/archive/refs/heads/main.zip" -OutFile "$WorkFolder\mpg.zip" -UseClassicWay
    Expand-Archive -LiteralPath "$WorkFolder\mpg.zip" -DestinationPath "$WorkFolder"
    Remove-Item "$WorkFolder\mpg.zip"
    Write-Host ">>>> Add JWTTool..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/ticarpi/jwt_tool/archive/refs/heads/master.zip" -OutFile "$WorkFolder\jwttool.zip" -UseClassicWay
    Expand-Archive -LiteralPath "$WorkFolder\jwttool.zip" -DestinationPath "$WorkFolder"
    pip install -r "$WorkFolder\jwt_tool-master\requirements.txt"
    pip install pycryptodomex
    Remove-Item "$WorkFolder\jwttool.zip"
    Write-Host "<< Added!" -ForegroundColor Yellow
}

function Add-NucleiFuzzingTemplates {
    Write-Host ">> Add NucleiFuzzingTemplates..." -ForegroundColor Yellow
    Get-RemoteFile -Uri "https://github.com/projectdiscovery/fuzzing-templates/archive/refs/heads/main.zip" -OutFile "$WorkFolder\nft.zip" -UseClassicWay
    Expand-Archive -LiteralPath "$WorkFolder\nft.zip" -DestinationPath "$WorkFolder"
    Remove-Item "$WorkFolder\nft.zip"
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
Add-SecListsRepoCopy
Add-Python
Add-FFUF
Add-BurpCE
Add-JDK
Add-DNSpy
Add-JDGUI
Add-NotepadPP
Add-VSCode
Add-Browsers
Add-KeyStoreExplorer
Add-Sysinternals
Add-Wireshark
Add-CyberChef
Add-PortScanTools
Add-Nuclei
Add-NucleiFuzzingTemplates
Add-Cmder
Add-7zip
Add-Interactsh
Add-SQLiteBrowser
Add-Greenshot
Add-SoapUI
Add-PythonSecurityUtilityTools
Add-MiscTools
Write-Host "[+] Little cleanup prior to create the archive..." -ForegroundColor Yellow
Remove-Item $WorkFolder\*.md -ErrorAction Ignore -Force
Remove-Item $WorkFolder\LICENSE -ErrorAction Ignore -Force
Remove-Item $WorkFolder\Python\Lib\venv -Recurse -ErrorAction Ignore -Force
Write-Host "[+] Add utility content and information note..." -ForegroundColor Yellow
Copy-Item -Path .\patch_python_binaries.py -Destination $WorkFolder
Copy-Item -Path .\Clear-Workstation.ps1 -Destination $WorkFolder
"Open a PowerShell shell with CMDER and execute the script 'patch_python_binaries.py' from this shell." | Out-File -FilePath $WorkFolder\FirstUsageNote.txt -Encoding "utf8"
.\Update-ToolkitMetadata.ps1
Write-Host "[+] Create the archive..." -ForegroundColor Yellow
Compress-Archive -Path $WorkFolder -DestinationPath $TKArchiveName -CompressionLevel Optimal
Write-Host "[+] Cleanup..." -ForegroundColor Yellow
Remove-Item $WorkFolder -ErrorAction Ignore -Force -Recurse
$stopwatch.Stop()
$processingTime = $stopwatch.Elapsed.Minutes
Write-Host "[+] Processing finished in $processingTime minutes!" -ForegroundColor Yellow
Get-FileHash -Algorithm SHA256 $TKArchiveName
Write-Host "[+] File 'last_release_info.txt' updated." -ForegroundColor Yellow
Get-FileHash -Algorithm SHA256 $TKArchiveName | Out-File -FilePath last_release_info.txt -Force
Get-Date | Out-File -FilePath last_release_info.txt -Force -Append
Get-Content -Path last_release_info.txt
