#!/bin/bash

set -e

CSV_FILE="data/tiers.csv"
DB_CONTAINER="dolibarr-db"
DB_NAME="dolibarr"
DB_USER="dolibarr"
DB_PASSWORD="dolibarrpass"

if [ ! -f "$CSV_FILE" ]; then
    echo "Erreur : fichier CSV introuvable : $CSV_FILE"
    exit 1
fi

TMP_SQL=$(mktemp)

python3 - "$CSV_FILE" "$TMP_SQL" <<'PY'
import csv
import sys

csv_file = sys.argv[1]
sql_file = sys.argv[2]

def sql_escape(value):
    return value.replace("'", "''")

with open(csv_file, newline="", encoding="utf-8-sig") as f:
    reader = csv.DictReader(f)

    with open(sql_file, "w", encoding="utf-8") as out:
        for row in reader:
            nom = sql_escape(row["Nom du tiers* (s.nom)"].strip())
            status = int(row["État* (s.status)"])
            code_pays = sql_escape(row["Code pays (s.fk_pays)"].strip())
            client = int(row["Client* (s.client)"])
            fournisseur = int(row["Fournisseur* (s.fournisseur)"])

            out.write(f"""
INSERT INTO llx_societe
(
    entity,
    nom,
    status,
    fk_pays,
    client,
    fournisseur,
    datec
)
SELECT
    1,
    '{nom}',
    {status},
    c.rowid,
    {client},
    {fournisseur},
    NOW()
FROM llx_c_country c
WHERE c.code = '{code_pays}'
  AND NOT EXISTS (
      SELECT 1
      FROM llx_societe s
      WHERE s.nom = '{nom}'
  );

""")
PY

echo "Import des Tiers..."

docker exec -i -e MYSQL_PWD="$DB_PASSWORD" "$DB_CONTAINER" \
    mariadb -u "$DB_USER" "$DB_NAME" < "$TMP_SQL"

rm -f "$TMP_SQL"

echo "Import terminé."
