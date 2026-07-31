param(
	[string]$Path = '.'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSCommandPath
Set-Location -Path $repoRoot

$searchRoot = Resolve-Path -Path $Path -ErrorAction SilentlyContinue
if (-not $searchRoot) {
	Write-Host "The path '$Path' does not exist relative to $repoRoot." -ForegroundColor Red
	exit 1
}

$searchRootPath = $searchRoot.Path
if (-not (Test-Path -Path $searchRootPath -PathType Container)) {
	Write-Host "The path '$Path' is not a directory." -ForegroundColor Red
	exit 1
}

if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
	Write-Host "Azure CLI ('az') is not installed or not available on PATH." -ForegroundColor Red
	exit 1
}

$bicepFiles = @(Get-ChildItem -Path $searchRootPath -Filter '*.bicep' -Recurse -File | Sort-Object FullName)

if ($bicepFiles.Count -eq 0) {
	Write-Host "No .bicep files found under $searchRootPath" -ForegroundColor Yellow
	exit 0
}

$failedFiles = @()

foreach ($bicepFile in $bicepFiles) {
	$relativePath = Resolve-Path -Path $bicepFile.FullName -Relative
	Write-Host "Linting $relativePath" -ForegroundColor DarkCyan

	az bicep lint --file $bicepFile.FullName
	if ($LASTEXITCODE -ne 0) {
		$failedFiles += $relativePath
	}
}

if ($failedFiles.Count -gt 0) {
	Write-Host "`nLint failed for $($failedFiles.Count) file(s):" -ForegroundColor Red
	foreach ($failedFile in $failedFiles) {
		Write-Host " - $failedFile" -ForegroundColor Red
	}
	exit 1
}

Write-Host "`nLint completed successfully for $($bicepFiles.Count) file(s)." -ForegroundColor Green
