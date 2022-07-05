#Get Variables
$Domain = Get-AutomationVariable -Name "Domain_Complete"
$connection = Get-AutomationConnection –Name AzureRunAsConnection
$tenant = $Domain

Connect-ExchangeOnline –CertificateThumbprint $connection.CertificateThumbprint –AppId $connection.ApplicationID –ShowBanner:$false –Organization $tenant

#Enable Outbound Spam Filtering Rules
$OutboundSpamFilteringRules_Enabled = Get-AutomationVariable -Name "OutboundSpamFilteringRules_Enabled"
if($OutboundSpamFilteringRules_Enabled -Like "true") {
$CheckOutboundSpamFilter=Get-HostedOutboundSpamFilterPolicy
    if ($CheckOutboundSpamFilter.IsDefault -Like "True") {
    Write-Output '*** OutboundFilter Policy Already Exists'
    }
    else{
     New-HostedOutboundSpamFilterPolicy -Name 'Default' -RecipientLimitExternalPerHour 400 -RecipientLimitInternalPerHour 800 -RecipientLimitPerDay 800 -ActionWhenThresholdReached BlockUser
     New-HostedOutboundSpamFilterRule -Name 'Default' -Enabled $true -HostedOutboundSpamFilterPolicy 'Default' -FromMemberOf  "All Company"
     Write-Output '*** OutboundFilter Policy has now been created'
    }
}


# Enable Client Forwarding Block Transport Mail Flow Rule:
$ClientForwardBlockRules_Enabled = Get-AutomationVariable -Name "ClientForwardBlockRules_Enabled" 
if($ClientForwardBlockRules_Enabled -Like "true") {
$Clientrules = Get-TransportRule | Select Name
    if ($Clientrules.Name -Like "Client Rules Forwarding Block") {
        Write-Output '***Client Rules Forwarding Block Already Exists'
    }
    else {
        New-TransportRule "Client Rules Forwarding Block" `
            -FromScope "InOrganization" `
            -MessageTypeMatches "AutoForward" `
            -SentToScope "NotInOrganization" `
            -RejectMessageReasonText "External Email Forwarding via Client Rules is not permitted"
        Write-Output '***Client Rules Forwarding Block has now been created'
    }
}

#EnableAntipishing Rules
$SafeAttachmentRules_Enabled = Get-AutomationVariable -Name "SafeAttachmentRules_Enabled"
$SafeLinkRules_Enabled = Get-AutomationVariable -Name "SafeLinkRules_Enabled"



if($SafeAttachmentRules_Enabled -Like "true" -Or $SafeLinkRules_Enabled -Like "true") {
$AtpMailbox = Get-Mailbox
    # Create a Redirected Mailbox for mail that gets flagged by the Safe Attachment policy to be delivered to.
    if ($AtpMailbox.Name -Like "ATPRedirectedMessages") {
        Write-Output '***Configuration for ATP Mailbox and Default ATP Policies Already Exist'
    }
    else {
        New-Mailbox -PrimarySmtpAddress "ATPRedirectedMessages@$($Domain)" -Name ATPRedirectedMessages -DisplayName ATPRedirectedMessages -Password (ConvertTo-SecureString -AsPlainText -Force (([char[]]([char]33 .. [char]95) + ([char[]]([char]97 .. [char]126)) + 0 .. 9 | sort { Get-Random })[0 .. 8] -join '')) -MicrosoftOnlineServicesID "ATPRedirectedMessages@$($Domain)"
        Set-Mailbox -Identity "ATPRedirectedMessages@$($Domain)" -HiddenFromAddressListsEnabled $True
        Add-MailboxPermission -Identity "ATPRedirectedMessages@$($Domain)" -AutoMapping $false -InheritanceType All -User $cred.UserName -AccessRights FullAccess
        }
        # Create a new Safe Attachment policy.
    if($SafeAttachmentRules_Enabled -Like "true") {
        $SafeAttachmentPolicies = Get-SafeAttachmentPolicy | Select Name
    if ($SafeAttachmentPolicies.Name -Like "Default Safe Attachment Policy'") {
        Write-Output '***Safe Attachment Policies Already Exists'
    }
    else {
            New-SafeAttachmentPolicy -Name 'Default Safe Attachment Policy' -AdminDisplayName 'Default Safe Attachment Policy' -Action Replace -Redirect $True -RedirectAddress "ATPRedirectedMessages@$($Domain)" -Enable $True
            New-SafeAttachmentRule -Name 'Default Safe Attachment Rule' -RecipientDomainIs $Domain -SafeAttachmentPolicy 'Default Safe Attachment Policy' -Enabled $True
        }

        # Create a new Safe Links policy.
    if($SafeLinkRules_Enabled -Like "true") {
        $SafeLinksPolicies = Get-SafeLinksPolicy | Select Name
    if ($SafeLinksPolicies.Name -Like "Default Safe Links Policy'") {
        Write-Output '***Safe Links Policies Already Exists'
    }
    else {
            New-SafeLinksPolicy -Name 'Default Safe Links Policy' -AdminDisplayName Default -TrackClicks $true -IsEnabled $true -AllowClickThrough $false -ScanUrls $true
            New-SafeLinksRule -Name 'Default Safe Links Rule' -RecipientDomainIs $Domain -SafeLinksPolicy Default -Enabled $true
        }
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
    Write-Output -ForegroundColor Green "Set mailbox auditing on all mailboxes."
    # Enable audit data recording
    Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true -ea silentlycontinue -wa silentlycontinue
    Write-Output -ForegroundColor Green "Enabled Audit Data Recording"
}
