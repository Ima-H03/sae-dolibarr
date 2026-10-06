# Journal de bord

SAE 51 - Installation d'un ERP/CRM (Dolibarr)

CHEF DE PROJET : Algor Zoubabela

AUTRE MEMBRE EQUIPE : Imabith Houngbo

DATE DEBUT : 23/09/2026

## Séance n° 1

date - heure : 23/09/2026 de 8h30 à 11h30

Travail effectué : Installation de Git et clonage du dépôt sae-dolibarr sur la VM Debian. Tentative d'installation manuelle de Dolibarr : installation de MariaDB, d'Apache et de PHP, et configuration de l'accès root à la base. Le téléchargement du paquet DoliDeb n'a pas abouti, donc l'installation manuelle est abandonnée au profit de l'image Docker officielle, autorisée par le sujet. Installation de Docker, création d'un docker-compose.yml avec deux conteneurs (MariaDB et Dolibarr), lancement de Dolibarr et accès depuis le navigateur. Configuration de base (société IUT, module Third Parties), création du compte user.user avec des permissions limitées à la gestion des Tiers. Test réussi : création d'un tiers BUT3 depuis ce compte.

Difficultés rencontrées : Clavier de la VM en QWERTY, ce qui corrompait les adresses saisies. Copier-coller impossible entre le PC et la VM, VM sans interface graphique et réseau lent. Le paquet php-imap n'existe plus dans cette version de Debian. Erreurs d'indentation dans le fichier YAML. Téléchargement des images Docker très long.

Remarques sur la séance : Dolibarr fonctionne dans Docker. Il reste à importer des données.

## Séance n° 2

date - heure : 28/09/2026 de 08h30 à 11h30

Travail effectué : Passage sur une nouvelle VM Debian 12 avec interface graphique. Reprise du docker-compose.yml d'Imabith (port 8081) comme référence commune. Lancement des conteneurs et configuration de Dolibarr : société IUT, modules Third Parties, Vendors et Data imports, compte user.user avec ses permissions.

Difficultés rencontrées : Le plugin Docker Compose v2 n'est pas disponible via apt sur Debian 12, il a fallu l'installer à la main pour que les scripts fonctionnent. Les identifiants administrateur du docker-compose ne sont pas appliqués sur une base déjà initialisée, il a fallu recréer les volumes.

Remarques sur la séance : Les deux membres de l'équipe ont chacun leur instance Dolibarr, avec sa propre base.

## Séance n° 3

date - heure : 28/09/2026 de 20h30 à 23h30

Travail effectué : Import de 15 tiers fictifs (9 clients et 6 fournisseurs) avec l'assistant d'import de Dolibarr. Test de import_csv.sh : 6 tiers ajoutés, 21 au total, accents corrects. Test de backup.sh puis restore.sh : conteneurs et volumes supprimés puis restaurés, 21 tiers et comptes admin et user.user retrouvés. Retrait de l'ancien fichier dolibarr_dump.sql du dépôt et ajout de *.sql au .gitignore.

Documentation : Rédaction de docs/configuration-manuelle.md et de tests/test-backup-restore.md.

Difficultés rencontrées : Les fournisseurs importés n'apparaissent que si le module Vendors est activé. L'assistant d'import attend un séparateur virgule et une colonne statut.

Remarques sur la séance : Les scripts install.sh, import_csv.sh, backup.sh et restore.sh ont été écrits par Imabith. Reste à tester install.sh depuis une machine vierge, à compléter le README et à indiquer dans sources.md que les données sont fictives.
