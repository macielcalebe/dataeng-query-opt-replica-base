#!/bin/bash
set -e

# Este script cria o slot de replicacao no Primary

DB_USER="${POSTGRES_USER_APP}"
DB_NAME="${POSTGRES_DB_APP}"

# Aguarda o servidor estar pronto
until pg_isready -U "$DB_USER" -d "$DB_NAME"; do
  echo "Aguardando o servidor Primary estar disponivel para criar o slot de replicacao..."
  sleep 1
done

echo "Criando slot de replicacao 'replica_slot_01'..."

# Cria o slot de replicacao se nao existir
psql -v ON_ERROR_STOP=1 --username "$DB_USER" --dbname "$DB_NAME" <<-EOSQL
    SELECT pg_create_physical_replication_slot('replica_slot_01') 
    WHERE NOT EXISTS (
        SELECT 1 FROM pg_replication_slots WHERE slot_name = 'replica_slot_01'
    );
EOSQL

echo "Slot de replicacao criado/verificado com sucesso."
