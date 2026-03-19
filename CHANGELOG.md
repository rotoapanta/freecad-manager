# Changelog

All notable changes to this project will be documented in this file.

The format is based on:
https://keepachangelog.com/en/1.0.0/

---

## [1.0.0] - 2026-03-19

### Added

* Initial release of FreeCAD Manager
* Interactive Bash menu
* Installation from local AppImage
* Installation from remote URL
* Automatic creation of:

  * CLI launcher (`freecad`)
  * Desktop entry (.desktop)
  * Application icon
* Icon extraction from AppImage
* Clean uninstall option
* User-space installation under `~/.local`

### Notes

* Compatible with Ubuntu 22.04 and 24.04
* Designed for AppImage workflow instead of APT/PPA

---

## [Unreleased]

### Planned

* Auto-detection of AppImages in Downloads folder
* Version selector from GitHub Releases
* Non-interactive mode (`--install`, `--remove`)
* Logging system
* Update mechanism
