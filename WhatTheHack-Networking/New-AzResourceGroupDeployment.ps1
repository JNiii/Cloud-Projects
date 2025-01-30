$rg = Get-AzResourceGroup -location eastus
$vnet = "./VirtualNetwork.json"
$nsg = "./NetworkSecurityGroups.json"
$vnetgw = "./VNetGateway.json"
$vnetpeer = "./VNetPeering.json"
$vm = "./VirtualMachines.json"
$gwconn = "./VNetGatewayConnection.json"
$fw = "./Firewall.json"
$rt = "./RouteTables.json"

$storageName = read-host -prompt "Enter Storage Account Name"
$vaultname = read-host -prompt "Enter Key Vault Name"
$scriptURL = read-host -prompt "Enter IIS SAS URL"
#$firewallName = read-host -prompt "Enter Firewall Name"

New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $nsg
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnet
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vm -vaultName $vaultname -scriptURL $scriptURL -storageaccountname $storageName
#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $rt
#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnetgw
#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $gwconn -vaultName $vaultname
#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnetpeer
#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $fw -firewallName $firewallName -asJob


