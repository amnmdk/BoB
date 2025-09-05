# BoB

Assistant domestique local pour Raspberry Pi 5 avec interface d'administration web.

## Architecture

- **Langage** : C
- **Serveur HTTP** : sockets basiques
- **Configuration** : à venir

## Compilation

```bash
make
```

## Utilisation

```bash
./bob_server
```

Ouvrir ensuite `http://<adresse_ip>:8080/` dans un navigateur pour accéder à l'interface d'administration.

## Dépendances

- gcc ou tout compilateur C compatible
- libc standard

## Prochaines étapes

- Ajouter le traitement audio (TTS/STT)
- Interface HTML plus complète
- Gestion de configuration
