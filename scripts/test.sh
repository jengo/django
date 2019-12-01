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
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`

# Silly workaround to let the containers finish loading
sleep 5

cd build
expected_containers=( django db nginx adminer )

https_check()
{
	path=$1
	statuscode=$( curl -k --silent --output /dev/null --write-out "%{http_code}" --max-time 3 --retry 3 --retry-delay 2 --retry-max-time 30 https://localhost${path} )
	if test $statuscode -ne 200; then
		echo "Incorrect status code for HTTPS path=${path}, expected 200 got $statuscode"

		((FAILED++))
	fi
}

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

https_check "/"
https_check "/healthz"
# Verify the django admin CSS is operating as expected
https_check "/static/admin/css/base.css"


if test $FAILED -ne 0; then
	printf "${RED}\n\n⛔️ Total tests failed: $FAILED!\n${RESET}"
	exit -1
else
	printf "${GREEN}\n\n🎉 All tests successful!\n${RESET}"
fi
