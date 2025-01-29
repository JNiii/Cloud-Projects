$rg = Get-AzResourceGroup -location southeastasia
$vnet = "./VirtualNetwork.json"
$nsg = "./NetworkSecurityGroups.json"
$vnetgw = "./VNetGateway.json"
$vnetpeer = "./VNetPeering.json"
$vm = "./VirtualMachines.json"
$gwconn = "./VNetGatewayConnection.json"
$fw = "./Firewall.json"
$rt = "./RouteTables.json"

$vaultname = read-host -prompt "Enter Key Vault Name"
$scriptURL = read-host -prompt "Enter IIS SAS URL"
$firewallName = read-host -prompt "Enter Firewall Name"

New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $nsg
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $rt
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnet
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vm -vaultName $vaultname -scriptURL $scriptURL -AsJob
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $fw -firewallName $firewallName -asJob
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnetgw
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $gwconn -vaultName $vaultname
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnetpeer

