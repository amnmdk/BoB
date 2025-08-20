#!/usr/bin/env bash
set -euo pipefail

echo "=== BoB Assistant - Installation Jour 1 ==="
echo "Configuration pour utilisateur: bob"

# Mise à jour du système
echo "Mise à jour du système..."
sudo apt update && sudo apt install -y build-essential pkg-config libasound2-dev ffmpeg curl unzip git

# Installation de Rust si nécessaire
if ! command -v rustc >/dev/null; then
  echo "Installation de Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
else
  echo "Rust déjà installé."
fi

# Création des répertoires
echo "Création des répertoires..."
mkdir -p ~/bin ~/projects

# Installation de Piper + voix française
if [ ! -d ~/bin/piper ]; then
  echo "Installation de Piper TTS..."
  cd ~/bin
  curl -L -o piper.tar.gz https://github.com/rhasspy/piper/releases/latest/download/piper_linux_arm64.tar.gz
  mkdir -p piper && tar -xzf piper.tar.gz -C piper --strip-components=1
  chmod +x piper/piper
  rm piper.tar.gz
  
  # Téléchargement de la voix française
  echo "Téléchargement de la voix française..."
  mkdir -p piper/voices && cd piper/voices
  
  # Version spécifique connue qui fonctionne
  curl -LO https://github.com/rhasspy/piper/releases/download/v1.2.0/fr_FR-mls_1840-medium.onnx
  curl -LO https://github.com/rhasspy/piper/releases/download/v1.2.0/fr_FR-mls_1840-medium.onnx.json
  
  echo "Piper installé avec succès."
else
  echo "Piper déjà installé."
fi

# Test de la sortie audio
echo "Test de la sortie audio..."
if command -v aplay >/dev/null; then
  echo "ALSA disponible."
else
  echo "Installation d'ALSA..."
  sudo apt install -y alsa-utils
fi

# Test rapide de Piper
echo "Test de Piper..."
if [ -f ~/bin/piper/piper ] && [ -f ~/bin/piper/voices/fr_FR-mls_1840-medium.onnx ]; then
  echo "Bonjour, installation terminée." | ~/bin/piper/piper --model ~/bin/piper/voices/fr_FR-mls_1840-medium.onnx --config ~/bin/piper/voices/fr_FR-mls_1840-medium.onnx.json --output_raw | aplay -r 22050 -f S16_LE -c 1 2>/dev/null || echo "Test audio échoué (normal si pas de sortie audio configurée)"
else
  echo "Erreur: Piper ou voix française non trouvés."
fi

echo "=== Installation terminée ==="
echo "Prochaines étapes:"
echo "1. cd ~/projects/bob"
echo "2. cargo build --release"
echo "3. ./target/release/bob whoami"
echo "4. ./target/release/bob say 'Bonjour BoB'"
