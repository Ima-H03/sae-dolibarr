#!/bin/bash

set -e

BACKUP_DIR="$1"

if [ -z "$BACKUP_DIR" ]; then
    echo "Usage : $0 <dossier_de_sauvegarde>"
    exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
    echo "ERREUR : dossier introuvable : $BACKUP_DIR"
    exit 1
fi

if [ ! -f "$BACKUP_DIR/dolibarr.sql" ] || \
   [ ! -f "$BACKUP_DIR/dolibarr_documents.tar.gz" ] || \
   [ ! -f "$BACKUP_DIR/sha256sums.txt" ]; then
    echo "ERREUR : sauvegarde incomplète."
    exit 1
fi

echo "Vérification de l'intégrité de la sauvegarde..."
(
    cd "$BACKUP_DIR"
    sha256sum -c sha256sums.txt
)

echo
echo "ATTENTION : cette opération va remplacer les données actuelles."
read -r -p "Confirmer la restauration ? (oui/non) : " CONFIRMATION

if [ "$CONFIRMATION" != "oui" ]; then
    echo "Restauration annulée."
    exit 0
fi

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

echo
echo "[1/4] Arrêt de Dolibarr..."
docker compose stop dolibarr

echo "[2/4] Restauration de la base MariaDB..."
docker exec -i -e MYSQL_PWD='dolibarrpass' \
    dolibarr-db \
    mariadb -u dolibarr dolibarr < "$BACKUP_DIR/dolibarr.sql"

echo "[3/4] Redémarrage de Dolibarr..."
docker compose start dolibarr

echo "[4/4] Restauration des documents..."
docker exec dolibarr-app \
    sh -c 'find /var/www/documents -mindepth 1 -delete'

docker exec -i dolibarr-app \
    tar xzf - -C /var/www/documents \
    < "$BACKUP_DIR/dolibarr_documents.tar.gz"

echo
echo "======================================"
echo " Restauration terminée"
echo "======================================"

docker compose ps
