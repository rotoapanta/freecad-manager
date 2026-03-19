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

<p align="right"><strong>[ES]</strong> | <a href="README.md">[EN]</a></p>

# <p align="center">FreeCAD Manager (Linux)</p>

## Descripción

**FreeCAD Manager** es una herramienta en Bash que permite instalar, gestionar, actualizar y desinstalar **FreeCAD AppImage** en sistemas Linux, integrándolo como una aplicación nativa del sistema.

El script automatiza todo el proceso: descarga o copia del AppImage, creación de accesos, integración en el menú de aplicaciones y ejecución desde terminal, sin necesidad de privilegios de superusuario.

---

## Características

* Menú interactivo fácil de usar
* Modo no interactivo mediante CLI
* Instalación desde:
  * AppImage local
  * URL remota
* Creación automática de:
  * Comando CLI (`freecad`)
  * Acceso en el menú (.desktop)
  * Ícono de la aplicación
* Sistema de logs
* Actualización del AppImage
* Desinstalación limpia
* Instalación en espacio de usuario (`~/.local`)
* Compatible con:
  * Ubuntu 22.04
  * Ubuntu 24.04

---

## Estructura de instalación

FreeCAD se instala en:

```bash
~/.local/opt/freecad/FreeCAD.AppImage
```

Y se crean los siguientes accesos:

```bash
~/.local/bin/freecad
~/.local/share/applications/freecad.desktop
~/.local/share/icons/hicolor/256x256/apps/freecad.png
```

Logs del sistema:

```bash
~/.local/state/freecad-manager/freecad-manager.log
```
---

## Requisitos

* Linux (Ubuntu recomendado)
* Bash
* `wget` o `curl`
* `find`, `chmod`, `mktemp`

---

## Instalación

```bash
git clone https://github.com/rotoapanta/freecad-manager.git
cd freecad-manager
chmod +x freecad-manager.sh
./freecad-manager.sh
```

---

## Uso

Modo interactivo

El script presenta un menú:

```text
1) Instalar desde AppImage local
2) Instalar desde URL
3) Desinstalar
4) Salir
```

Modo no interactivo (CLI)

Instalar desde archivo local:

```bash
./freecad-manager.sh --install --from-file ~/Descargas/FreeCAD.AppImage
```

Instalar desde URL:

```bash
./freecad-manager.sh --install --from-url "https://servidor/ruta/FreeCAD.AppImage"
```

Actualizar:

```bash
./freecad-manager.sh --update --from-file ~/Descargas/FreeCAD_nueva.AppImage
```

Desinstalar:

```bash
./freecad-manager.sh --remove
```

Ver ayuda:

```bash
./freecad-manager.sh --help
```

Ver versión:

```bash
./freecad-manager.sh --version
```
---

## Ejecutar FreeCAD

Desde terminal:

```bash
freecad
```

O desde el menú de aplicaciones del sistema.

---

## Desinstalar

```bash
./freecad-manager.sh --remove
```

---

## Actualizar FreeCAD

```bash
./freecad-manager.sh --update --from-file archivo.AppImage
```

---

## ¿Por qué usar AppImage en lugar de APT?

| Método   | Versión        | Recomendado |
| -------- | -------------- | ----------- |
| APT      | Antigua        | ❌           |
| PPA      | Limitada       | ⚠️          |
| AppImage | Última versión | ✅           |

---

## Estructura del proyecto

```text
freecad-manager/
├── freecad-manager.sh
├── README.md
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
└── .github/
```

---
 
## Contribuciones

Las contribuciones son bienvenidas:

1. Realiza un fork del repositorio
2. Crea una rama (`feature/nueva-funcionalidad`)
3. Realiza los cambios
4. Envía un Pull Request

Consulta `CONTRIBUTING.md` para más detalles.

---

## Licencia

Este proyecto está bajo la licencia MIT.

---

## Autor

**Roberto Toapanta**
Ingeniero Eléctrico
Sistemas Embebidos | IoT | Energía

---

## Roadmap

* Detección automática de AppImages en Descargas
* Selector de versiones desde GitHub Releases
* Actualización automática
* Sistema de logs
* Modo no interactivo

---

## Apoyo

Si este proyecto te resulta útil, considera darle una estrella ⭐
