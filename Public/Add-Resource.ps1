function Add-Resource {
  <#
    .SYNOPSIS
    Add resource

    .DESCRIPTION
    Add a resource to a JBoss instance

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss batch client.

    .PARAMETER Controller
    The controller parameter corresponds to the host to connect to.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Resource
    The resource parameter corresponds to the path to the resource.

    .PARAMETER Parameters
    The parameters parameter corresponds to the configuration of the resource to create.

    .INPUTS
    System.String. You can pipe the resource path to Add-Resource.

    .OUTPUTS
    System.String. Add-Resource returns the raw output from the JBoss client.

    .NOTES
    File name:      Add-Resource.ps1
    Author:         Florian Carrier
    Creation date:  20/01/2020
    Last modified:  20/01/2020

    .LINK
    Invoke-JBossClient

    .LINK
    Read-Resource

    .LINK
    Test-Resource

    .LINK
    Remove-Resource
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
      HelpMessage = "Path to the resource",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Resource,
    [Parameter (
      Position    = 5,
      Mandatory   = $false,
      HelpMessage = "Resource parameters"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Parameters
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Define command
    if ($PSBoundParameters.ContainsKey("Parameters")) {
      $Command = "$($Resource):add($Parameters)"
    } else {
      $Command = "$($Resource):add()"
    }
    # Execute command
    if ($PSBoundParameters.ContainsKey('Credentials')) {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
    } else {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
    }
  }
}
