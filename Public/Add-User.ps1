function Add-User {
  <#
    .SYNOPSIS
    Add user

    .DESCRIPTION
    Add an user to the WildFly management interface

    .PARAMETER Properties
    The properties parameter corresponds to the application configuration.

    .PARAMETER Credentials
    The credentials parameter corresponds to the credentials of the user to be created.

    .PARAMETER Type
    The type parameter corresponds to the type of user to be created.
    There are two available types:
    1. Management
    2. Application

    .PARAMETER Realm
    The type parameter corresponds to the name of the realm used to secure the management interfaces.
    There are two available types:
    1. Management
    2. Application

    .NOTES
    File name:      Add-User.ps1
    Author:         Florian Carrier
    Creation date:  15/10/2019
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
    $Properties,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "Credentials of the administration user"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.Management.Automation.PSCredential]
    $Credentials,
    [Parameter (
      Position    = 3,
      Mandatory   = $true,
      HelpMessage = "Type of user"
    )]
    [ValidateSet (
      "Management",
      "Application"
    )]
    [String]
    $Type,
    [Parameter (
      Position    = 4,
      Mandatory   = $false,
      HelpMessage = "User group in which to add the user"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $UserGroup
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Format user type
    $UserType = Format-String -String $Type -Format "lowercase"
    # Define realm
    if ($Type -eq "Application") {
      $Realm = "ApplicationRealm"
    } elseif ($Type -eq "Management") {
      $Realm = "ManagementRealm"
    }
  }
  Process {
    Write-Log -Type "INFO" -Object "Add $UserType user $($Credentials.UserName)"
    $BinDirectory   = Join-Path -Path $Properties.JBossHomeDirectory  -ChildPath $Properties.WildFlyBinDirectory
    $AddUserScript  = Join-Path -Path $BinDirectory                   -ChildPath $Properties.AddUserScript
    # Define JBoss client command
    $AddUserCommand = "$AddUserScript --user $($Credentials.UserName) --password $($Credentials.GetNetworkCredential().Password) --realm '$Realm' --silent"
    # Add user group if applicable
    if ($PSBoundParameters.ContainsKey("UserGroup") -And ($UserGroup)) {
      $AddUserCommand = $AddUserCommand + " --group '$UserGroup'"
    }
    Write-Log -Type "DEBUG" -Object $AddUserCommand
    # Execute add user command
    Invoke-Expression -Command $AddUserCommand
    Write-Log -Type "CHECK" -Object "User $($Credentials.UserName) successfully created"
  }
}
