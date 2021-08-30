# Use this file to run your own startup commands
# See https://github.com/cmderdev/cmder/tree/master/config

## Prompt Customization
<#
.SYNTAX
    <PrePrompt><CMDER DEFAULT>
    λ <PostPrompt> <repl input>
.EXAMPLE
    <PrePrompt>N:\Documents\src\cmder [master]
    λ <PostPrompt> |
#>

[ScriptBlock]$PrePrompt = {

}

# Replace the cmder prompt entirely with this.
# [ScriptBlock]$CmderPrompt = {}

[ScriptBlock]$PostPrompt = {

}

## Add important EXE to $PATH
Write-Host "[+] Setting environment variables..." -NoNewline
cd ..
$env:PATH += ";$pwd;"
Get-ChildItem -Path "." -Include "*.exe" -Recurse -File -Force -ErrorAction SilentlyContinue | ForEach-Object -Process { 
	if ($_.FullName -like "*java.exe") {
		$x = $_.Directory.Parent.FullName
		$env:JAVA_HOME = $x
		$x = $_.DirectoryName
		$env:PATH = ";$x;" + $env:PATH
	}
	if ($_.FullName -like "*python.exe") {
		$x = $_.DirectoryName
		$env:PYTHONHOME = $x
		$env:PATH = ";$x;" + $env:PATH
	}	
	if ($_.FullName -like "*pip.exe") {
		$x = $_.DirectoryName
		$env:PATH = ";$x;" + $env:PATH
	} 
}
Write-Host "OK"
Remove-Item alias:curl
Remove-Item alias:wget
