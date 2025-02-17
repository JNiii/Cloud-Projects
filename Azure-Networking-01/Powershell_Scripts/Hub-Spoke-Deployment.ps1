$region = "eastus"

$rg = Get-AzResourceGroup -location $region
$tenant = Get-AzTenant

$kv = "./KeyVault.json"
$vnet = "./VirtualNetwork.json"
$nsg = "./NetworkSecurityGroups.json"
$vnetgw = "./VNetGateway.json"
$vnetpeer = "./VNetPeering.json"
$vm = "./VirtualMachines.json"
$gwconn = "./VNetGatewayConnection.json"
$fw = "./Firewall.json"
$fwpol = "./FirewallPolicy.json"
$rt = "./RouteTables.json"
$ag = "./AppGateway.json"

$user = whoami 
$user = $user + "@instructorwhizlabs.onmicrosoft.com"

$storageName = read-host -prompt "Enter Storage Name"
$vaultName = read-host -prompt "Enter Key Vault Name"

$scriptURL = "https://$storageName.blob.core.windows.net/scripts/IIS.ps1"

$adminSecretName = "winadmin"
$storageSecretName = "storageaccountkey"
$adminSecretPass = read-host -prompt "Enter Admin password for Virtual Machine logon" -assecurestring
$firewallPolicyName = read-host -prompt "Enter Firewall Policy Name"
$firewallName = read-host -prompt "Enter Firewall Name"

$container = "scripts"

$context = (get-azstorageaccount -resourcegroupname $rg.resourceGroupName -name $storageName)
new-azstoragecontainer -name $container -context $context.Context
$upload = @{
    File             = 'IIS.ps1'
    Container        = $container
    Blob             = "IIS.ps1"
    Context          = $context.Context
    StandardBlobTier = 'Hot'
}
Set-AzStorageBlobContent @upload
$token = Get-AzStorageAccountKey -ResourceGroupName $rg.resourceGroupName -Name $storageName | Select-Object -ExpandProperty Value
$token = ConvertTo-SecureString $token[0] -AsPlainText -Force


New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $kv -vaultName $vaultName -tenantId $tenant.tenantId -adminSecretName $adminSecretName -localAdminPass $adminSecretPass -storageSecretName $storageSecretName -storageSecretPass $token 


$keyvault = Get-AzKeyVault -VaultName $vaultName -ResourceGroupName $rg.resourceGroupName
New-AzRoleAssignment -SignInName $user -RoleDefinitionName "Key Vault Administrator" -Scope $keyvault.resourceId

New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $nsg
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnet
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vm -vaultName $vaultName -storageaccountname $storageName -scriptURL $scriptURL -AsJob
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnetgw
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $gwconn -vaultName $vaultName
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnetpeer
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $fwpol -policyName $firewallPolicyName
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $fw -firewallName $firewallName -firewallPolicyName $firewallPolicyName -asJob
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $ag
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $rt
