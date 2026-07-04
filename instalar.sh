#!/bin/bash
clear

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
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
echo -e "  - ${CYAN}Si no tenés un archivo .txt en el formato de arte ASCII correcto, podés usar aplicaciones en línea como 'ASCII Art Generator' (para imágenes) o 'Patorjk's TAAG' (para textos) para generarlo fácilmente.${NC}"
echo ""
echo "¿Qué va a hacer este instalador?"
echo "  1. Creará la carpeta de plugins en tu perfil de usuario si no existe."
echo "  2. Copiará el archivo del plugin 'gentle-logo.tsx'."
echo "  3. Si tenés un archivo .txt con tu logo listo en esta carpeta, lo copiará."
echo "  4. Registrará el plugin en tu configuración de 'tui.json' para dejarlo activo."
echo ""

read -p "¿Querés continuar con la instalación? (S/N): " confirm
if [[ ! "$confirm" =~ ^[sS]$ ]]; then
    echo -e "${RED}Instalación cancelada por el usuario.${NC}"
    exit 0
fi

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
        exit 1
    fi
    echo -e "${GREEN}[✓] Plugin 'gentle-logo.tsx' descargado e instalado con éxito.${NC}"
fi

# 3. Copy custom .txt logo if requested
read -p "¿Tenés un archivo de texto .txt con tu diseño ASCII listo para usar? (S/N): " hasLogo
if [[ "$hasLogo" =~ ^[sS]$ ]]; then
    read -p "  Ingrese la ruta o nombre exacto de su archivo (ej: mi-gato.txt): " logoName
    if [ -f "$logoName" ]; then
        # Clean any other .txt files in destination folder to prevent conflicts
        rm -f "$PLUGIN_DIR"/*.txt
        
        logoBasename=$(basename -- "$logoName")
        cp "$logoName" "$PLUGIN_DIR/$logoBasename"
        echo -e "${GREEN}  [✓] '$logoBasename' copiado correctamente.${NC}"
        
        cleanName="${logoBasename%.*}"
        echo -e "${CYAN}  [INFO] La versión compacta de tu logo mostrará dinámicamente: '✦ $cleanName ✦'.${NC}"
    else
        echo -e "${RED}  [ERROR] El archivo '$logoName' no existe. Se omitirá la copia del logo personalizado.${NC}"
    fi
else
    echo -e "${CYAN}  [INFO] No hay problema. Se usará el gato verde Matrix por defecto.${NC}"
    echo -e "${CYAN}  [INFO] Si más adelante querés usar tu propio diseño, podés generarlo en formato ASCII (.txt) con webs como 'ASCII Art Generator' o 'Patorjk's TAAG' y copiarlo a la carpeta de plugins.${NC}"
fi

# 4. Configure tui.json
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
