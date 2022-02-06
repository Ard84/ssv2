$cred = Get-AutomationPSCredential -Name "MSOnline"
Connect-AzureAD -Credential $cred
Connect-MsolService -Credential $cred

### Variables

$ResourceGroup=atssv16dev0
$Location=EastUS
$WorkspaceName=TestADR


### Check if resource group exist
Get-AzResourceGroup -Name $ResourceGroup -ErrorAction Stop
### Check if log Workspace exist

### Create log workspace.

New-AzOperationalInsightsWorkspace -Location $Location -Name $WorkspaceName -Sku Standard -ResourceGroupName $ResourceGroup

### Create rules