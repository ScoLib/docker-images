#!/bin/bash

# ensure this script has the correct environment variables, as it may also be called by "docker exec ..."
source /etc/container_environment.sh

if [ $INSTALLED_VERSION != $SEAFILE_VERSION ]; then
	echo "ERROR: Skipping seaf-gc cron job: INSTALLED_VERSION=${INSTALLED_VERSION} does not match SEAFILE_VERSION=${SEAFILE_VERSION} installed in container"
	exit 31
fi

if [ "${DATABASE_TYPE}" != "mysql" ]; then
    echo "Cannot run seaf-gc with [ DATABASE_TYPE != mysql ]"
    exit 1
fi

if [ "${ENABLE_CRON_GC}" == 1 ]; then
	"${SEAFILE_BIN}/seaf-gc.sh" \
		1>/proc/1/fd/1 \
		2>/proc/1/fd/2
fi
