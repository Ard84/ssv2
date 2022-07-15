Write-Host '*********** Create Conditional Access Policies  Require MFA for Exchange Online v1 **************';
        $conditions = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessConditionSet;
        $conditions.Applications = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessApplicationCondition;
        $conditions.Applications.IncludeApplications = '00000002-0000-0ff1-ce00-000000000000';
        $conditions.Users = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessUserCondition;
        $conditions.Users.IncludeUsers = 'all';
        $controls = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessGrantControls;
        $controls._Operator = 'OR';
        $controls.BuiltInControls = 'mfa';
        Write-Host '*********** Print Variables **************';
        $Parameters = @{
          DisplayName     = '365 MFA Policy';
          State           = 'Disabled';
          Conditions      = $Conditions;
          GrantControls   = $controls;
        }
          Write-host @Parameters;
          New-AzureADMSConditionalAccessPolicy @Parameters;
