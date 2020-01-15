function Write-AddUserCmd {
  <#
    .SYNOPSIS
    Construct Add-User script command

    .DESCRIPTION
    Generate command to call the JBoss Add-User script.

    .PARAMETER Path
    The path parameter corresponds to the path to the Add-User script.

    .PARAMETER Credentials
    The credentials parameter corresponds to the credentials of the user to be created.

    .PARAMETER Realm
    The realm parameter corresponds to the realm in which to add the user.
    There are two available realm:
    1. ApplicationRealm
    2. ManagementRealm

    .PARAMETER UserGroup
    The optional user group parameter corresponds to the name of the user group to assign the user to.

    .INPUTS
    System.Management.Automation.PSCredential. You can pipe the credentials of the user to Write-AddUserCmd.

    .OUTPUTS
    System.String. Write-AddUserCmd returns the Add-User formatted command.

    .NOTES
    File name:      Write-AddUserCmd.ps1
    Author:         Florian Carrier
    Creation date:  14/01/2020
    Last modified:  15/01/2020
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
      HelpMessage = "Credentials of the user to add",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNullOrEmpty ()]
    [System.Management.Automation.PSCredential]
    $Credentials,
    [Parameter (
      Position    = 3,
      Mandatory   = $true,
      HelpMessage = "Realm in which to add the user"
    )]
    [ValidateSet (
      "ApplicationRealm",
      "ManagementRealm"
    )]
    [String]
    $Realm,
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
    # Define command
    $Command = "& ""$Path"" --user ""$($Credentials.UserName)"" --password ""$($Credentials.GetNetworkCredential().Password)"" --realm ""$Realm"""
    # Add user group if applicable
    if ($PSBoundParameters.ContainsKey("UserGroup") -And ($UserGroup)) {
      $Command = $Command + " --group ""$UserGroup"""
    }
    # Add silent switch if applicable
    if ($Silent) {
      $Command = $Command + " --silent"
    }
    # Debugging with obfuscation
    Write-Log -Type "DEBUG" -Object $Command -Obfuscate $Credentials.GetNetworkCredential().Password
    # Return command
    return $Command
  }
}
