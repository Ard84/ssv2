#region declarations
$Domain = Get-AutomationVariable -Name "SCM_Domain"
$Script:tenantDomain = Get-AutomationVariable -Name $Domain #please endter the defualt domain of the tenant the managed identity belongs to.
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
            $null = Import-PSSession $Session -DisableNameChecking -CommandName "*New-dlp*", "*unified*" -AllowClobber
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
    if ($Clientdlp.Name -Like "Argentina National Identity (DNI) Number"){
            Write-Host '*****DLP Rule Policy Argentina DNI not Installed*******'
            }else{
            $name="Argentina National Identity (DNI) Number"
            $name2="Argentina DLP"
            $sensitiveInformation=@(Name = "Argentina National Identity (DNI) Number"; minCount = “1”)
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Argentina National Identity (DNI) Number Installed*******"
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
    "Brazil"{
        if ($Clientdlp.Name -Like "Brazil National ID Card (RG)"){
            Write-Host '*****DLP Rule Policy Brazil National ID Card (RG) not Installed*******'
            }else{
            $name="Brazil National ID Card (RG)"
            $name2="Brazil DLP"
            $sensitiveInformation=@(Name = "Brazil National ID Card (RG)"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Brazil National ID Card (RG) Installed*******"
            }
    }
    
    "Canada"{
    if ($Clientdlp.Name -Like "Canada Financial Data") {
                Write-Host '***DLP for Canada Financial Data Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Canada Financial Data" -Mode $DLPRules_DeploymentMode -Template 'Canada Financial Data';
                Write-Host '***DLP for Canada Financial Data Installed'               
            }
           
            if ($Clientdlp.Name -Like "Canada Health Information Act (HIA)") {
                Write-Host '***DLP for Canada Health Information Act (HIA) Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Canada Health Information Act (HIA)" -Mode $DLPRules_DeploymentMode -Template 'Canada Health Information Act (HIA)';
                Write-Host '***DLP for Canada Health Information Act (HIA) Installed'
            }
            
            if ($Clientdlp.Name -Like "Canada Personal Health Information Act (PHIA) - Manitoba") {
                Write-Host '***DLP for Canada Personal Health Information Act (PHIA) - Manitoba Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Canada Personal Health Information Act (PHIA) - Manitoba" -Mode $DLPRules_DeploymentMode -Template 'Canada Personal Health Information Act (PHIA) - Manitoba';
                Write-Host '***DLP for Canada Personal Health Information Act (PHIA) - Manitoba Installed'               
            }
           
            if ($Clientdlp.Name -Like "Canada Personal Information Protection Act (PIPA)") {
                Write-Host '***DLP for Canada Personal Information Protection Act (PIPA) Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Canada Personal Information Protection Act (PIPA)" -Mode $DLPRules_DeploymentMode -Template 'Canada Personal Information Protection Act (PIPA)';
                Write-Host '***DLP for Canada Personal Information Protection Act (PIPA) Installed'
            }

            if ($Clientdlp.Name -Like "Canada Personal Information Protection Act (PIPEDA)") {
                Write-Host '***DLP for Canada Personal Information Protection Act (PIPEDA) Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Canada Personal Information Protection Act (PIPEDA)" -Mode $DLPRules_DeploymentMode -Template 'Canada Personal Information Protection Act (PIPEDA)';
                Write-Host '***DLP for Canada Personal Information Protection Act (PIPEDA) Installed'
            }

            if ($Clientdlp.Name -Like "Canada Personally Identifiable Information (PII) Data") {
                Write-Host '***DLP for Canada Personally Identifiable Information (PII) Data Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Canada Personally Identifiable Information (PII) Data" -Mode $DLPRules_DeploymentMode -Template 'Canada Personally Identifiable Information (PII) Data';
                Write-Host '***DLP for Canada Personally Identifiable Information (PII) Data Installed'
            }
        }

    "Chile"{
            if ($Clientdlp.Name -Like "Chile Identity Card Number"){
            Write-Host '*****DLP Rule Policy Chile Identity Card Number not Installed*******'
            }else{
            $name="Chile Identity Card Number"
            $name2="Chile DLP"
            $sensitiveInformation=@(Name = "Chile Identity Card Number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Chile Identity Card Number Installed*******"
            }
    }

    "China"{
            if ($Clientdlp.Name -Like "China Resident Identity Card (PRC) Number"){
            Write-Host '*****DLP Rule Policy China Resident Identity Card (PRC) Number not Installed*******'
            }else{
            $name="China Resident Identity Card (PRC) Number"
            $name2="China DLP"
            $sensitiveInformation=@(Name = "China Resident Identity Card (PRC) Number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy China Resident Identity Card (PRC) Number Installed*******"
            }
    }

    "Croatia"{
            if ($Clientdlp.Name -Like "Croatia Identity Card Number-"){
            Write-Host '*****DLP Rule Policy Croatia Identity Card Number- not Installed*******'
            }else{
            $name="Croatia Identity Card Number-"
            $name2="Croatia DLP"
            $sensitiveInformation=@(Name = "Croatia Identity Card Number-"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Croatia Identity Card Number- Installed*******"
            }
    }

    "Czech"{
            if ($Clientdlp.Name -Like "Czech National Identity Card Number "){
            Write-Host '*****DLP Rule Policy Czech National Identity Card Number  not Installed*******'
            }else{
            $name="Czech National Identity Card Number "
            $name2="Czech DLP"
            $sensitiveInformation=@(Name = "Czech National Identity Card Number "; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Czech National Identity Card Number  Installed*******"
            }
    }
    
    "Denmark"{
            if ($Clientdlp.Name -Like "Denmark Personal Identification Number"){
            Write-Host '*****DLP Rule Policy Denmark Personal Identification Number not Installed*******'
            }else{
            $name="Denmark Personal Identification Number"
            $name2="Denmark DLP"
            $sensitiveInformation=@(Name = "Denmark Personal Identification Number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Denmark Personal Identification Number Installed*******"
            }
    }
    
    "EU"{
    if ($Clientdlp.Name -Like "General Data Protection Regulation (GDPR)") {
                Write-Host '***DLP for General Data Protection Regulation (GDPR) Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "General Data Protection Regulation (GDPR)" -Mode $DLPRules_DeploymentMode -Template 'General Data Protection Regulation (GDPR)';
                Write-Host '***DLP for General Data Protection Regulation (GDPR) Installed'               
            }
    }

    "France"{
    if ($Clientdlp.Name -Like "France Data Protection Act") {
                Write-Host '***DLP for France Data Protection Act Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "France Data Protection Act" -Mode $DLPRules_DeploymentMode -Template 'France Data Protection Act';
                Write-Host '***DLP for France Data Protection Act Installed'               
            }
           
            if ($Clientdlp.Name -Like "France Financial Data") {
                Write-Host '***DLP for France Financial Data Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "France Financial Data" -Mode $DLPRules_DeploymentMode -Template 'France Financial Data';
                Write-Host '***DLP for France Financial Data Installed'
            }

            if ($Clientdlp.Name -Like "France Personally Identifiable Information (PII) Data") {
                Write-Host '***DLP for France Personally Identifiable Information (PII) Data Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "France Personally Identifiable Information (PII) Data" -Mode $DLPRules_DeploymentMode -Template 'France Personally Identifiable Information (PII) Data';
                Write-Host '***DLP for France Personally Identifiable Information (PII) Data Installed'
            }
    }

    "Germany"{
    if ($Clientdlp.Name -Like "Germany Financial Data") {
                Write-Host '***DLP for Germany Financial Data Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Germany Financial Data" -Mode $DLPRules_DeploymentMode -Template 'Germany Financial Data';
                Write-Host '***DLP for Germany Financial Data Installed'               
            }

            if ($Clientdlp.Name -Like "Germany Personally Identifiable Information (PII) Data") {
                Write-Host '***DLP for Germany Personally Identifiable Information (PII) Data Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Germany Personally Identifiable Information (PII) Data" -Mode $DLPRules_DeploymentMode -Template 'Germany Personally Identifiable Information (PII) Data';
                Write-Host '***DLP for Germany Personally Identifiable Information (PII) Data Installed'
            }
    }

    "Greece"{
            if ($Clientdlp.Name -Like "Greece National ID Card "){
            Write-Host '*****DLP Rule Policy Greece National ID Card  not Installed*******'
            }else{
            $name="Greece National ID Card "
            $name2="Greece DLP"
            $sensitiveInformation=@(Name = "Greece National ID Card "; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Greece National ID Card  Installed*******"
            }
    }

    "Hong Kong"{
            if ($Clientdlp.Name -Like "Hong Kong Identity Card (HKID) number"){
            Write-Host '*****DLP Rule Policy Hong Kong Identity Card (HKID) number not Installed*******'
            }else{
            $name="Hong Kong Identity Card (HKID) number"
            $name2="Hong Kong DLP"
            $sensitiveInformation=@(Name = "Hong Kong Identity Card (HKID) number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Hong Kong Identity Card (HKID) number Installed*******"
            }
    }

    "Hungary"{
            if ($Clientdlp.Name -Like ""){
            Write-Host '*****DLP Rule Policy Brazil DNI not Installed*******'
            }else{
            $name=""
            $name2=""
            $sensitiveInformation=@(Name = "Brazil National ID Card (RG)"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Argentina DNI Installed*******"
            }
    }
    
    "India"{
            if ($Clientdlp.Name -Like "India Unique Identification (Aadhaar) number"){
            Write-Host '*****DLP Rule Policy India Unique Identification (Aadhaar) not Installed*******'
            }else{
            $name="India Unique Identification (Aadhaar) number"
            $name2="India DLP"
            $sensitiveInformation=@(Name = "India Unique Identification (Aadhaar) number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy India Unique Identification (Aadhaar) number  Installed*******"
            }
    }
    
    "Indonesia"{
            if ($Clientdlp.Name -Like "Indonesia Identity Card (KTP) Number"){
            Write-Host '*****DLP Rule Policy Îndonesia not Installed*******'
            }else{
            $name="Indonesia Identity Card (KTP) Number"
            $name2="Indonesia DLP"
            $sensitiveInformation=@(Name = "Indonesia Identity Card (KTP) Number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Indonesia Installed*******"
            }
    }

    "Ireland"{
            if ($Clientdlp.Name -Like "Ireland Personal Public Service (PPS) Number"){
            Write-Host '*****DLP Rule Policy Ireland Personal Public Service (PPS) Number not Installed*******'
            }else{
            $name="Ireland Personal Public Service (PPS) Number"
            $name2="Ireland DLP"
            $sensitiveInformation=@(Name = "Ireland Personal Public Service (PPS) Number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Ireland Personal Public Service (PPS) Number Installed*******"
            }
    }

    "Israel"{
    if ($Clientdlp.Name -Like "Israel Financial Data") {
                Write-Host '***DLP for Israel Financial Data Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Israel Financial Data" -Mode $DLPRules_DeploymentMode -Template 'Israel Financial Data';
                Write-Host '***DLP for Israel Financial Data Installed'               
            }
           
            if ($Clientdlp.Name -Like "Israel Personally Identifiable Information (PII) Data") {
                Write-Host '***DLP for Israel Personally Identifiable Information (PII) Data Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Israel Personally Identifiable Information (PII) Data" -Mode $DLPRules_DeploymentMode -Template 'Israel Personally Identifiable Information (PII) Data';
                Write-Host '***DLP for Israel Personally Identifiable Information (PII) Data Installed'
            }

            if ($Clientdlp.Name -Like "Israel Protection of Privacy") {
                Write-Host '***DLP for Israel Protection of Privacy Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Israel Protection of Privacy" -Mode $DLPRules_DeploymentMode -Template 'Israel Protection of Privacy';
                Write-Host '***DLP for Israel Protection of Privacy Installed'
            }
    }

    "Italy"{
            if ($Clientdlp.Name -Like "Italy Driver license Number"){
            Write-Host '*****DLP Rule Policy Italy Drivers license Number not Installed*******'
            }else{
            $name="Italy Driver's license Number"
            $name2="Italy DLP"
            $sensitiveInformation=@(Name = "Italy Driver's license Number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Italy Driver's license Number Installed*******"
            }
    }
    
    "Japan"{
    if ($Clientdlp.Name -Like "Japan Financial Data") {
                Write-Host '***DLP for Japan Financial Data Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Japan Financial Data" -Mode $DLPRules_DeploymentMode -Template 'Japan Financial Data';
                Write-Host '***DLP for Japan Financial Data Installed'               
            }
           
            if ($Clientdlp.Name -Like "Japan Personally Identifiable Information (PII) Data") {
                Write-Host '***DLP for Japan Personally Identifiable Information (PII) Data Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Japan Personally Identifiable Information (PII) Data" -Mode $DLPRules_DeploymentMode -Template 'Japan Personally Identifiable Information (PII) Data';
                Write-Host '***DLP for Japan Personally Identifiable Information (PII) Data Installed'
            }

            if ($Clientdlp.Name -Like "Japan Protection of Personal Information") {
                Write-Host '***DLP for Japan Protection of Personal Information Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "Japan Protection of Personal Information" -Mode $DLPRules_DeploymentMode -Template 'Japan Protection of Personal Information';
                Write-Host '***DLP for Japan Protection of Personal Information Installed'
            } 
    }
    
    "Malaysia"{
            if ($Clientdlp.Name -Like "Malaysia ID Card Number"){
            Write-Host '*****DLP Rule Policy Malaysia ID Card Number not Installed*******'
            }else{
            $name="Malaysia ID Card Number"
            $name2="Malaysia DLP"
            $sensitiveInformation=@(Name = "Malaysia ID Card Number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Malaysia ID Card Number Installed*******"
            }
    }
    
    "Netherlands"{
            if ($Clientdlp.Name -Like "Netherlands Citizen's Service (BSN) Number"){
            Write-Host '*****DLP Rule Policy Netherlands Citizen Service (BSN) Number not Installed*******'
            }else{
            $name="Netherlands Citizen's Service (BSN) Number"
            $name2="Netherlands DLP"
            $sensitiveInformation=@(Name = "Netherlands Citizen's Service (BSN) Number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Netherlands Citizen's Service (BSN) NumberI Installed*******"
            }
    }

    "New Zealand"{
            if ($Clientdlp.Name -Like "New Zealand Health Number"){
            Write-Host '*****DLP Rule Policy New Zealand Health Number not Installed*******'
            }else{
            $name="New Zealand Health Number"
            $name2="NewZealand DLP"
            $sensitiveInformation=@(Name = "New Zealand Health Number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy New Zealand Health Number Installed*******"
            }
    }

    "Norway"{
            if ($Clientdlp.Name -Like "Norway Identification Number"){
            Write-Host '*****DLP Rule Policy Norway Identification Number not Installed*******'
            }else{
            $name="Norway Identification Number"
            $name2="Norway DLP"
            $sensitiveInformation=@(Name = "Norway Identification Number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Norway Identification Number Installed*******"
            }
    }

    "Philippines"{
            if ($Clientdlp.Name -Like "Philippines Unified Multi-Purpose ID number"){
            Write-Host '*****DLP Rule Policy Philippines Unified Multi-Purpose ID number not Installed*******'
            }else{
            $name="Philippines Unified Multi-Purpose ID number"
            $name2="Philippines DLP"
            $sensitiveInformation=@(Name = "Philippines Unified Multi-Purpose ID number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Philippines Unified Multi-Purpose ID number Installed*******"
            }
    }

    "Poland"{
            if ($Clientdlp.Name -Like "Poland Identity Card"){
            Write-Host '*****DLP Rule Policy Poland Identity Card not Installed*******'
            }else{
            $name="Poland Identity Card"
            $name2="Poland DLP"
            $sensitiveInformation=@(Name = "Poland Identity Card"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Poland Identity Card Installed*******"
            }
    }
    
    "Portugal"{
            if ($Clientdlp.Name -Like "Portugal Citizen Card Number"){
            Write-Host '*****DLP Rule Policy Portugal Citizen Card Number not Installed*******'
            }else{
            $name="Portugal Citizen Card Number"
            $name2="Portugal DLP"
            $sensitiveInformation=@(Name = "Portugal Citizen Card Number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Portugal Citizen Card Number Installed*******"
            }
    }
    
    "Romania"{
            if ($Clientdlp.Name -Like ""){
            Write-Host '*****DLP Rule Policy Brazil DNI not Installed*******'
            }else{
            $name=""
            $name2=""
            $sensitiveInformation=@(Name = "Brazil National ID Card (RG)"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Argentina DNI Installed*******"
            }
    }

    "Saudi Arabia"{
            if ($Clientdlp.Name -Like "Saudi Arabia National ID"){
            Write-Host '*****DLP Rule Policy Saudi Arabia National ID not Installed*******'
            }else{
            $name="Saudi Arabia National ID"
            $name2="SaudiA DLP"
            $sensitiveInformation=@(Name = "Saudi Arabia National ID"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Saudi Arabia National ID Installed*******"
            }
    }

    "Singapore"{
            if ($Clientdlp.Name -Like "Singapore National Registration Identity Card (NRIC) Number"){
            Write-Host '*****DLP Rule Policy Singapore National Registration Identity Card (NRIC) Number not Installed*******'
            }else{
            $name="Singapore National Registration Identity Card (NRIC) Number"
            $name2="Singapore DLP"
            $sensitiveInformation=@(Name = "Singapore National Registration Identity Card (NRIC) Number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Singapore National Registration Identity Card (NRIC) Number Installed*******"
            }
    }

    "South Africa"{
            if ($Clientdlp.Name -Like "South Africa Identification Number"){
            Write-Host '*****DLP Rule Policy South Africa Identification Number not Installed*******'
            }else{
            $name="South Africa Identification Number"
            $name2="SA DLP"
            $sensitiveInformation=@(Name = "South Africa Identification Number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy South Africa Identification Number Installed*******"
            }
    }

    "South Korea"{
            if ($Clientdlp.Name -Like "South Korea Resident Registration Number"){
            Write-Host '*****DLP Rule Policy South Korea Resident Registration Number not Installed*******'
            }else{
            $name="South Korea Resident Registration Number"
            $name2="South Korea DLP"
            $sensitiveInformation=@(Name = "South Korea Resident Registration Number"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy South Korea Resident Registration Number Installed*******"
            }
    }

    "Spain"{
            if ($Clientdlp.Name -Like "Spain SSN"){
            Write-Host '*****DLP Rule Policy Spain SSN not Installed*******'
            }else{
            $name="Spain SSN"
            $name2="Spain DLP"
            $sensitiveInformation=@(Name = "Spain SSN"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Spain SSN Installed*******"
            }
    }
    
    "Sweden"{
            if ($Clientdlp.Name -Like "Sweden National ID"){
            Write-Host '*****DLP Rule Policy Sweden National ID not Installed*******'
            }else{
            $name="Sweden National ID"
            $name2="Sweden DLP"
            $sensitiveInformation=@(Name = "Sweden National ID"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Sweden National ID Installed*******"
            }
    }
    
    "Taiwan"{
            if ($Clientdlp.Name -Like "Taiwanese National ID"){
            Write-Host '*****DLP Rule Policy Taiwanese National ID not Installed*******'
            }else{
            $name="Taiwanese National ID"
            $name2="Taiwan DLP"
            $sensitiveInformation=@(Name = "Taiwanese National ID"; mincount = "1")
            New-dlpcompliancepolicy -Name $name -ExchangeLocation All -Mode Enable
            New-dlpcompliancerule -Name $name2 -Policy $name -ContentContainsSensitiveInformation $sensitiveInformation -BlockAccess $true -AccessScope "NotInOrganization" -BlockAccessScope All -Disabled $false -GenerateAlert "SiteAdmin" -GenerateIncidentReport "SiteAdmin" -IncidentReportContent All -NotifyUser "Owner","SiteAdmin"
            Write-Host "******* DLP Policy Taiwanese National ID Installed*******"
            }
    }

    "United kingdom"{
    if ($Clientdlp.Name -Like "U.K. Access to Medical Reports Act") {
                Write-Host '***DLP for U.K. Access to Medical Reports Act Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "U.K. Access to Medical Reports Act" -Mode $DLPRules_DeploymentMode -Template 'U.K. Access to Medical Reports Act';
                Write-Host '***DLP for U.K. Access to Medical Reports Act'               
            }
           
            if ($Clientdlp.Name -Like "U.K. Data Protection Act") {
                Write-Host '***DLP for U.K. Data Protection Act Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "U.K. Data Protection Act" -Mode $DLPRules_DeploymentMode -Template 'U.K. Data Protection Act';
                Write-Host '***DLP for U.K. Data Protection Act Installed'
            }

            if ($Clientdlp.Name -Like "U.K. Financial Data") {
                Write-Host '***DLP for U.K. Financial Data Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "U.K. Financial Data" -Mode $DLPRules_DeploymentMode -Template 'U.K. Financial Data';
                Write-Host '***DLP for U.K. Financial Data Installed'
            }
            
            if ($Clientdlp.Name -Like "U.K. Personal Information Online Code of Practice (PIOCP)") {
                Write-Host '***DLP for U.K. Personal Information Online Code of Practice (PIOCP) Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "U.K. Personal Information Online Code of Practice (PIOCP)" -Mode $DLPRules_DeploymentMode -Template 'U.K. Personal Information Online Code of Practice (PIOCP)';
                Write-Host '***DLP for U.K. Personal Information Online Code of Practice (PIOCP) Installed'               
            }
           
            if ($Clientdlp.Name -Like "U.K. Personally Identifiable Information (PII) Data") {
                Write-Host '***DLP for U.K. Personally Identifiable Information (PII) Data Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "U.K. Personally Identifiable Information (PII) Data" -Mode $DLPRules_DeploymentMode -Template 'U.K. Personally Identifiable Information (PII) Data';
                Write-Host '***DLP for U.K. Personally Identifiable Information (PII) Data Installed'
            }

            if ($Clientdlp.Name -Like "U.K. Privacy and Electronic Communications Regulations") {
                Write-Host '***DLP for U.K. Privacy and Electronic Communications Regulations Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "U.K. Privacy and Electronic Communications Regulations" -Mode $DLPRules_DeploymentMode -Template 'U.K. Privacy and Electronic Communications Regulations';
                Write-Host '***DLP for U.K. Privacy and Electronic Communications Regulations Installed'
            }
    }
    "USA"{
    if ($Clientdlp.Name -Like "U.S. Personally Identifiable Information (PII) Data") {
                Write-Host '***DLP for U.S. State Breach Notification Laws Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "U.S. Personally Identifiable Information (PII) Data" -Mode $DLPRules_DeploymentMode -Template 'U.S. Personally Identifiable Information (PII) Data';
                Write-Host '***DLP for U.S. State Breach Notification Laws Installed'               
            }
           
            if ($Clientdlp.Name -Like "U.S. State Social Security Number Confidentiality Laws") {
                Write-Host '***DLP for U.S. State Social Security Number Confidentiality Laws Already Exists -- DLP Rule Not Installed'
            } else {
                New-DlpPolicy -Name "U.S. State Social Security Number Confidentiality Laws" -Mode $DLPRules_DeploymentMode -Template 'U.S. State Social Security Number Confidentiality Laws';
                Write-Host '***DLP for U.S. State Social Security Number Confidentiality Laws Installed'
            }
        }
    default{
            Write-Host '**No DLP Policies Deployed'
        }
    }
}


Get-PSSession | Remove-PSSession
#endregion execute
# Close the PS Session
Remove-PSSession $Session
