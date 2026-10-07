# Journal de bord

SAE 51 - Installation d'un ERP/CRM (Dolibarr)

CHEF DE PROJET : Algor Zoubabela

AUTRE MEMBRE EQUIPE : Imabith Houngbo

DATE DEBUT : 23/09/2026


## Séance n°1

**Date :** 23/09/2026  
**Horaire :** 08h30 - 10h00  
**Durée :** 1h30

### Travail effectué

- Installation et vérification de Git sur la machine de travail.
- Clonage du dépôt GitHub `sae-dolibarr`.
- Première prise en main du sujet et identification des besoins du projet.
- Étude de l'architecture nécessaire pour déployer Dolibarr.
- Première tentative d'installation manuelle de Dolibarr avec MariaDB, Apache et PHP.
- Constat des difficultés liées à l'installation manuelle et choix de s'orienter vers Docker.
- Installation de Docker et vérification de Docker Compose.
- Mise en place d'une première architecture composée de deux conteneurs :
  - un conteneur MariaDB ;
  - un conteneur Dolibarr.
- Création et premiers tests du fichier `docker-compose.yml`.
- Lancement de Dolibarr et vérification de son accès depuis le navigateur.

### Difficultés rencontrées

- Problèmes liés à l'environnement de la machine virtuelle.
- Difficultés de saisie et de configuration dans la VM.
- Temps de téléchargement important des images Docker.
- Premières erreurs de configuration dans le fichier YAML.

### Résultats

Une première version de l'environnement Dolibarr fonctionnant avec Docker a été mise en place.

Le choix d'une architecture Docker a été retenu afin de faciliter la reproductibilité de l'installation.


## Séance n°2

**Date :** 28/09/2026  
**Horaires :** 08h30 - 11h30 et 14h30 - 17h30  
**Durée :** 6h00

### Travail effectué

- Reprise de l'environnement de travail sur une VM Debian 12.
- Récupération des dernières modifications du dépôt GitHub.
- Mise en place et vérification de Docker Compose.
- Reprise du fichier `docker-compose.yml` afin d'utiliser une architecture commune à l'équipe.
- Création des conteneurs Dolibarr et MariaDB.
- Vérification de la communication entre les conteneurs.
- Accès à l'interface Web de Dolibarr.
- Configuration initiale de Dolibarr.
- Création et configuration de la société utilisée pour le projet.
- Activation des modules nécessaires à la gestion des Tiers.
- Création d'un compte utilisateur avec des droits limités.
- Vérification de la gestion des clients et des fournisseurs.
- Premiers essais d'ajout manuel de Tiers dans Dolibarr.

### Difficultés rencontrées

- Installation et configuration de Docker Compose sur Debian 12.
- Gestion des volumes Docker lors de la réinitialisation de l'environnement.
- Prise en compte des paramètres de configuration uniquement lors de la première initialisation de la base.

### Résultats

L'environnement de développement est opérationnel.

Dolibarr et MariaDB fonctionnent correctement dans des conteneurs séparés et permettent de poursuivre la configuration du projet.


## Séance n°3

**Date :** 30/09/2026  
**Horaire :** 14h30 - 17h30  
**Durée :** 3h00

### Travail effectué

- Préparation du jeu de données utilisé pour le projet.
- Création et vérification du fichier `data/tiers.csv`.
- Ajout de données fictives représentant des clients et des fournisseurs.
- Vérification des différentes colonnes nécessaires à l'import des Tiers.
- Vérification des valeurs utilisées pour les statuts, le pays et les catégories client/fournisseur.
- Travail sur l'automatisation de l'import des Tiers dans MariaDB.
- Développement et amélioration du script `scripts/import_csv.sh`.
- Mise en place du traitement du fichier CSV avec Python.
- Vérification de la prise en compte des caractères accentués.
- Vérification du nombre de Tiers présents après import.
- Vérification du comportement du script en cas de nouvelle exécution afin d'éviter les doublons.

### Difficultés rencontrées

- Prise en compte du format exact du fichier CSV.
- Gestion des accents et des caractères spéciaux.
- Vérification des catégories client et fournisseur dans Dolibarr.
- Nécessité de rendre l'import reproductible et non dépendant d'une saisie manuelle.

### Résultats

Le fichier CSV de données est exploitable et le script `import_csv.sh` permet d'automatiser l'import des Tiers.

Le jeu de données final contient 21 Tiers.


## Séance n°4

**Date :** 05/10/2026  
**Horaire :** 13h00 - 16h00  
**Durée :** 3h00

### Travail effectué

- Poursuite de l'automatisation du déploiement de Dolibarr.
- Finalisation du script `scripts/install.sh`.
- Mise en place des vérifications des prérequis nécessaires au lancement du projet.
- Automatisation du démarrage des conteneurs avec Docker Compose.
- Ajout de vérifications permettant d'attendre que MariaDB soit disponible.
- Ajout d'une vérification permettant de confirmer que l'interface Web de Dolibarr est accessible.
- Vérification de l'installation depuis un environnement propre.
- Mise en place du script `scripts/backup.sh`.
- Réalisation d'une sauvegarde de la base MariaDB.
- Sauvegarde des documents utilisés par Dolibarr.
- Génération d'une somme de contrôle SHA-256 pour vérifier l'intégrité des sauvegardes.
- Mise en place du script `scripts/restore.sh`.
- Test de suppression puis de restauration des conteneurs et des volumes.
- Vérification de la récupération des données après restauration.
- Vérification du nombre de Tiers après restauration.
- Vérification de la présence des données clients et fournisseurs.

### Difficultés rencontrées

- Gestion de l'ordre de démarrage des conteneurs.
- Nécessité d'attendre que MariaDB soit réellement disponible avant de lancer les opérations SQL.
- Vérification de la restauration complète des données.

### Résultats

Les principaux scripts d'automatisation sont opérationnels :

- `install.sh`
- `import_csv.sh`
- `backup.sh`
- `restore.sh`

La procédure de sauvegarde et de restauration a été testée avec succès.


## Séance n°5

**Date :** 06/10/2026  
**Horaire :** 14h30 - 17h30  
**Durée :** 3h00

### Travail effectué

- Poursuite des tests du projet Dolibarr.
- Vérification du fonctionnement des scripts d'installation et d'import.
- Vérification des données importées dans Dolibarr.
- Contrôle de la sauvegarde et de la restauration de la base de données.
- Vérification de la cohérence entre les fichiers du dépôt et l'environnement Docker.
- Vérification de la structure du dépôt GitHub.
- Nettoyage des fichiers et éléments devenus inutiles.
- Vérification du fichier `.gitignore`.
- Poursuite de la rédaction et de la mise à jour de la documentation.
- Relecture du `README.md`.
- Mise à jour du fichier `sources.md`.
- Vérification de la cohérence entre la documentation, les scripts et le fichier `docker-compose.yml`.

### Difficultés rencontrées

- Vérification de la cohérence entre les différentes versions des fichiers du dépôt.
- Nécessité de maintenir une documentation correspondant à l'état réel du projet.
- Vérification de l'ensemble des fonctionnalités avant la finalisation du dépôt.

### Résultats

Les différents éléments du projet ont été vérifiés afin de préparer la finalisation du dépôt et la mise au propre de la documentation.


## Séance n°6

**Date :** 07/10/2026  
**Horaire :** 16h00 - 19h00  
**Durée :** 3h00

### Travail effectué

- Vérification de l'état général du dépôt GitHub.
- Vérification de la structure du projet et des différents fichiers présents dans le dépôt.
- Nettoyage de la structure du dépôt.
- Vérification de l'absence de fichiers de sauvegarde SQL inutiles dans le dépôt.
- Finalisation du `README.md`.
- Mise à jour de `sources.md`.
- Vérification de la cohérence entre la documentation, les scripts et le fichier `docker-compose.yml`.
- Vérification du fonctionnement des conteneurs Dolibarr et MariaDB.
- Vérification de l'accès à Dolibarr depuis le poste de travail.
- Vérification de la configuration de la société `NormaLink`.
- Vérification de l'activation des modules nécessaires.
- Vérification de l'import des 21 Tiers.
- Vérification de la répartition des Tiers :
  - 14 clients ;
  - 7 fournisseurs.
- Relecture des scripts d'installation, d'import, de sauvegarde et de restauration.
- Mise au propre du journal de bord du projet.

### Résultats

Le dépôt est organisé autour de l'architecture Docker retenue pour le projet.

Les scripts d'automatisation sont disponibles et fonctionnels :

- installation ;
- import des Tiers ;
- sauvegarde ;
- restauration.

La documentation principale a été mise à jour et le projet est prêt pour les dernières vérifications avant la remise.