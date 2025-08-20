# Installation BoB sur Raspberry Pi via GitHub

Une fois le repo GitHub créé, voici les étapes pour installer BoB sur votre Raspberry Pi.

## 1. Sur votre Raspberry Pi (dans votre terminal SSH)

```bash
# Cloner le repo (remplacez USERNAME par votre username GitHub)
cd ~
git clone https://github.com/USERNAME/bob-assistant.git projects/bob

# Aller dans le répertoire
cd projects/bob

# Rendre le script exécutable
chmod +x scripts/setup_day1.sh

# Lancer l'installation complète
./scripts/setup_day1.sh
```

## 2. Compilation et test

```bash
# S'assurer que Rust est dans le PATH
source ~/.cargo/env

# Compiler le projet
cargo build --release

# Tester BoB
./target/release/bob whoami
./target/release/bob say "Bonjour Aimane, je suis BoB, ton assistant domestique local"
```

## 3. En cas de problème

### Audio
```bash
# Vérifier les périphériques audio
aplay -l

# Tester la sortie audio
speaker-test -c2 -t wav

# Ajuster le volume
alsamixer
```

### Compilation
```bash
# Réinstaller Rust si nécessaire
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env

# Nettoyer et recompiler
cargo clean
cargo build --release
```

## 4. Installation comme service (optionnel)

```bash
# Copier le service systemd
sudo cp systemd/bob.service /etc/systemd/system/

# Recharger systemd
sudo systemctl daemon-reload

# Activer le service (démarrage automatique)
sudo systemctl enable bob.service

# Démarrer le service
sudo systemctl start bob.service

# Vérifier le statut
sudo systemctl status bob.service
