all: clean depends test

clean:
# If they aren't found, don't error out
	-docker-compose rm -f

depends:
	docker-compose up --build -d --remove-orphans

dev:
	docker-compose -f docker-compose.yml -f docker-compose-dev.yml up --build -d --remove-orphans
# Connect to the container after rebuild
	make shell

run:
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

