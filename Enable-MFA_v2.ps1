#Automation Variables
$MFA_Enabled = Get-AutomationVariable -Name "MFA_Enabled"

#Enable MFA Policies
if($MFA_Enabled -Like "Yes") {
  $cred = Get-AutomationPSCredential -Name "MSOL"
  Connect-AzureAD -Credential $cred
  Connect-MsolService -Credential $cred

  #Enable MFA
  $multiFactor = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
  $multiFactor.RelyingParty = "*"
  $multiFactor.State = "Enforced"
  $multiFactor.RememberDevicesNotIssuedBefore = (Get-Date) 
  $multiFactorOff = @()
  $domains = Get-MsolDomain
  $secureScoreUser = Get-AutomationVariable -Name "User"

  #For all users turn MFA on
  Get-MsolUser | ForEach-Object {
      Set-MsolUser -UserPrincipalName $_.UserPrincipalName -StrongAuthenticationRequirements $multiFactor
  }

  #Turn off MFA for the SecureScore user. This is done explicitly in case SecureScore user is not in BreakGlass group yet
  Set-MsolUser -UserPrincipalName $secureScoreUser -StrongAuthenticationRequirements $multiFactorOff 

  #If there is a group called "SecureScoreBreakGlass" then exclude the additional users (i.e. Turn MFA Off for them)
  if ((Get-MsolGroup -SearchString "BreakGlass" | Measure-Object).Count -gt 0) {
    Get-MsolGroupMember -GroupObjectId (Get-MsolGroup -SearchString "BreakGlass").ObjectId | ForEach-Object {
      Set-MsolUser -UserPrincipalName $_.EmailAddress -StrongAuthenticationRequirements $multiFactorOff
    }
  }
}