@echo off
echo ================================================
echo   Déploiement BoB vers Raspberry Pi
echo ================================================
echo.

echo Copie des fichiers vers bob@192.168.1.46...
scp -r . bob@192.168.1.46:~/projects/bob

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ================================================
    echo Fichiers copiés avec succès !
    echo.
    echo Prochaines étapes :
    echo 1. Aller dans votre terminal SSH connecté à la Pi
    echo 2. Exécuter : cd ~/projects/bob
    echo 3. Exécuter : chmod +x scripts/setup_day1.sh
    echo 4. Exécuter : ./scripts/setup_day1.sh
    echo ================================================
) else (
    echo.
    echo ERREUR : Échec de la copie des fichiers
    echo Vérifiez votre connexion réseau et l'accès SSH
    echo ================================================
)
pause
