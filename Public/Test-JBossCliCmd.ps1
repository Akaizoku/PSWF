# ------------------------------------------------------------------------------
# Test JBoss client command outcome
# ------------------------------------------------------------------------------
function Test-JBossCliCmd {
  [CmdletBinding()]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "JBoss client command output log"
    )]
    [ValidateNotNullOrEmpty()]
    [Object]
    $Log,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "Name of the resource affected"
    )]
    [String]
    $Object,
    [Parameter (
      Position    = 3,
      Mandatory   = $true,
      HelpMessage = "Operation performed"
    )]
    [String]
    $Verb,
    [Parameter (
      Position    = 4,
      Mandatory   = $false,
      HelpMessage = "Past tense of the operational verb"
    )]
    [String]
    $Irregular,
    [Parameter (
      HelpMessage = "Flag whether the plural form should be used"
    )]
    [Switch]
    $Plural = $false
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Format output
    if ($PSBoundParameters["Irregular"]) {
      $FormattedVerb = Format-String -String $Irregular -Format "lowercase"
    } else {
      $Verb = Format-String -String $Verb -Format "lowercase"
      if ($Verb.SubString($Verb.Length - 1, 1) -eq "e") {
        $FormattedVerb = $Verb + "d"
      } else {
        $FormattedVerb = $Verb + "ed"
      }
    }
    if ($Plural) {
      $FormattedSuccess   = "have been successfully"
      $FormattedDuplicate = "are already"
    } else {
      $FormattedSuccess   = "has been successfully"
      $FormattedDuplicate = "is already"
    }
  }
  Process {
    Write-Log -Type "DEBUG" -Object $Log
    # If (at least one) operation fails
    if (Select-String -InputObject $Log -Pattern '"outcome" => "failed"' -SimpleMatch -Quiet) {
      # If resource already exists
      if (Select-String -InputObject $Log -Pattern '"failure-description" => "WFLYCTL0212: Duplicate resource' -SimpleMatch -Quiet) {
        Write-Log -Type "WARN" -Object "$Object $FormattedDuplicate $FormattedVerb"
      } else {
        Write-Log -Type "ERROR" -Object "$Object could not be $FormattedVerb"
        Write-Log -Type "ERROR" -Object $Log -ErrorCode 1
      }
    }
    # Case when calling JBoss Cli manually and no build outcome is generated
    elseif ((Select-String -InputObject $Log -Pattern '"outcome" => "success"' -SimpleMatch -Quiet) -And (-Not (Select-String -InputObject $Log -Pattern "BUILD FAILED" -SimpleMatch -Quiet))) {
      Write-Log -Type "CHECK" -Object "$Object $FormattedSuccess $FormattedVerb"
    }
    # Case when no errors have been encountered and the build outcome is successfull
    elseif (Select-String -InputObject $Log -Pattern 'BUILD SUCCESSFUL' -SimpleMatch -Quiet) {
      Write-Log -Type "CHECK" -Object "$Object $FormattedSuccess $FormattedVerb"
    } else {
      Write-Log -Type "ERROR" -Object "$Object could not be $FormattedVerb"
      Write-Log -Type "ERROR" -Object $Log -ErrorCode 1
    }
  }
}
