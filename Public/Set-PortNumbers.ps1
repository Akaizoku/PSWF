function Set-PortNumbers {
  <#
    .SYNOPSIS
    Configure WildFly ports

    .DESCRIPTION
    Configure port numbers for WildFly interfaces

    .PARAMETER Properties
    The properties parameter corressponds to the application configuration.

    .NOTES
    File name:      Set-PortNumbers.ps1
    Author:         Florian Carrier
    Creation date:  15/10/2019
    Last modified:  15/10/2019
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
  }
  Process {
    Write-Log -Type "INFO" -Object "Configuring ports"
    $ConfigDirectory  = Join-Path -Path $Properties.JBossHomeDirectory -ChildPath $Properties.WSConfigDirectory
    $StandaloneXML    = Join-Path -Path $ConfigDirectory -ChildPath $Properties.WSStandaloneXML
    # Load XML content
    $NewStandaloneXML = New-Object -TypeName "System.XML.XMLDocument"
    $NewStandaloneXML.Load($StandaloneXML)
    # Select socket binding group node
    $SocketGroupNode = Select-XMLNode -XML $NewStandaloneXML -XPath $Properties.XPathSocketGroup
    # Set port offset
    $SocketGroupNode.SetAttribute("port-offset", '${jboss.socket.binding.port-offset:' + $Properties.PortOffset + '}')
    # Select socket binding nodes
    $SocketBindingNodes = Select-XMLNode -XML $NewStandaloneXML -XPath $Properties.XPathSocketBinding
    # Loop through socket binding nodes
    foreach ($SocketBindingNode in $SocketBindingNodes) {
      # Port placeholder
      $Port = $null
      # Check socket definition
      switch ($SocketBindingNode.name) {
        # Get port configuration
        "management-http"           { $Port = '${jboss.management.http.port:' + $Properties.HTTPManagementPort + '}'            }
        "management-https"          { $Port = '${jboss.management.https.port:' + $Properties.HTTPSManagementPort + '}'          }
        "ajp"                       { $Port = '${jboss.ajp.port:' + $Properties.AJPConnectorPort + '}'                          }
        "http"                      { $Port = '${jboss.http.port:' + $Properties.HTTPPort + '}'                                 }
        "https"                     { $Port = '${jboss.https.port:' + $Properties.HTTPSPort + '}'                               }
        "txn-recovery-environment"  { $Port = "$($Properties.TXNRecoveryPort)"                                                  }
        "txn-status-manager"        { $Port = "$($Properties.TXNStatusPort)"                                                    }
        default                     { Write-Log -Type "DEBUG" -Object "No custom configuration for $($SocketBindingNode.name)"  }
      }
      # Set port number
      if ($Port -ne $null) {
        Write-Log -Type "DEBUG" -Object $Port
        $SocketBindingNode.SetAttribute("port", $Port)
      }
    }
    # Save updated XML file
    $NewStandaloneXML.Save($StandaloneXML)
  }
}
