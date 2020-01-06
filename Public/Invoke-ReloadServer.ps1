function Invoke-ReloadServer {
  <#
    .SYNOPSIS
    Reload web-server

    .DESCRIPTION
    Reload JBoss web-server

    .PARAMETER Properties
    The properties parameter corresponds to the system properties.

    .EXAMPLE
    Invoke-ReloadServer -Properties $Properties

    .NOTES
    File name:      Invoke-ReloadServer.ps1
    Author:         Florian Carrier
    Creation date:  02/12/2019
    Last modified:  06/12/2019
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
      Position    = 4,
      Mandatory   = $false,
      HelpMessage = "User credentials"
    )]
    [ValidateNotNUllOrEmpty ()]
    [System.Management.Automation.PSCredential]
    $Credentials
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    Write-Log -Type "DEBUG" -Object "Reload server"
    # Define command
    $Command = ':reload'
    # Execute command
    if ($PSBoundParameters.ContainsKey('Credentials')) {
      $Status = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials -Redirect
    } else {
      $Status = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Redirect
    }
    # Check outcome
    if (Select-String -InputObject $Status -Pattern '"outcome" => "success"' -SimpleMatch -Quiet) {
      return $true
    } else {
      return $false
    }
  }
}
