.EXPORT_ALL_VARIABLES:

# Notes on how this will work:
# - Directory named templates will contain all template files, including Makefile which will be used later
# - jengo_django has a Makefile which is only about creating the project.  The Makefile in the templates directory is for the project it self
# - Create directory in build/$PROJECT
# - Build container with volume linked to build/$PROJECT and templates directory. That container will be used to setup all the required files.
# - Once build is complete, temp build container is destoryed and new project is brought up in dev mode.

PROJECT?=jengo_django_sampleoutput
DATABASE_TYPE?=mysql
# Set this value if you want to push the sample code to an origin
# Jolene will be using this to test CI for the boilerplate output
SAMPLE_ORIGIN?=git@github.com:jengo/django-sampleoutput.git

# Sometimes rebuilds of a project can cause lingering layers which really mess things up
# But not using cache can also slow down development
# You can turn caching back on by using COMPOSE_BUILD_OPT= make
COMPOSE_BUILD_OPT?=--force-recreate

all: clean depends test

clean:
# If they aren't found, don't error out
	-docker-compose stop
	-docker-compose rm -f
# If there was a previous build, stop those containers as well
	-cd build && docker-compose stop
	-cd build && docker-compose rm -f

depends:
	mkdir -p build
	docker-compose up --build -d --remove-orphans ${COMPOSE_BUILD_OPT}
	docker-compose exec buildtmp sh -c 'scripts/create.sh'
	# docker-compose stop
	cd build && make

# TODO! REMOVE
depends_org:
	mkdir -p build
	docker-compose up --build -d --remove-orphans ${COMPOSE_BUILD_OPT}
	docker-compose exec buildtmp sh -c 'cp -r /tmp/build/* /app'
	# docker-compose exec buildtmp sh -c 'cp /tmp/build/.env /app'
	# docker-compose exec buildtmp sh -c 'cp /tmp/build/.dockerignore /app'
	# cp templates/env_${DATABASE_TYPE} build/.env
# Name is different because it should NOT be used for the repo it self
# It's only a template
	cp templates/gitignore build/.gitignore
# Don't do this inside the container because we want the commit to come from the user who created it
# The host -should- have git properly setup
	cd build && git init && git add * && git add .gitignore && git add .env && git commit -m 'initial import from jengo django'
# Now build the newly created project
	cd build && make
# Clean up the temp build container
	-docker-compose stop
	-docker-compose rm -f

sample:
# Generate the sample output application that will appear at https://github.com/jengo/django-sampleoutput
	make
# Using a force push, no reason to deal with conflicts it's just a sample and for testing CI
	cd build && git remote add origin ${SAMPLE_ORIGIN} && git push origin master -f


shell:
# Use exec so we are connecting to the exact container running
# Useful for checking things like the contents of /tmp
	docker-compose exec buildtmp bash

test:
	scripts/test.sh

# This will be used by CI to update the example repo
# Replace the initialized .git with django-sampleoutput/.git
update_sample_repo:
	rm -fr /tmp/django-sampleoutput/
	cd /tmp && git clone git@github.com:jengo/django-sampleoutput.git
	rm -fr build/.git
	mv /tmp/django-sampleoutput/.git build
# TODO: Once I add a version number, set it in the message
# TODO: In CI, use the same branch name
	cd build && git add -A \
		&& git commit -m '[updated] To newest version' \
		&& git push
