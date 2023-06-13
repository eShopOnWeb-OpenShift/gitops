#!/bin/bash

##
## Development instructions
##
#
# helm template foo .
# cd files/init-hook
# oc port-forward service/sql-server 1433:1433
# export SA_PASSWORD='R3dH4t1!'
# export SQLSERVER_HOSTNAME="127.0.0.1"
# export DATABASE_NAME="eShop"
# export SCHEMA_NAME="eShop"
# export DATABASE_USERNAME="eShop"
# export DATABASE_PASSWORD='R3dH4t1!'

set -Eeuo pipefail

export PATH="/opt/mssql-tools/bin:$PATH"

echo "========================================================================"
echo " Connecting to SQL Server"
echo "========================================================================"
echo

while ! sqlcmd -Usa "-P${SA_PASSWORD}" "-S${SQLSERVER_HOSTNAME},1433" -Q"SELECT @@version" &>/dev/null; do
    echo "SQL Server not ready..."
    sleep 5
done

echo OK
echo

echo "========================================================================"
echo " Configuring SQL Server"
echo "========================================================================"
echo

sqlcmd -Usa "-P${SA_PASSWORD}" "-S${SQLSERVER_HOSTNAME},1433" -Q"
CREATE DATABASE ${DATABASE_NAME};"

sqlcmd -Usa "-P${SA_PASSWORD}" "-S${SQLSERVER_HOSTNAME},1433" "-d${DATABASE_NAME}" -Q"
CREATE SCHEMA ${SCHEMA_NAME};
GO
CREATE LOGIN ${DATABASE_USERNAME} WITH PASSWORD = '${DATABASE_PASSWORD}', DEFAULT_DATABASE = ${DATABASE_NAME};
GO
CREATE USER ${DATABASE_USERNAME} FOR LOGIN ${DATABASE_USERNAME} WITH DEFAULT_SCHEMA=${SCHEMA_NAME};
GO
GRANT ALL PRIVILEGES ON SCHEMA::${SCHEMA_NAME} TO ${DATABASE_USERNAME} WITH GRANT OPTION;
GO
ALTER ROLE db_owner ADD MEMBER ${DATABASE_USERNAME};
GO
"

exit 0
