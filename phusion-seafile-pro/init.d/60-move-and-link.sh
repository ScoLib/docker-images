#!/bin/bash
set -e

# WARNING: this has to run AFTER setup scripts to allow it to move newly created configurations into to volume

# move from SEAFILE_HOME to DATA_DIR
for TARGET_DIR in "ccnet" "conf" "seafile-data" "seahub-data" "pro-data"
do
	if [ -e "${SEAFILE_HOME}/${TARGET_DIR}" -a ! -L "${DATA_DIR}/${TARGET_DIR}" ]
	then
		echo "moving: ${SEAFILE_HOME}/${TARGET_DIR} -> ${DATA_DIR}/${TARGET_DIR}"
		mv ${SEAFILE_HOME}/${TARGET_DIR} ${DATA_DIR}
	fi
done

# sqlite3 data
if [ -e "${SEAFILE_HOME}/seahub.db" -a ! -L "${SEAFILE_HOME}/seahub.db" ]
then
	echo "moving: ${SEAFILE_HOME}/seahub.db -> ${DATA_DIR}/seahub.db"
	mv ${SEAFILE_HOME}/seahub.db ${DATA_DIR}/
fi


# symlink from DATA_DIR to SEAFILE_HOME
for TARGET_DIR in "ccnet" "conf" "seafile-data" "seahub-data" "pro-data"
do
	if [ -e "${DATA_DIR}/${TARGET_DIR}" ]
	then
		echo "linking: ${SEAFILE_HOME}/${TARGET_DIR} -> ${DATA_DIR}/${TARGET_DIR}"
		ln -sf ${DATA_DIR}/${TARGET_DIR} ${SEAFILE_HOME}/${TARGET_DIR}
		# chown -h seafile:seafile ${SEAFILE_HOME}/${TARGET_DIR}
	fi
done

# sqlite3 data
if [ -e "${DATA_DIR}/seahub.db" -a ! -L "${DATA_DIR}/seahub.db" ]
then
	echo "linking: ${SEAFILE_HOME}/seahub.db -> ${DATA_DIR}/seahub.db"
	ln -fs ${DATA_DIR}/seahub.db ${SEAFILE_HOME}/seahub.db
	# chown -h seafile:seafile ${SEAFILE_HOME}/seahub.db
fi
