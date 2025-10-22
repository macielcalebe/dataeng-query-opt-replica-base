#!/bin/bash
set -e

# Este script e executado pelo entrypoint do Docker no servidor Primary
# para configurar o PostgreSQL para aceitar conexoes de replicao.

REPL_USER="${POSTGRES_REPLICATION_USER}"
REPL_PASS="${POSTGRES_REPLICATION_PASSWORD}"
DB_USER="${POSTGRES_USER_APP}"
DB_NAME="${POSTGRES_DB_APP}"

# Cria o usuario com permissao de REPLICATION
# Aguarda o servidor temporario do Postgres (em execucao pelo entrypoint) iniciar
until pg_isready -U "$DB_USER" -d "$DB_NAME"; do
  echo "Aguardando o servidor Primary estar disponivel para criar o usuario de replica..."
  sleep 1
done

echo "Criando o usuario de replicação '$REPL_USER'..."
psql -v ON_ERROR_STOP=1 --username "$DB_USER" <<-EOSQL
    CREATE USER "$REPL_USER" WITH REPLICATION ENCRYPTED PASSWORD '$REPL_PASS';
EOSQL

echo "Configuracoes internas realizadas."

# Configura postgresql.conf para habilitar streaming replication e hot standby
# O entrypoint do Docker ja inicia com as configuracoes padrao. 
# Adicionamos ou sobrescrevemos as necessarias.
# O local padrao de configuracao e /var/lib/postgresql/data/
PGDATA_PATH="/var/lib/postgresql/data"

echo "Configurando arquivos de servidor..."
echo "wal_level = replica" >> "$PGDATA_PATH/postgresql.conf"
echo "max_wal_senders = 10" >> "$PGDATA_PATH/postgresql.conf"
echo "max_replication_slots = 10" >> "$PGDATA_PATH/postgresql.conf"
echo "hot_standby = on" >> "$PGDATA_PATH/postgresql.conf"

# Adiciona a linha ao pg_hba.conf
# Adiciona linha para o usuario de REPLICATION, permitindo conexao de qualquer IP da rede Docker.
echo "host replication ${REPL_USER} all scram-sha-256" >> "$PGDATA_PATH/pg_hba.conf" 

echo "Configuracao do Primary finalizada. O servidor principal sera iniciado agora."
