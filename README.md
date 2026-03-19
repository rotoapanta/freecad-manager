![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-orange.svg)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20%7C%2024.04-E95420?logo=ubuntu)
![Shell](https://img.shields.io/badge/script-bash-121011?logo=gnu-bash)
![FreeCAD](https://img.shields.io/badge/FreeCAD-AppImage-blue)
![Status](https://img.shields.io/badge/status-stable-brightgreen)
![Issues](https://img.shields.io/github/issues/TU_USUARIO/freecad-manager)
![Last Commit](https://img.shields.io/github/last-commit/TU_USUARIO/freecad-manager)
![Repo Size](https://img.shields.io/github/repo-size/TU_USUARIO/freecad-manager)

---

<p align="right"><strong>English</strong> | <a href="README.es.md">Español</a></p>

# <p align="center">FreeCAD Manager (Linux)</p>

## Description

**FreeCAD Manager** is a lightweight Bash utility that allows you to install, manage, and uninstall **FreeCAD AppImage** on Linux systems as if it were a native desktop application.

It integrates FreeCAD into your system by creating launchers, menu entries, and command-line access — all without requiring root privileges.

---

## Features

* Interactive installation menu
* Install from:

  * Local AppImage
  * Remote URL
* Automatic creation of:

  * CLI launcher (`freecad`)
  * Desktop entry (.desktop)
  * Application icon
* Clean uninstall process
* User-space installation (`~/.local`)
* Compatible with:

  * Ubuntu 22.04
  * Ubuntu 24.04

---

## Installation Structure

FreeCAD is installed in:

```
~/.local/opt/freecad/FreeCAD.AppImage
```

The script also creates:

```
~/.local/bin/freecad
~/.local/share/applications/freecad.desktop
~/.local/share/icons/hicolor/256x256/apps/freecad.png
```

---

## Requirements

* Linux (Ubuntu recommended)
* Bash
* `wget` or `curl`
* `find`, `chmod`, `mktemp`

---

## nstallation

```bash
git clone https://github.com/TU_USUARIO/freecad-manager.git
cd freecad-manager
chmod +x freecad-manager.sh
./freecad-manager.sh
```

---

## Usage

The script provides an interactive menu:

```
1) Install from local AppImage
2) Install from URL
3) Uninstall
4) Exit
```

---

## Run FreeCAD

From terminal:

```bash
freecad
```

Or open it from your system applications menu.

---

## Uninstall

Run the script and select:

```
Option 3 → Uninstall
```

---

## Update FreeCAD

Run the script again and install a new version.

The previous AppImage will be automatically replaced.

---

## Why AppImage instead of APT?

| Method   | Version | Recommended |
| -------- | ------- | ----------- |
| APT      | Old     | ❌           |
| PPA      | Limited | ⚠️          |
| AppImage | Latest  | ✅           |

---

## Project Structure

```
freecad-manager/
├── freecad-manager.sh
├── README.md
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
└── .github/
```

---

## Contributing

Contributions are welcome!

1. Fork the repository
2. Create a new branch
3. Make your changes
4. Submit a Pull Request

See `CONTRIBUTING.md` for more details.

---

## License

This project is licensed under the MIT License.

---

## Author

**Roberto Toapanta**
Electrical Engineer
Embedded Systems | IoT | Energy

---

## Roadmap

* Auto-detect AppImages in Downloads
* Version selector from GitHub Releases
* Auto-update feature
* Logging system
* Non-interactive mode

---

## Support

If you find this project useful, consider giving it a star ⭐
