@echo off
SETLOCAL

REM ============================================================
REM  run_tests.bat - Dolar BCV
REM  Ejecuta la suite de pruebas y actualiza la version patch
REM  Uso: run_tests.bat
REM ============================================================

echo.
echo ======================================================
echo   DOLAR BCV - Suite de Pruebas Automatizada
echo ======================================================
echo.

REM --- 1. Ejecutar todas las pruebas ---
echo [1/3] Ejecutando pruebas...
flutter test
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Algunas pruebas fallaron. No se actualizara la version.
    echo         Revisa los errores anteriores y corrígelos antes de continuar.
    exit /b 1
)

echo.
echo [OK] Todas las pruebas pasaron exitosamente.

REM --- 2. Leer version actual de pubspec.yaml ---
echo.
echo [2/3] Leyendo version actual...
FOR /F "tokens=2 delims=: " %%A IN ('findstr /B "version:" pubspec.yaml') DO SET FULL_VER=%%A

REM Separar X.Y.Z del build number (+N)
FOR /F "tokens=1,2 delims=+" %%A IN ("%FULL_VER%") DO (
    SET SEM_VER=%%A
    SET BUILD_NUM=%%B
)

REM Separar X, Y, Z
FOR /F "tokens=1,2,3 delims=." %%A IN ("%SEM_VER%") DO (
    SET MAJOR=%%A
    SET MINOR=%%B
    SET PATCH=%%C
)

SET /A NEW_PATCH=%PATCH%+1
SET /A NEW_BUILD=%BUILD_NUM%+1
SET NEW_VER=%MAJOR%.%MINOR%.%NEW_PATCH%+%NEW_BUILD%

echo     Version actual:  %SEM_VER%+%BUILD_NUM%
echo     Version nueva:   %NEW_VER%

REM --- 3. Actualizar pubspec.yaml ---
echo.
echo [3/3] Actualizando pubspec.yaml...
powershell -Command "(Get-Content pubspec.yaml) -replace 'version: .*', 'version: %NEW_VER%' | Set-Content pubspec.yaml"

echo.
echo ======================================================
echo   Version actualizada a v%NEW_VER%
echo   Recuerda hacer commit con:
echo     git add pubspec.yaml
echo     git commit -m "chore: bump version to v%NEW_VER%"
echo ======================================================
echo.

ENDLOCAL
