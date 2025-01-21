$user = whoami 
$user = $user + "@instructorwhizlabs.onmicrosoft.com"

$rg = Get-AzResourceGroup -location eastus
$kvname = "vmkv3005"
$secretName = "winadmin"
$secretPass = read-host -prompt "Enter password" -assecurestring
$container = "scripts"

new-azkeyvault -name $kvname -resourcegroup $rg.resourceGroupName -location "East US" -sku "Standard"

$kv = Get-AzKeyVault -VaultName $kvname -ResourceGroupName $rg.resourceGroupName

Start-Sleep -Seconds 5

New-AzRoleAssignment -SignInName $user -RoleDefinitionName "Key Vault Administrator" -Scope $kv.resourceId

Set-AzKeyVaultAccessPolicy -VaultName $kvname -ResourceGroupName $rg.resourceGroupName -EnabledForDeployment $true -EnabledForTemplateDeployment $true -EnabledForTemplateDeployment $true

set-azkeyvaultsecret -vaultname $kvname -name $secretName -secretvalue $secretPass -Expires (Get-Date).AddHours(2)

$secretName = Get-AzKeyVaultSecret -vaultname $kvname -Name $secretName

write-host $secretName

$context = (get-azstorageaccount -resourcegroupname $rg.resourceGroupName -name "azstore3000")

new-azstoragecontainer -name $container -context $context.Context

$upload = @{
    File             = 'IIS.ps1'
    Container        = $container
    Blob             = "IIS.ps1"
    Context          = $context.Context
    StandardBlobTier = 'Hot'
}
Set-AzStorageBlobContent @upload

$blobep = $context.PrimaryEndpoints.Blob

$token = New-AzStorageBlobSASToken -Container $container -Blob "IIS.ps1" -Permission r -ExpiryTime (Get-Date).AddHours(1) -context $context.Context

$blobURI = $blobep + $container + "/IIS.ps1?" + $token
