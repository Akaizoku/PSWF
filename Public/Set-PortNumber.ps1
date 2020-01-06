function Set-PortNumber {
  <#
    .SYNOPSIS
    Configure port number

    .DESCRIPTION
    Configure port number for a specified socket

    .PARAMETER Path
    The path parameter corresponds to the path to the configuration file.

    .PARAMETER Name
    The name parameter corresponds to the name of the interface to configure.

    .PARAMETER Value
    The value parameter corresponds to port number to configure.

    .NOTES
    File name:      Set-PortNumber.ps1
    Author:         Florian Carrier
    Creation date:  15/10/2019
    Last modified:  12/12/2019
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "Path to the configuration file"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Path,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "Name of the socket"
    )]
    [ValidateNotNUllOrEmpty ()]
    [String]
    $Name,
    [Parameter (
      Position    = 3,
      Mandatory   = $true,
      HelpMessage = "Port number"
    )]
    [ValidateNotNUllOrEmpty ()]
    [Alias ("Port")]
    [String]
    $Value
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    Write-Log -Type "INFO" -Object "Configuring $Name socket"
    # Load XML content
    $XML = New-Object -TypeName "System.XML.XMLDocument"
    $XML.Load($Path)
    # Select socket binding node
    $XPath = '/server/socket-binding-group/socket-binding[@name="' + $Name + '"]'
    $SocketBindingNode = Select-XMLNode -XML $XML -XPath $XPath
    # Check socket definition
    switch ($Name) {
      # Get port configuration
      "management-http"           { $Port = '${jboss.management.http.port:' + $Value + '}'    }
      "management-https"          { $Port = '${jboss.management.https.port:' + $Value + '}'   }
      "ajp"                       { $Port = '${jboss.ajp.port:' + $Value + '}'                }
      "http"                      { $Port = '${jboss.http.port:' + $Value + '}'               }
      "https"                     { $Port = '${jboss.https.port:' + $Value + '}'              }
      "txn-recovery-environment"  { $Port = "$Value"                                          }
      "txn-status-manager"        { $Port = "$Value"                                          }
      default                     { Write-Log -Type "WARN" -Object "Unknown socket ""$Name""" }
    }
    # Set port number
    if ($Port -ne $null) {
      Write-Log -Type "DEBUG" -Object $Port
      $SocketBindingNode.SetAttribute("port", $Port)
    }
    # Save updated XML file
    $XML.Save($Path)
  }
}
