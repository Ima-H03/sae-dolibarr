#!/bin/bash

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_ROOT="$HOME/SAE51-backups"

DATE="$(date '+%Y-%m-%d_%H-%M-%S')"
BACKUP_DIR="$BACKUP_ROOT/$DATE"

DB_CONTAINER="dolibarr-db"
DB_NAME="dolibarr"
DB_USER="dolibarr"
DB_PASSWORD="dolibarrpass"

echo "======================================"
echo " SAE Dolibarr - Sauvegarde"
echo "======================================"

mkdir -p "$BACKUP_DIR"

echo
echo "[1/3] Sauvegarde de la base MariaDB..."

docker exec -e MYSQL_PWD="$DB_PASSWORD" \
    "$DB_CONTAINER" \
    mariadb-dump \
    -u "$DB_USER" \
    --single-transaction \
    --routines \
    --triggers \
    "$DB_NAME" \
    > "$BACKUP_DIR/dolibarr.sql"

echo "Base sauvegardée."

echo
echo "[2/3] Sauvegarde des documents Dolibarr..."

docker exec dolibarr-app \
    tar czf - \
    -C /var/www/documents . \
    > "$BACKUP_DIR/dolibarr_documents.tar.gz"

echo "Documents sauvegardés."

echo
echo "[3/3] Calcul des sommes de contrôle..."

cd "$BACKUP_DIR"
sha256sum dolibarr.sql dolibarr_documents.tar.gz > sha256sums.txt

echo
echo "======================================"
echo " Sauvegarde terminée"
echo "======================================"
echo
echo "Dossier : $BACKUP_DIR"
echo
ls -lh "$BACKUP_DIR"
