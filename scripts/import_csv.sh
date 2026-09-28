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
trap 'rm -f "$TMP_SQL"' EXIT

python3 - "$CSV_FILE" "$TMP_SQL" <<'PY'
import csv
import sys

csv_file = sys.argv[1]
sql_file = sys.argv[2]

def esc(value):
    return value.strip().replace("'", "''")

def sql_text(value):
    value = value.strip()
    return "NULL" if not value else f"'{esc(value)}'"

with open(csv_file, newline="", encoding="utf-8-sig") as f:
    reader = csv.DictReader(f)

    required = [
        "Nom du tiers* (s.nom)",
        "État* (s.status)",
        "Code pays (s.fk_pays)",
        "Client* (s.client)",
        "Fournisseur* (s.fournisseur)",
    ]

    for column in required:
        if column not in reader.fieldnames:
            raise SystemExit(f"Colonne absente du CSV : {column}")

    with open(sql_file, "w", encoding="utf-8") as out:
        for row in reader:
            nom = row["Nom du tiers* (s.nom)"].strip()
            status = int(row["État* (s.status)"])
            code_pays = esc(row["Code pays (s.fk_pays)"])
            client = int(row["Client* (s.client)"])
            fournisseur = int(row["Fournisseur* (s.fournisseur)"])

            address = sql_text(row.get("Adresse (s.address)", ""))
            zip_code = sql_text(row.get("Code postal (s.zip)", ""))
            town = sql_text(row.get("Ville (s.town)", ""))
            phone = sql_text(row.get("Téléphone (s.phone)", ""))
            email = sql_text(row.get("Email (s.email)", ""))
            import_key = sql_text(row.get("Clé import (s.import_key)", ""))

            nom_sql = sql_text(nom)

            # Mise à jour si le Tiers existe déjà.
            out.write(f"""
UPDATE llx_societe s
JOIN llx_c_country c ON c.code = '{code_pays}'
SET
    s.status = {status},
    s.fk_pays = c.rowid,
    s.client = {client},
    s.fournisseur = {fournisseur},
    s.address = {address},
    s.zip = {zip_code},
    s.town = {town},
    s.phone = {phone},
    s.email = {email},
    s.import_key = {import_key}
WHERE s.nom = {nom_sql};

""")

            # Insertion si le Tiers n'existe pas.
            out.write(f"""
INSERT INTO llx_societe
(
    entity,
    nom,
    status,
    fk_pays,
    client,
    fournisseur,
    address,
    zip,
    town,
    phone,
    email,
    import_key,
    datec
)
SELECT
    1,
    {nom_sql},
    {status},
    c.rowid,
    {client},
    {fournisseur},
    {address},
    {zip_code},
    {town},
    {phone},
    {email},
    {import_key},
    NOW()
FROM llx_c_country c
WHERE c.code = '{code_pays}'
  AND NOT EXISTS (
      SELECT 1
      FROM llx_societe s
      WHERE s.nom = {nom_sql}
  );

""")
PY

echo "Import enrichi des Tiers..."

docker exec -i -e MYSQL_PWD="$DB_PASSWORD" \
    "$DB_CONTAINER" \
    mariadb -u "$DB_USER" "$DB_NAME" < "$TMP_SQL"

echo "Import terminé."
