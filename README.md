![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-orange.svg)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20%7C%2024.04-E95420?logo=ubuntu)
![Shell](https://img.shields.io/badge/script-bash-121011?logo=gnu-bash)
![FreeCAD](https://img.shields.io/badge/FreeCAD-AppImage-blue)
![Status](https://img.shields.io/badge/status-stable-brightgreen)
![Issues](https://img.shields.io/github/issues/rotoapanta/freecad-manager)
![Last Commit](https://img.shields.io/github/last-commit/rotoapanta/freecad-manager)
![Repo Size](https://img.shields.io/github/repo-size/rotoapanta/freecad-manager)

---

<p align="right"><strong>[EN]</strong> | <a href="README.es.md">[ES]</a></p>

# <p align="center">FreeCAD Manager (Linux)</p>

## Description

**FreeCAD Manager** is a Bash-based tool that allows you to install, manage, update, and uninstall **FreeCAD AppImage** on Linux systems, integrating it as a native desktop application.

The script automates the entire process: downloading or copying the AppImage, creating launchers, integrating it into the application menu, and enabling execution from the terminal — all without requiring root privileges.

---

## Features

* Easy-to-use interactive menu
* Non-interactive CLI mode
* Installation from:
  * Local AppImage file
  * Remote URL
* Automatic creation of:
  * CLI command (`freecad`)
  * Desktop entry (.desktop)
  * Application icon
* Logging system
* AppImage update mechanism
* Clean uninstall
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

Log file:

```bash
~/.local/state/freecad-manager/freecad-manager.log
```
---

## Requirements

* Linux (Ubuntu recommended)
* Bash
* `wget` or `curl`
* `find`, `chmod`, `mktemp`

---

## Installation

```bash
git clone https://github.com/TU_USUARIO/freecad-manager.git
cd freecad-manager
chmod +x freecad-manager.sh
./freecad-manager.sh
```

---

## Usage

Interactive Mode

The script provides a menu:

```
1) Install from local AppImage
2) Install from URL
3) Uninstall
4) Exit
```

Non-Interactive Mode (CLI)

Install from local file:

```bash
./freecad-manager.sh --install --from-file ~/Descargas/FreeCAD.AppImage
```

Install from URL:

```bash
./freecad-manager.sh --install --from-url "https://servidor/ruta/FreeCAD.AppImage"
```

Update:

```bash
./freecad-manager.sh --update --from-file ~/Descargas/FreeCAD_nueva.AppImage
```

Uninstall:

```bash
./freecad-manager.sh --remove
```

Help:

```bash
./freecad-manager.sh --help
```

Version:

```bash
./freecad-manager.sh --version
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

```bash
./freecad-manager.sh --remove
```

---

## Update FreeCAD

```bash
./freecad-manager.sh --update --from-file archivo.AppImage
```

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
