function Add-User {
  <#
    .SYNOPSIS
    Add user

    .DESCRIPTION
    Add a user to a JBoss instance

    .PARAMETER Path
    The path parameter corresponds to the path to the add-user script.

    .PARAMETER Credentials
    The credentials parameter corresponds to the credentials of the user to be created.

    .PARAMETER Type
    The type parameter corresponds to the type of user to be created.
    There are two available types:
    1. Management
    2. Application

    .PARAMETER UserGroup
    The optional user group parameter corresponds to the name of the user group to assign the user to.

    .INPUTS
    System.Management.Automation.PSCredential. You can pipe the credentials of the user to Add-User.

    .OUTPUTS
    System.String. Add-User returns the raw output of the add-user script.

    .NOTES
    File name:      Add-User.ps1
    Author:         Florian Carrier
    Creation date:  15/10/2019
    Last modified:  07/01/2020
    TODO            Check JBoss client script type (extension)
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "Path to the JBoss add user script"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Path,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "Credentials of the user",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
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
    switch ($Type) {
      "Application" { $Realm = "ApplicationRealm" }
      "Management"  { $Realm = "ManagementRealm"  }
    }
  }
  Process {
    Write-Log -Type "DEBUG" -Object "Add $UserType user $($Credentials.UserName)"
    # Define JBoss client command
    $AddUserCommand = "& ""$Path"" --user ""$($Credentials.UserName)"" --password ""$($Credentials.GetNetworkCredential().Password)"" --realm ""$Realm"" --silent"
    # Add user group if applicable
    if ($PSBoundParameters.ContainsKey("UserGroup") -And ($UserGroup)) {
      $AddUserCommand = $AddUserCommand + " --group ""$UserGroup"""
    }
    Write-Log -Type "DEBUG" -Object $AddUserCommand -Obfuscate $Credentials.GetNetworkCredential().Password
    # Execute add user command
    Invoke-Expression -Command $AddUserCommand | Out-String
  }
}
