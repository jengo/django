#!/bin/bash
set -x

# This startup script will not gather / copy django admin assets to a shared volume
# If you are going to use a CDN during your build process, you will want to
# set your CMD to this script

# NOTE: You will need to modify the number of workers for your environment
gunicorn jengo_django_sampleoutput.wsgi -b 0.0.0.0 -w 4
