#!/bin/bash
set -x

# This startup will gather / copy django admin assets to a shared volume
# that will exist in the same pod.  Use this method if you aren't using a CDN

python manage.py collectstatic --no-input

# NOTE: You will need to modify the number of workers for your environment
gunicorn jengo_django_sampleoutput.wsgi -b 0.0.0.0 -w 4
