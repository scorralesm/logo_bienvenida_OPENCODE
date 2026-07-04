# Windows installer for logo_bienvenida_OPENCODE
Clear-Host

Write-Host "============================================================" -ForegroundColor Green
Write-Host "  INSTALADOR DE PLUGIN: LOGO BIENVENIDA (OpenCode)" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Este script instalará el logo personalizado para OpenCode de forma automática."
Write-Host ""
Write-Host "[INFO] Comportamiento del logo en pantalla:" -ForegroundColor Yellow
Write-Host "  - Si iniciás OpenCode en una ventana de terminal estándar (chica), vas a ver la versión compacta adaptada al nombre de tu archivo: '✦ [nombre_de_tu_archivo] ✦'."
Write-Host "  - Para ver el arte ASCII completo (tu diseño personalizado), simplemente MAXIMIZÁ o agrandá la ventana de tu terminal. El logo se adaptará solo al instante."
Write-Host "  - Si no tenés un archivo .txt en el formato de arte ASCII correcto, podés usar aplicaciones en línea como 'ASCII Art Generator' (para imágenes) o 'Patorjk's TAAG' (para textos) para generarlo fácilmente." -ForegroundColor Cyan
Write-Host ""
Write-Host "¿Qué va a hacer este instalador?"
Write-Host "  1. Creará la carpeta de plugins en tu perfil de usuario si no existe."
Write-Host "  2. Copiará el archivo del plugin 'gentle-logo.tsx'."
Write-Host "  3. Si tenés un archivo .txt con tu logo listo en esta carpeta, lo copiará."
Write-Host "  4. Guardará tu selección de color (verde, amarillo, magenta o rojo) en la configuración."
Write-Host "  5. Registrará el plugin en tu configuración de 'tui.json' para dejarlo activo."
Write-Host ""

$confirm = Read-Host "¿Querés continuar con la instalación? (S/N)"
if ($confirm -notmatch '^[sS]$') {
    Write-Host "Instalación cancelada por el usuario." -ForegroundColor Red
    Write-Host ""
    Read-Host "Presione Enter para salir..."
    Exit
}

# 0. Preguntar por logo personalizado ANTES de empezar la instalación
Write-Host ""
Write-Host "===== LOGO PERSONALIZADO =====" -ForegroundColor Yellow
$hasLogo = Read-Host "¿Tenés tu logo en arte ASCII listo en un archivo .txt? (S/N)"
$customLogoPath = $null

if ($hasLogo -match '^[sS]$') {
    $logoInput = (Read-Host "  Ingresá la ruta completa de tu archivo .txt").Trim('"', "'")
    # Si escribe "n" o "no" → se arrepintió, usar gato por defecto
    if ($logoInput -match '^[nN][oO]?$') {
        $customLogoPath = $null
        Write-Host "  [INFO] Usando gato verde Matrix por defecto." -ForegroundColor Cyan
    } elseif (Test-Path $logoInput) {
        $customLogoPath = $logoInput
        Write-Host "  [✓] Archivo encontrado: '$customLogoPath'" -ForegroundColor Green
        # Validar dimensiones del arte ASCII
        $artLines = Get-Content -Path $customLogoPath
        $artLineCount = $artLines.Count
        $artMaxWidth = ($artLines | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum
        if ($artLineCount -gt 50 -or $artMaxWidth -gt 80) {
            Write-Host "  [ADVERTENCIA] El archivo mide $artLineCount líneas x $artMaxWidth caracteres de ancho máximo." -ForegroundColor Yellow
            Write-Host "  [ADVERTENCIA] Se recomienda máximo 50 líneas y 80 columnas para verse bien en terminal." -ForegroundColor Yellow
            Write-Host "  [ADVERTENCIA] Si es muy grande, solo se mostrará la versión compacta: '✦ nombre ✦'" -ForegroundColor Yellow
            Write-Host "  [ADVERTENCIA] Podés generar arte optimizado en: https://www.asciiart.eu/image-to-ascii" -ForegroundColor Yellow
        } else {
            Write-Host "  [INFO] Dimensiones: $artLineCount líneas x $artMaxWidth columnas — ideal para la terminal." -ForegroundColor Green
        }
        # Confirmación: chance de arrepentirse antes de seguir
        $confirmLogo = Read-Host "  ¿Confirmás usar este archivo o preferís el gato por defecto? (S = este archivo / N = gato por defecto)"
        if ($confirmLogo -notmatch '^[sS]$') {
            $customLogoPath = $null
            Write-Host "  [INFO] Usando gato verde Matrix por defecto." -ForegroundColor Cyan
        }
    } else {
        Write-Host "  [ERROR] El archivo '$logoInput' no existe. Cancelando instalación." -ForegroundColor Red
        Write-Host ""
        Read-Host "Presione Enter para salir..."
        Exit
    }
} else {
    # Si dijo N, darle chance de devolverse
    Write-Host "  [INFO] Se usará el gato verde Matrix por defecto." -ForegroundColor Cyan
    $confirmDefault = Read-Host "  ¿Estás seguro? (S = gato por defecto / N = volver y elegir un archivo)"
    if ($confirmDefault -match '^[nN]$') {
        $hasLogo = "S"
        $logoInput = (Read-Host "  Ingresá la ruta completa de tu archivo .txt").Trim('"', "'")
        if (Test-Path $logoInput) {
            $customLogoPath = $logoInput
            Write-Host "  [✓] Archivo encontrado: '$customLogoPath'" -ForegroundColor Green
            # Validar dimensiones del arte ASCII
            $artLines = Get-Content -Path $customLogoPath
            $artLineCount = $artLines.Count
            $artMaxWidth = ($artLines | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum
            if ($artLineCount -gt 50 -or $artMaxWidth -gt 80) {
                Write-Host "  [ADVERTENCIA] El archivo mide $artLineCount líneas x $artMaxWidth caracteres de ancho máximo." -ForegroundColor Yellow
                Write-Host "  [ADVERTENCIA] Se recomienda máximo 50 líneas y 80 columnas para verse bien en terminal." -ForegroundColor Yellow
                Write-Host "  [ADVERTENCIA] Si es muy grande, solo se mostrará la versión compacta: '✦ nombre ✦'" -ForegroundColor Yellow
                Write-Host "  [ADVERTENCIA] Podés generar arte optimizado en: https://www.asciiart.eu/image-to-ascii" -ForegroundColor Yellow
            } else {
                Write-Host "  [INFO] Dimensiones: $artLineCount líneas x $artMaxWidth columnas — ideal para la terminal." -ForegroundColor Green
            }
        } else {
            Write-Host "  [ERROR] El archivo '$logoInput' no existe. Cancelando instalación." -ForegroundColor Red
            Write-Host ""
            Read-Host "Presione Enter para salir..."
            Exit
        }
    }
}

# ── SELECCIÓN DE COLOR ──────────────────────────────────────────
Write-Host ""
Write-Host "===== SELECCIÓN DE COLOR =====" -ForegroundColor Yellow
Write-Host "Elegí el color para tu logo (tanto el gato default como tu arte personalizado):"
Write-Host ""
Write-Host "  1) Verde Matrix   (#00FF00) — por defecto" -ForegroundColor Green
Write-Host "  2) Amarillo        (#FFFF00)" -ForegroundColor Yellow
Write-Host "  3) Magenta         (#FF00FF)" -ForegroundColor Magenta
Write-Host "  4) Rojo            (#FF0000)" -ForegroundColor Red
Write-Host ""
$colorChoice = Read-Host "Elegí un color (1-4) [default: 1]"

$selectedColor = "green"
switch ($colorChoice) {
  "2" { $selectedColor = "yellow" }
  "3" { $selectedColor = "magenta" }
  "4" { $selectedColor = "red" }
  default { $selectedColor = "green" }
}

Write-Host "  [✓] Color seleccionado: $selectedColor" -ForegroundColor Cyan

Write-Host ""
Write-Host "===== INICIANDO INSTALACIÓN =====" -ForegroundColor Yellow

# 1. Verify/create directory
$pluginDir = Join-Path $env:USERPROFILE ".config\opencode\tui-plugins"
if (-not (Test-Path $pluginDir)) {
    New-Item -ItemType Directory -Path $pluginDir -Force | Out-Null
    Write-Host "[✓] Carpeta de plugins creada." -ForegroundColor Green
} else {
    Write-Host "[✓] Carpeta de plugins verificada." -ForegroundColor Green
}

# 2. Copy gentle-logo.tsx
$pluginDest = Join-Path $pluginDir "gentle-logo.tsx"
$gentleLogoUrl = "https://raw.githubusercontent.com/scorralesm/logo_bienvenida_OPENCODE/master/gentle-logo.tsx"

if (Test-Path ".\gentle-logo.tsx") {
    Copy-Item -Path ".\gentle-logo.tsx" -Destination $pluginDest -Force
    Write-Host "[✓] Plugin 'gentle-logo.tsx' copiado desde la carpeta local." -ForegroundColor Green
} else {
    Write-Host "[INFO] gentle-logo.tsx no encontrado localmente. Descargándolo desde GitHub..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri $gentleLogoUrl -OutFile $pluginDest -UseBasicParsing
        Write-Host "[✓] Plugin 'gentle-logo.tsx' descargado e instalado con éxito." -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] No se pudo descargar gentle-logo.tsx de GitHub. Verificá tu conexión a internet." -ForegroundColor Red
        Write-Host ""
        Read-Host "Presione Enter para salir..."
        Exit
    }
}

# 3. Copy custom .txt logo (solo si el usuario tenía uno listo)
if ($customLogoPath) {
    # Limpiar .txt existentes primero para evitar duplicados
    $existingTxt = Get-ChildItem -Path $pluginDir -Filter *.txt -ErrorAction SilentlyContinue
    if ($existingTxt) {
        $existingTxt | Remove-Item -Force
        Write-Host "  [INFO] Logo(s) anterior(es) eliminado(s)." -ForegroundColor Cyan
    }
    $logoDest = Join-Path $pluginDir (Split-Path $customLogoPath -Leaf)
    Copy-Item -Path $customLogoPath -Destination $logoDest -Force
    Write-Host "  [✓] Logo personalizado copiado: '$customLogoPath'" -ForegroundColor Green
    $cleanName = [System.IO.Path]::GetFileNameWithoutExtension($customLogoPath)
    Write-Host "  [INFO] Versión compacta mostrará: '✦ $cleanName ✦'" -ForegroundColor Cyan
} else {
    # Eliminar .txt existentes para que el plugin use el gato por defecto
    $existingTxt = Get-ChildItem -Path $pluginDir -Filter *.txt -ErrorAction SilentlyContinue
    if ($existingTxt) {
        $existingTxt | Remove-Item -Force
        Write-Host "  [INFO] Logo personalizado anterior eliminado. Se usará el gato verde Matrix por defecto." -ForegroundColor Cyan
    } else {
        Write-Host "  [INFO] Usando gato verde Matrix por defecto." -ForegroundColor Cyan
    }
}

# 4. Guardar configuración de color
$colorConfigPath = Join-Path $pluginDir "gentle-logo-color.json"
$colorConfig = @{ color = $selectedColor } | ConvertTo-Json -Compress
Set-Content -Path $colorConfigPath -Value $colorConfig -Encoding utf8 -NoNewline
Write-Host "  [✓] Color config guardado: $selectedColor" -ForegroundColor Green

# 5. Configure tui.json (ahora paso 5)
Write-Host "[INFO] Configurando 'tui.json'..." -ForegroundColor Yellow
$tuiJsonPath = Join-Path $env:USERPROFILE ".config\opencode\tui.json"
$tuiObj = @{
    "`$schema" = "https://opencode.ai/tui.json"
    "plugin" = @()
}

if (Test-Path $tuiJsonPath) {
    try {
        $existingJson = Get-Content -Raw -Path $tuiJsonPath | ConvertFrom-Json
        if ($existingJson.plugin) {
            $tuiObj.plugin = [System.Collections.ArrayList]($existingJson.plugin)
        }
    } catch {
        Write-Host "  [WARNING] No se pudo leer tui.json anterior. Creando una configuración nueva." -ForegroundColor Yellow
    }
}

# Format destination path with backslashes
$escapedPath = $pluginDest.Replace("/", "\")

if ($tuiObj.plugin -notcontains $escapedPath) {
    [void]$tuiObj.plugin.Add($escapedPath)
}

$tuiObj | ConvertTo-Json -Depth 5 | Out-File -FilePath $tuiJsonPath -Encoding utf8
Write-Host "[✓] Plugin registrado con éxito en tui.json." -ForegroundColor Green
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "    ¡INSTALACIÓN COMPLETADA CON ÉXITO!" -ForegroundColor Green
Write-Host "    Reiniciá OpenCode para empezar a ver los cambios." -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Read-Host "Presione Enter para salir..."
Exit
