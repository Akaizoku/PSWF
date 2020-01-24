function Test-Module {
  <#
    .SYNOPSIS
    Test module

    .DESCRIPTION
    Check if a module exists on a JBoss web-application server

    .PARAMETER JBossHome
    The optional JBoss home parameter corresponds to the path to the JBoss home directory.

    .PARAMETER Module
    The module parameter corresponds to the name of the JDBC driver module.

    .INPUTS
    System.String. You can pipe the module name to Test-Module.

    .OUTPUTS
    Boolean. Test-Module returns the a boolean depending if the module has been found or not.

    .NOTES
    File name:      Test-Module.ps1
    Author:         Florian Carrier
    Creation date:  06/01/2020
    Last modified:  14/01/2020
    WARNING         Values passed from pipeline can only be used in the process section

    .LINK
    Invoke-JBossClient
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "Path to the JBoss home directory"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $JBossHome,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "Name of the module to test",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Module
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Define module path
    $ModulePath = Join-Path -Path $JBossHome -ChildPath "modules"
    foreach ($Directory in $Module.Split(".")) {
      $ModulePath = Join-Path -Path $ModulePath -ChildPath $Directory
    }
    # Test module path
    Write-Log -Type "DEBUG" -Object $ModulePath
    if (Test-Path -Path $ModulePath) {
      return $true
    } else {
      return $false
    }
  }
}
