function Set-JavaOptions {
  <#
    .SYNOPSIS
    Configure java options

    .DESCRIPTION
    Configure Java Virtual Machine options

    .PARAMETER Path
    The path parameter corresponds to the path to the application configuration file.

    .PARAMETER JavaOptions
    The java options parameter corresponds to the Java options to configure for the JVM.

    .NOTES
    File name:      Set-JavaOptions.ps1
    Author:         Florian Carrier
    Creation date:  15/10/2019
    Last modified:  12/12/2019
    Warning:        /!\ JAVA_OPTS environment variable takes precedence
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "Path to WildFly configuration file"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Path,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "Java options"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $JavaOptions
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    Write-Log -Type "INFO" -Object "Configure Java Virtual Machine (JVM)"
    $JVMConfiguration = Get-Content -Path $Path
    # Select configuration anchor line number
    $AnchorLine = $JVMConfiguration | Select-String -Pattern 'rem # JVM memory allocation pool parameters - modify as appropriate.' | Select-Object -ExpandProperty "LineNumber"
    # Update configuration
    $JavaOpts = 'set "JAVA_OPTS=' + $JavaOptions + '"'
    Write-Log -Type "DEBUG" -Object $JavaOpts
    $JVMConfiguration[$AnchorLine] = $JavaOpts
    # Save configuration file
    Set-Content -Path $Path -Value $JVMConfiguration
  }
}
