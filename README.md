# SAE Dolibarr

Projet SAE 51 – Déploiement d'un ERP/CRM Dolibarr avec Docker et MariaDB.

L'objectif est de fournir une installation reproductible de Dolibarr, l'import automatisé des Tiers ainsi qu'un mécanisme de sauvegarde et de restauration.

## Prérequis

- Git
- Docker
- Docker Compose
- Python 3
- curl

Vérifier les prérequis :

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

Le script démarre MariaDB et Dolibarr et attend que le service soit disponible.

Dolibarr est accessible sur :

```text
http://localhost:8081
```

La configuration initiale utilise :

```text
Société : NormaLink
Pays : France
```

## Import des Tiers

Les données de démonstration sont stockées dans :

```text
data/tiers.csv
```

Lancer l'import :

```bash
./scripts/import_csv.sh
```

Le jeu de données contient :

```text
21 Tiers
14 clients
7 fournisseurs
0 double catégorie
```

Le script peut être relancé sans créer de doublons pour les Tiers déjà présents.

## Sauvegarde

Créer une sauvegarde :

```bash
./scripts/backup.sh
```

Les sauvegardes sont stockées dans :

```text
~/SAE51-backups/
```

Une sauvegarde contient :

```text
dolibarr.sql
dolibarr_documents.tar.gz
sha256sums.txt
```

## Restauration

Restaurer une sauvegarde :

```bash
./scripts/restore.sh <répertoire_de_sauvegarde>
```

Exemple :

```bash
./scripts/restore.sh ~/SAE51-backups/2026-09-28_17-53-25
```

Le script vérifie l'intégrité de la sauvegarde avant de restaurer la base et les documents.

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

Arrêter et supprimer les conteneurs :

```bash
docker compose down
```

Supprimer également les volumes :

```bash
docker compose down -v
```

> Attention : `docker compose down -v` supprime les volumes contenant les données de l'application.

Afficher les logs :

```bash
docker logs dolibarr-app
docker logs dolibarr-db
```

## Scripts

| Script | Fonction |
|---|---|
| `scripts/install.sh` | Installation et démarrage de l'environnement |
| `scripts/import_csv.sh` | Import des Tiers depuis le CSV |
| `scripts/backup.sh` | Sauvegarde de la base et des documents |
| `scripts/restore.sh` | Restauration d'une sauvegarde |

## Configuration

La configuration de l'environnement est définie dans :

```text
docker-compose.yml
```

Les données de démonstration sont définies dans :

```text
data/tiers.csv
```

## Structure du projet

```text
sae-dolibarr/
├── data/
│   └── tiers.csv
├── scripts/
│   ├── install.sh
│   ├── import_csv.sh
│   ├── backup.sh
│   └── restore.sh
├── tests/
├── docker-compose.yml
├── README.md
├── sources.md
└── suivi_projet.md
```

## Sources

Les sources documentaires utilisées pour le projet sont regroupées dans :

```text
sources.md
```

## Suivi du projet

Le journal de bord est disponible dans :

```text
suivi_projet.md

