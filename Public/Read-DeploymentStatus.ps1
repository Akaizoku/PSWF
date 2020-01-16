function Read-DeploymentStatus {
  <#
    .SYNOPSIS
    Read deployment status

    .DESCRIPTION
    Query the status of a deployed application

    .PARAMETER Path
    The optional path parameter corresponds to the path to the JBoss batch client.

    .PARAMETER Controller
    The controller parameter corresponds to the host to connect to.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to the JBoss instance.

    .PARAMETER Application
    The application parameter corresponds to the name of the application deployed.

    .INPUTS
    System.String. You can pipe the application name to Read-DeploymentStatus.

    .OUTPUTS
    System.String. Read-DeploymentStatus returns the raw output of the JBoss client.

    .NOTES
    File name:      Read-DeploymentStatus.ps1
    Author:         Florian Carrier
    Creation date:  20/12/2019
    Last modified:  15/01/2020
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
      HelpMessage = "Name of the application",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
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
      Read-Attribute -Path $Path -Controller $Controller -Resource $Resource -Attribute "status" -Credentials $Credentials
    } else {
      Read-Attribute -Path $Path -Controller $Controller -Resource $Resource -Attribute "status"
    }
  }
}
