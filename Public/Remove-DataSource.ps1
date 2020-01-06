function Remove-DataSource {
  <#
    .SYNOPSIS
    Remove data-source

    .DESCRIPTION
    Remove a data-source

    .PARAMETER Path
    The path parameter corresponds to the path to the JBoss client.

    .PARAMETER Controller
    The controller parameter corresponds to the hostname and port of the JBoss host.

    .PARAMETER DataSource
    The data-source parameter corresponds to the name of the data source to remove.

    .PARAMETER Credentials
    The optional credentials parameter correspond to the credentials of the account to use to connect to JBoss.

    .NOTES
    File name:      Remove-DataSource.ps1
    Author:         Florian Carrier
    Creation date:  19/12/2019
    Last modified:  19/12/2019
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
      HelpMessage = "Name of the data source to be removed"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $DataSource
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    Write-Log -Type "INFO" -Object "Removing $DataSource data-source"
    # Define JBoss client command
    $Command = "/subsystem=datasources/data-source=""$DataSource"":remove()"
    # Execute command
    if ($PSBoundParameters.ContainsKey("Credentials")) {
      $RemoveDataSource = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command -Credentials $Credentials
    } else {
      $RemoveDataSource = Invoke-JBossClient -Path $Path -Controller $Controller -Command $Command
    }
    # Check outcome
    # /!\ Special parsing to account for failure due to missing data-source
    # If operation fails
    if (Select-String -InputObject $RemoveDataSource -Pattern '"outcome" => "failed"' -SimpleMatch -Quiet) {
      # If resource already exists
      if (Select-String -InputObject $RemoveDataSource -Pattern '"failure-description" => "(.|\t|\n|\r)*not found"' -Quiet) {
        Write-Log -Type "WARN" -Object "$DataSource data-source was not found"
      } else {
        Write-Log -Type "DEBUG" -Object $RemoveDataSource
        Write-Log -Type "ERROR" -Object "$DataSource data-source could not be unregistered" -ExitCode 1
      }
    }
    # If no errors are detected
    elseif (Select-String -InputObject $RemoveDataSource -Pattern '"outcome" => "success"' -SimpleMatch -Quiet) {
      Write-Log -Type "CHECK" -Object "$DataSource data-source was successfully unregistered"
    }
  }
}
