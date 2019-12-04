#!/bin/bash
set -x

# This startup will gather / copy django admin assets to a shared volume
# that will exist in the same pod.  Use this method if you aren't using a CDN

python manage.py collectstatic --no-input

# If the DB host is not ready, migrate will fail

# When deploying more than 1 pod, you will want to orchestrate running migrations as a job only once
if [ -z "${NO_MIGRATIONS}" ]; then
	scripts/wait-for-it.sh -h ${DB_HOST} -p ${DB_PORT}
	yes "yes" | python manage.py migrate
fi

# NOTE: You will need to modify the number of workers for your environment
gunicorn jengo_django_sampleoutput.wsgi -b 0.0.0.0 -w 4
