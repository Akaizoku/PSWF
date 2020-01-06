function Read-DeploymentStatus {
  <#
    .SYNOPSIS
    Get deployment status

    .DESCRIPTION
    Get the status of the web-application deployed

    .PARAMETER Path
    The optional path parameter corresponds to the path to the JBoss batch client.

    .PARAMETER Controller
    The controller parameter corresponds to the host to connect to.

    .PARAMETER WAR
    The WAR parameter corresponds to the name of the web-application deployed.

    .NOTES
    File name:      Read-DeploymentStatus.ps1
    Author:         Florian Carrier
    Creation date:  20/12/2019
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
    $Credentials,
    [Parameter (
      Position    = 4,
      Mandatory   = $false,
      HelpMessage = "Name of the WAR file"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $WAR
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    Write-Log -Type "DEBUG" -Object "Read deployment status attribute"
    # Define command
    $Command = "/deployment=""$WAR"":read-attribute(name=status)"
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
      # Return missing status
      return 'MISSING'
    }
  }
}