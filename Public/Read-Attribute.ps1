function Read-Attribute {
  <#
    .SYNOPSIS
    Read attribute

    .DESCRIPTION
    Query an attribute of a resource on a JBoss instance

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss batch client.

    .PARAMETER Controller
    The controller parameter corresponds to the host to connect to.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .PARAMETER Resource
    The optional resource parameter corresponds to the path to the resource.

    .PARAMETER Attribute
    The attribute parameter corresponds to the name of the attribute.

    .INPUTS
    System.String. You can pipe the resource path and attribute name to Read-Attribute.

    .OUTPUTS
    System.String. Read-Attribute returns the raw output from the JBoss client.

    .NOTES
    File name:      Read-Attribute.ps1
    Author:         Florian Carrier
    Creation date:  15/01/2020
    Last modified:  21/01/2020

    .LINK
    Invoke-JBossClient

    .LINK
    Test-Attribute

    .LINK
    Remove-Attribute
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
      HelpMessage = "Path to the resource",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNull ()]
    [String]
    $Resource = '',
    [Parameter (
      Position    = 5,
      Mandatory   = $true,
      HelpMessage = "Name of the attribute",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Attribute
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Define command
    $Command = "$($Resource):read-attribute(name=$Attribute)"
    # Execute command
    if ($PSBoundParameters.ContainsKey('Credentials')) {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
    } else {
      Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
    }
  }
}
