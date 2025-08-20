# Étapes suivantes pour finaliser BoB

## 1. Créer le repo GitHub privé

1. Aller sur https://github.com/new
2. Nom du repo : `bob-assistant`
3. Description : `BoB - Assistant domestique local pour Raspberry Pi`
4. **IMPORTANT : Cocher "Private"**
5. Ne pas initialiser avec README, .gitignore ou license (on a déjà tout)
6. Cliquer "Create repository"

## 2. Obtenir l'URL du repo

GitHub vous donnera l'URL, qui devrait être :
```
https://github.com/Riavaas/bob-assistant.git
```

## 3. Pousser le code vers GitHub

Exécuter le script :
```cmd
.\push_to_github.bat
```

Ou manuellement :
```cmd
git remote add origin https://github.com/Riavaas/bob-assistant.git
git push -u origin master
```

## 4. Sur la Raspberry Pi

Dans votre terminal SSH :
```bash
# Cloner le repo
git clone https://github.com/Riavaas/bob-assistant.git ~/projects/bob

# Aller dans le répertoire
cd ~/projects/bob

# Suivre le guide
cat raspberry_pi_setup.md
```

## 5. Installation automatique

```bash
chmod +x scripts/setup_day1.sh
./scripts/setup_day1.sh
source ~/.cargo/env
cargo build --release
./target/release/bob say "Bonjour Aimane, BoB est opérationnel !"
```

---

**Note :** Tous les fichiers sont prêts et commitées. Une fois le repo GitHub créé, le déploiement sera instantané et fiable !
