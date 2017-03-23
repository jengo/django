#!/bin/bash

# This is run inside the container, don't run from your host
# I may move this into the Dockerfile haven't decided yet

mkdir /tmp/build
django-admin startproject ${PROJECT} /tmp/build
cd /tmp/build

python manage.py startapp homepage

