function Read-Resource {
  <#
    .SYNOPSIS
    Read resource

    .DESCRIPTION
    Check if a resource exists on a JBoss web-application server

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss batch client.

    .PARAMETER Controller
    The controller parameter corresponds to the host to connect to.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Resource
    The resource parameter corresponds to the path to the resource.

    .INPUTS
    System.String. You can pipe the resource path to Read-Resource.

    .OUTPUTS
    System.String. Read-Resource returns the raw output from the JBoss client.

    .NOTES
    File name:      Read-Resource.ps1
    Author:         Florian Carrier
    Creation date:  20/12/2019
    Last modified:  14/01/2020

    .LINK
    Invoke-JBossClient

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
    $Resource
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Define command
    $Command = "$($Resource):read-resource()"
    # Execute command
    if ($PSBoundParameters.ContainsKey('Credentials')) {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
    } else {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
    }
  }
}
