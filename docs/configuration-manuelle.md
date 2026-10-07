# Découverte et configuration manuelle de Dolibarr

Cette étape correspond à la phase de découverte de Dolibarr réalisée avant l'automatisation du déploiement.

## Environnement

- OS : Debian
- Base de données : MariaDB
- Serveur ERP/CRM : Dolibarr
- Déploiement final : Docker

## Découverte de Dolibarr

Une première configuration manuelle a été réalisée afin de comprendre le fonctionnement de Dolibarr avant son automatisation.

Les principales opérations réalisées sont :

- configuration de l'accès à la base de données ;
- création du compte administrateur ;
- création d'un compte utilisateur ;
- configuration des droits du compte utilisateur ;
- activation des modules nécessaires à la gestion des Tiers ;
- création et consultation de clients et fournisseurs ;
- découverte de l'assistant d'import CSV.

## Modules utilisés

Les fonctionnalités nécessaires au projet concernent principalement :

- Tiers / Sociétés ;
- Fournisseurs ;
- Import de données.

## Données de test

Les données utilisées dans le projet sont fictives.

Le fichier utilisé pour l'import automatisé est :

```text
data/tiers.csv