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
rm -fr /app/*
mkdir -p /app/scripts
django-admin startproject ${PROJECT} /app

cd /jengo_django
cp -r templates/Makefile templates/requirements.txt templates/nginx templates/Dockerfile \
	templates/README.md templates/docker-compose-dev.yml templates/Jenkinsfile /app

cp templates/dockerignore /app/.dockerignore
cp templates/gitignore /app/.gitignore
cp scripts/wait-for-it.sh /app/scripts/wait-for-it.sh
cp scripts/entrypoint.sh /app/scripts/entrypoint.sh
cp scripts/run*.sh /app/scripts/

cd /app
python manage.py startapp welcome
python manage.py startapp healthz
sed -i "s/PROJECT=jengo_django_sampleoutput/TEST=${PROJECT}/" /app/Makefile
sed -i "s/jengo_django_sampleoutput.wsgi/${PROJECT}.wsgi/" /app/scripts/run-copy-assets.sh
sed -i "s/jengo_django_sampleoutput.wsgi/${PROJECT}.wsgi/" /app/scripts/run-no-copy-assets.sh

cd /jengo_django

cp templates/healthz/views.py templates/healthz/urls.py /app/healthz/
cp templates/welcome/views.py templates/welcome/urls.py /app/welcome/

# MySQL setup
if [ "$DATABASE_TYPE" = "mysql" ]; then
	cat templates/docker-compose.yml templates/docker-compose-part-mysql.yml > /app/docker-compose.yml
fi

# PostgreSQL setup
if [ "$DATABASE_TYPE" = "postgres" ]; then
	cat templates/docker-compose.yml templates/docker-compose-part-postgres.yml > /app/docker-compose.yml
fi

cp templates/env_${DATABASE_TYPE} /app/.env
printf "\nSTATIC_ROOT=\"/static\"\n" >> /app/${PROJECT}/settings.py
sed -i 's/SECRET_KEY.*/SECRET_KEY = os.environ.get("SECRET_KEY")/' /app/${PROJECT}/settings.py
printf "\nCSRF_TRUSTED_ORIGINS = os.environ.get(\"CSRF_TRUSTED_ORIGINS\").split(',')\n" >> /app/${PROJECT}/settings.py

# Add route for healthz
sed -i "s/]/    path\('healthz', include('healthz.urls')),\n    path\('', include('welcome.urls')), \n]/" /app/${PROJECT}/urls.py
sed -i 's/from django.urls import path/from django.urls import path,include/' /app/${PROJECT}/urls.py
scripts/update_settings.py -f /app/${PROJECT}/settings.py
printf "SECRET_KEY=$(openssl rand  -base64 40)\n\n" >> /app/.env
printf "CSRF_TRUSTED_ORIGINS=https://localhost,http://localhost\n\n" >> /app/.env

# Add version of jengo/django to the build
# Maybe some day this will allow scripted upgrades
echo "JENGO_DJANGO_VERSION=\"$( cat VERSION )\"" >> /app/${PROJECT}/__init__.py
echo "JENGO_DJANGO_DATABASE_TYPE=\"${DATABASE_TYPE}\"" >> /app/${PROJECT}/__init__.py

sed -i "s/'django.contrib.staticfiles',/'django.contrib.staticfiles',\n    'django_grpc_framework',/" /app/${PROJECT}/settings.py
