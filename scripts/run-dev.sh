#!/bin/bash
set -x

# This mode should not be used in prod, this is only during development that will reload the server
# when changes to the files are made

# If the DB host is not ready, migrate will fail
scripts/wait-for-it.sh -h ${DB_HOST} -p ${DB_PORT}
yes "yes" | python manage.py migrate

python manage.py runserver 0.0.0.0:8000
