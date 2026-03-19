#!/usr/bin/env bash
set -euo pipefail

APP_NAME="FreeCAD"
INSTALL_DIR="${HOME}/.local/opt/freecad"
BIN_DIR="${HOME}/.local/bin"
APP_DIR="${HOME}/.local/share/applications"
ICON_DIR="${HOME}/.local/share/icons/hicolor/256x256/apps"

APPIMAGE_PATH="${INSTALL_DIR}/FreeCAD.AppImage"
WRAPPER_PATH="${BIN_DIR}/freecad"
DESKTOP_PATH="${APP_DIR}/freecad.desktop"
ICON_PATH="${ICON_DIR}/freecad.png"

DEFAULT_LOCAL_APPIMAGE="${HOME}/Descargas/FreeCAD_1.0.2-conda-Linux-x86_64-py311.AppImage"
DEFAULT_URL=""

print_line() {
    echo "------------------------------------------------------------"
}

check_dependencies() {
    local missing=()

    command -v chmod >/dev/null 2>&1 || missing+=("chmod")
    command -v cp >/dev/null 2>&1 || missing+=("cp")
    command -v mkdir >/dev/null 2>&1 || missing+=("mkdir")
    command -v find >/dev/null 2>&1 || missing+=("find")
    command -v mktemp >/dev/null 2>&1 || missing+=("mktemp")

    if ! command -v wget >/dev/null 2>&1 && ! command -v curl >/dev/null 2>&1; then
        missing+=("wget o curl")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Faltan dependencias: ${missing[*]}"
        echo "Instálalas y vuelve a ejecutar el script."
        exit 1
    fi
}

create_dirs() {
    mkdir -p "${INSTALL_DIR}" "${BIN_DIR}" "${APP_DIR}" "${ICON_DIR}"
}

download_appimage() {
    local url="$1"

    if [[ -z "${url}" ]]; then
        echo "La URL no puede estar vacía."
        exit 1
    fi

    echo "Descargando AppImage..."
    if command -v wget >/dev/null 2>&1; then
        wget -O "${APPIMAGE_PATH}" "${url}"
    else
        curl -L "${url}" -o "${APPIMAGE_PATH}"
    fi

    chmod +x "${APPIMAGE_PATH}"
}

copy_local_appimage() {
    local source_appimage="$1"

    if [[ ! -f "${source_appimage}" ]]; then
        echo "No se encontró el archivo:"
        echo "  ${source_appimage}"
        exit 1
    fi

    echo "Copiando AppImage local..."
    cp "${source_appimage}" "${APPIMAGE_PATH}"
    chmod +x "${APPIMAGE_PATH}"
}

create_wrapper() {
    cat > "${WRAPPER_PATH}" <<EOF
#!/usr/bin/env bash
exec "${APPIMAGE_PATH}" "\$@"
EOF
    chmod +x "${WRAPPER_PATH}"
}

extract_icon() {
    local tmp_dir
    tmp_dir="$(mktemp -d)"

    (
        cd "${tmp_dir}"

        if "${APPIMAGE_PATH}" --appimage-extract >/dev/null 2>&1; then
            local found_icon=""
            found_icon="$(find squashfs-root -type f \( -iname "freecad.png" -o -iname "*freecad*.png" -o -iname "*.svg" \) | head -n 1 || true)"

            if [[ -n "${found_icon}" ]]; then
                cp "${found_icon}" "${ICON_PATH}"
                echo "Ícono extraído correctamente."
            else
                echo "No se encontró un ícono dentro del AppImage."
            fi
        else
            echo "No se pudo extraer el ícono del AppImage."
        fi
    )

    rm -rf "${tmp_dir}"
}

create_desktop_entry() {
    cat > "${DESKTOP_PATH}" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=FreeCAD
Comment=Parametric 3D CAD modeler
Exec=${WRAPPER_PATH} %F
Terminal=false
Categories=Graphics;Engineering;Development;
StartupNotify=true
MimeType=application/x-extension-fcstd;
EOF

    if [[ -f "${ICON_PATH}" ]]; then
        cat >> "${DESKTOP_PATH}" <<EOF
Icon=${ICON_PATH}
EOF
    else
        cat >> "${DESKTOP_PATH}" <<EOF
Icon=freecad
EOF
    fi

    chmod +x "${DESKTOP_PATH}"
}

update_desktop_db() {
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "${APP_DIR}" >/dev/null 2>&1 || true
    fi
}

show_summary() {
    print_line
    echo "Instalación completada."
    echo
    echo "AppImage instalado en:"
    echo "  ${APPIMAGE_PATH}"
    echo
    echo "Comando disponible:"
    echo "  ${WRAPPER_PATH}"
    echo
    echo "Si ~/.local/bin está en tu PATH, podrás abrirlo con:"
    echo "  freecad"
    echo
    echo "También debería aparecer en el menú de aplicaciones."
    print_line
}

install_from_local() {
    local source_path
    read -r -p "Ruta del AppImage local [${DEFAULT_LOCAL_APPIMAGE}]: " source_path
    source_path="${source_path:-$DEFAULT_LOCAL_APPIMAGE}"

    create_dirs
    copy_local_appimage "${source_path}"
    create_wrapper
    extract_icon
    create_desktop_entry
    update_desktop_db
    show_summary
}

install_from_url() {
    local url
    read -r -p "URL directa del AppImage [${DEFAULT_URL}]: " url
    url="${url:-$DEFAULT_URL}"

    create_dirs
    download_appimage "${url}"
    create_wrapper
    extract_icon
    create_desktop_entry
    update_desktop_db
    show_summary
}

uninstall_freecad() {
    print_line
    echo "Desinstalando FreeCAD instalado por este script..."
    rm -f "${WRAPPER_PATH}"
    rm -f "${DESKTOP_PATH}"
    rm -f "${ICON_PATH}"
    rm -rf "${INSTALL_DIR}"
    update_desktop_db
    echo "FreeCAD eliminado."
    print_line
}

main_menu() {
    clear || true
    print_line
    echo "Instalador de FreeCAD AppImage"
    print_line
    echo "1) Instalar desde AppImage local"
    echo "2) Instalar descargando desde URL"
    echo "3) Desinstalar"
    echo "4) Salir"
    print_line

    local option
    read -r -p "Escoge una opción [1-4]: " option

    case "${option}" in
        1)
            install_from_local
            ;;
        2)
            install_from_url
            ;;
        3)
            uninstall_freecad
            ;;
        4)
            echo "Saliendo."
            exit 0
            ;;
        *)
            echo "Opción no válida."
            exit 1
            ;;
    esac
}

check_dependencies
main_menu
