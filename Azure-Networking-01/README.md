## Introduction

**Azure-Networking-01** project aims to engage into an increasingly complex Azure Virtual Network setup and starts with a deep dive in hub and spoke networking and user-defined routes, and then goes on by adding components such as the Azure Application Gateway, and Azure Firewall.

By completing this project, I have an understanding of the following concepts:
* Virtual Machines and Custom Script Extensions
* Virtual Networks and Virtual Network peering
* Azure Keyvaults
* Network Security Groups
* Hub and Spoke design
* User Defined Routes and hybrid connectivity
* Azure Virtual Network Gateways
* Azure Firewall network and application rules
* Designs combining the Azure Firewall and the Application Gateway
* Azure Powershell
* Azure Resource Manager (ARM) templates 

## Diagrams
<div style="width:70%; height:auto;">
  <img src="Images/Hub-and-Spoke.png" alt="Diagram">
</div>

**Note**: To simulate a simple on-premise network, I've used a separate Azure Virtual Network with a network address of 172.16.0.0/16 and added a connectivity to the cloud network with a network address of 10.0.0.0/8 via Virtual Network Gateway. 
This simulates Site-to-Site (S2S) connectivity between the two network deployment. Hence, providing a connectivity between both sites.

**Note**: The project is created on Whizlabs Azure Sandbox subscription so I've used only what was available and didn't use any other available resource sku's on Pay-as-you-go model.
By using the sandbox subscription provided, the options are limited and I'm sure that there are plenty of better ways to do it by reading Azure documentations.

## Further Details
**Azure-Networking-01** project aims to engage into an increasingly complex Azure Virtual Network setup and starts with a deep dive in hub and spoke networking and user-defined routes, and then goes on by adding components such as the Azure Application Gateway, and Azure Firewall.

Since I am using a Whizlabs Azure sandbox subscription, I've worked out with the restrictions and limits presented by the sandbox. It is also time limited to just a maximum of 3 hour per session. So, let's say you've created a session with a 3 hour limit, after the limit, all of your resources are now deleted and you're back to square one which drove me to create Azure Resource Manager templates in order to automate and redeploy resources faster. This is deployed via Azure Cloud Shell on each session and triggered by "Hub-Spoke-Deployment.ps1" powershell script.

When triggered, the powershell script first asks for desired variables to be used i.e. storage account name, keyvault name, local admin password (used on Virtual Machines), firewall policy name, and firewall name. It would then upload the custom script extension file ("IIS.ps1") which is used to download and run scripts on Azure VMs upon creation. After that, it will now deploy ARM template for Azure Key Vault creation ("KeyVault.json"). After the Key Vault is created, the script will now add a role (in this case, the role is Key Vault Administrator but please use least privilege principle) to the user and create "secrets" used to configure VMs and Virtual Network Gateway connection. It will now then proceed with resource creation as follows:

1. Network Security Group
2. Virtual Networks and Subnets
3. Virtual Machines
4. Virtual Network Gateway
5. Connect On-premise and Cloud gateways
6. Virtual Network Peering
7. Firewall Policy
8. Azure Firewall
9. Application Gateway
10. Route Tables

## The Objectives:
1. Onprem-vm should now be able to RDP on Hub-vm, Spoke1-vm, and Spoke2-vm
2. Onprem-vm can access the webpages hosted by cloud workload VMs through Application Gateway using Private IP and HTTP
3. Public requests (Allowed IPs) can reach the Application Gateway via Public IP
4. Traffic from onprem (RDP and HTTP) and public (HTTP via Application Gateway) gets inspected by Firewall

## Screenshots:
<div style="width:70%; height:auto;">
  <img src="Images/onprem-rdp-to-hub-and-spokes.png" alt="onprem-rdp-to-hub-and-spokes">
</div>
<div style="width:70%; height:auto;">
  <img src="Images/onprem-vm-curl-to-appgw.png" alt="onprem-vm-curl-to-appgw">
</div>
<div style="width:70%; height:auto;">
  <img src="Images/local-computer-curl-to-appgw.png" alt="local-computer-curl-to-appgw">
</div>
<div style="width:70%; height:auto;">
  <img src="Images/az-fw-log-data-rdp-http.png" alt="az-fw-log-data-rdp-http">
</div>

## What's Next:
I am looking into using linked ARM templates in deploying resources. <br />
Will also add the ability to create Log analytics workspace for monitoring.

