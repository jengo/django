# Notes on how this will work:
# - Directory named templates will contain all template files, including Makefile which will be used later
# - jengo_django has a Makefile which is only about creating the project.  The Makefile in the templates directory is for the project it self
# - Create directory in build/$PROJECT
# - Build container with volume linked to build/$PROJECT and templates directory. That container will be used to setup all the required files.
# - Once build is complete, temp build container is destoryed and new project is brought up in dev mode.

PROJECT ?= "jengo_django"
DATABASE_TYPE ?= "mysql"

all: clean depends test

clean:
# If they aren't found, don't error out
	-docker-compose rm -f
# TODO! Throw an error if the build has already been created.  This will help prevent accidents
	rm -fr build

depends:
	mkdir -p build
	PROJECT=${PROJECT} DATABASE_TYPE=${DATABASE_TYPE} docker-compose up --build -d --remove-orphans 
	docker-compose exec buildtmp sh -c 'cp -r /tmp/build/* /usr/src/app'
# Don't do this inside the container because we want the commit to come from the user who created it
# The host -should- have git properly setup
	cd build && git init && git add * && git commit -m 'initial import from jengo django'
# Now build the newly created project
	cd build && make
# Clean up the temp build container
	-docker-compose stop
	-docker-compose rm -f

shell:
# Use exec so we are connecting to the exact container running
# Useful for checking things like the contents of /tmp
	docker-compose exec buildtmp bash

test:
	echo "not implemented"

