$rg = Get-AzResourceGroup -location eastus
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

$storageName = read-host -prompt "Enter Storage Account Name"
$scriptURL = "https://$storageName.blob.core.windows.net/scripts/IIS.ps1"
$vaultname = read-host -prompt "Enter Key Vault Name"

$firewallPolicyName = read-host -prompt "Enter Firewall Policy Name"
$firewallName = read-host -prompt "Enter Firewall Name"


New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $nsg
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnet
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vm -vaultName $vaultname -storageaccountname $storageName -scriptURL $scriptURL -AsJob
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnetgw
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $gwconn -vaultName $vaultname
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $vnetpeer
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $fwpol -policyName $firewallPolicyName
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $fw -firewallName $firewallName -firewallPolicyName $firewallPolicyName -asJob
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $ag -asJob
New-AzResourceGroupDeployment -resourceGroup $rg.resourceGroupName -templatefile $rt



