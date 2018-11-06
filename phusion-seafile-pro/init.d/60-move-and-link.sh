#!/bin/bash
set -e

# WARNING: this has to run AFTER setup scripts to allow it to move newly created configurations into to volume

# move from SEAFILE_HOME to DATA_DIR 
# "seahub.db" is sqlite3 data
for TARGET_DIR in "ccnet" "conf" "seafile-data" "seahub-data" "pro-data" "seahub.db"
do
	if [ -e "${SEAFILE_HOME}/${TARGET_DIR}" -a ! -L "${SEAFILE_HOME}/${TARGET_DIR}" ]
	then
		echo "moving: ${SEAFILE_HOME}/${TARGET_DIR} -> ${DATA_DIR}/${TARGET_DIR}"
		mv ${SEAFILE_HOME}/${TARGET_DIR} ${DATA_DIR}
	else
		echo "${SEAFILE_HOME}/${TARGET_DIR} has moved"
	fi

	# symlink from DATA_DIR to SEAFILE_HOME
	if [ -e "${DATA_DIR}/${TARGET_DIR}" -a ! -L "${SEAFILE_HOME}/${TARGET_DIR}" ]
	then
		echo "linking: ${SEAFILE_HOME}/${TARGET_DIR} -> ${DATA_DIR}/${TARGET_DIR}"
		ln -sf ${DATA_DIR}/${TARGET_DIR} ${SEAFILE_HOME}/${TARGET_DIR}
		# chown -h seafile:seafile ${SEAFILE_HOME}/${TARGET_DIR}
	else
		echo "${SEAFILE_HOME}/${TARGET_DIR} has been linked"
	fi
done
