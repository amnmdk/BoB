# Guide de Déploiement BoB - Étapes à suivre dans votre terminal SSH

Exécutez ces commandes dans l'ordre dans votre terminal SSH connecté à la Raspberry Pi.

## 1. Vérification de l'environnement
```bash
whoami
pwd
```

## 2. Création des répertoires
```bash
mkdir -p ~/projects ~/bin
cd ~/projects
```

## 3. Copie des fichiers depuis votre machine Windows
Depuis votre machine Windows (nouveau terminal), exécutez :
```cmd
scp -r c:/Users/Amn/Desktop/BoB bob@192.168.1.46:~/projects/bob
```

## 4. Retour sur la Raspberry Pi - Installation des dépendances
```bash
cd ~/projects/bob
chmod +x scripts/setup_day1.sh
sudo apt update
sudo apt install -y build-essential pkg-config libasound2-dev ffmpeg curl unzip git
```

## 5. Installation de Rust
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env
```

## 6. Installation de Piper TTS
```bash
cd ~/bin
curl -L -o piper.tar.gz https://github.com/rhasspy/piper/releases/latest/download/piper_linux_arm64.tar.gz
mkdir -p piper && tar -xzf piper.tar.gz -C piper --strip-components=1
chmod +x piper/piper
rm piper.tar.gz
```

## 7. Installation de la voix française
```bash
mkdir -p ~/bin/piper/voices
cd ~/bin/piper/voices
curl -LO https://github.com/rhasspy/piper/releases/download/v1.2.0/fr_FR-mls_1840-medium.onnx
curl -LO https://github.com/rhasspy/piper/releases/download/v1.2.0/fr_FR-mls_1840-medium.onnx.json
```

## 8. Test de Piper
```bash
echo "Test de la voix française" | ~/bin/piper/piper --model ~/bin/piper/voices/fr_FR-mls_1840-medium.onnx --config ~/bin/piper/voices/fr_FR-mls_1840-medium.onnx.json --output_raw | aplay -r 22050 -f S16_LE -c 1
```

## 9. Compilation du projet BoB
```bash
cd ~/projects/bob
source ~/.cargo/env
cargo build --release
```

## 10. Test des commandes BoB
```bash
./target/release/bob whoami
./target/release/bob say "Bonjour Aimane, je suis BoB, ton assistant domestique local"
```

## En cas d'erreur audio
```bash
# Vérifier les périphériques audio
aplay -l
# Ajuster le volume
alsamixer
