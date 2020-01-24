function Test-Deployment {
  <#
    .SYNOPSIS
    Test deployment

    .DESCRIPTION
    Check the state of an application deployment

    .PARAMETER Path
    The optional path parameter corresponds to the path to the JBoss batch client.

    .PARAMETER Controller
    The controller parameter corresponds to the host to connect to.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to the JBoss instance.

    .PARAMETER Application
    The application parameter corresponds to the name of the application deployment to check.

    .PARAMETER State
    The optional state parameter corresponds to the expected server state. The default value is "OK".

    .INPUTS
    System.String. You can pipe the application name to Test-Deployment.

    .OUTPUTS
    Boolean. Test-Deployment returns a boolean depending if the deployment state matches the provided expected state.

    .NOTES
    File name:     Test-Deployment.ps1
    Author:        Florian Carrier
    Creation date: 15/01/2020
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
      HelpMessage = "Name of the application",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Application,
    [Parameter (
      Position    = 5,
      Mandatory   = $false,
      HelpMessage = "Expected server state"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $State = "OK"
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
      $DeploymentStatus = Read-Attribute -Path $Path -Controller $Controller -Resource $Resource -Attribute "status" -Credentials $Credentials
    } else {
      $DeploymentStatus = Read-Attribute -Path $Path -Controller $Controller -Resource $Resource -Attribute "status"
    }
    # Check outcome
    if (Test-JBossClientOutcome -Log $DeploymentStatus) {
      return $true
    } else {
      return $false
    }
  }
}
