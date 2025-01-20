$user = whoami 
$user = $user + "@instructorwhizlabs.onmicrosoft.com"

$rg = Get-AzResourceGroup -location eastus
$kvname = "vmkv3003"
$adminName = "winadmin"
$adminPass = read-host -prompt "Enter password" -assecurestring
$container = "scripts"

$kv = new-azkeyvault -name $kvname -resourcegroup $rg.resourceGroupName -location "East US" -sku "Standard"


New-AzRoleAssignment -SignInName $user -RoleDefinitionName "Key Vault Administrator" -Scope $kv.resourceId

Set-AzKeyVaultAccessPolicy -VaultName $kvname -UserPrincipalName $user -PermissionsToSecrets set, delete, get, list

set-azkeyvaultsecret -vaultname $kvname -name $adminNameName -secretvalue $adminPass -Expires (Get-Date).AddHours(2)

$adminName = Get-AzKeyVaultSecret -vaultname $kvname -Name $adminNameName

write-host $adminName

new-azstoragecontainer -name $container -context (get-azstorageaccount -resourcegroupname $rg.resourceGroupName -name "azstore3000").context

$context = (get-azstorageaccount -resourcegroupname $rg.resourceGroupName -name "azstore3000").context

$upload = @{
    File             = 'IIS.ps1'
    Container        = $container
    Blob             = "IIS.ps1"
    Context          = $context
    StandardBlobTier = 'Hot'
}
Set-AzStorageBlobContent @upload

$blobep = (Get-AzStorageAccount -ResourceGroupName $rg.ResourceGroupName -Name "azstore3000").PrimaryEndpoints.Blob

$token = New-AzStorageBlobSASToken -Container $container -Blob "IIS.ps1" -Permission r -ExpiryTime (Get-Date).AddHours(1) -context $context

$blobURI = $blobep + $container + "/IIS.ps1?" + $token
