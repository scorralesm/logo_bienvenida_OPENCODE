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
