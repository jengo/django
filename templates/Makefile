.EXPORT_ALL_VARIABLES:

all: clean depends test

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
	-docker-compose rm -f

depends:
	docker-compose up --build -d --remove-orphans

deploy:
# This is where you will add commands to push to your docker registry
	echo "deploy not implemented"

dev:
	docker-compose -f docker-compose.yml -f docker-compose-dev.yml up --build -d --remove-orphans ${COMPOSE_BUILD_OPT}
# Connect to the container after rebuild
	make shell

run:
# If the DB host is not ready, migrate will fail
# TODO: make run needs to be replaced with a proper entrypoint.sh
	scripts/wait-for-it.sh -h ${DB_HOST} -p ${DB_PORT}
	yes "yes" | python manage.py migrate
	python manage.py runserver 0.0.0.0:8000

shell:
# Use exec so we are connecting to the exact container running
# Useful for checking things like the contents of /tmp
	docker-compose exec django bash

start:
	echo "not implemented"

stop:
	echo "not implemented"

test:
	echo "not implemented"

