#!/usr/bin/env sh

# run tests against all supported databases
# postgres / mysql run via docker
# sqlite (default) runs against local database file (database.db)

echo "starting local database instances"
docker-compose -f tests/docker-compose.yml up -d

export DJANGO_SETTINGS_MODULE=settings

export IMPORT_EXPORT_POSTGRESQL_USER=pguser
export IMPORT_EXPORT_POSTGRESQL_PASSWORD=pguserpass

export IMPORT_EXPORT_MYSQL_USER=mysqluser
export IMPORT_EXPORT_MYSQL_PASSWORD=mysqluserpass

echo "running tests (sqlite)"
tox

echo "running tests (mysql)"
export IMPORT_EXPORT_TEST_TYPE=mysql-innodb
tox

echo "running tests (postgres)"
export IMPORT_EXPORT_TEST_TYPE=postgres
tox

echo "removing local database instances"
docker-compose -f tests/docker-compose.yml down -v