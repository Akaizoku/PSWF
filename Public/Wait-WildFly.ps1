function Wait-WildFly {
  <#
    .SYNOPSIS
    Wait until WildFly is running

    .DESCRIPTION
    Wait until the web-application server has finished loading and is ready to use

    .PARAMETER Path
    The optional path parameter corresponds to the path to the JBoss batch client.

    .PARAMETER Controller
    The controller parameter corresponds to the host to connect to.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER TimeOut
    The optional time-out parameter corresponds to the wait period after which the resource is declared unreachable.

    .PARAMETER RetryInterval
    The optional retry interval parameter is the interval in millisecond in between each queries to check the availability of the web resource.

    .NOTES
    File name:     Wait-WildFly.ps1
    Author:        Florian Carrier
    Creation date: 20/12/2019
    Last modified: 20/12/2019
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
      HelpMessage = "Time in seconds before time-out"
    )]
    [ValidateNotNullOrEmpty ()]
    [Int]
    $TimeOut = 60,
    [Parameter (
      Position    = 5,
      Mandatory   = $false,
      HelpMessage = "Interval in between retries"
    )]
    [ValidateNotNullOrEmpty ()]
    [Int]
    $RetryInterval = 1
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    Write-Log -Type "DEBUG" -Object "Waiting for WildFly to be available"
    $Timer = [System.Diagnostics.Stopwatch]::StartNew()
    while (($Timer.Elapsed.TotalSeconds -lt $TimeOut) -And ((Read-ServerState -Path $Path -Controller $Controller -Credentials $Credentials) -ne "running")) {
      Start-Sleep -Seconds $RetryInterval
    }
    $Timer.Stop()
    # Check state
    if (($Timer.Elapsed.TotalSeconds -gt $TimeOut) -And ((Read-ServerState -Path $Path -Controller $Controller -Credentials $Credentials) -ne "running")) {
      # Timeout
      return $false
    } else {
      return $true
    }
  }
}
