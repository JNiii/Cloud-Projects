$user = whoami 
$user = $user + "@instructorwhizlabs.onmicrosoft.com"

$rg = Get-AzResourceGroup -location eastus
$kvname = read-host -prompt "Enter Key Vault Name"
$storageName = read-host -prompt "Enter Storage Name"

$adminsecretName = "winadmin"
$storagesecretName = "storageaccountkey"

$adminsecretPass = read-host -prompt "Enter Admin password for Virtual Machine logon" -assecurestring
$container = "scripts"

new-azkeyvault -name $kvname -resourcegroup $rg.resourceGroupName -location "East US" -sku "Standard"

$kv = Get-AzKeyVault -VaultName $kvname -ResourceGroupName $rg.resourceGroupName

New-AzRoleAssignment -SignInName $user -RoleDefinitionName "Key Vault Administrator" -Scope $kv.resourceId

Write-Host "Waiting for Role Assignment replication to complete"

Start-Sleep -Seconds 10

Set-AzKeyVaultAccessPolicy -VaultName $kvname -ResourceGroupName $rg.resourceGroupName -EnabledForDeployment -EnabledForTemplateDeployment

set-azkeyvaultsecret -vaultname $kvname -name $adminsecretName -secretvalue $adminsecretPass -Expires (Get-Date).AddHours(1)

$context = (get-azstorageaccount -resourcegroupname $rg.resourceGroupName -name $storageName)

$token = Get-AzStorageAccountKey -ResourceGroupName $rg.resourceGroupName -Name $storageName | select -ExpandProperty Value

$token = ConvertTo-SecureString $token[0] -AsPlainText -Force

set-azkeyvaultsecret -vaultname $kvname -name $storagesecretName -secretvalue $token -Expires (Get-Date).AddHours(1)

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

$blobURI = $blobep + $container + "/IIS.ps1"

write-host $blobUri
write-host $kvname
