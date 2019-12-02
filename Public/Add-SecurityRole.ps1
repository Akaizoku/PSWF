function Add-SecurityRole {
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "Properties"
    )]
    [ValidateNotNUllOrEmpty ()]
    [System.Collections.Specialized.OrderedDictionary]
    $Properties,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "Name of the role to be created"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Name
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Batch command error stream redirection
    $Redirection = "2>&1"
  }
  Process {
    Write-Log -Type "INFO" -Object "Creating $Name role"
    # TODO check if role already exists
    # Define JBoss client command
    $Command = "/core-service=management/access=authorization/role-mapping=$($Name):add"
    # Execute command
    $AddRole = Invoke-JBossCli -Properties $Properties -Command $Command -Redirect
    Test-JBossCliCmd -Log $AddRole -Object "$Name role" -Verb "create"
  }
}
