#region declarations
$Domain = Get-AutomationVariable -Name "Domain_Complete"
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
            $null = Import-PSSession $Session -DisableNameChecking -CommandName "*-HostedOutboundSpamFilterPolicy*","*New-Transport*","*New-Safe*","*-Mailbox*","*-Sharing*","*Set-AdminAuditLog*" -AllowClobber
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


#Enable Outbound Spam Filtering Rules
$OutboundSpamFilteringRules_Enabled = Get-AutomationVariable -Name "OutboundSpamFilteringRules_Enabled"
if($OutboundSpamFilteringRules_Enabled -Like "true") {
    Get-HostedOutboundSpamFilterPolicy | Set-HostedOutboundSpamFilterPolicy -NotifyOutboundSpam $true -NotifyOutboundSpamRecipients $NotifyOutboundSpamRecipients
}

# Enable Client Forwarding Block Transport Mail Flow Rule:
$ClientForwardBlockRules_Enabled = Get-AutomationVariable -Name "ClientForwardBlockRules_Enabled" 
if($ClientForwardBlockRules_Enabled -Like "true") {
    
    if ($Clientrules.Name -Like "Client Rules Forwarding Block") {
        Write-Host '***Client Rules Forwarding Block Already Exists'
    }
    else {
        New-TransportRule "Client Rules Forwarding Block" `
            -FromScope "InOrganization" `
            -MessageTypeMatches "AutoForward" `
            -SentToScope "NotInOrganization" `
            -RejectMessageReasonText "External Email Forwarding via Client Rules is not permitted"
        Write-Host '***Client Rules Forwarding Block has now been created'
    }
}

#EnableAntipishing Rules
$SafeAttachmentRules_Enabled = Get-AutomationVariable -Name "SafeAttachmentRules_Enabled"
$SafeLinkRules_Enabled = Get-AutomationVariable -Name "SafeLinkRules_Enabled"


if($SafeAttachmentRules_Enabled -Like "true" -Or $SafeLinkRules_Enabled -Like "true") {

    # Create a Redirected Mailbox for mail that gets flagged by the Safe Attachment policy to be delivered to.
    if ($AtpMailbox.Name -Like "ATPRedirectedMessages") {
        Write-Host '***Configuration for ATP Mailbox and Default ATP Policies Already Exist'
    }
    else {
        New-Mailbox -PrimarySmtpAddress "ATPRedirectedMessages@$($Domain)" -Name ATPRedirectedMessages -DisplayName ATPRedirectedMessages -Password (ConvertTo-SecureString -AsPlainText -Force (([char[]]([char]33 .. [char]95) + ([char[]]([char]97 .. [char]126)) + 0 .. 9 | sort { Get-Random })[0 .. 8] -join '')) -MicrosoftOnlineServicesID "ATPRedirectedMessages@$($Domain)"
        Set-Mailbox -Identity "ATPRedirectedMessages@$($Domain)" -HiddenFromAddressListsEnabled $True
        Add-MailboxPermission -Identity "ATPRedirectedMessages@$($Domain)" -AutoMapping $false -InheritanceType All -User $cred.UserName -AccessRights FullAccess

        # Create a new Safe Attachment policy.
        if($SafeAttachmentRules_Enabled -Like "true") {
            New-SafeAttachmentPolicy -Name 'Default Safe Attachment Policy' -AdminDisplayName 'Default Safe Attachment Policy' -Action Replace -Redirect $True -RedirectAddress "ATPRedirectedMessages@$($Domain)" -Enable $True
            New-SafeAttachmentRule -Name 'Default Safe Attachment Rule' -RecipientDomainIs $Domain -SafeAttachmentPolicy 'Default Safe Attachment Policy' -Enabled $True
        }

        # Create a new Safe Links policy.
        if($SafeLinkRules_Enabled -Like "true") {
            New-SafeLinksPolicy -Name Default -AdminDisplayName Default -TrackClicks $true -IsEnabled $true -AllowClickThrough $false -ScanUrls $true
            New-SafeLinksRule -Name Default -RecipientDomainIs $Domain -SafeLinksPolicy Default -Enabled $true
        }
    }
}

# Disallow anonymous Calendar Sharing: Free/Busy And Disallow anonymous Calendar Detail Sharing
#Automation Variables
$AnonymousCalendarSharingRules_Enabled = Get-AutomationVariable -Name "AnonymousCalendarSharingRules_Enabled"
if($AnonymousCalendarSharingRules_Enabled -Like "true") {
    New-SharingPolicy -Name "Anonymous" -Domains 'Anonymous: CalendarSharingFreeBusySimple' -Enabled $false
        foreach($user in Get-Mailbox -RecipientTypeDetails UserMailbox) {Set-SharingPolicy -Mailbox $user -Name "Anonymous"}
    Get-SharingPolicy "Anonymous"| Format-list
}


# Set mailbox auditing on all mailboxes
#Automation Variables
$MailboxAuditingRules_Enabled = Get-AutomationVariable -Name "MailboxAuditingRules_Enabled"
if($MailboxAuditingRules_Enabled -Like "true") {
    Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox" -or RecipientTypeDetails -eq "SharedMailbox" -or RecipientTypeDetails -eq "RoomMailbox" -or RecipientTypeDetails -eq "DiscoveryMailbox"} | Set-Mailbox -AuditEnabled $true -AuditLogAgeLimit 730 -AuditAdmin Update, MoveToDeletedItems, SoftDelete, HardDelete, SendAs, SendOnBehalf, Create, UpdateFolderPermission -AuditDelegate Update, SoftDelete, HardDelete, SendAs, Create, UpdateFolderPermissions, MoveToDeletedItems, SendOnBehalf -AuditOwner UpdateFolderPermission, MailboxLogin, Create, SoftDelete, HardDelete, Update, MoveToDeletedItems 
    Write-Host -ForegroundColor Green "Set mailbox auditing on all mailboxes."
    # Enable audit data recording
    Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true -ea silentlycontinue -wa silentlycontinue
    Write-Host -ForegroundColor Green "Enabled Audit Data Recording"
}

Get-PSSession | Remove-PSSession
#endregion execute
# Close the PS Session
Remove-PSSession $Session
