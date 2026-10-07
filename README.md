# SAE Dolibarr

Projet SAE 51 – Déploiement d'un ERP/CRM Dolibarr avec Docker et MariaDB.

L'objectif est de fournir une installation reproductible de Dolibarr, l'import automatisé des Tiers ainsi qu'un mécanisme de sauvegarde et de restauration.

## Versions utilisées

- Dolibarr : 24.0.0
- MariaDB : 11
- Docker Compose : v2

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

Le script démarre MariaDB et Dolibarr et attend que les services soient disponibles.

Dolibarr est accessible sur :

```text
http://localhost:8081
```

La configuration initiale utilise :

```text
Société : NormaLink
Pays : France
```

Les modules suivants sont activés automatiquement :

```text
Societe
Fournisseur
Import
Export
```

## Découverte et comptes

Une phase de découverte manuelle de Dolibarr a été réalisée avant l'automatisation.

Cette phase comprend notamment :

- un compte superadmin pour l'administration de Dolibarr ;
- un compte utilisateur avec des droits limités à la gestion des Tiers ;
- l'activation des modules nécessaires ;
- la découverte de l'assistant d'import et des fonctionnalités d'export.

Les informations détaillées sont disponibles dans :

```text
docs/configuration-manuelle.md
```

Aucun mot de passe de compte n'est stocké dans le dépôt.

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
./scripts/restore.sh ~/SAE51-backups/AAAA-MM-JJ_HH-MM-SS
```

Le script vérifie l'intégrité de la sauvegarde avant de restaurer la base et les documents.

Après restauration, le script attend que Dolibarr soit réellement accessible avant de terminer.

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

## Documentation

La documentation complémentaire se trouve dans :

```text
docs/
└── configuration-manuelle.md
```

Ce document présente la phase de découverte et de configuration manuelle de Dolibarr avant l'automatisation du déploiement.

## Configuration

La configuration de l'environnement est définie dans :

```text
docker-compose.yml
```

La configuration actuelle utilise :

```text
Dolibarr : 24.0.0
MariaDB : 11
Port Web : 8081
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
├── docs/
│   └── configuration-manuelle.md
├── scripts/
│   ├── install.sh
│   ├── import_csv.sh
│   ├── backup.sh
│   └── restore.sh
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
```

## Auteurs

- Algor Zoubabela
- Imabith Houngbo

Projet réalisé dans le cadre de la SAE 51 – BUT Réseaux & Télécommunications, IUT Rouen.
