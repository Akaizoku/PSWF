#Requires -Version 3.0

<#
  .SYNOPSIS
  PowerShell WildFly Module

  .DESCRIPTION
  Collection of useful functions and procedures to manage WildFly.

  .NOTES
  File name:      PSWF.psm1
  Author:         Florian Carrier
  Creation date:  02/12/2019
  Last modified:  02/12/2019
  Repository:     https://github.com/Akaizoku/PSTF
  Dependencies:   PowerShell Tool Kit (PSTK)

  .LINK
  https://github.com/Akaizoku/PSWF

  .LINK
  https://github.com/Akaizoku/PSTK

  .LINK
  https://www.powershellgallery.com/packages/PSTK
#>

# Get public and private function definition files
$Public  = @( Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1"  -ErrorAction "SilentlyContinue" )
$Private = @( Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -ErrorAction "SilentlyContinue" )

# Import files using dot sourcing
foreach ($File in @($Public + $Private)) {
  try   { . $File.FullName }
  catch { Write-Error -Message "Failed to import function $($File.FullName): $_" }
}

# Export public functions
Export-ModuleMember -Function $Public.BaseName
