# Changelog

## [1.0.6] - 2026-09-29

### Fixed

- The module failed to load on Linux and macOS because the root module dot-sourced
  Private\Get-TDDParamBlockAttribute without its .ps1 extension.

## [1.0.5] - 2026-08-31

### Added

- New function Test-TDDSupportsShouldProcess, which returns true when a command declares SupportsShouldProcess (opts in to -WhatIf and -Confirm).

### Fixed

- Test-TDDParameter (added for 1.0.4) is now dot-sourced and exported by the module manifest; it was previously present in Public but never wired up.

# Changelog

## [1.0.4] - 2022-07-16

### Added

- New function Test-TDDParameter

# Changelog

## [1.0.3] - 2022-07-12

### Removed

- Removed function Invoke-TDDInCmdlet

# Changelog

- This version was revoked. Do not install it.

## [1.0.2] - 2022-07-12

### Added

- New function: Invoke-TDDInCmdlet

# Changelog

## [1.0.1] - 2022-07-07

### Fixed

- Fixed an issue with a private file that wasn't dot sourced by the module

## [1.0.0] - 2022-07-06

_First release._

