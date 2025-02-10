<<<<<<< HEAD:WhatTheHack-Networking/New-AzResourceGroupDeployment.ps1
$rg = Get-AzResourceGroup -location southeastasia

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
$kvname = read-host -prompt "Enter Key Vault Name"

$scriptURL = "https://$storageName.blob.core.windows.net/scripts/IIS.ps1"

$adminsecretName = "winadmin"
$storagesecretName = "storageaccountkey"

$adminsecretPass = read-host -prompt "Enter Admin password for Virtual Machine logon" -assecurestring

$firewallPolicyName = read-host -prompt "Enter Firewall Policy Name"
$firewallName = read-host -prompt "Enter Firewall Name"

$container = "scripts"

new-azkeyvault -name $kvname -resourcegroup $rg.resourceGroupName -location "East US" -sku "Standard"

$kv = Get-AzKeyVault -VaultName $kvname -ResourceGroupName $rg.resourceGroupName

New-AzRoleAssignment -SignInName $user -RoleDefinitionName "Key Vault Administrator" -Scope $kv.resourceId

Write-Host "Waiting for Role Assignment replication to complete"

Start-Sleep -Seconds 10

Set-AzKeyVaultAccessPolicy -VaultName $kvname -ResourceGroupName $rg.resourceGroupName -EnabledForDeployment -EnabledForTemplateDeployment

set-azkeyvaultsecret -vaultname $kvname -name $adminsecretName -secretvalue $adminsecretPass -Expires (Get-Date).AddHours(1)

$context = (get-azstorageaccount -resourcegroupname $rg.resourceGroupName -name $storageName)

$token = Get-AzStorageAccountKey -ResourceGroupName $rg.resourceGroupName -Name $storageName | Select-Object -ExpandProperty Value

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

New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $nsg
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnet
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vm -vaultName $kvname -storageaccountname $storageName -scriptURL $scriptURL -AsJob
#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnetgw
#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $gwconn -vaultName $kvname
#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnetpeer
#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $fwpol -policyName $firewallPolicyName
#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $fw -firewallName $firewallName -firewallPolicyName $firewallPolicyName -asJob
#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $ag -asJob
#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $rt



=======
$region = "southeastasia"

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
Write-Host "Waiting for Role Assignment replication to complete"

New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $nsg
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnet
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vm -vaultName $vaultName -storageaccountname $storageName -scriptURL $scriptURL -AsJob
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnetgw
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $gwconn -vaultName $vaultName
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnetpeer
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $fwpol -policyName $firewallPolicyName
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $fw -firewallName $firewallName -firewallPolicyName $firewallPolicyName -asJob
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $ag -asJob
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $rt



>>>>>>> b7e2eb9551bbc98cb03dae9b1abcc87daae7c80f:Azure-Networking-01/Powershell Scripts/Hub-Spoke-Deployment.ps1
