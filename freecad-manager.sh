#!/usr/bin/env bash
#
# ==============================================================================
#  FreeCAD Manager
# ==============================================================================
#  Descripción:
#    Script en Bash para instalar, gestionar, actualizar y desinstalar
#    FreeCAD AppImage en sistemas Linux, integrándolo como una aplicación
#    nativa del usuario.
#
#  Funcionalidades:
#    - Instalación desde un AppImage local
#    - Instalación descargando desde una URL
#    - Modo interactivo y no interactivo
#    - Creación de comando lanzador: freecad
#    - Creación de acceso en el menú de aplicaciones
#    - Extracción automática de ícono desde el AppImage
#    - Sistema de logs
#    - Actualización del AppImage instalado
#    - Desinstalación limpia
#
#  Ubicaciones usadas:
#    - AppImage:   ~/.local/opt/freecad/FreeCAD.AppImage
#    - Lanzador:   ~/.local/bin/freecad
#    - Desktop:    ~/.local/share/applications/freecad.desktop
#    - Ícono:      ~/.local/share/icons/hicolor/256x256/apps/freecad.png
#    - Logs:       ~/.local/state/freecad-manager/freecad-manager.log
#
#  Compatibilidad:
#    - Ubuntu 22.04
#    - Ubuntu 24.04
#    - Otras distribuciones Linux compatibles con AppImage
#
#  Requisitos:
#    - bash
#    - wget o curl
#    - chmod
#    - cp
#    - mkdir
#    - find
#    - mktemp
#
#  Autor:
#    Roberto Toapanta
#
#  Licencia:
#    MIT
#
#  Versión:
#    1.1.0
#
# ==============================================================================

set -euo pipefail

SCRIPT_NAME="freecad-manager"
SCRIPT_VERSION="1.1.0"

APP_NAME="FreeCAD"
INSTALL_DIR="${HOME}/.local/opt/freecad"
BIN_DIR="${HOME}/.local/bin"
APP_DIR="${HOME}/.local/share/applications"
ICON_DIR="${HOME}/.local/share/icons/hicolor/256x256/apps"
LOG_DIR="${HOME}/.local/state/freecad-manager"
LOG_FILE="${LOG_DIR}/freecad-manager.log"

APPIMAGE_PATH="${INSTALL_DIR}/FreeCAD.AppImage"
WRAPPER_PATH="${BIN_DIR}/freecad"
DESKTOP_PATH="${APP_DIR}/freecad.desktop"
ICON_PATH="${ICON_DIR}/freecad.png"

DEFAULT_LOCAL_APPIMAGE="${HOME}/Descargas/FreeCAD_1.0.2-conda-Linux-x86_64-py311.AppImage"
DEFAULT_URL=""

print_line() {
    echo "------------------------------------------------------------"
}

create_log_dir() {
    mkdir -p "${LOG_DIR}"
}

log_info() {
    create_log_dir
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*" | tee -a "${LOG_FILE}"
}

log_error() {
    create_log_dir
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" | tee -a "${LOG_FILE}" >&2
}

show_help() {
    cat <<EOF
Uso:
  ./${SCRIPT_NAME}.sh [opciones]

Opciones:
  --install               Instala FreeCAD
  --remove                Desinstala FreeCAD
  --update                Actualiza FreeCAD
  --from-file RUTA        Usa un AppImage local
  --from-url URL          Descarga el AppImage desde una URL
  --help                  Muestra esta ayuda
  --version               Muestra la versión del script

Ejemplos:
  ./${SCRIPT_NAME}.sh
  ./${SCRIPT_NAME}.sh --install --from-file ~/Descargas/FreeCAD.AppImage
  ./${SCRIPT_NAME}.sh --install --from-url https://servidor/ruta/FreeCAD.AppImage
  ./${SCRIPT_NAME}.sh --update --from-file ~/Descargas/FreeCAD_nueva.AppImage
  ./${SCRIPT_NAME}.sh --update --from-url https://servidor/ruta/FreeCAD_nueva.AppImage
  ./${SCRIPT_NAME}.sh --remove
EOF
}

check_dependencies() {
    local missing=()

    command -v chmod >/dev/null 2>&1 || missing+=("chmod")
    command -v cp >/dev/null 2>&1 || missing+=("cp")
    command -v mkdir >/dev/null 2>&1 || missing+=("mkdir")
    command -v find >/dev/null 2>&1 || missing+=("find")
    command -v mktemp >/dev/null 2>&1 || missing+=("mktemp")
    command -v rm >/dev/null 2>&1 || missing+=("rm")
    command -v cat >/dev/null 2>&1 || missing+=("cat")
    command -v tee >/dev/null 2>&1 || missing+=("tee")
    command -v date >/dev/null 2>&1 || missing+=("date")

    if ! command -v wget >/dev/null 2>&1 && ! command -v curl >/dev/null 2>&1; then
        missing+=("wget o curl")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Faltan dependencias: ${missing[*]}"
        echo "Instálalas y vuelve a ejecutar el script."
        exit 1
    fi

    log_info "Dependencias verificadas correctamente."
}

create_dirs() {
    mkdir -p "${INSTALL_DIR}" "${BIN_DIR}" "${APP_DIR}" "${ICON_DIR}"
    log_info "Directorios de instalación verificados."
}

download_appimage() {
    local url="$1"

    if [[ -z "${url}" ]]; then
        log_error "La URL no puede estar vacía."
        echo "La URL no puede estar vacía."
        exit 1
    fi

    log_info "Descargando AppImage desde URL: ${url}"
    echo "Descargando AppImage..."

    if command -v wget >/dev/null 2>&1; then
        wget -O "${APPIMAGE_PATH}" "${url}"
    else
        curl -L "${url}" -o "${APPIMAGE_PATH}"
    fi

    chmod +x "${APPIMAGE_PATH}"
    log_info "AppImage descargado correctamente en ${APPIMAGE_PATH}"
}

copy_local_appimage() {
    local source_appimage="$1"

    if [[ ! -f "${source_appimage}" ]]; then
        log_error "No se encontró el archivo local: ${source_appimage}"
        echo "No se encontró el archivo:"
        echo "  ${source_appimage}"
        exit 1
    fi

    echo "Copiando AppImage local..."
    cp "${source_appimage}" "${APPIMAGE_PATH}"
    chmod +x "${APPIMAGE_PATH}"
    log_info "AppImage local copiado desde ${source_appimage}"
}

create_wrapper() {
    cat > "${WRAPPER_PATH}" <<EOF
#!/usr/bin/env bash
exec "${APPIMAGE_PATH}" "\$@"
EOF

    chmod +x "${WRAPPER_PATH}"
    log_info "Wrapper creado en ${WRAPPER_PATH}"
}

extract_icon() {
    local tmp_dir
    local found_icon=""

    tmp_dir="$(mktemp -d)"

    (
        cd "${tmp_dir}"

        if "${APPIMAGE_PATH}" --appimage-extract >/dev/null 2>&1; then
            found_icon="$(find squashfs-root -type f \( -iname "freecad.png" -o -iname "*freecad*.png" -o -iname "*.svg" \) | head -n 1 || true)"

            if [[ -n "${found_icon}" ]]; then
                cp "${found_icon}" "${ICON_PATH}"
                echo "Ícono extraído correctamente."
                log_info "Ícono extraído a ${ICON_PATH}"
            else
                echo "No se encontró un ícono dentro del AppImage."
                log_info "No se encontró ícono dentro del AppImage."
            fi
        else
            echo "No se pudo extraer el ícono del AppImage."
            log_info "No se pudo extraer el ícono del AppImage."
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
    log_info "Acceso .desktop creado en ${DESKTOP_PATH}"
}

update_desktop_db() {
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "${APP_DIR}" >/dev/null 2>&1 || true
        log_info "Base de datos de aplicaciones actualizada."
    else
        log_info "update-desktop-database no está disponible. Se omite."
    fi
}

show_summary() {
    print_line
    echo "Operación completada."
    echo
    echo "AppImage instalado en:"
    echo "  ${APPIMAGE_PATH}"
    echo
    echo "Comando disponible:"
    echo "  ${WRAPPER_PATH}"
    echo
    echo "Archivo de log:"
    echo "  ${LOG_FILE}"
    echo
    echo "Si ~/.local/bin está en tu PATH, podrás abrirlo con:"
    echo "  freecad"
    echo
    echo "También debería aparecer en el menú de aplicaciones."
    print_line
}

install_common() {
    create_wrapper
    extract_icon
    create_desktop_entry
    update_desktop_db
    log_info "Instalación finalizada correctamente."
    show_summary
}

install_from_local() {
    local source_path
    read -r -p "Ruta del AppImage local [${DEFAULT_LOCAL_APPIMAGE}]: " source_path
    source_path="${source_path:-$DEFAULT_LOCAL_APPIMAGE}"

    create_dirs
    copy_local_appimage "${source_path}"
    install_common
}

install_from_url() {
    local url
    read -r -p "URL directa del AppImage [${DEFAULT_URL}]: " url
    url="${url:-$DEFAULT_URL}"

    create_dirs
    download_appimage "${url}"
    install_common
}

install_non_interactive() {
    local source_type="$1"
    local source_value="$2"

    create_dirs

    case "${source_type}" in
        file)
            copy_local_appimage "${source_value}"
            ;;
        url)
            download_appimage "${source_value}"
            ;;
        *)
            log_error "Tipo de fuente no válido: ${source_type}"
            echo "Fuente no válida. Usa --from-file o --from-url."
            exit 1
            ;;
    esac

    install_common
}

update_freecad() {
    local source_type="$1"
    local source_value="$2"

    log_info "Iniciando actualización de FreeCAD."
    install_non_interactive "${source_type}" "${source_value}"
    log_info "Actualización completada correctamente."
}

uninstall_freecad() {
    print_line
    echo "Desinstalando FreeCAD instalado por este script..."
    rm -f "${WRAPPER_PATH}"
    rm -f "${DESKTOP_PATH}"
    rm -f "${ICON_PATH}"
    rm -rf "${INSTALL_DIR}"
    update_desktop_db
    log_info "FreeCAD eliminado del sistema del usuario."
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

parse_args() {
    local action=""
    local source_type=""
    local source_value=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --install)
                action="install"
                shift
                ;;
            --remove)
                action="remove"
                shift
                ;;
            --update)
                action="update"
                shift
                ;;
            --from-file)
                if [[ $# -lt 2 ]]; then
                    log_error "Falta la ruta después de --from-file"
                    echo "Debes indicar una ruta después de --from-file"
                    exit 1
                fi
                source_type="file"
                source_value="$2"
                shift 2
                ;;
            --from-url)
                if [[ $# -lt 2 ]]; then
                    log_error "Falta la URL después de --from-url"
                    echo "Debes indicar una URL después de --from-url"
                    exit 1
                fi
                source_type="url"
                source_value="$2"
                shift 2
                ;;
            --help)
                show_help
                exit 0
                ;;
            --version)
                echo "${SCRIPT_NAME} ${SCRIPT_VERSION}"
                exit 0
                ;;
            *)
                log_error "Opción no válida: $1"
                echo "Opción no válida: $1"
                echo "Usa --help para ver las opciones disponibles."
                exit 1
                ;;
        esac
    done

    if [[ -z "${action}" ]]; then
        return 1
    fi

    case "${action}" in
        install)
            if [[ -z "${source_type}" || -z "${source_value}" ]]; then
                log_error "Instalación no interactiva sin fuente definida."
                echo "Para instalar en modo no interactivo debes usar --from-file o --from-url."
                exit 1
            fi
            install_non_interactive "${source_type}" "${source_value}"
            ;;
        update)
            if [[ -z "${source_type}" || -z "${source_value}" ]]; then
                log_error "Actualización sin fuente definida."
                echo "Para actualizar debes usar --from-file o --from-url."
                exit 1
            fi
            update_freecad "${source_type}" "${source_value}"
            ;;
        remove)
            uninstall_freecad
            ;;
    esac

    return 0
}

check_dependencies

if ! parse_args "$@"; then
    main_menu
fi