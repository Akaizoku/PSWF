function Invoke-JBossClient {
  <#
    .SYNOPSIS
    Call JBoss client

    .DESCRIPTION
    Execute a specified command using the JBoss client

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Command
    The command parameter corresponds to the command to execeute.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Redirect
    The redirect parameter is a flag to enable the redirection of errors to the standard output stream.

    .NOTES
    File name:      Invoke-JBossClient.ps1
    Author:         Florian Carrier
    Creation date:  21/10/2019
    Last modified:  28/01/2020
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $false,
      HelpMessage = "Path to the JBoss client"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Path,
    [Parameter (
      Position    = 2,
      Mandatory   = $false,
      HelpMessage = "Controller"
    )]
    # TODO validate format
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Controller,
    [Parameter (
      Position    = 3,
      Mandatory   = $true,
      HelpMessage = "Command to execute"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Command,
    [Parameter (
      Position    = 4,
      Mandatory   = $false,
      HelpMessage = "User credentials"
    )]
    [ValidateNotNUllOrEmpty ()]
    [System.Management.Automation.PSCredential]
    $Credentials,
    [Parameter (
      HelpMessage = "Switch to redirect error stream"
    )]
    [Switch]
    $Redirect
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # JBoss client path
    if ($PSBoundParameters.ContainsKey('Path')) {
      # Check path
      if (-Not (Test-Path -Path $Path)) {
        return "Path not found $Path"
        exit 1
      }
    } else {
      # Use PATH environment variable
      Write-Log -Type "WARN" -Object "No path was provided, using PATH environment variable"
      $Path = 'jboss-cli.ps1'
    }
    # Check controller
    if ($PSBoundParameters.ContainsKey("Controller")) {
      # Remote controller
      if ($PSBoundParameters.ContainsKey("Credentials")) {
        # Construct JBoss client command for remote controller with credentials
        $JBossCliCmd = Write-JBossClientCmd -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials -Redirect:$Redirect
      } else {
        # Construct JBoss client command for remote controller with local user
        $JBossCliCmd = Write-JBossClientCmd -Path $Path -Controller $Controller -Command $Command -Redirect:$Redirect
      }
    } else {
      # Local controller
      if ($PSBoundParameters.ContainsKey("Credentials")) {
        # Construct JBoss client command with credentials
        $JBossCliCmd = Write-JBossClientCmd -Path $Path -Command $Command -Credentials $Credentials -Redirect:$Redirect
      } else {
        # Construct JBoss client command with local user
        $JBossCliCmd = Write-JBossClientCmd -Path $Path -Command $Command -Redirect:$Redirect
      }
    }
    # Execute command
    try {
      $JBossCliLog = Invoke-Expression -Command $JBossCliCmd | Out-String
      Write-Log -Type "DEBUG" -Object $JBossCliLog
    } catch {
      return $Error[0].Exception
      exit 1
    }
    # Return log
    return $JBossCliLog
  }
}
