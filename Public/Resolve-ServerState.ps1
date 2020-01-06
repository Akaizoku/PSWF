function Resolve-ServerState {
  <#
    .SYNOPSIS
    Try to resolve server status

    .DESCRIPTION
    Check server status and try to resolve it if possible

    .PARAMETER Path
    The optional path parameter corresponds to the path to the JBoss batch client.

    .PARAMETER Hostname
    The hostname parameter corresponds to the name of the host to conect to.

    .PARAMETER Port
    The port parameter corresponds to the port to use to connect to the server.

    .EXAMPLE
    Resolve-ServerState -Hostname localhost -Port 9990

    .EXAMPLE
    Resolve-ServerState -Path "C:\WildFly\bin\jboss-cli.bat" -Hostname localhost -Port 9990

    .EXAMPLE
    $Credentials = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList ("admin", (ConvertTo-SecureString -String "password" -AsPlainText -Force))
    Resolve-ServerState -Path "C:\WildFly\bin\jboss-cli.bat" -Hostname localhost -Port 9990 -Credentials $Credentials

    .NOTES
    File name:      Resolve-ServerState.ps1
    Author:         Florian Carrier
    Creation date:  01/12/2019
    Last modified:  02/12/2019
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
      Mandatory   = $false,
      HelpMessage = "User credentials"
    )]
    [ValidateNotNUllOrEmpty ()]
    [System.Management.Automation.PSCredential]
    $Credentials,
    [Parameter (
      HelpMessage = "Switch to use HTTPS"
    )]
    [Switch]
    $HTTPS
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Define protocol to use
    if ($HTTPS) {
      $Protocol = "HTTPS"
    } else {
      $Protocol = "HTTP"
    }
    # Define URI
    $URI = Get-URI -Scheme $Protocol -Authority $Controller
  }
  Process {
    # Get web-server status
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      $Status = Read-ServerState -Path $Path -Controller $Controller -Credentials $Credentials
    } else {
      $Status = Read-ServerState -Path $Path -Controller $Controller
    }
    # Check status
    switch ($Status) {
      'running' {
        Write-Log -Type "DEBUG" -Object "WildFly is running"
        return $true
      }
      'reload-required' {
        Write-Log -Type "WARN" -Object "WildFly must be reloaded"
        # Restart web-server
        Write-Log -Type "INFO" -Object "Reloading WildFly"
        if ($PSBoundParameters.ContainsKey("Credentials")) {
          $Reload = Invoke-ReloadServer -Path $Path -Controller $Controller -Credentials $Credentials
        } else {
          $Reload = Invoke-ReloadServer -Path $Path -Controller $Controller
        }
        # Check reload state
        if ($Reload) {
          # Wait for web-server to come back up
          if ($PSBoundParameters.ContainsKey("Credentials")) {
            $Wait = Wait-WildFly -Path $Path -Controller $Controller -Credentials $Credentials -TimeOut 60 -RetryInterval 1
          } else {
            $Wait = Wait-WildFly -Path $Path -Controller $Controller -TimeOut 60 -RetryInterval 1
          }
          # Return outcome
          return $Wait
        } else {
          return $false
        }
      }
      'down' {
        Write-Log -Type "DEBUG" -Object "WildFly is unreachable"
        return $false
      }
      default {
        Write-Log -Type "DEBUG" -Object $Status
        Write-Log -Type "ERROR" -Object "An error occurred while reloading WildFly" -ExitCode 1
      }
    }
  }
}
