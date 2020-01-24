function Write-JBossClientCmd {
  <#
    .SYNOPSIS
    Construct JBoss client command

    .DESCRIPTION
    Generate command to call JBoss client.

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
    File name:      Write-JBossClientCmd.ps1
    Author:         Florian Carrier
    Creation date:  21/10/2019
    Last modified:  15/01/2020
    TODO:           - Handle path with spaces with batch script
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $false,
      HelpMessage = "Path to JBoss client"
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
    # JBoss client path
    if ($PSBoundParameters.ContainsKey('Path')) {
      $JBossCliPath = $Path
    } else {
      # Use PATH environment variable
      $JBossCliPath = 'jboss-cli.bat'
    }
    # Batch command error stream redirection
    if ($Redirect) {
      $Redirection = "2>&1"
    } else {
      $Redirection = ""
    }
  }
  Process {
    # Define baseline JBoss client call command
    $Baseline = "--connect"
    # Add controller (if provided)
    if ($PSBoundParameters.ContainsKey("Controller")) {
      $Baseline = $Baseline + " --controller='$Controller'"
    }
    # Add credentials (if provided)
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      $Baseline = $Baseline + " --user='$($Credentials.UserName)' --password='$($Credentials.GetNetworkCredential().Password)'"
    }
    # Add command parameter
    $CommandLine = $Baseline + " --command='$Command'"
    # Check JBoss client type (extension)
    $Extension = $Path.SubString($Path.LastIndexOf("."), $Path.Length - $Path.LastIndexOf("."))
    switch ($Extension) {
      ".bat" {
        # Wrap command to use Windows Command Line
        # TODO bypass user action requirements
        $JBossCliCmd = "cmd /c ""$Path"" $CommandLine $Redirection".Trim()
      }
      ".ps1" {
        $JBossCliCmd = "& ""$Path"" $CommandLine".Trim()
      }
      default {
        # If path exists
        if ($JBossClient) {
          Write-Log -Type "ERROR" -Object "Unsupported JBoss client type ($Extension)"
        }
        Write-Log -Type "WARN"  -Object "Defaulting to Windows Command line."
        $JBossCliCmd = "cmd /c '""$Path"" $CommandLine $Redirection'".Trim()
      }
    }
    # Debugging with obfuscation (if applicable)
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Write-Log -Type "DEBUG" -Object $JBossCliCmd -Obfuscate $Credentials.GetNetworkCredential().Password
    } else {
      Write-Log -Type "DEBUG" -Object $JBossCliCmd
    }
    # Return command
    return $JBossCliCmd
  }
}
