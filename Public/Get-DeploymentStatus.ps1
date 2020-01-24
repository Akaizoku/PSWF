function Get-DeploymentStatus {
  <#
    .SYNOPSIS
    Get deployment status

    .DESCRIPTION
    Get the status of a deployed application

    .PARAMETER Path
    The optional path parameter corresponds to the path to the JBoss batch client.

    .PARAMETER Controller
    The controller parameter corresponds to the host to connect to.

    .PARAMETER Application
    The application parameter corresponds to the name of the application deployed.

    .INPUTS
    None. You cannot pipe object to Get-DeploymentStatus.

    .OUTPUTS
    System.String. Get-DeploymentStatus returns the status of the deployment.

    The possible values are:
    - OK:       indicates that the application is up and running.
    - FAILED:   indicates a dependency is missing or a service could not start.
    - STOPPED:  indicates that the application is not enabled or was manually stopped.
    - KO:       indicates that the application is not deployed.

    .NOTES
    File name:      Get-DeploymentStatus.ps1
    Author:         Florian Carrier
    Creation date:  15/01/2020
    Last modified:  15/01/2020

    .LINK
    Read-DeploymentStatus

    .LINK
    Get-JBossClientResult
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
      Mandatory   = $true,
      HelpMessage = "Name of the application"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Application
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Define resource
    $Resource = "/deployment=$Application"
    # Query resource
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      $DeploymentStatus = Read-DeploymentStatus -Path $Path -Controller $Controller -Application $Application -Credentials $Credentials
    } else {
      $DeploymentStatus = Read-DeploymentStatus -Path $Path -Controller $Controller -Application $Application
    }
    # Get result
    $Result = Get-JBossClientResult -Log $DeploymentStatus
    if ($Result) {
      return $Result
    } else {
      # If application is not deployed
      return "KO"
    }
  }
}
