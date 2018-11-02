
#!/bin/bash
set -e

cd $SEAFILE_BIN

# only run once post-install
if [ $POST_INSTALL_SCRIPTS != "1" ]; then
	exit 0
fi

# safe installed version
echo "${SEAFILE_VERSION}" > "${INSTALLED_VERSION_FILE}"
