#!/bin/bash

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "======================================"
echo " SAE Dolibarr - Installation"
echo "======================================"

cd "$PROJECT_DIR"

# Vérification de Docker
if ! command -v docker >/dev/null 2>&1; then
    echo "ERREUR : Docker n'est pas installé."
    exit 1
fi

# Vérification de Docker Compose
if ! docker compose version >/dev/null 2>&1; then
    echo "ERREUR : Docker Compose n'est pas disponible."
    exit 1
fi

# Vérification du fichier Compose
if [ ! -f "$PROJECT_DIR/docker-compose.yml" ]; then
    echo "ERREUR : docker-compose.yml introuvable."
    exit 1
fi

echo
echo "[1/3] Démarrage de MariaDB et Dolibarr..."
docker compose up -d

echo
echo "[2/3] Attente du démarrage de MariaDB..."

until docker exec dolibarr-db mariadb-admin ping \
    -h localhost \
    -u dolibarr \
    -p'dolibarrpass' \
    --silent >/dev/null 2>&1
do
    sleep 2
done

echo "MariaDB est opérationnel."

echo
echo "[3/3] Vérification des conteneurs..."
docker compose ps

echo
echo "======================================"
echo " Installation terminée"
echo "======================================"
echo "Dolibarr : http://localhost:8081"
echo
echo "Pour importer les données :"
echo "    ./scripts/import_csv.sh"
