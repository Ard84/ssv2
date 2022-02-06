#region declarations
$Script:tenantDomain = Get-AutomationVariable -Name "SCM_Domain" #please endter the defualt domain of the tenant the managed identity belongs to.
#endregion declarations

#region functions
function makeMSIOAuthCred () {
    $accessToken = Get-AzAccessToken -ResourceUrl "https://outlook.office365.com/"
    $authorization = "Bearer {0}" -f $accessToken.Token
    $Password = ConvertTo-SecureString -AsPlainText $authorization -Force
    $tenantID = (Get-AzTenant).Id
    $MSIcred = New-Object System.Management.Automation.PSCredential -ArgumentList ("OAuthUser@$tenantID",$Password)
    return $MSICred
}

function connectEXOAsMSI ($OAuthCredential) {
    #Function to connect to Exchange Online using OAuth credentials from the MSI
    $psSessions = Get-PSSession | Select-Object -Property State, Name
    If (((@($psSessions) -like '@{State=Opened; Name=RunSpace*').Count -gt 0) -ne $true) {
        Write-Verbose "Creating new EXOPSSession..." -Verbose
        try {
            $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/PowerShell-LiveId?BasicAuthToOAuthConversion=true&email=SystemMailbox%7bbb558c35-97f1-4cb9-8ff7-d53741dc928c%7d%40$tenantDomain" -Credential $OAuthCredential -Authentication Basic -AllowRedirection
            $null = Import-PSSession $Session -DisableNameChecking -CommandName "*Enable-OrganizationCustomization*", "*unified*" -AllowClobber
            Write-Verbose "New EXOPSSession established!" -Verbose
        } catch {
            Write-Error $_
        }
    } else {
        Write-Verbose "Found existing EXOPSSession! Skipping connection." -Verbose
    }
}
#endregion functions

#region execute
$null = Connect-AzAccount -Identity
$null = Connect-ExchangeOnline -Identity
connectEXOAsMSI -OAuthCredential (makeMSIOAuthCred)

#Do some exchange scripting here!
#Automation Variables


Get-PSSession | Remove-PSSession
#endregion execute
#Automation Variables
$Clientdlp = Get-DlpPolicy
$Domains = (Get-AcceptedDomain | Where-Object {$_.Default -eq $true}) 
$Domain = Get-AutomationVariable -Name "SCM_Domain"
$DLPRules_Enabled = Get-AutomationVariable -Name "DLPRules_Enabled"
$DLPRules_Selection = Get-AutomationVariable -Name "DLPRules_Selection"
$DLPRules_DeploymentMode = Get-AutomationVariable -Name "DLPRules_DeploymentMode"

if($DLPRules_Enabled -Like "Yes") {

    switch($DLPRules_Selection) {
    "Argentina"{
    if ($Clientdlp.Name -Like "Argentina Personally Identifiable Information"){
            Write-Host ''
            }else{
            New-DLP
            Write-Host "******* DLP Policy Argentina DNI Installed"
            }
    }
    
    "Australia"{
    if ($Clientdlp.Name -Like "Australia Financial Data") {
                Write-Host '***DLP for Australia Financial Data Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Australia Financial Data" -Mode $DLPRules_DeploymentMode -Template 'Australia Financial Data';
                Write-Host '***DLP for Australia Financial Data Installed'               
            }
           
            if ($Clientdlp.Name -Like "Australia Health Records Act (HRIP Act)") {
                Write-Host '***DLP for Australia Health Records Act (HRIP Act) Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Australia Health Records Act (HRIP Act)" -Mode $DLPRules_DeploymentMode -Template 'Australia Health Records Act (HRIP Act)';
                Write-Host '***DLP for Australia Health Records Act (HRIP Act) Installed'
            }

            if ($Clientdlp.Name -Like "Australia Personally Identifiable Information (PII) Data") {
                Write-Host '***DLP for Australia Personally Identifiable Information (PII) Data Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Australia Personally Identifiable Information (PII) Data" -Mode $DLPRules_DeploymentMode -Template 'Australia Personally Identifiable Information (PII) Data';
                Write-Host '***DLP for Australia Personally Identifiable Information (PII) Data Installed'
            }
    }
    
    "Australia"{}
    
    "Brazil"{}
    
    "Canada"{}

    "Chile"{}

    "China"{}

    "Croatia"{}

    "Czech"{}
    
    "Denmark"{}
    
    "EU"{}

    "France"{}

    "Germany"{}

    "Greece"{}

    "Hong Kong"{}
    
    "India"{}
    
    "Indonesia"{}

    "Ireland"{}

    "Israel"{}

    "Italy"{}
    
    "Japan"{}
    
    "Malaysia"{}
    
    "Netherlands"{}

    "New Zeland"{}

    "Norway"{}

    "Philippines"{}

    "Poland"{}
    
    "Portugal"{}
    
    "Saudi Arabia"{}

    "Singapore"{}

    "South Africa"{}

    "South Korea"{}

    "Spain"{}
    
    "Sweden"{}
    
    "Taiwan"{}

    "United kingdom"{}

    "USA"{}

    }

}



# Close the PS Session
Remove-PSSession $Session
