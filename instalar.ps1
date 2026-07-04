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
Write-Host "  4. Registrará el plugin en tu configuración de 'tui.json' para dejarlo activo."
Write-Host ""

$confirm = Read-Host "¿Querés continuar con la instalación? (S/N)"
if ($confirm -notmatch '^[sS]$') {
    Write-Host "Instalación cancelada por el usuario." -ForegroundColor Red
    Exit
}

# 0. Preguntar por logo personalizado ANTES de empezar la instalación
Write-Host ""
Write-Host "===== LOGO PERSONALIZADO =====" -ForegroundColor Yellow
$hasLogo = Read-Host "¿Tenés tu logo en arte ASCII listo en un archivo .txt? (S/N)"
$customLogoPath = $null

if ($hasLogo -match '^[sS]$') {
    $logoInput = Read-Host "  Ingresá la ruta completa de tu archivo .txt"
    if (Test-Path $logoInput) {
        $customLogoPath = $logoInput
        Write-Host "  [✓] Archivo encontrado: '$customLogoPath'" -ForegroundColor Green
    } else {
        Write-Host "  [ERROR] El archivo '$logoInput' no existe. Cancelando instalación." -ForegroundColor Red
        Exit
    }
} else {
    Write-Host "  [INFO] Se usará el gato verde Matrix por defecto." -ForegroundColor Cyan
}

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
        Exit
    }
}

# 3. Copy custom .txt logo (solo si el usuario tenía uno listo)
if ($customLogoPath) {
    $logoDest = Join-Path $pluginDir (Split-Path $customLogoPath -Leaf)
    Copy-Item -Path $customLogoPath -Destination $logoDest -Force
    Write-Host "  [✓] Logo personalizado copiado: '$customLogoPath'" -ForegroundColor Green
    $cleanName = [System.IO.Path]::GetFileNameWithoutExtension($customLogoPath)
    Write-Host "  [INFO] Versión compacta mostrará: '✦ $cleanName ✦'" -ForegroundColor Cyan
} else {
    Write-Host "  [INFO] Usando gato verde Matrix por defecto (no se copia ningún .txt adicional)." -ForegroundColor Cyan
}

# 4. Configure tui.json
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
