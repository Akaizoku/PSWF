function Set-JVMProperties {
  <#
    .SYNOPSIS
    Configure JVM

    .DESCRIPTION
    Configure Java Virtual Machine properties

    .PARAMETER Properties
    The properties parameter corressponds to the application configuration.

    .NOTES
    File name:      Set-JVMProperties.ps1
    Author:         Florian Carrier
    Creation date:  15/10/2019
    Last modified:  15/10/2019
    Warning:        /!\ JAVA_OPTS environment variable takes precedence
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "List of properties"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.Collections.Specialized.OrderedDictionary]
    $Properties,
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
    $BinDirectory         = Join-Path -Path $Properties.JBossHomeDirectory  -ChildPath $Properties.WildFlyBinDirectory
    $JVMConfigurationFile = Join-Path -Path $BinDirectory -ChildPath $Properties.WSStandaloneConfig
    $JVMConfiguration     = Get-Content -Path $JVMConfigurationFile
    # Select configuration anchor line number
    $AnchorLine = $JVMConfiguration | Select-String -Pattern "$($Properties.JavaOptionsAnchor)" | Select-Object -ExpandProperty "LineNumber"
    # Update configuration
    $JavaOpts = 'set "JAVA_OPTS=' + $JavaOptions + '"'
    Write-Log -Type "DEBUG" -Object $JavaOpts
    $JVMConfiguration[$AnchorLine] = $JavaOpts
    # Save configuration file
    Set-Content -Path $JVMConfigurationFile -Value $JVMConfiguration
  }
}
