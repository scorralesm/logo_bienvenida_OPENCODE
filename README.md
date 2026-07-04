# logo_bienvenida_OPENCODE

Gato en verde Matrix para la pantalla de bienvenida de **OpenCode**. Reemplaza el logo default de Catppuccin por un gato hecho en ASCII art, renderizado en `#00FF00`.

## Requisitos

- [OpenCode](https://opencode.ai) instalado
- Terminal con al menos **70 caracteres de ancho** y **36 líneas de alto**

## Instalación (2 pasos)

### 1. Copiar el plugin

Copiá `gentle-logo.tsx` a la carpeta de plugins de OpenCode:

**Windows:**
```powershell
# Crear la carpeta si no existe
New-Item -ItemType Directory -Path "$env:USERPROFILE\.config\opencode\tui-plugins" -Force

# Copiar el plugin
Copy-Item -Path ".\gentle-logo.tsx" -Destination "$env:USERPROFILE\.config\opencode\tui-plugins\gentle-logo.tsx"
```

**macOS / Linux:**
```bash
mkdir -p ~/.config/opencode/tui-plugins
cp gentle-logo.tsx ~/.config/opencode/tui-plugins/gentle-logo.tsx
```

### 2. Registrar el plugin en `tui.json`

Editá `~/.config/opencode/tui.json` (crealo si no existe) y agregá:

```json
{
  "$schema": "https://opencode.ai/tui.json",
  "plugin": [
    "C:\\Users\\TU_USUARIO\\.config\\opencode\\tui-plugins\\gentle-logo.tsx"
  ]
}
```

En macOS / Linux usá la ruta con `/home/tu-usuario/.config/opencode/tui-plugins/gentle-logo.tsx`.

> **Tip:** Si ya tenés otros plugins en `tui.json`, solo agregá la línea del `gentle-logo.tsx` al array `plugin`.

### 3. Reiniciar OpenCode

Cerralo y abrilo de nuevo. El gato debería aparecer en la pantalla de bienvenida.

## Personalización (Opcional)

Si querés usar tu propio diseño o arte ASCII en lugar del gato por defecto, podés hacerlo fácilmente sin necesidad de tocar el código del plugin. Cualquier desarrollador o asistente de IA puede leer esta guía para replicar el proceso.

### ¿Cómo crear tu propio arte ASCII?
Si no sabés cómo diseñar arte ASCII, podés usar herramientas en línea gratuitas que convierten texto o imágenes directamente:
- **Para convertir imágenes a ASCII:** Subí tu imagen de referencia a [ASCII Art Generator](https://www.ascii-art-generator.org/) o [ASCII Generator (Site)](https://ascii-generator.site/).
- **Para convertir texto en fuentes de bloques gigantes:** Usá [Patorjk's TAAG](https://patorjk.com/software/taag/) para generar palabras o frases estilizadas.

### Paso a paso para instalar tu logo personalizado:

1. **Generá el diseño:** Creá tu arte ASCII usando alguna de las herramientas mencionadas arriba.
2. **Creá el archivo de texto:** Creá un archivo de texto plano llamado exactamente `logo.txt` y pegá tu arte ASCII dentro de él.
3. **Guardá el archivo:** Copiá el archivo `logo.txt` a la carpeta de plugins de OpenCode (donde instalaste `gentle-logo.tsx`):
   - **En Windows (PowerShell):**
     ```powershell
     Copy-Item -Path ".\logo.txt" -Destination "$env:USERPROFILE\.config\opencode\tui-plugins\logo.txt" -Force
     ```
     *(La carpeta de plugins se ubica en `%USERPROFILE%\.config\opencode\tui-plugins\`)*
   - **En macOS / Linux (Terminal):**
     ```bash
     cp logo.txt ~/.config/opencode/tui-plugins/logo.txt
     ```
     *(La carpeta de plugins se ubica en `~/.config/opencode/tui-plugins/`)*

4. **Reiniciá OpenCode:** Cerrá la terminal o salí de OpenCode y volvé a iniciarlo. El plugin detectará automáticamente la presencia de `logo.txt` y renderizará tu diseño personalizado en verde Matrix.

> [!NOTE]
> **Fallback Automático:** Si en algún momento querés volver al gato Matrix original, simplemente borrá o renombrá el archivo `logo.txt` de la carpeta de plugins. El plugin está diseñado para detectar que no está el archivo y volver a cargar el gato por defecto sin fallar.

## Verificación

Si el gato no aparece, puede ser que:

1. **La terminal es muy chica** — necesitás al menos 70×36 caracteres
2. **La ruta en `tui.json` es incorrecta** — verificá que apunte al archivo exacto
3. **OpenCode no encontró el plugin** — revisá los logs con `opencode --log-level=DEBUG`

## Estructura

```
logo_bienvenida_OPENCODE/
├── gentle-logo.tsx        # Plugin TUI de OpenCode
└── README.md              # Esta guía
```

## Créditos

Hecho con ♥ para la bienvenida de OpenCode. Verde Matrix porque el gato merece estilo.
