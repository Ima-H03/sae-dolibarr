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

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Vérification de l'intégrité de la sauvegarde..."
(
    cd "$BACKUP_DIR"
    sha256sum -c sha256sums.txt
)

echo
echo "ATTENTION : cette opération va supprimer les conteneurs et volumes actuels."
read -r -p "Confirmer la restauration ? (oui/non) : " CONFIRMATION

if [ "$CONFIRMATION" != "oui" ]; then
    echo "Restauration annulée."
    exit 0
fi

cd "$PROJECT_DIR"

echo
echo "[1/5] Suppression de l'environnement actuel..."
docker compose down -v

echo
echo "[2/5] Démarrage de MariaDB uniquement..."
docker compose up -d db

echo
echo "Attente de MariaDB..."

until docker exec dolibarr-db mariadb-admin \
    -h localhost \
    -u dolibarr \
    -p'dolibarrpass' \
    --silent ping >/dev/null 2>&1
do
    sleep 2
done

echo "MariaDB est opérationnel."

echo
echo "[3/5] Restauration de la base..."

docker exec -i -e MYSQL_PWD='dolibarrpass' \
    dolibarr-db \
    mariadb -u dolibarr dolibarr < "$BACKUP_DIR/dolibarr.sql"

echo "Base restaurée."

echo
echo "[4/5] Démarrage de Dolibarr..."
docker compose up -d dolibarr

echo
echo "Attente de Dolibarr..."
sleep 5

echo
echo "[5/5] Restauration des documents..."

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
