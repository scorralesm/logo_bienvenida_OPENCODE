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
Copy-Item -Path ".\gentle-logo.tsx" -Destination $pluginDest -Force
Write-Host "[✓] Plugin 'gentle-logo.tsx' copiado con éxito." -ForegroundColor Green

# 3. Copy custom .txt logo if requested
$hasLogo = Read-Host "¿Tenés un archivo de texto .txt con tu diseño ASCII en esta carpeta? (S/N)"
if ($hasLogo -match '^[sS]$') {
    $logoName = Read-Host "  Ingrese el nombre exacto de su archivo (ej: mi-gato.txt)"
    if (Test-Path $logoName) {
        $logoDest = Join-Path $pluginDir $logoName
        
        # Clean any other .txt files in the destination folder to prevent conflicts
        Get-ChildItem -Path $pluginDir -Filter *.txt | Remove-Item -Force
        
        Copy-Item -Path $logoName -Destination $logoDest -Force
        Write-Host "  [✓] '$logoName' copiado correctamente." -ForegroundColor Green
        $cleanName = [System.IO.Path]::GetFileNameWithoutExtension($logoName)
        Write-Host "  [INFO] La versión compacta de tu logo mostrará dinámicamente: '✦ $cleanName ✦'." -ForegroundColor Cyan
    } else {
        Write-Host "  [ERROR] El archivo '$logoName' no existe en esta carpeta. Se omitirá la copia del logo personalizado." -ForegroundColor Red
    }
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
