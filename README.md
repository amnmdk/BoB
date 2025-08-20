<<<<<<< HEAD
# BoB
=======
# BoB Assistant - Jour 1

Assistant domestique local pour Raspberry Pi 5 avec synthèse vocale française.

## Architecture

- **Langage**: Rust
- **TTS**: Piper (local)
- **Audio**: ALSA/ffmpeg
- **Configuration**: YAML

## Structure du projet

```
bob/
├── Cargo.toml              # Dépendances Rust
├── src/
│   └── main.rs            # Code principal avec CLI
├── config/
│   └── bob.yaml           # Configuration des profils
├── scripts/
│   └── setup_day1.sh      # Script d'installation
├── systemd/
│   └── bob.service        # Service systemd
└── README.md              # Ce fichier
```

## Installation sur Raspberry Pi

### 1. Copier le projet

```bash
# Sur votre machine locale
scp -r . bob@192.168.1.46:~/projects/bob/
```

### 2. Exécuter l'installation

```bash
# Sur la Raspberry Pi
ssh bob@192.168.1.46
cd ~/projects/bob
chmod +x scripts/setup_day1.sh
./scripts/setup_day1.sh
```

### 3. Compiler le projet

```bash
cargo build --release
```

## Utilisation

### Commandes disponibles

```bash
# Afficher le profil actif
./target/release/bob whoami

# Faire parler BoB
./target/release/bob say "Bonjour Aimane, je suis BoB"
```

### Configuration des profils

Le fichier `config/bob.yaml` contient deux profils :

- **aimane** : Rouge (#E53935), personnalité détendue et drôle
- **bob** : Bleu (#1976D2), personnalité équilibrée

## Dépendances système

- Rust (installé automatiquement)
- Piper TTS + voix française
- ALSA/ffmpeg pour l'audio
- build-essential, pkg-config

## Service systemd (optionnel)

```bash
# Copier et activer le service
sudo cp systemd/bob.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable bob.service
sudo systemctl start bob.service
```

## Troubleshooting

### Pas de son
- Vérifier la sortie audio avec `alsamixer`
- Tester avec `speaker-test -c2 -t wav`

### Erreur compilation
- Vérifier que Rust est dans le PATH : `source ~/.cargo/env`
- Mettre à jour Rust : `rustup update`

## Prochaines étapes

- [ ] Ajout du STT (Whisper)
- [ ] Interface graphique (egui)
- [ ] Wake word detection
- [ ] Intégration domotique
>>>>>>> 413a9a1 (Initial commit - BoB Assistant Jour 1)
