@echo off
echo ================================================
echo   Push BoB vers GitHub
echo ================================================
echo.

REM URL du repo GitHub
set REPO_URL=https://github.com/Riavaas/BoB.git

echo Configuration du remote GitHub...
git remote add origin %REPO_URL%

echo Push vers GitHub...
git push -u origin master

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ================================================
    echo Code poussé avec succès vers GitHub !
    echo.
    echo Prochaines étapes :
    echo 1. Aller sur votre Raspberry Pi
    echo 2. Exécuter : git clone %REPO_URL% ~/projects/bob
    echo 3. Suivre le guide raspberry_pi_setup.md
    echo ================================================
) else (
    echo.
    echo ERREUR : Échec du push vers GitHub
    echo Vérifiez l'URL du repo et vos permissions
    echo ================================================
)

pause
