#!/bin/bash
clear

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
WHITE='\033[1;37m'
PINK='\033[38;2;255;110;199m'
NC='\033[0m' # No Color

echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}  INSTALADOR DE PLUGIN: LOGO BIENVENIDA (OpenCode)${NC}"
echo -e "${GREEN}============================================================${NC}"
echo ""
echo "Este script instalará el logo personalizado para OpenCode de forma automática."
echo ""
echo -e "${YELLOW}[INFO] Comportamiento del logo en pantalla:${NC}"
echo "  - Si iniciás OpenCode en una ventana de terminal estándar (chica), vas a ver la versión compacta adaptada al nombre de tu archivo: '✦ [nombre_de_tu_archivo] ✦'."
echo "  - Para ver el arte ASCII completo (tu diseño personalizado), simplemente MAXIMIZÁ o agrandá la ventana de tu terminal. El logo se adaptará solo al instante."
echo -e "  - ${CYAN}Si no tenés un archivo .txt en el formato de arte ASCII correcto, te recomendamos usar 'Image to ASCII' (https://www.asciiart.eu/image-to-ascii) para convertir imágenes, o 'Patorjk's TAAG' para texto estilizado.${NC}"
echo ""
echo "¿Qué va a hacer este instalador?"
echo "  1. Creará la carpeta de plugins en tu perfil de usuario si no existe."
echo "  2. Copiará el archivo del plugin 'gentle-logo.tsx'."
echo "  3. Si tenés un archivo .txt con tu logo listo en esta carpeta, lo copiará."
echo "  4. Guardará tu selección de color (verde, amarillo, magenta o rojo) en la configuración."
echo "  5. Registrará el plugin en tu configuración de 'tui.json' para dejarlo activo."
echo ""

read -p "¿Querés continuar con la instalación? (S/N): " confirm
if [[ ! "$confirm" =~ ^[sS]$ ]]; then
    echo -e "${RED}Instalación cancelada por el usuario.${NC}"
    echo ""
    read -p "Presione Enter para salir..."
    exit 0
fi

# 0. Preguntar por logo personalizado ANTES de empezar la instalación
echo ""
echo -e "${YELLOW}===== LOGO PERSONALIZADO =====${NC}"
read -p "¿Tenés tu logo en arte ASCII listo en un archivo .txt? (S/N): " hasLogo
customLogoPath=""

if [[ "$hasLogo" =~ ^[sS]$ ]]; then
    read -p "  Ingresá la ruta completa de tu archivo .txt: " logoInput
    # Strip surrounding quotes (both single and double) from user input
    logoInput="${logoInput%\"}"
    logoInput="${logoInput#\"}"
    logoInput="${logoInput%\'}"
    logoInput="${logoInput#\'}"
    # Si escribe "n" o "no" → se arrepintió, usar gato por defecto
    if [[ "$logoInput" =~ ^[nN][oO]?$ ]]; then
        customLogoPath=""
        echo -e "${CYAN}  [INFO] Usando gato verde Matrix por defecto.${NC}"
    elif [ -f "$logoInput" ]; then
        customLogoPath="$logoInput"
        echo -e "${GREEN}  [✓] Archivo encontrado: '$customLogoPath'${NC}"
        # Validar dimensiones del arte ASCII
        artLineCount=$(wc -l < "$customLogoPath")
        artMaxWidth=$(awk '{ if (length > max) max = length } END { print max }' "$customLogoPath")
        if [ "$artLineCount" -gt 50 ] || [ "$artMaxWidth" -gt 80 ]; then
            echo -e "${YELLOW}  [ADVERTENCIA] El archivo mide $artLineCount líneas x $artMaxWidth caracteres de ancho máximo.${NC}"
            echo -e "${YELLOW}  [ADVERTENCIA] Se recomienda máximo 50 líneas y 80 columnas para verse bien en terminal.${NC}"
            echo -e "${YELLOW}  [ADVERTENCIA] Si es muy grande, solo se mostrará la versión compacta: '✦ nombre ✦'${NC}"
            echo -e "${YELLOW}  [ADVERTENCIA] Podés generar arte optimizado en: https://www.asciiart.eu/image-to-ascii${NC}"
        else
            echo -e "${GREEN}  [INFO] Dimensiones: $artLineCount líneas x $artMaxWidth columnas — ideal para la terminal.${NC}"
        fi
        # Confirmación: chance de arrepentirse antes de seguir
        read -p "  ¿Confirmás usar este archivo o preferís el gato por defecto? (S = este archivo / N = gato por defecto): " confirmLogo
        if [[ ! "$confirmLogo" =~ ^[sS]$ ]]; then
            customLogoPath=""
            echo -e "${CYAN}  [INFO] Usando gato verde Matrix por defecto.${NC}"
        fi
    else
        echo -e "${RED}  [ERROR] El archivo '$logoInput' no existe. Cancelando instalación.${NC}"
        echo ""
        read -p "Presione Enter para salir..."
        exit 1
    fi
else
    # Si dijo N, darle chance de devolverse
    echo -e "${CYAN}  [INFO] Usando gato verde Matrix por defecto.${NC}"
    read -p "  ¿Estás seguro? (S = gato por defecto / N = volver y elegir un archivo): " confirmDefault
    if [[ "$confirmDefault" =~ ^[nN]$ ]]; then
        hasLogo="S"
        read -p "  Ingresá la ruta completa de tu archivo .txt: " logoInput
        # Strip surrounding quotes
        logoInput="${logoInput%\"}"
        logoInput="${logoInput#\"}"
        logoInput="${logoInput%\'}"
        logoInput="${logoInput#\'}"
        # Si escribe "n" o "no" → se arrepintió otra vez, usar gato por defecto
        if [[ "$logoInput" =~ ^[nN][oO]?$ ]]; then
            customLogoPath=""
            echo -e "${CYAN}  [INFO] Usando gato verde Matrix por defecto.${NC}"
        elif [ -f "$logoInput" ]; then
            customLogoPath="$logoInput"
            echo -e "${GREEN}  [✓] Archivo encontrado: '$customLogoPath'${NC}"
            # Validar dimensiones
            artLineCount=$(wc -l < "$customLogoPath")
            artMaxWidth=$(awk '{ if (length > max) max = length } END { print max }' "$customLogoPath")
            if [ "$artLineCount" -gt 50 ] || [ "$artMaxWidth" -gt 80 ]; then
                echo -e "${YELLOW}  [ADVERTENCIA] El archivo mide $artLineCount líneas x $artMaxWidth caracteres de ancho máximo.${NC}"
                echo -e "${YELLOW}  [ADVERTENCIA] Se recomienda máximo 50 líneas y 80 columnas para verse bien en terminal.${NC}"
                echo -e "${YELLOW}  [ADVERTENCIA] Si es muy grande, solo se mostrará la versión compacta: '✦ nombre ✦'${NC}"
                echo -e "${YELLOW}  [ADVERTENCIA] Podés generar arte optimizado en: https://www.asciiart.eu/image-to-ascii${NC}"
            else
                echo -e "${GREEN}  [INFO] Dimensiones: $artLineCount líneas x $artMaxWidth columnas — ideal para la terminal.${NC}"
            fi
            # Confirmación
            read -p "  ¿Confirmás usar este archivo o preferís el gato por defecto? (S = este archivo / N = gato por defecto): " confirmLogo
            if [[ ! "$confirmLogo" =~ ^[sS]$ ]]; then
                customLogoPath=""
                echo -e "${CYAN}  [INFO] Usando gato verde Matrix por defecto.${NC}"
            fi
        else
            echo -e "${RED}  [ERROR] El archivo '$logoInput' no existe. Cancelando instalación.${NC}"
            echo ""
            read -p "Presione Enter para salir..."
            exit 1
        fi
    fi
fi

# ── SELECCIÓN DE COLOR ──────────────────────────────────────────
echo ""
echo -e "${YELLOW}===== SELECCIÓN DE COLOR =====${NC}"
echo "Elegí el color para tu logo (tanto el gato default como tu arte personalizado):"
echo ""
echo -e "  1) ${GREEN}Verde Matrix   (#00FF00)${NC} — por defecto"
echo -e "  2) ${YELLOW}Amarillo        (#FFFF00)${NC}"
echo -e "  3) Magenta         (#FF00FF)"
echo -e "  4) ${RED}Rojo            (#FF0000)${NC}"
echo -e "  5) ${WHITE}Blanco          (#FFFFFF)${NC}"
echo -e "  6) ${CYAN}Cyan            (#00FFFF)${NC}"
echo -e "  7) ${PINK}Rosa neón       (#FF6EC7)${NC}"
echo ""
read -p "Elegí un color (1-7) [default: 1]: " colorChoice

selectedColor="green"
case "$colorChoice" in
  2) selectedColor="yellow" ;;
  3) selectedColor="magenta" ;;
  4) selectedColor="red" ;;
  5) selectedColor="white" ;;
  6) selectedColor="cyan" ;;
  7) selectedColor="pink" ;;
  *) selectedColor="green" ;;
esac

echo -e "${CYAN}  [✓] Color seleccionado: $selectedColor${NC}"

echo ""
echo -e "${YELLOW}===== INICIANDO INSTALACIÓN =====${NC}"

# 1. Verify/create directory
PLUGIN_DIR="$HOME/.config/opencode/tui-plugins"
if [ ! -d "$PLUGIN_DIR" ]; then
    mkdir -p "$PLUGIN_DIR"
    echo -e "${GREEN}[✓] Carpeta de plugins creada.${NC}"
else
    echo -e "${GREEN}[✓] Carpeta de plugins verificada.${NC}"
fi

# 2. Copy gentle-logo.tsx
DestPath="$PLUGIN_DIR/gentle-logo.tsx"
gentleLogoUrl="https://raw.githubusercontent.com/scorralesm/logo_bienvenida_OPENCODE/master/gentle-logo.tsx"

if [ -f "./gentle-logo.tsx" ]; then
    cp "./gentle-logo.tsx" "$DestPath"
    echo -e "${GREEN}[✓] Plugin 'gentle-logo.tsx' copiado desde la carpeta local.${NC}"
else
    echo -e "${YELLOW}[INFO] gentle-logo.tsx no encontrado localmente. Descargándolo desde GitHub...${NC}"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$gentleLogoUrl" -o "$DestPath"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$gentleLogoUrl" -O "$DestPath"
    else
        echo -e "${RED}[ERROR] No se pudo descargar gentle-logo.tsx de GitHub porque no se encontró curl ni wget.${NC}"
        echo ""
        read -p "Presione Enter para salir..."
        exit 1
    fi
    echo -e "${GREEN}[✓] Plugin 'gentle-logo.tsx' descargado e instalado con éxito.${NC}"
fi

# 3. Copy custom .txt logo (solo si el usuario tenía uno listo)
if [ -n "$customLogoPath" ]; then
    # Limpiar .txt existentes primero para evitar duplicados
    existingTxt=$(ls "$PLUGIN_DIR"/*.txt 2>/dev/null | head -1)
    if [ -n "$existingTxt" ]; then
        rm -f "$PLUGIN_DIR"/*.txt
        echo -e "${CYAN}  [INFO] Logo(s) anterior(es) eliminado(s).${NC}"
    fi
    logoBasename=$(basename -- "$customLogoPath")
    cp "$customLogoPath" "$PLUGIN_DIR/$logoBasename"
    echo -e "${GREEN}  [✓] Logo personalizado copiado: '$customLogoPath'${NC}"
    cleanName="${logoBasename%.*}"
    echo -e "${CYAN}  [INFO] Versión compacta mostrará: '✦ $cleanName ✦'${NC}"
else
    # Eliminar .txt existentes para que el plugin use el gato por defecto
    existingTxt=$(ls "$PLUGIN_DIR"/*.txt 2>/dev/null | head -1)
    if [ -n "$existingTxt" ]; then
        rm -f "$PLUGIN_DIR"/*.txt
        echo -e "${CYAN}  [INFO] Logo personalizado anterior eliminado. Se usará el gato verde Matrix por defecto.${NC}"
    else
        echo -e "${CYAN}  [INFO] Usando gato verde Matrix por defecto.${NC}"
    fi
fi

# 4. Guardar configuración de color
colorConfigPath="$PLUGIN_DIR/gentle-logo-color.json"
echo "{\"color\":\"$selectedColor\"}" > "$colorConfigPath"
echo -e "${GREEN}  [✓] Color config guardado: $selectedColor${NC}"

# 5. Configure tui.json
echo -e "${YELLOW}[INFO] Configurando 'tui.json'...${NC}"
node -e '
const fs = require("fs");
const path = require("path");
const tuiPath = path.join(process.env.HOME, ".config/opencode/tui.json");
const pluginPath = path.join(process.env.HOME, ".config/opencode/tui-plugins/gentle-logo.tsx");
let tui = { "$schema": "https://opencode.ai/tui.json", "plugin": [] };
if (fs.existsSync(tuiPath)) {
  try { tui = JSON.parse(fs.readFileSync(tuiPath, "utf8")); } catch(e) {}
}
if (!tui.plugin) tui.plugin = [];
if (!tui.plugin.includes(pluginPath)) tui.plugin.push(pluginPath);
fs.writeFileSync(tuiPath, JSON.stringify(tui, null, 2), "utf8");
'

echo -e "${GREEN}[✓] Plugin registrado con éxito en tui.json.${NC}"
echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}    ¡INSTALACIÓN COMPLETADA CON ÉXITO!${NC}"
echo -e "${GREEN}    Reiniciá OpenCode para empezar a ver los cambios.${NC}"
echo -e "${GREEN}============================================================${NC}"
echo ""
read -p "Presione Enter para salir..."
exit 0
