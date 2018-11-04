#!/bin/bash
set -e

cd $SEAFILE_BIN

# only run once post-install
echo "POST_INSTALL_SCRIPTS=${POST_INSTALL_SCRIPTS}"
if [ $POST_INSTALL_SCRIPTS != "1" ]; then
	echo "Pass this script ..."
	exit 0
fi

# safe installed version
echo "SEAFILE_VERSION=${SEAFILE_VERSION}"
echo "${SEAFILE_VERSION}" > "${INSTALLED_VERSION_FILE}"

# configure URLs
echo "FILE_SERVER_ROOT = 'http://${SERVER_IP}/seafhttp'" >> $DATA_DIR/conf/seahub_settings.py
sed -i "s|^SERVICE_URL = .*$|SERVICE_URL = http://${SERVER_IP}|" $DATA_DIR/conf/ccnet.conf

# append settings to existing files
# - enable syslog for seafevents, seafile, seahub
echo "Running post-install: append configuration"

cat /config/seahub_settings.append.py >> $DATA_DIR/conf/seahub_settings.py
cat /config/seafevents.append.conf >> $DATA_DIR/conf/seafevents.conf
cat /config/seafile.append.conf >> $DATA_DIR/conf/seafile.conf
cat /config/seafdav.conf > $DATA_DIR/conf/seafdav.conf
# cat /config/gunicorn.conf > $DATA_DIR/conf/gunicorn.conf