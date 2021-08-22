# Use this file to run your own startup commands

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

## Add any folder containing EXE file to $PATH
Write-Host "[+] Setting PATH and JAVA_HOME environment variables..." -NoNewline
cd ..
Get-ChildItem -Path "." -Include "*.exe" -Recurse -File -Force -ErrorAction SilentlyContinue | ForEach-Object -Process { 
	if ($_.FullName -like "*java.exe") {
		$x = $_.Directory.Parent.FullName
		$env:JAVA_HOME = $x
	}
	$d = $_.DirectoryName	
	if (-Not ($env:PATH -like "*$d*")) {
		$env:PATH += ";$d;"
	}  
}
Write-Host "OK"
Remove-Item alias:curl
Remove-Item alias:wget
