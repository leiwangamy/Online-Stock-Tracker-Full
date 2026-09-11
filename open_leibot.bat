@echo off
REM LeiBot FULL archive — start server on 3001 and open Watchlist.
setlocal
set "ROOT=C:\Users\Admin\Documents\Online-Stock-Tracker-Full"
REM Reuse daily project's venv (Full copy has no venv).
set "PY=C:\Users\Admin\Documents\Online-Stock-Tracker\venv\Scripts\python.exe"
set "LEIBOT_PORT=3001"
set "URL=http://127.0.0.1:3001/watchlist?tab=mine"

cd /d "%ROOT%"

if not exist "%PY%" (
  echo Python venv not found: %PY%
  pause
  exit /b 1
)

powershell -NoProfile -Command ^
  "$c = Get-NetTCPConnection -LocalPort 3001 -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1;" ^
  "if (-not $c) {" ^
  "  $env:LEIBOT_PORT = '3001';" ^
  "  Start-Process -FilePath '%PY%' -ArgumentList 'app.py' -WorkingDirectory '%ROOT%' -WindowStyle Minimized;" ^
  "  $ok = $false;" ^
  "  for ($i=0; $i -lt 40; $i++) {" ^
  "    Start-Sleep -Milliseconds 500;" ^
  "    try { $r = Invoke-WebRequest -Uri 'http://127.0.0.1:3001/' -UseBasicParsing -TimeoutSec 2; if ($r.StatusCode -ge 200) { $ok = $true; break } } catch {}" ^
  "  }" ^
  "  if (-not $ok) { Write-Host 'Full server starting slowly — opening browser anyway...' }" ^
  "}"

start "" "%URL%"
endlocal
