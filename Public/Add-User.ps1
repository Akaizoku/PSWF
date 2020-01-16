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

    .PARAMETER Realm
    The realm parameter corresponds to the realm in which to add the user.
    There are two available realm:
    1. ApplicationRealm
    2. ManagementRealm (default value)

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
    Last modified:  15/01/2020
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
      HelpMessage = "Credentials of the user to add",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNullOrEmpty ()]
    [System.Management.Automation.PSCredential]
    $Credentials,
    [Parameter (
      Position    = 3,
      Mandatory   = $false,
      HelpMessage = "Realm in which to add the user"
    )]
    [ValidateSet (
      "ApplicationRealm",
      "ManagementRealm"
    )]
    [String]
    $Realm = "ManagementRealm",
    [Parameter (
      Position    = 4,
      Mandatory   = $false,
      HelpMessage = "User group in which to add the user"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $UserGroup,
    [Parameter (
      HelpMessage = "Silent switch"
    )]
    [Switch]
    $Silent
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Construct command
    if ($PSBoundParameters.ContainsKey("UserGroup") -And ($UserGroup)) {
      $AddUserCommand = Write-AddUserCmd -Path $Path -Credentials $Credentials -Realm $Realm -Silent:$Silent -UserGroup $UserGroup
    } else {
      $AddUserCommand = Write-AddUserCmd -Path $Path -Credentials $Credentials -Realm $Realm -Silent:$Silents
    }
    # Execute command
    $AddUser = Invoke-Expression -Command $AddUserCommand | Out-String
    Write-Log -Type "DEBUG" -Object $AddUser
    # Return outcome
    return $AddUser
  }
}
