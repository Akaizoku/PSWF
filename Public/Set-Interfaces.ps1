function Set-Interfaces {
  <#
    .SYNOPSIS
    Configure WildFly interfaces

    .DESCRIPTION
    Configure interfaces for WildFly

    .PARAMETER Properties
    The properties parameter corressponds to the application configuration.

    .NOTES
    File name:      Set-Interfaces.ps1
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
    Write-Log -Type "INFO" -Object "Configuring interfaces"
    $ConfigDirectory  = Join-Path -Path $Properties.JBossHomeDirectory -ChildPath $Properties.WSConfigDirectory
    $StandaloneXML    = Join-Path -Path $ConfigDirectory -ChildPath $Properties.WSStandaloneXML
    # Load XML content
    $NewStandaloneXML = New-Object -TypeName "System.XML.XMLDocument"
    $NewStandaloneXML.Load($StandaloneXML)
    # Select interface nodes
    $InterfaceNodes = Select-XMLNode -XML $NewStandaloneXML -XPath $Properties.XPathInterface
    foreach ($InterfaceNode in $InterfaceNodes) {
      # TODO manage restricted list of addresses
      # Create new node with updated value
      $NewInterfaceNode = $NewStandaloneXML.CreateElement($Properties.InterfaceAddress, $NewStandaloneXML.DocumentElement.NamespaceURI)
      Write-Log -Type "DEBUG" -Object $NewInterfaceNode.OuterXml
      # Replace existing node (and suppress output)
      $InterfaceNode.ParentNode.ReplaceChild($NewInterfaceNode, $InterfaceNode) | Out-Null
    }
    # Save updated XML file
    $NewStandaloneXML.Save($StandaloneXML)
  }
}
