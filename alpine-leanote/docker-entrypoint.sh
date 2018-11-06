#!/bin/sh

set -euo pipefail

INSTALLED_VERSION_FILE="${LEANOTE_HOME}/version"
INSTALLED_VERSION="NONE"

# installed version
if [ -f $INSTALLED_VERSION_FILE ]
then
	INSTALLED_VERSION=$(cat $INSTALLED_VERSION_FILE)
else
	echo "NONE" > $INSTALLED_VERSION_FILE
fi


if [ $INSTALLED_VERSION != "NONE" ]; then
	echo "leanote is installed ..."
    exec "$@"
	exit 0
fi

if [ ! -e "${LEANOTE_HOME}/files" ]; then
	echo "mkdir ${LEANOTE_HOME}/files ..."
	mkdir -p ${LEANOTE_HOME}/files
fi

# move from LEANOTE_HOME to LEANOTE_DATA_DIR 
for TARGET_DIR in "conf" "files" "mongodb_backup"
do
	if [ -e "${LEANOTE_HOME}/${TARGET_DIR}" -a ! -L "${LEANOTE_HOME}/${TARGET_DIR}" ]
	then
		if [ ! -e "${LEANOTE_DATA_DIR}/${TARGET_DIR}" ]
		then 
			echo "moving: ${LEANOTE_HOME}/${TARGET_DIR} -> ${LEANOTE_DATA_DIR}/${TARGET_DIR}"
			mv ${LEANOTE_HOME}/${TARGET_DIR} ${LEANOTE_DATA_DIR}
		else
			echo "${LEANOTE_DATA_DIR}/${TARGET_DIR} already exists"
		fi
	else
		echo "${LEANOTE_HOME}/${TARGET_DIR} has moved"
	fi

    # symlink from LEANOTE_DATA_DIR to LEANOTE_HOME
	if [ -e "${LEANOTE_DATA_DIR}/${TARGET_DIR}" -a ! -L "${LEANOTE_HOME}/${TARGET_DIR}" ]
	then
		echo "linking: ${LEANOTE_HOME}/${TARGET_DIR} -> ${LEANOTE_DATA_DIR}/${TARGET_DIR}"
		ln -sf ${LEANOTE_DATA_DIR}/${TARGET_DIR} ${LEANOTE_HOME}/${TARGET_DIR}
	else
		echo "${LEANOTE_HOME}/${TARGET_DIR} has been linked"
	fi
done

if [ -e "${LEANOTE_HOME}/public/upload" -a ! -L "${LEANOTE_HOME}/public/upload" ]
then
		echo "moving: ${LEANOTE_HOME}/public/upload -> ${LEANOTE_DATA_DIR}/upload"
		mv ${LEANOTE_HOME}/public/upload ${LEANOTE_DATA_DIR}/upload
else
		echo "${LEANOTE_HOME}/public/upload has moved"
fi

if [ -e "${LEANOTE_DATA_DIR}/upload" -a ! -L "${LEANOTE_HOME}/public/upload" ]
then
		echo "linking: ${LEANOTE_HOME}/public/upload -> ${LEANOTE_DATA_DIR}/upload"
		ln -sf ${LEANOTE_DATA_DIR}/upload ${LEANOTE_HOME}/public/upload
else
		echo "${LEANOTE_HOME}/public/upload has been linked"
fi

# set conf
echo "replace app.conf parameters"
sed -i "s|^site.url=.*$|site.url=${LEANOTE_SITE_URL}|" ${LEANOTE_DATA_DIR}/conf/app.conf
sed -i "s|^db.host=.*$|db.host=${LEANOTE_MONGO_HOST}|" ${LEANOTE_DATA_DIR}/conf/app.conf
sed -i "s|^db.port=.*$|db.port=${LEANOTE_MONGO_PORT}|" ${LEANOTE_DATA_DIR}/conf/app.conf
sed -i "s|^db.dbname=.*$|db.dbname=${LEANOTE_MONGO_DATABASE}|" ${LEANOTE_DATA_DIR}/conf/app.conf

# create mongo data
echo "restore mongo data"
/usr/bin/mongorestore -h $LEANOTE_MONGO_HOST -d $LEANOTE_MONGO_DATABASE --dir ${LEANOTE_DATA_DIR}/mongodb_backup/leanote_install_data/


# echo
# # ls /docker-entrypoint-initdb.d/ > /dev/null
# for f in /docker-entrypoint-initdb.d/*; do
#     case "$f" in
#         *.sh) echo "$0: running $f"; . "$f" ;;
#         *)    echo "$0: ignoring $f" ;;
#     esac
#     echo
# done

# leanote installed version
echo "LEANOTE_VERSION=${LEANOTE_VERSION}"
echo "${LEANOTE_VERSION}" > $INSTALLED_VERSION_FILE

exec "$@"