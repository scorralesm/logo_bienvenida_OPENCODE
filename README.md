# logo_bienvenida_OPENCODE

Gato en ASCII art para la pantalla de bienvenida de **OpenCode**, con selección de color. Reemplaza el logo default de Catppuccin por un gato hecho en ASCII art renderizado en el color que elijas (verde, amarillo, magenta o rojo), o por cualquier logo personalizado en texto plano que desees colocar.

Cualquier desarrollador, usuario o asistente de IA puede leer esta guía para entender el funcionamiento e instalarlo en minutos.

---

## Requisitos

- [OpenCode](https://opencode.ai) instalado.
- Terminal capaz de renderizar colores ANSI.

---

## Instalación Automática (Recomendada)

El plugin se puede instalar de forma instantánea sin clonar el repositorio, o bien ejecutando el script localmente si ya lo tenés en tu máquina.

### Opción A: Instalación Instantánea (Sin clonar el repositorio)

Simplemente abrí la terminal de tu sistema y ejecutá el comando correspondiente:

#### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/scorralesm/logo_bienvenida_OPENCODE/master/instalar.ps1 | iex
```

#### macOS / Linux (Bash)
```bash
curl -fsSL https://raw.githubusercontent.com/scorralesm/logo_bienvenida_OPENCODE/master/instalar.sh | bash
```

---

### Opción B: Instalación Local (Si clonaste el repositorio)

#### Windows (PowerShell)
Ejecutá el instalador desde la carpeta del proyecto:
```powershell
.\instalar.ps1
```
*(Si encontrás un error de políticas de scripts, podés usar: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; .\instalar.ps1`)*

#### macOS / Linux (Bash)
Dale permisos de ejecución y corré el script desde la carpeta del proyecto:
```bash
chmod +x instalar.sh
./instalar.sh
```

---

## Instalación Manual

Si preferís realizar la configuración a mano, seguí estos pasos:

### 1. Copiar el plugin
Copiá `gentle-logo.tsx` a la carpeta de plugins de OpenCode:
- **Windows:**
  ```powershell
  New-Item -ItemType Directory -Path "$env:USERPROFILE\.config\opencode\tui-plugins" -Force
  Copy-Item -Path ".\gentle-logo.tsx" -Destination "$env:USERPROFILE\.config\opencode\tui-plugins\gentle-logo.tsx"
  ```
- **macOS / Linux:**
  ```bash
  mkdir -p ~/.config/opencode/tui-plugins
  cp gentle-logo.tsx ~/.config/opencode/tui-plugins/gentle-logo.tsx
  ```

### 2. Registrar el plugin en `tui.json`
Editá tu archivo de configuración `tui.json` (ubicado en `~/.config/opencode/tui.json` o `%USERPROFILE%\.config\opencode\tui.json`) y registrá la ruta absoluta de `gentle-logo.tsx` en el array `"plugin"`:
```json
{
  "$schema": "https://opencode.ai/tui.json",
  "plugin": [
    "C:\\Users\\TU_USUARIO\\.config\\opencode\\tui-plugins\\gentle-logo.tsx"
  ]
}
```

### 3. Reiniciar OpenCode
Cerrá la terminal o salí de OpenCode y volvé a iniciarlo.

---

## Personalización

### 🎨 Selección de Color

El instalador te permite elegir entre **4 colores** para tu logo, ya sea que uses el gato por defecto o tu propio arte personalizado:

| # | Color   | Hex       | Preview |
|---|---------|-----------|---------|
| 1 | Verde   | `#00FF00` | 🟢 Matrix (por defecto) |
| 2 | Amarillo| `#FFFF00` | 🟡 |
| 3 | Magenta | `#FF00FF` | 🟣 |
| 4 | Rojo    | `#FF0000` | 🔴 |

El color elegido se guarda en `gentle-logo-color.json` dentro de la carpeta de plugins y el plugin lo aplica automáticamente.

### 🐱 Logo por Defecto vs. Personalizado

El instalador te guía paso a paso para elegir entre:

- **🐱 Gato** (el arte ASCII incluido, en el color que elijas)
- **🎨 Tu propio arte ASCII** en un archivo `.txt`

### ¿Cómo crear tu arte ASCII?
Usá generadores online que convierten imágenes a arte ASCII:
- **[Image to ASCII](https://www.asciiart.eu/image-to-ascii)** — el que usaste para el genio. Recomienda ~50 líneas máx.
- **[ASCII Art Generator](https://www.ascii-art-generator.org/)** — alternativa similar.
- **[Patorjk's TAAG](https://patorjk.com/software/taag/)** — para texto estilizado en bloque.

> [!TIP]
> **Tamaño recomendado:** máximo **50 líneas** y **80 columnas**. El instalador te advierte si tu archivo excede estas dimensiones.

### ¿Cómo instalar tu diseño personalizado?

Corré el instalador y seguí el diálogo interactivo:

```
¿Tenés tu logo en arte ASCII listo en un archivo .txt? (S/N)
```

Si respondés **S:**
1. Ingresá la **ruta completa** de tu archivo `.txt`
2. El instalador valida que exista y mide sus dimensiones
3. Te pregunta si **confirmás** o preferís el gato por defecto
4. Si tecleás `n` o `no` cuando pide la ruta, vuelve al gato por defecto

Si respondés **N:**
1. Confirma que querés el gato por defecto
2. Si decís "no" a la confirmación, **vuelve** a preguntarte la ruta de un archivo

Luego de definir el logo, el instalador te preguntará:

```
Elegí un color (1-4) [default: 1]:
1) Verde Matrix   (#00FF00)
2) Amarillo       (#FFFF00)
3) Magenta        (#FF00FF)
4) Rojo           (#FF0000)
```

El color se aplica tanto al gato por defecto como a tu arte personalizado.

> [!NOTE]
> **Fallback automático:** Si no hay ningún `.txt` en la carpeta de plugins, el plugin muestra el gato. Si retirás tu archivo personalizado, el fallback se activa solo. El color elegido se mantiene aunque cambies el logo.

---

## Comportamiento del Logo en la Terminal (Responsivo)

El plugin se redibuja en tiempo real adaptándose al tamaño de la terminal:
1. **Ventana Estándar / Chica (ej. al abrir por primera vez):** Muestra únicamente el texto compacto `✦ [nombre_de_tu_archivo] ✦` en el color seleccionado.
2. **Ventana Maximizada:** Cuando maximizás la terminal o la estirás a un tamaño suficiente, el plugin detecta el espacio y dibuja automáticamente el arte ASCII completo en el color elegido.

---

## Estructura del Proyecto

```
logo_bienvenida_OPENCODE/
├── gentle-logo.tsx              # Código fuente del plugin TUI
├── gentle-logo-color.json       # Configuración de color (se genera en la instalación)
├── instalar.ps1                 # Instalador automático para Windows
├── instalar.sh                  # Instalador automático para macOS/Linux
└── README.md                    # Esta guía detallada
```

> **Nota:** `gentle-logo-color.json` se crea automáticamente al ejecutar el instalador. Si no existe, el plugin usa verde (`#00FF00`) por defecto.

---

## Créditos

Hecho con ♥ para la bienvenida de OpenCode. Elegí tu color — verde, amarillo, magenta o rojo — porque tu consola merece estilo propio.
