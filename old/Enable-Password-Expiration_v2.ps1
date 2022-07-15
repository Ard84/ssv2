#Automation Variables
$PasswordExpirationRules_Enabled = Get-AutomationVariable -Name "PasswordExpirationRules_Enabled"

#Enable MFA Policies
if($PasswordExpirationRules_Enabled -Like "Yes") {
  $cred = Get-AutomationPSCredential -Name "MSOL"
  Connect-MsolService -Credential $cred

	Write-Verbose 'Setting all 365 user passwords to Never Expire' -Verbose
    $Userexpire = Get-MSOLUser | Where-Object {$_.PasswordNeverExpires -ne $true}
    if ($Userexpire.Count -eq "0") {
        Write-Verbose '***All user passwords are already set to never expire' -Verbose
    } else {
        $Userexpire | Set-MSOLUser -PasswordNeverExpires $true
        Write-Verbose '***All user passwords are now set to never expire' -Verbose
    }
}
