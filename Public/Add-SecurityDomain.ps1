function Add-SecurityDomain {
  <#
    .SYNOPSIS
    Add security domain

    .DESCRIPTION
    Add a new security domain to a JBoss instance

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER SecurityDomain
    The security domain parameter corresponds to the name of the security domain to create.

    .PARAMETER Cache
    The optional cache parameter corresponds to the type of cache to configure. The default is "default".

    .INPUTS
    None. You can pipe the name of the security domain to Add-SecurityDomain.

    .OUTPUTS
    System.String. Add-SecurityDomain returns the raw output from the JBoss client.

    .NOTES
    File name:      Add-SecurityDomain.ps1
    Author:         Florian Carrier
    Creation date:  20/01/2020
    Last modified:  20/01/2020

    .LINK
    Add-Resource

    .LINK
    Test-SecurityDomain

    .LINK
    Read-SecurityDomain

    .LINK
    Remove-SecurityDomain
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
      HelpMessage = "Name of the security domain to be created",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $SecurityDomain,
    [Parameter (
      Position    = 5,
      Mandatory   = $false,
      HelpMessage = "Type of the cache"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $ChacheType = "default"
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Define attributes
    $Resource   = "/subsystem=security/security-domain=$SecurityDomain"
    $Parameters = "cache-type=\""$ChacheType\"""
    # Add resource
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Add-Resource -Path $Path -Controller $Controller -Resource $Resource -Parameters $Parameters -Credentials $Credentials
    } else {
      Add-Resource -Path $Path -Controller $Controller -Resource $Resource -Parameters $Parameters
    }
  }
}
