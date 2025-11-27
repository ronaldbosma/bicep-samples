param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName
)

Write-Host "Starting deployment of site.bicep"
az deployment group create `
    --name "deploy-site-$(Get-Date -Format "yyyyMMdd-HHmmss")" `
    --resource-group $ResourceGroupName `
    --template-file './site.bicep' `
    --verbose
Write-Host "Site deployment completed."

Read-Host -Prompt "Press any key to continue or CTRL+C to quit" | Out-Null


Write-Host "Starting deployment of additional-app-settings.bicep"

az deployment group create `
    --name "deployt-additional-app-settings-$(Get-Date -Format "yyyyMMdd-HHmmss")" `
    --resource-group $ResourceGroupName `
    --template-file './additional-app-settings.bicep' `
    --verbose

Write-Host "Additional App Settings deployment completed."
