function Get-JBossClientResult {
  <#
    .SYNOPSIS
    Get JBoss client result

    .DESCRIPTION
    Get the result of a JBoss client operation

    .PARAMETER Log
    The log parameter corresponds to the output of the JBoss client.

    .INPUTS
    System.String. You can pipe the JBoss client operation log to Get-JBossClientResult.

    .OUTPUTS
    System.String. Get-JBossClientResult returns the result of the JBoss client operation (if any).

    .EXAMPLE
    $Log = '{
      "outcome" => "success",
      "result" => "running"
    }'
    Get-JBossClientResult -Log $Log

    In this example, Get-JBossClientResult will return the result "running" (without quotes).

    .NOTES
    File name:      Get-JBossClientResult.ps1
    Author:         Florian Carrier
    Creation date:  15/01/2020
    Last modified:  15/01/2020
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
    [ValidateNotNullOrEmpty()]
    [Object]
    $Log
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Check JBoss client operation outcome
    if (Test-JBossClientOutcome -Log $Log) {
      # Select result
      $Result = Select-String -InputObject $Log -Pattern '(?<=\"result\" \=\> ")(\w|-)*' | ForEach-Object { $_.Matches.Value }
      # Return formatted value
      return $Result.Replace('"', '').Trim()
    } else {
      # If outcome is failed or an error occured
      return $null
    }
  }
}
