function Set-Security {
  <#
    .SYNOPSIS
    Setup WildFLy security

    .DESCRIPTION
    Setup and configure WildFly security model

    .PARAMETER Properties
    The properties parameter corresponds to the application configuration.

    .NOTES
    File name:      Set-Security.ps1
    Author:         Florian Carrier
    Creation date:  21/10/2019
    Last modified:  21/10/2019
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "List of properties"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.Collections.Specialized.OrderedDictionary]
    $Properties
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Get admin credentials
    if ($Unattended) {
      # Use provided credentials
      $SecurePassword   = ConvertTo-SecureString -String $Properties.AdminPassword -AsPlainText -Force
      $AdminCredentials = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList ($Properties.AdminUsername, $SecurePassword)
    } else {
      # Prompt user for credentials
      $AdminCredentials = Get-Credential -Message "Please enter a username and password for WildFly administration user"
    }
  }
  Process {
    if ($Properties.EnableRBAC -eq $true) {
      # Setup role-based access control model (RBAC)
      # TODO add check if version <= 7
      # Create administration role
      Add-SecurityRole -Properties $Properties -Name "Administrator"
      # Create application administration user
      Add-User -Properties $Properties -Credentials $AdminCredentials -Type "Management" -UserGroup $Properties.AdminUserGroup
      # Map administration user group to administration role
      Grant-SecurityRole -Properties $Properties -Role "Administrator" -UserGroup $Properties.AdminUserGroup
      # Enable RBAC
      Enable-RBAC -Properties $Properties
    } else {
      # Setup administration console
      Add-User -Properties $Properties -Credentials $AdminCredentials -Type "Management"
    }
  }
}
