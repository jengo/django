#!/bin/bash

# This file is intended to be run from the host, macOS or Linux

# TODO: Run tests against the output in build/
# Examples:
# - Containers running
# - HTTP running and accessible 
# - HTTPS accessible 
# - healthz responding
# - DB accessible and using .env credentials
# - Not using SQLite
# - Migrations are working
# - Migrations with etcd

FAILED=0

# Silly workaround to let the containers finish loading
sleep 5

cd build
expected_containers=( django db nginx adminer )

# Verify all expected containers are running
for container in "${expected_containers[@]}"
do
	echo "Verifying container: $container is running"
	docker-compose ps $container

	if test $? -ne 0; then
		((FAILED++))
	fi
done

# Verify connections
# HTTP
statuscode=$( curl --silent --output /dev/null --write-out "%{http_code}" --max-time 1 http://localhost/ )
if test $statuscode -ne 301; then
	echo "Incorrect status code for HTTP path=/, expected 301 got $statuscode"

	((FAILED++))
fi

# HTTPS - /
statuscode=$( curl -k --silent --output /dev/null --write-out "%{http_code}" --max-time 1 https://localhost/ )
if test $statuscode -ne 200; then
	echo "Incorrect status code for HTTPS path=/, expected 200 got $statuscode"

	((FAILED++))
fi

# HTTPS - /healthz
statuscode=$( curl -k --silent --output /dev/null --write-out "%{http_code}" --max-time 1 https://localhost/healthz )
if test $statuscode -ne 200; then
	echo "Incorrect status code for HTTPS path=/healthz, expected 200 got $statuscode"

	((FAILED++))
fi

# HTTPS - /static/admin/css/base.css
# Verify the django admin CSS is operating as expected
statuscode=$( curl -k --silent --output /dev/null --write-out "%{http_code}" --max-time 1 https://localhost/static/admin/css/base.css )
if test $statuscode -ne 200; then
	echo "Incorrect status code for HTTPS path=/static/admin/css/base.css, expected 200 got $statuscode"

	((FAILED++))
fi

printf "\n\n$FAILED tests failed\n"

if test $FAILED -ne 0; then
	exit -1
fi
