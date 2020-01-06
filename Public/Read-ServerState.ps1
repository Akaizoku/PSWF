function Read-ServerState {
  <#
    .SYNOPSIS
    Get web-server status

    .DESCRIPTION
    Get the status of the web-server

    .PARAMETER Path
    The optional path parameter corresponds to the path to the JBoss batch client.

    .PARAMETER Controller
    The controller parameter corresponds to the host to connect to.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .EXAMPLE
    Read-ServerState -Hostname localhost -Port 9990

    .EXAMPLE
    Read-ServerState -Path "C:\WildFly\bin\jboss-cli.bat" -Hostname localhost -Port 9990

    .EXAMPLE
    $Credentials = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList ("admin", (ConvertTo-SecureString -String "password" -AsPlainText -Force))
    Read-ServerState -Path "C:\WildFly\bin\jboss-cli.bat" -Hostname localhost -Port 9990 -Credentials $Credentials

    .NOTES
    File name:      Read-ServerState.ps1
    Author:         Florian Carrier
    Creation date:  01/12/2019
    Last modified:  20/12/2019
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
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
    $Credentials
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    Write-Log -Type "DEBUG" -Object "Read server-state attribute"
    # Define command
    $Command = ':read-attribute(name=server-state)'
    # Execute command
    if ($PSBoundParameters.ContainsKey('Credentials')) {
      $Status = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials -Redirect
    } else {
      $Status = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Redirect
    }
    # Check outcome
    if (Select-String -InputObject $Status -Pattern '"outcome" => "success"' -SimpleMatch -Quiet) {
      $Status = Select-String -InputObject $Status -Pattern '(?<=\"result\" \=\> ")(\w|-)*' -Encoding "UTF8" | ForEach-Object { $_.Matches.Value }
      # Remove double-quotes and trim
      $Status = $Status.Replace('"', '').Trim()
      # Return status
      return $Status
    } else {
      # Return down status
      return 'down'
    }
  }
}
