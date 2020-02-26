# WildFly PowerShell Module

WildFly PowerShell Module (PSWF) is a framework to manage WildFly using PowerShell.

<!-- TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:1 -->

1.  [Usage](#usage)
    1.  [Installation](#installation)
    2.  [Import](#import)
    3.  [List available functions](#list-available-functions)
2.  [Dependencies](#dependencies)
3.  [Roadmap](#roadmap)

<!-- /TOC -->

## Usage

### Installation

There are two ways of setting up the WildFly PowerShell Module on your system:
1.  Download the PSWF module from the [Github repository](https://github.com/Akaizoku/PSWF);
2.  Install the PSWF module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/PSWF).

```powershell
Install-Module -Name "PSWF" -Repository "PSGallery"
```

### Import

```powershell
Import-Module -Name "PSWF"
```

### List available functions

```powershell
Get-Command -Module "PSWF"
```

| CommandType | Name                       | Version | Source |
| ----------- | -------------------------- | ------- | ------ |
| Function    | Add-DataSource             | 1.0.1   | PSWF   |
| Function    | Add-JDBCDriver             | 1.0.1   | PSWF   |
| Function    | Add-Module                 | 1.0.1   | PSWF   |
| Function    | Add-Resource               | 1.0.1   | PSWF   |
| Function    | Add-SecurityDomain         | 1.0.1   | PSWF   |
| Function    | Add-SecurityRole           | 1.0.1   | PSWF   |
| Function    | Add-User                   | 1.0.1   | PSWF   |
| Function    | Add-UserGroupRole          | 1.0.1   | PSWF   |
| Function    | Disable-DataSource         | 1.0.1   | PSWF   |
| Function    | Disable-Deployment         | 1.0.1   | PSWF   |
| Function    | Disable-RBAC               | 1.0.1   | PSWF   |
| Function    | Enable-DataSource          | 1.0.1   | PSWF   |
| Function    | Enable-Deployment          | 1.0.1   | PSWF   |
| Function    | Enable-RBAC                | 1.0.1   | PSWF   |
| Function    | Get-DeploymentStatus       | 1.0.1   | PSWF   |
| Function    | Grant-SecurityRole         | 1.0.1   | PSWF   |
| Function    | Invoke-DeployApplication   | 1.0.1   | PSWF   |
| Function    | Invoke-JBossClient         | 1.0.1   | PSWF   |
| Function    | Invoke-ReloadServer        | 1.0.1   | PSWF   |
| Function    | Invoke-UndeployApplication | 1.0.1   | PSWF   |
| Function    | Read-Attribute             | 1.0.1   | PSWF   |
| Function    | Read-DeploymentStatus      | 1.0.1   | PSWF   |
| Function    | Read-Resource              | 1.0.1   | PSWF   |
| Function    | Read-SecurityDomain        | 1.0.1   | PSWF   |
| Function    | Read-ServerState           | 1.0.1   | PSWF   |
| Function    | Remove-Attribute           | 1.0.1   | PSWF   |
| Function    | Remove-DataSource          | 1.0.1   | PSWF   |
| Function    | Remove-JDBCDriver          | 1.0.1   | PSWF   |
| Function    | Remove-Module              | 1.0.1   | PSWF   |
| Function    | Remove-Resource            | 1.0.1   | PSWF   |
| Function    | Remove-SecurityDomain      | 1.0.1   | PSWF   |
| Function    | Remove-SecurityRole        | 1.0.1   | PSWF   |
| Function    | Remove-User                | 1.0.1   | PSWF   |
| Function    | Remove-UserGroupRole       | 1.0.1   | PSWF   |
| Function    | Test-DataSource            | 1.0.1   | PSWF   |
| Function    | Test-DataSourceConnection  | 1.0.1   | PSWF   |
| Function    | Test-Deployment            | 1.0.1   | PSWF   |
| Function    | Test-JBossClientOutcome    | 1.0.1   | PSWF   |
| Function    | Test-JDBCDriver            | 1.0.1   | PSWF   |
| Function    | Test-Module                | 1.0.1   | PSWF   |
| Function    | Test-Resource              | 1.0.1   | PSWF   |
| Function    | Test-SecurityDomain        | 1.0.1   | PSWF   |
| Function    | Test-SecurityRole          | 1.0.1   | PSWF   |
| Function    | Test-ServerState           | 1.0.1   | PSWF   |
| Function    | Test-User                  | 1.0.1   | PSWF   |
| Function    | Test-UserGroupRole         | 1.0.1   | PSWF   |
| Function    | Write-Attribute            | 1.0.1   | PSWF   |

## Dependencies

The WildFly PowerShell Module requires the [PowerShell Tool Kit module (PSTK)](https://www.powershellgallery.com/packages/PSTK).

## Roadmap

-   [ ] Add functions to configure logs
