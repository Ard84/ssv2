#Get Variables
$Domain = Get-AutomationVariable -Name "Domain_Complete"
$connection = Get-AutomationConnection –Name AzureRunAsConnection
$tenant = $Domain

Connect-IPPSSession -CertificateThumbPrint $connection.CertificateThumbprint –AppId $connection.ApplicationID –Organization $tenant

#Automation Variables
$Clientdlp = Get-DlpPolicy
$Domain = Get-AutomationVariable -Name "SCM_Domain"
$DLPRules_Enabled = Get-AutomationVariable -Name "DLPRules_Enabled"
$DLPRules_Selection = Get-AutomationVariable -Name "DLPRules_Selection"
$DLPRules_DeploymentMode = "AuditandNotify"

if($DLPRules_Enabled -Like "true") {
$Clientdlp=Get-DlpCompliancePolicy
Write-Output $Clientdlp
    switch($DLPRules_Selection) {
    "Argentina"{
    if ($Clientdlp.Name -Like "Argentina Global Rule"){
                Write-Output '***DLP Rules for Argentina already Exists***'
            }else{
            $dlpPolicyName="Argentina Global Rule";
            $dlpRuleName="Argentina DNI TAX Rule";
            $dlpSensitiveData= @{Name="Argentina National Identity (DNI) Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Argentina Installed***'
            }
    }
    
    "Australia"{
    if ($Clientdlp.Name -Like "Australia Global Rule") {
                Write-Output '***DLP Rules for Australia already Exists***'
            } else {
            $dlpPolicyName="Australia Global Rule";
            $dlpRuleName="Australia TAX Rule";
            $dlpSensitiveData= @{Name="Australia Tax File Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Australia Installed***'
            }
    }
    "Brazil"{
    if ($Clientdlp.Name -Like "Australia Global Rule") {
                Write-Output '***DLP Rules for Australia already Exists***'
            } else {
            $dlpPolicyName="Australia Global Rule";
            $dlpRuleName="Australia DNI TAX Rule";
            $dlpSensitiveData= @{Name="Spain DNI";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Australia Installed***'
            }
    }  
    "Canada"{
    if ($Clientdlp.Name -Like "Canada Global Rule") {
                Write-Output '***DLP Rules for Canada already Exists***'
            } else {
            $dlpPolicyName="Canada Global Rule";
            $dlpRuleName="Canada ID TAX Rule";
            $dlpSensitiveData= @{Name="Canada Bank Account Number";minCount="1"},@{Name="Canada Passport Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Canada Installed***'
            }
        }

    "Chile"{
    if ($Clientdlp.Name -Like "Chile Global Rule") {
                Write-Output '***DLP Rules for Chile already Exists***'
            } else {
            $dlpPolicyName="Chile Global Rule";
            $dlpRuleName="Chile DNI Rule";
            $dlpSensitiveData= @{Name="Chile Identity Card Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Chile Installed***'
            }
    }

    "China"{
    if ($Clientdlp.Name -Like "China Global Rule") {
                Write-Output '***DLP Rules for China already Exists***'
            } else {
            $dlpPolicyName="China Global Rule";
            $dlpRuleName="China ID Rule";
            $dlpSensitiveData= @{Name="China Resident Identity Card (PRC) Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for China Installed***'
            }
    }

    "Croatia"{
    if ($Clientdlp.Name -Like "Croatia Global Rule") {
                Write-Output '***DLP Rules for Croatia already Exists***'
            } else {
            $dlpPolicyName="Croatia Global Rule";
            $dlpRuleName="Croatia ID Rule";
            $dlpSensitiveData= @{Name="Croatia Identity Card Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Australia Installed***'
            }
    }

    "Czech"{
    if ($Clientdlp.Name -Like "Czech Global Rule") {
                Write-Output '***DLP Rules for Czech already Exists***'
            } else {
            $dlpPolicyName="Czech Global Rule";
            $dlpRuleName="Czech ID TAX Rule";
            $dlpSensitiveData= @{Name="Czech Personal Identity Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Czech Installed***'
            }
    }
    
    "Denmark"{
    if ($Clientdlp.Name -Like "Denmark Global Rule") {
                Write-Output '***DLP Rules for Denmark already Exists***'
            } else {
            $dlpPolicyName="Denmark Global Rule";
            $dlpRuleName="Denmark ID Rule";
            $dlpSensitiveData= @{Name="Denmark Personal Identification Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Denmark Installed***'
            }
    }
    
    "EU"{
      if ($Clientdlp.Name -Like "Europe Global Rule") {
                Write-Output '***DLP Rules for Europe already Exists***'
            } else {
            $dlpPolicyName="Europe Global Rule";
            $dlpRuleName="Europe ID Rule";
            $dlpSensitiveData= @{Name="Austria Identity Card";minCount="1"},@{Name="Belgium National Number";minCount="1"},@{Name="Bulgaria Uniform Civil Number";minCount="1"},@{Name="Croatia Identity Card Number";minCount="1"},@{Name="Cyprus Identity Card";minCount="1"},@{Name="Czech Personal Identity Number";minCount="1"},@{Name="Denmark Personal Identification Number";minCount="1"},@{Name="Estonia Personal Identification Code";minCount="1"},@{Name="Finnish National ID";minCount="1"},@{Name="France CNI";minCount="1"},@{Name="Germany Identity Card Number";minCount="1"},@{Name="Greece National ID Card";minCount="1"},@{Name="Hungary Personal Identification Number";minCount="1"},@{Name="Ireland Personal Public Service (PPS) Number";minCount="1"},@{Name="Italy Fiscal Code";minCount="1"},@{Name="Latvia Personal Code";minCount="1"},@{Name="Lithuania Personal Code";minCount="1"},@{Name="Luxemburg National Identification Number (Natural persons)";minCount="1"},@{Name="Malta Identity Card Number";minCount="1"},@{Name="Netherlands Citizen's Service (BSN) Number";minCount="1"},@{Name="Poland National ID (PESEL)";minCount="1"},@{Name="Portugal Citizen Card Number";minCount="1"},@{Name="Romania Personal Numerical Code (CNP)";minCount="1"},@{Name="Slovakia Personal Number";minCount="1"},@{Name="Slovenia Unique Master Citizen Number";minCount="1"},@{Name="Spain DNI";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Europe Installed***'
            }
        }

    "France"{
    if ($Clientdlp.Name -Like "France Global Rule") {
                Write-Output '***DLP Rules for France already Exists***'
            } else {
            $dlpPolicyName="France Global Rule";
            $dlpRuleName="France DNI TAX Rule";
            $dlpSensitiveData= @{Name="France INSEE";minCount="1"},@{Name="France Tax Identification Number (numéro SPI.)";minCount="1"},@{Name="France CNI";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for France Installed***'
            }
    }

    "Germany"{
    if ($Clientdlp.Name -Like "Germany Global Rule") {
                Write-Output '***DLP Rules for Germany already Exists***'
            } else {
            $dlpPolicyName="Germany Global Rule";
            $dlpRuleName="Germany DNI TAX Rule";
            $dlpSensitiveData= @{Name="Germany Identity Card Number";minCount="1"},@{Name="Germany Tax Identification Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Germany Installed***'
            }
    }

    "Greece"{
    if ($Clientdlp.Name -Like "Greece Global Rule") {
                Write-Output '***DLP Rules for Greece already Exists***'
            } else {
            $dlpPolicyName="Greece Global Rule";
            $dlpRuleName="Greece DNI TAX Rule";
            $dlpSensitiveData= @{Name="Greece National ID Card";minCount="1"},@{Name="Greek Tax Identification Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Greece Installed***'
            }
    }

    "Hong Kong"{
    if ($Clientdlp.Name -Like "Hong Kong Global Rule") {
                Write-Output '***DLP Rules for Hong Kong already Exists***'
            } else {
            $dlpPolicyName="Hong Kong Global Rule";
            $dlpRuleName="Hong Kong ID Rule";
            $dlpSensitiveData= @{Name="Hong Kong Identity Card (HKID) number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Hong Kong Installed***'
            }
    }

    "Hungary"{
    if ($Clientdlp.Name -Like "Hungary Global Rule") {
                Write-Output '***DLP Rules for Hungary already Exists***'
            } else {
            $dlpPolicyName="Hungary Global Rule";
            $dlpRuleName="Hungary TAJ ID TAX Rule";
            $dlpSensitiveData= @{Name="Hungarian Social Security Number (TAJ)";minCount="1"},@{Name="Hungarian Value Added Tax Number";minCount="1"},@{Name="Hungary Passport Number";minCount="1"},@{Name="Hungary Personal Identification Number";minCount="1"},@{Name="Hungary Tax identification Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Hungary Installed***'
            }
    }
    
    "India"{
    if ($Clientdlp.Name -Like "India Global Rule") {
                Write-Output '***DLP Rules for India already Exists***'
            } else {
            $dlpPolicyName="India Global Rule";
            $dlpRuleName="India PAN GST ID AADHAAR Rule";
            $dlpSensitiveData= @{Name="India GST Number";minCount="1"},@{Name="India Permanent Account Number (PAN)";minCount="1"},@{Name="India Unique Identification (Aadhaar) Number";minCount="1"},@{Name="India Voter Id Card";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for India Installed***'
            }
    }
    
    "Indonesia"{
    if ($Clientdlp.Name -Like "Indonesia Global Rule") {
                Write-Output '***DLP Rules for Indonesia already Exists***'
            } else {
            $dlpPolicyName="Indonesia Global Rule";
            $dlpRuleName="Indonesia KTP Rule";
            $dlpSensitiveData= @{Name="Indonesia Identity Card (KTP) Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Indonesia Installed***'
            }
    }

    "Ireland"{
    if ($Clientdlp.Name -Like "Ireland Global Rule") {
                Write-Output '***DLP Rules for Ireland already Exists***'
            } else {
            $dlpPolicyName="Ireland Global Rule";
            $dlpRuleName="Ireland ID PPSRule";
            $dlpSensitiveData= @{Name="Ireland Passport Number";minCount="1"},@{Name="Ireland Personal Public Service (PPS) Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Ireland Installed***'
            }
    }

    "Israel"{
    if ($Clientdlp.Name -Like "Israel Global Rule") {
                Write-Output '***DLP Rules for Israel already Exists***'
            } else {
            $dlpPolicyName="Israel Global Rule";
            $dlpRuleName="Israel ID BANK TAX Rule";
            $dlpSensitiveData= @{Name="Israel Bank Account Number";minCount="1"},@{Name="Israel National ID";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Israel Installed***'
            }
    }

    "Italy"{
    if ($Clientdlp.Name -Like "Italy Global Rule") {
                Write-Output '***DLP Rules for Italy already Exists***'
            } else {
            $dlpPolicyName="Italy Global Rule";
            $dlpRuleName="Italy ID TAX Rule";
            $dlpSensitiveData= @{Name="Italy Fiscal Code";minCount="1"},@{Name="Italy Passport Number";minCount="1"},@{Name="Italy Value Added Tax Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Italy Installed***'
            }
    }
    
    "Japan"{
    if ($Clientdlp.Name -Like "Japan Global Rule") {
                Write-Output '***DLP Rules for Japan already Exists***'
            } else {
            $dlpPolicyName="Japan Global Rule";
            $dlpRuleName="Japan BANK ID SIN TAX Rule";
            $dlpSensitiveData= @{Name="";minCount="1"},@{Name="Japan Bank Account Number";minCount="1"},@{Name="Japan Passport Number";minCount="1"},@{Name="Japan Social Insurance Number (SIN)";minCount="1"},@{Name="Japanese Residence Card Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Japan Installed***'
            }
    }
    
    "Malaysia"{
    if ($Clientdlp.Name -Like "Malaysia Global Rule") {
                Write-Output '***DLP Rules for Malaysia already Exists***'
            } else {
            $dlpPolicyName="Malaysia Global Rule";
            $dlpRuleName="Malaysia ID Rule";
            $dlpSensitiveData= @{Name="Malaysia Identity Card Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Malaysia Installed***'
            }
    }
    
    "Netherlands"{
    if ($Clientdlp.Name -Like "Netherlands Global Rule") {
                Write-Output '***DLP Rules for Netherlands already Exists***'
            } else {
            $dlpPolicyName="Netherlands Global Rule";
            $dlpRuleName="Netherlands BSN ID TAX Rule";
            $dlpSensitiveData= @{Name="";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Netherlands Installed***'
            }
    }

    "New Zealand"{
    if ($Clientdlp.Name -Like "New Zealand Global Rule") {
                Write-Output '***DLP Rules for New Zealand already Exists***'
            } else {
            $dlpPolicyName="New Zealand Global Rule";
            $dlpRuleName="New Zealand ID HEALTH BANK Rule";
            $dlpSensitiveData= @{Name="New Zealand Social Welfare Number";minCount="1"},@{Name="New Zealand Ministry of Health Number";minCount="1"},@{Name="New Zealand Inland Revenue number";minCount="1"},@{Name="New Zealand bank account number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for New Zealand Installed***'
            }
    }

    "Norway"{
    if ($Clientdlp.Name -Like "Norway Global Rule") {
                Write-Output '***DLP Rules for Norway already Exists***'
            } else {
            $dlpPolicyName="Norway Global Rule";
            $dlpRuleName="Norway ID Rule";
            $dlpSensitiveData= @{Name="Norway Identity Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Norway Installed***'
            }
    }

    "Philippines"{
    if ($Clientdlp.Name -Like "Philippines Global Rule") {
                Write-Output '***DLP Rules for Philippines already Exists***'
            } else {
            $dlpPolicyName="Philippines Global Rule";
            $dlpRuleName="Philippines ID Rule";
            $dlpSensitiveData= @{Name="Philippines Unified Multi-Purpose ID Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Philippines Installed***'
            }
    }

    "Poland"{
    if ($Clientdlp.Name -Like "Poland Global Rule") {
                Write-Output '***DLP Rules for Poland already Exists***'
            } else {
            $dlpPolicyName="Poland Global Rule";
            $dlpRuleName="Poland ID TAX Rule";
            $dlpSensitiveData= @{Name="Poland Identity Card";minCount="1"},@{Name="Poland National ID (PESEL)";minCount="1"},@{Name="Poland Passport";minCount="1"},@{Name="Poland Tax Identification Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Poland Installed***'
            }
    }
    
    "Portugal"{
    if ($Clientdlp.Name -Like "Portugal Global Rule") {
                Write-Output '***DLP Rules for Portugal already Exists***'
            } else {
            $dlpPolicyName="Portugal Global Rule";
            $dlpRuleName="Portugal ID TAX Rule";
            $dlpSensitiveData= @{Name="Portugal Citizen Card Number";minCount="1"},@{Name="Portugal Passport Number";minCount="1"},@{Name="Portugal Tax Identification Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Portugal Installed***'
            }
    }
    
    "Romania"{
    if ($Clientdlp.Name -Like "Romania Global Rule") {
                Write-Output '***DLP Rules for Romania already Exists***'
            } else {
            $dlpPolicyName="Romania Global Rule";
            $dlpRuleName="Romania ID CNP Rule";
            $dlpSensitiveData= @{Name="Romania Passport Number";minCount="1"},@{Name="Romania Personal Numerical Code (CNP)";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Romania Installed***'
            }
    }

    "Saudi Arabia"{
    if ($Clientdlp.Name -Like "Saudi Arabia Global Rule") {
                Write-Output '***DLP Rules for Saudi Arabia already Exists***'
            } else {
            $dlpPolicyName="Saudi Arabia Global Rule";
            $dlpRuleName="Saudi Arabia ID Rule";
            $dlpSensitiveData= @{Name="Saudi Arabia National ID";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Saudi Arabia Installed***'
            }
    }

    "Singapore"{
    if ($Clientdlp.Name -Like "Singapore Global Rule") {
                Write-Output '***DLP Rules for Singapore already Exists***'
            } else {
            $dlpPolicyName="Singapore Global Rule";
            $dlpRuleName="Singapore NRIC Rule";
            $dlpSensitiveData= @{Name="Singapore National Registration Identity Card (NRIC) Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Singapore Installed***'
            }
    }

    "South Africa"{
    if ($Clientdlp.Name -Like "South Africa Global Rule") {
                Write-Output '***DLP Rules for South Africa already Exists***'
            } else {
            $dlpPolicyName="South Africa Global Rule";
            $dlpRuleName="South Africa ID Rule";
            $dlpSensitiveData= @{Name="South Africa Identification Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for South Africa Installed***'
            }
    }

    "South Korea"{
    if ($Clientdlp.Name -Like "South Korea Global Rule") {
                Write-Output '***DLP Rules for South Korea already Exists***'
            } else {
            $dlpPolicyName="South Korea Global Rule";
            $dlpRuleName="South Korea RRN Rule";
            $dlpSensitiveData= @{Name="South Korea Resident Registration Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for South Korea Installed***'
            }
    }

    "Spain"{
    if ($Clientdlp.Name -Like "Spain Global Rule") {
                Write-Output '***DLP Rules for Spain already Exists***'
            } else {
            $dlpPolicyName="Spain Global Rule";
            $dlpRuleName="Spain DNI TAX SSN Rule";
            $dlpSensitiveData= @{Name="Spain DNI";minCount="1"},@{Name="Spain Passport Number";minCount="1"},@{Name="Spain Social Security Number (SSN)";minCount="1"},@{Name="Spain Tax Identification Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Spain Installed***'
            }
    }
    
    "Sweden"{
    if ($Clientdlp.Name -Like "Sweden Global Rule") {
                Write-Output '***DLP Rules for Sweden already Exists***'
            } else {
            $dlpPolicyName="Sweden Global Rule";
            $dlpRuleName="Sweden ID TAX LICENSE Rule";
            $dlpSensitiveData= @{Name="Sweden Driver's License Number";minCount="1"},@{Name="Sweden National ID";minCount="1"},@{Name="Sweden Passport Number";minCount="1"},@{Name="Sweden Tax Identification Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Sweden Installed***'
            }
    }
    
    "Taiwan"{
    if ($Clientdlp.Name -Like "Taiwan Global Rule") {
                Write-Output '***DLP Rules for Taiwan already Exists***'
            } else {
            $dlpPolicyName="Taiwan Global Rule";
            $dlpRuleName="Taiwan ID TARC Rule";
            $dlpSensitiveData= @{Name="Taiwan National ID";minCount="1"},@{Name="Taiwan Passport Number";minCount="1"},@{Name="Taiwan Resident Certificate (ARC/TARC)";minCount="1"};
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for Taiwan Installed***'
            }
    }

    "United kingdom"{
    if ($Clientdlp.Name -Like "UK Global Rule") {
                Write-Output '***DLP Rules for UK already Exists***'
            } else {
            $dlpPolicyName="UK Global Rule";
            $dlpRuleName="UK ID TAX DRIVER LI NINO HSN Rule";
            $dlpSensitiveData= @{Name="U.S. / U.K. Passport Number";minCount="1"},@{Name="U.K. Driver's License Number";minCount="1"},@{Name="U.K. Electoral Roll Number";minCount="1"},@{Name="U.K. National Health Service Number";minCount="1"},@{Name="U.K. National Insurance Number (NINO)";minCount="1"},@{Name="U.K. Unique Taxpayer Reference Number";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for UK Installed***'
            }
    }
    "USA"{
    if ($Clientdlp.Name -Like "USA Global Rule") {
                Write-Output '***DLP Rules for USA already Exists***'
            } else {
            $dlpPolicyName="USA Global Rule";
            $dlpRuleName="USA SSN BANK ID TAX ADDRESS Rule";
            $dlpSensitiveData= @{Name="U.S. / U.K. Passport Number";minCount="1"},@{Name="U.S. Social Security Number (SSN)";minCount="1"},@{Name="U.S. Bank Account Number";minCount="1"},@{Name="U.S. Driver's License Number";minCount="1"},@{Name="U.S. Individual Taxpayer Identification Number (ITIN)";minCount="1"}
            New-DlpCompliancePolicy -Name $dlpPolicyName -Mode TestWithNotifications -ExchangeLocation All -TeamsLocation All -SharePointLocation All -OneDriveLocation All ;
            Set-DlpCompliancePolicy -Identity $dlpPolicyName -Comment "Primary policy applied to SharePoint Online, Teams, Onedrive, and Exchange Online locations.";
            New-DlpComplianceRule -Name $dlpRuleName -Policy $dlpPolicyName -ContentContainsSensitiveInformation $dlpSensitiveData -BlockAccess $True  ;         
            Write-Output '***DLP Rules for USA Installed***';
            }
        }
    default{
            Write-Output '**No DLP Policies Installed'
        }
    }
}
