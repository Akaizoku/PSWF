function Remove-SecurityDomain {
  <#
    .SYNOPSIS
    Remove security domain

    .DESCRIPTION
    Remove a security domain from a JBoss instance

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER SecurityDomain
    The security domain parameter corresponds to the name of the security domain to create.

    .INPUTS
    None. You can pipe the name of the security domain to Remove-SecurityDomain.

    .OUTPUTS
    System.String. Remove-SecurityDomain returns the raw output from the JBoss client.

    .NOTES
    File name:      Remove-SecurityDomain.ps1
    Author:         Florian Carrier
    Creation date:  20/01/2020
    Last modified:  20/01/2020

    .LINK
    Remove-Resource

    .LINK
    Add-SecurityDomain

    .LINK
    Read-SecurityDomain

    .LINK
    Test-SecurityDomain
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
    $SecurityDomain
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Define resource
    $Resource = "/subsystem=security/security-domain=$SecurityDomain"
    # Remove resource
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      Remove-Resource -Path $Path -Controller $Controller -Resource $Resource -Credentials $Credentials
    } else {
      Remove-Resource -Path $Path -Controller $Controller -Resource $Resource
    }
  }
}
