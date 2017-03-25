# Notes on how this will work:
# - Directory named templates will contain all template files, including Makefile which will be used later
# - jengo_django has a Makefile which is only about creating the project.  The Makefile in the templates directory is for the project it self
# - Create directory in build/$PROJECT
# - Build container with volume linked to build/$PROJECT and templates directory. That container will be used to setup all the required files.
# - Once build is complete, temp build container is destoryed and new project is brought up in dev mode.

PROJECT ?= "jengo_django"
DATABASE_TYPE ?= "mysql"
# Set this value if you want to push the sample code to an origin
# Jolene will be using this to test CI for the boilerplate output
SAMPLE_ORIGIN ?= "git@github.com:jengo/django-sampleoutput.git"

# Sometimes rebuilds of a project can cause lingering layers which really mess things up
# But not using cache can also slow down development
# You can turn caching back on by using COMPOSE_BUILD_OPT= make
COMPOSE_BUILD_OPT ?= "--force-recreate"

all: clean depends test

clean:
# If they aren't found, don't error out
	-docker-compose rm -f
# TODO! Throw an error if the build has already been created.  This will help prevent accidents
	rm -fr build

depends:
	mkdir -p build
	PROJECT=${PROJECT} DATABASE_TYPE=${DATABASE_TYPE} docker-compose up --build -d --remove-orphans ${COMPOSE_BUILD_OPT}
	docker-compose exec buildtmp sh -c 'cp -r /tmp/build/* /usr/src/app'
	docker-compose exec buildtmp sh -c 'cp /tmp/build/.env /usr/src/app'
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
	PROJECT=jengo_django_sampleoutput DATABASE_TYPE=${DATABASE_TYPE} SAMPLE_ORIGIN=${SAMPLE_ORIGIN} make
# Using a force push, no reason to deal with conflicts it's just a sample and for testing CI
	cd build && git remote add origin ${SAMPLE_ORIGIN} && git push origin master -f


shell:
# Use exec so we are connecting to the exact container running
# Useful for checking things like the contents of /tmp
	docker-compose exec buildtmp bash

test:
	echo "not implemented"

