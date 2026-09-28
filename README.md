# SAE Dolibarr

Projet SAE 51 – Déploiement d'un ERP/CRM Dolibarr avec Docker et MariaDB.

L'objectif est de fournir une installation reproductible de Dolibarr, l'import automatisé de données de Tiers ainsi qu'un mécanisme de sauvegarde et de restauration.

## Prérequis

- Git
- Docker
- Docker Compose
- Python 3
- curl

Vérification :

```bash
git --version
docker --version
docker compose version
python3 --version
curl --version
```

## Installation

Cloner le dépôt :

```bash
git clone https://github.com/algorzoubabelamakaya-art/sae-dolibarr.git
cd sae-dolibarr
```

Lancer l'installation :

```bash
./scripts/install.sh
```

Dolibarr est accessible sur :

```text
http://localhost:8081
```

## Utilisation

### Importer les Tiers

Les données sont stockées dans :

`data/tiers.csv`

Lancer l'import :

```bash
./scripts/import_csv.sh
```

Jeu de données actuel :

- 21 Tiers
- 14 clients
- 7 fournisseurs
- 0 double catégorie

### Sauvegarder l'environnement

```bash
./scripts/backup.sh
```

Les sauvegardes sont stockées dans :

`~/SAE51-backups/`

### Restaurer une sauvegarde

```bash
./scripts/restore.sh <répertoire_de_sauvegarde>
```

Exemple :

```bash
./scripts/restore.sh ~/SAE51-backups/2026-09-28_17-53-25
```

## Configuration

La configuration Docker se trouve dans :

`docker-compose.yml`

L'environnement utilise notamment :

- Dolibarr
- MariaDB
- le port `8081`
- la société `NormaLink`
- les modules nécessaires au projet

Les données de démonstration sont fournies dans :

`data/tiers.csv`

## Commandes Docker utiles

Voir l'état des conteneurs :

```bash
docker compose ps
```

Démarrer les services :

```bash
docker compose up -d
```

Arrêter les services :

```bash
docker compose stop
```

Redémarrer les services :

```bash
docker compose restart
```

Supprimer les conteneurs :

```bash
docker compose down
```

Supprimer les conteneurs et les volumes :

```bash
docker compose down -v
```

> Attention : `docker compose down -v` supprime les volumes contenant les données.

Afficher les logs :

```bash
docker logs dolibarr-app
docker logs dolibarr-db
```

## Structure du projet

```text
sae-dolibarr/
├── data/               # Données CSV
├── docs/               # Documentation technique
├── scripts/            # Scripts d'automatisation
├── sources/            # Sources utilisées
├── tests/              # Tests
├── docker-compose.yml  # Architecture Docker
├── README.md           # Présentation et utilisation
├── sources.md          # Sources documentaires
└── suivi_projet.md     # Journal de bord
```

## Scripts

| Script | Fonction |
|---|---|
| `scripts/install.sh` | Installation de l'environnement |
| `scripts/import_csv.sh` | Import des Tiers |
| `scripts/backup.sh` | Sauvegarde |
| `scripts/restore.sh` | Restauration |

## Documentation complémentaire

- `docs/guide-technique.md` : fonctionnement technique du projet
- `docs/procedure-pra.md` : procédure de sauvegarde et restauration
- `sources.md` : sources documentaires
- `suivi_projet.md` : journal de bord

