FROM python:3.6

WORKDIR /usr/src/app

ADD requirements.txt /usr/src/app

RUN pip install --upgrade pip \
	&& pip install --no-cache-dir -r /usr/src/app/requirements.txt

# Only add what is needed
ADD templates /usr/src/templates

# Leaving this lower in the layers for CI, don't install the packages again
# CI will build both PostgreSQL and MySQL
ARG PROJECT
ARG DATABASE_TYPE

ENV PROJECT ${PROJECT}
ENV DATABASE_TYPE ${DATABASE_TYPE}

RUN mkdir /tmp/build \
	&& django-admin startproject ${PROJECT} /tmp/build 

ADD templates/Makefile /tmp/build/Makefile
ADD templates/requirements.txt /tmp/build/requirements.txt
ADD templates/nginx /tmp/build/nginx
ADD templates/Dockerfile /tmp/build/Dockerfile
ADD templates/docker-compose-dev.yml /tmp/build/docker-compose-dev.yml

# If you set the destination directory manage.py complain that it doesn't exist
# If you create the destination directory manage.py complains it's a duplicate
# *eye roll*
WORKDIR /tmp/build
RUN python manage.py startapp homepage
# 	&& printf "PROJECT = $PROJECT\n\n" > Makefile \
# 	&& cat /usr/src/templates/Makefile >> Makefile

# MySQL setup
RUN if [ "$DATABASE_TYPE" = "mysql" ]; then cat /usr/src/templates/docker-compose.yml /usr/src/templates/docker-compose-part-mysql.yml > /tmp/build/docker-compose.yml; fi

# PostgreSQL setup
RUN if [ "$DATABASE_TYPE" = "postgres" ]; then cat /usr/src/templates/docker-compose.yml /usr/src/templates/docker-compose-part-postgres.yml > /tmp/build/docker-compose.yml; fi


CMD ["bash"]
