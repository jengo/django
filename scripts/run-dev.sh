#!/bin/bash
set -x

# This mode should not be used in prod, this is only during development that will reload the server
# when changes to the files are made

python manage.py runserver 0.0.0.0:8000
