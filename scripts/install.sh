#!/bin/bash

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DOLIBARR_URL="http://localhost:8081"

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

# Vérification de curl
if ! command -v curl >/dev/null 2>&1; then
    echo "ERREUR : curl n'est pas installé."
    exit 1
fi

# Vérification du fichier Compose
if [ ! -f "$PROJECT_DIR/docker-compose.yml" ]; then
    echo "ERREUR : docker-compose.yml introuvable."
    exit 1
fi

echo
echo "[1/4] Démarrage de MariaDB et Dolibarr..."
docker compose up -d

echo
echo "[2/4] Attente du démarrage de MariaDB..."

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
echo "[3/4] Attente de la disponibilité de Dolibarr..."

MAX_ATTEMPTS=60
ATTEMPT=1

until curl -fsS --max-time 3 "$DOLIBARR_URL" >/dev/null 2>&1
do
    if [ "$ATTEMPT" -ge "$MAX_ATTEMPTS" ]; then
        echo "ERREUR : Dolibarr ne répond pas après 120 secondes."
        docker compose ps
        exit 1
    fi

    sleep 2
    ATTEMPT=$((ATTEMPT + 1))
done

echo "Dolibarr est accessible."

echo
echo "[4/4] Vérification des conteneurs..."
docker compose ps

echo
echo "======================================"
echo " Installation terminée"
echo "======================================"
echo "Dolibarr : $DOLIBARR_URL"
echo
echo "Pour importer les données :"
echo "    ./scripts/import_csv.sh"
