function Enable-RBAC {
  <#
    .SYNOPSIS
    Configure WildFly security

    .DESCRIPTION
    Configure role-based access control model security for WildFly

    .PARAMETER Properties
    The properties parameter corressponds to the application configuration.

    .NOTES
    File name:      Enable-RBAC.ps1
    Author:         Florian Carrier
    Creation date:  18/10/2019
    Last modified:  21/10/2019
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
    $Properties
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Batch command error stream redirection
    $Redirection = "2>&1"
  }
  Process {
    Write-Log -Type "INFO" -Object "Enabling role-based access control security model"
    # TODO
    $EnableRBAC = 'cmd /c @echo | ' + $Properties.JBossCli + ' --connect --controller=' + $Properties.Hostname + ':' + $Properties.HTTPManagementPort + ' --command="/core-service=management/access=authorization:write-attribute(name=provider,value=rbac)" ' + $Redirection
    Write-Log -Type "DEBUG" -Object $EnableRBAC
    $RBACSetupLog = Invoke-Expression -Command $EnableRBAC | Out-String
    Test-JBossCliCmd -Log $RBACSetupLog -Object "RBAC security model" -Verb "enable"
  }
}
