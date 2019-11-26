#!/bin/bash
set -ex

# This script was originally in the Dockerfile, but this tends to make development and troubleshooting
# more challenging.  Layer both made things faster and also more problematic :P
# The Dockerfile just creates our environment without any tools besides Docker
# After that, all commands are run using create.sh
# Once that is complete, the Makefile will copy the final app build locally
# From there, the build container is no longer used and build/ will be started up
# TODO: scripts/test.sh will launch basic tests on the output of the containers created from build/

# Start fresh, yes ... this will delete local host files
# TODO: Add protection in top level Makefile
rm -fr /app
mkdir -p /app/scripts
django-admin startproject ${PROJECT} /app

cd /jengo_django
cp -r templates/Makefile templates/requirements.txt templates/nginx templates/Dockerfile \
	templates/README.md templates/docker-compose-dev.yml templates/Jenkinsfile /app

cp templates/dockerignore /app/.dockerignore
cp scripts/wait-for-it.sh /app/scripts/wait-for-it.sh
cp scripts/entrypoint.sh /app/scripts/entrypoint.sh

cd /app
python manage.py startapp homepage
python manage.py startapp healthz
sed -i "s/PROJECT=jengo_django_sampleoutput/TEST=${PROJECT}/" /app/Makefile

cd /jengo_django

# MySQL setup
if [ "$DATABASE_TYPE" = "mysql" ]; then
	cat templates/docker-compose.yml templates/docker-compose-part-mysql.yml > /app/docker-compose.yml
fi

# PostgreSQL setup
if [ "$DATABASE_TYPE" = "postgres" ]; then
	cat templates/docker-compose.yml templates/docker-compose-part-postgres.yml > /app/docker-compose.yml
fi

cp templates/env_${DATABASE_TYPE} /app/.env
sed -i 's/SECRET_KEY.*/SECRET_KEY = os.environ.get("SECRET_KEY")/' /app/${PROJECT}/settings.py
scripts/update_settings.py -f /app/${PROJECT}/settings.py
printf "SECRET_KEY=$(openssl rand  -base64 40)\n\n" >> /app/.env
