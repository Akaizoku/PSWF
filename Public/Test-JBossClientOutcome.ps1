function Test-JBossClientOutcome {
  <#
    .SYNOPSIS
    Test JBoss client outcome

    .DESCRIPTION
    Check the outcome of a JBoss client operation

    .PARAMETER Log
    The log parameter corresponds to the output of the JBoss client.

    .NOTES
    File name:      Test-JBossClientOutcome.ps1
    Author:         Florian Carrier
    Creation date:  10/01/2020
    Last modified:  26/02/2020
  #>
  [CmdletBinding()]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "JBoss client command output log",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    # [ValidateNotNullOrEmpty()]
    [System.Object]
    $Log
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Check if log contains information
    if (($Log -eq $null) -Or ($Log -eq "")) {
      return $false
    } else {
      # Check JBoss client operation outcome
      if (Select-String -InputObject $Log -Pattern '"outcome" => "success"' -SimpleMatch -Quiet) {
        # If outcome is successfull
        return $true
      } else {
        # If outcome is failed or an error occured
        return $false
      }
    }
  }
}
