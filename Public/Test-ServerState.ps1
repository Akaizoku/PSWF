function Test-ServerState {
  <#
    .SYNOPSIS
    Test JBoss server state

    .DESCRIPTION
    Check the state of a JBoss server

    .PARAMETER Path
    The optional path parameter corresponds to the path to the JBoss batch client.

    .PARAMETER Controller
    The controller parameter corresponds to the host to connect to.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to the JBoss instance.

    .PARAMETER State
    The optional state parameter corresponds to the expected server state. The default value is "running".

    .INPUTS
    None. You cannot pipe objects to Test-ServerState.

    .OUTPUTS
    Boolean. Test-ServerState returns a boolean depending if the server state matches the provided expected state.

    .NOTES
    File name:     Test-ServerState.ps1
    Author:        Florian Carrier
    Creation date: 09/01/2020
    Last modified: 15/01/2020
  #>
  Param(
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "Path to the JBoss client"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Path,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "Controller"
    )]
    # TODO validate format
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Controller,
    [Parameter (
      Position    = 3,
      Mandatory   = $false,
      HelpMessage = "User credentials"
    )]
    [ValidateNotNUllOrEmpty ()]
    [System.Management.Automation.PSCredential]
    $Credentials,
    [Parameter (
      Position    = 4,
      Mandatory   = $false,
      HelpMessage = "Expected server state"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $State = "running"
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Read server state
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      $ReadServerState = Read-ServerState -Path $Path -Controller $Controller -Credentials $Credentials
    } else {
      $ReadServerState = Read-ServerState -Path $Path -Controller $Controller
    }
    # Check if read operation was successfull
    if (Test-JBossClientOutcome -Log $ReadServerState) {
      # Check result
      $ServerState = Get-JBossClientResult -log $ReadServerState
      if ($ServerState -eq $State) {
        # If server is running
        return $true
      } else {
        return $false
      }
    } else {
      return $false
    }
  }
}
