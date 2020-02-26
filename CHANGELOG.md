# Changelog
All notable changes to the [PSWF](https://github.com/Akaizoku/PSWF) project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0](https://github.com/Akaizoku/PSWF/releases/tag/1.0.1) - 2020-02-26

Expansion

### Added

The following functions have been added:
-   Add-Resource
-   Add-SecurityDomain
-   Disable-DataSource
-   Disable-Deployment
-   Enable-DataSource
-   Enable-Deployment
-   Get-DeploymentStatus
-   Get-JBossClientResult
-   Grant-SecurityRole
-   Invoke-DeployApplication
-   Invoke-UndeployApplication
-   Read-Attribute
-   Dead-DeploymentStatus
-   Read-SecurityDomain
-   Remove-Attribute
-   Remove-SecurityDomain
-   Test-DataSource
-   Test-DataSourceConnection
-   Test-Deployment
-   Test-JDBCDriver
-   Test-Resource
-   Test-SecurityDomain
-   Write-Attribute

### Changed

The following functions have been updated:
-   Add-DataSource
-   Add-JDBCDriver
-   Add-Module
-   Add-SecurityRole
-   Add-User
-   Add-UserGroupRole
-   Disable-RBAC
-   Enable-RBAC
-   Grant-SecurityRole
-   Invoke-DeployWAR
-   Invoke-JBossClient
-   Invoke-ReloadServer
-   Invoke-UndeployWAR
-   Read-DeploymentStatus
-   Read-Resource
-   Read-ServerState
-   Remove-DataSource
-   Remove-JDBCDriver
-   Remove-Module
-   Remove-Resource
-   Remove-SecurityRole
-   Remove-User
-   Remove-UserGroupRole
-   Resolve-ServerState
-   Test-JBossClientOutcome
-   Test-Module
-   Test-SecurityRole
-   Test-ServerState
-   Test-User
-   Test-UserGroupRole
-   Write-JBossClientCmd: Fix issue \#1 by using single-quoted command definition and escaping the double-quotes

### Removed

The following functions have been removed:
-   Set-Interface
-   Set-JavaOptions
-   Set-PortNumber
-   Set-PortOffset

## [1.0.0](https://github.com/Akaizoku/PSWF/releases/tag/1.0.0) - 2020-01-13

### Added

The following functions have been added:
-   Add-DataSource
-   Add-JDBCDriver
-   Add-Module
-   Add-SecurityRole
-   Add-User
-   Add-UserGroupRole
-   Disable-RBAC
-   Enable-RBAC
-   Grant-SecurityRole
-   Invoke-DeployWAR
-   Invoke-JBossClient
-   Invoke-ReloadServer
-   Invoke-UndeployWAR
-   Read-DeploymentStatus
-   Read-Resource
-   Read-ServerState
-   Remove-DataSource
-   Remove-JDBCDriver
-   Remove-Module
-   Remove-Resource
-   Remove-SecurityRole
-   Remove-User
-   Remove-UserGroupRole
-   Resolve-ServerState
-   Set-Interface
-   Set-JavaOptions
-   Set-PortNumber
-   Set-PortOffset
-   Test-JBossClientOutcome
-   Test-Module
-   Test-SecurityRole
-   Test-ServerState
-   Test-User
-   Test-UserGroupRole

The following files have been added:
-   CHANGELOG
-   LICENSE
-   README
