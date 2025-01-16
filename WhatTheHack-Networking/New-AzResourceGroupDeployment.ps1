$rg = Get-AzResourceGroup -location eastus
$vnet = "./VirtualNetwork.json"
$nsg = "./NetworkSecurityGroups.json"
$vnetgw = "./VNetGateway.json"
$vnetpeer = "./VNetPeering.json"
$vm = "./VirtualMachines.json"

#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $nsg
#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnet
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vm

#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnetgw -AsJob
#New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnetpeer -AsJob
