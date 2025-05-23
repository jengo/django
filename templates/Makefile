.EXPORT_ALL_VARIABLES:

all: clean depends test

PROJECT=jengo_django_sampleoutput

# Sometimes rebuilds of a project can cause lingering layers which really mess things up
# But not using cache can also slow down development
# You can turn caching back off caching by using COMPOSE_BUILD_OPT="--force-recreate" make
# NOTE: This is the total opposite of the default behavior for jengo django 
COMPOSE_BUILD_OPT?=

# You can change these if you get port conflicts
# Commonly developers have a webserver and db already running locally
MYSQL_PORT?=3306
POSTGRES_PORT?=5432
NGINX_HTTP_PORT?=80:80
NGINX_HTTPS_PORT?=443:443

clean:
# If they aren't found, don't error out
	-docker compose rm -f

include .env
create_admin:
	docker compose exec django python manage.py shell -c \
	 	"from django.contrib.auth import get_user_model; User = get_user_model(); \
		 User.objects.create_superuser('${DJANGO_ADMIN_USER}', 'admin@example.com', '${DJANGO_ADMIN_PASSWORD}')"

depends:
	docker compose up --build -d --remove-orphans

deploy:
# This is where you will add commands to push to your docker registry
	echo "deploy not implemented"

dev:
	docker compose -f docker-compose.yml -f docker-compose-dev.yml up --build -d --remove-orphans ${COMPOSE_BUILD_OPT}
# Connect to the container after rebuild
	make shell

shell:
# Use exec so we are connecting to the exact container running
# Useful for checking things like the contents of /tmp
	docker compose exec django bash

start:
	docker compose start

stop:
	docker compose stop

test:
	echo "not implemented"

