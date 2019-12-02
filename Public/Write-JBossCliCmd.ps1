function Write-JBossCliCmd {
  <#
    .SYNOPSIS
    Construct JBoss client command

    .DESCRIPTION
    Generate command to call JBoss client.

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Hostname
    The hostname parameter corresponds to the name of the JBoss host.

    .PARAMETER Port
    The port parameter corresponds to the port of the management console.

    .PARAMETER Command
    The command parameter corresponds to the command to execeute.

    .PARAMETER Redirect
    The redirect parameter is a flag to enable the redirection of errors to the standard output stream.

    .NOTES
    File name:      Write-JBossCliCmd.ps1
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
      HelpMessage = "Path to JBoss client"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Path,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "Name of the host"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Hostname,
    [Parameter (
      Position    = 3,
      Mandatory   = $true,
      HelpMessage = "Port of the management console"
    )]
    [ValidateNotNUllOrEmpty ()]
    [Int]
    $Port,
    [Parameter (
      Position    = 4,
      Mandatory   = $true,
      HelpMessage = "Command to execute"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Command,
    [Parameter (
      Position    = 5,
      Mandatory   = $false,
      HelpMessage = "User credentials"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
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
    # Batch command error stream redirection
    if ($Redirect) {
      $Redirection = " 2>&1"
    } else {
      $Redirection = ""
    }
  }
  Process {
    # Define JBoss client command
    $CommandLine = '"' + $Path + '" --connect --controller=' + $Hostname + ':' + $Port + ' --command="' + $Command + '"' + $Redirection + '"'
    $CommandWrapper = 'cmd /c @echo | "' + $CommandLine
    Write-Log -Type "DEBUG" -Object $CommandWrapper
    # Return command
    return $JBossCliCmd
  }
}
