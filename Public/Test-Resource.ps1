function Test-Resource {
  <#
    .SYNOPSIS
    Test resource

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
    System.String. You can pipe the resource path to Test-Resource.

    .OUTPUTS
    System.String. Test-Resource returns the raw output from the JBoss client.

    .NOTES
    File name:      Test-Resource.ps1
    Author:         Florian Carrier
    Creation date:  14/01/2020
    Last modified:  26/02/2020
    TODO            Wait for return from JBoss client to prevnt issue "Cannot validate argument on parameter 'Log'. The argument is null or empty."

    .LINK
    Invoke-JBossClient

    .LINK
    Read-Resource

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
    # Query resource
    if ($PSBoundParameters.ContainsKey('Credentials')) {
      $ReadResource = Read-Resource -Path $Path -Controller $Controller -Credentials $Credentials -Resource $Resource
    } else {
      $ReadResource = Read-Resource -Path $Path -Controller $Controller -Resource $Resource
    }
    # Check if resource exists
    if (Test-JBossClientOutcome -Log $ReadResource) {
      return $true
    } else {
      return $false
    }
  }
}
