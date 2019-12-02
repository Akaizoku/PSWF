function Invoke-JBossCli {
  <#
    .SYNOPSIS
    Call JBoss client

    .DESCRIPTION
    Execute a specified command using the JBoss client

    .PARAMETER Properties
    The properties parameter corresponds to the environment properties.

    .PARAMETER Command
    The command parameter corresponds to the command to execute.

    .PARAMETER Redirect
    The redirect parameter is a flag to enable the redirection of errors to the standard output stream.

    .NOTES
    File name:      Invoke-JBossCli.ps1
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
      HelpMessage = "Properties"
    )]
    [ValidateNotNUllOrEmpty ()]
    [System.Collections.Specialized.OrderedDictionary]
    $Properties,
    [Parameter (
      Position    = 4,
      Mandatory   = $true,
      HelpMessage = "Command to execute"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Command,
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
    # Construct JBoss client command
    $JBossCliCmd = Write-JBossCliCmd -Path $Properties.JBossCli -Hostname $Properties.Hostname -Port $Properties.ManagementPort -Command $Command -Redirect:$Redirect
    # Execute command
    $JBossCliLog = Invoke-Expression -Command $JBossCliCmd | Out-String
    # Return log
    return $JBossCliLog
  }
}
