param(
	[Parameter(Mandatory=$false)]
	[string]$codeLocation = $pwd
)

# Map of regular expression patterns, by web framework, to identify any controllers or SOAP/REST API endpoints.
$patterns = @{
	"JAVA_Spring-Boot" = "@(Request|Delete|Get|Patch|Post|Put)Mapping"
	"JAVA_JAX-WS" = "@Web(Service|Method)"
	"JAVA_JAX-RS" = "@(GET|POST|PUT|DELETE|HEAD)"
	"JAVA_Struts" = "@Action"
	"DOTNET_AspNet-Core-API" = "\[Http(Delete|Get|Patch|Post|Put|Head|Options)"
	"DOTNET_AspNet-Core-MVC" = "class\s+[a-zA-Z0-9_]+\s+:\s+Controller"
	"DOTNET_AspNet-MVC" = "class\s+[a-zA-Z0-9_]+\s+:\s+Controller"
	"PHP_Symfony-FOSRestBundle" = "(@|#)\[?Rest\\(Delete|Get|Patch|Post|Put|Head|Options)"
	"PHP_Symfony" = "#\[Route"
}

# Focus on files containing source codee
$sourceCodeFileExtensions  = @("*.java","*.cs","*.php")

# Gather names of technologies supported
$work = [System.Collections.Generic.HashSet[string]]::new()
foreach ($patternConfiguration in $patterns.GetEnumerator()) {
	$parts = $patternConfiguration.Name.ToString().Split("_")
	$technology = $parts[0]
	$notUsed = $work.Add($technology)
}
$work = $work | Sort-Object
$technologiesSupported = $work -join "/"

# Check that folder contains supported source code
Write-Host "[*] Check the provided folder..." -ForegroundColor DarkYellow
$fileCount = (Get-ChildItem -Path "$codeLocation" -Include $sourceCodeFileExtensions -File -Recurse).Count
if($fileCount -eq 0){
	Write-Host "No source code found matching the supported technologies: $technologiesSupported." -ForegroundColor Red
	exit -1
}else{
	Write-Host "$fileCount files found with supported technologies."
}

# Apply search for every patterns and stop at the fist that match the code base
Write-Host "[*] Analyse the provided folder..." -ForegroundColor DarkYellow
$endpointsFound = $false
foreach ($patternConfiguration in $patterns.GetEnumerator()) {
	$endpointsCounter = 0
	Get-ChildItem -Path "$codeLocation" -Include $sourceCodeFileExtensions -File -Recurse | Select-String -Pattern $patternConfiguration.Value -CaseSensitive | ForEach-Object { 
		$endpointsCounter += 1
	} 	
    if($endpointsCounter -gt 0){
		$parts = $patternConfiguration.Name.ToString().Split("_")
		$technology = $parts[0]
		$framework = $parts[1]
		Write-Host "Technology: $technology"
		Write-Host "Framework : $framework"
		Write-Host "Endpoints : " -NoNewLine
		Write-Host "$endpointsCounter" -NoNewLine -ForegroundColor Cyan
		Write-Host " identified" 
		$endpointsFound = $true
		break
	}
}

# Message in case of nothing found
if(!$endpointsFound){
	Write-Host "No controller or SOAP/REST API endpoints identified!" -ForegroundColor Red
	exit -2
}
exit 0