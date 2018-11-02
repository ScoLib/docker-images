#!/bin/bash
set -e


# container debug
CONTAINER_DEBUG="${CONTAINER_DEBUG:-0}"
echo $CONTAINER_DEBUG > /etc/container_environment/CONTAINER_DEBUG

# seafile binary dir
SEAFILE_BIN="${SEAFILE_HOME}/seafile-pro-server-${SEAFILE_VERSION}"
echo $SEAFILE_BIN > /etc/container_environment/SEAFILE_BIN

# data dir
DATA_DIR="/data"
echo $DATA_DIR > /etc/container_environment/DATA_DIR

# set SEAFILE_DIR, it used by seafile to store data
SEAFILE_DIR=$SEAFILE_HOME/seafile-data
echo $SEAFILE_DIR > /etc/container_environment/SEAFILE_DIR

# install version file
INSTALLED_VERSION_FILE="${DATA_DIR}/version"
echo $INSTALLED_VERSION_FILE > /etc/container_environment/INSTALLED_VERSION_FILE

# installed version
if [ -f $INSTALLED_VERSION_FILE ]
then
	INSTALLED_VERSION=$(cat $INSTALLED_VERSION_FILE)
	echo $INSTALLED_VERSION > /etc/container_environment/INSTALLED_VERSION
else
	echo "NONE" > /etc/container_environment/INSTALLED_VERSION
fi

# control flag for post-installation scripts
POST_INSTALL_SCRIPTS=0
echo $POST_INSTALL_SCRIPTS > /etc/container_environment/POST_INSTALL_SCRIPTS

# cron enable
ENABLE_CRON_GC="${ENABLE_CRON_GC:-0}"
echo $ENABLE_CRON_GC > /etc/container_environment/ENABLE_CRON_GC

# user id
#SEAFILE_UID="${SEAFILE_UID:-1000}"
#echo $SEAFILE_UID > /etc/container_environment/SEAFILE_UID

# group id
#SEAFILE_GID="${SEAFILE_GID:-1000}"
#echo $SEAFILE_GID > /etc/container_environment/SEAFILE_GID


# various
# echo "${SETUP_MODE:-auto}" > /etc/container_environment/SETUP_MODE
# echo "${NGINX_LISTEN_PORT:-80}" > /etc/container_environment/NGINX_LISTEN_PORT

# database
DATABASE_TYPE="${DATABASE_TYPE:-sqlite}"
echo $DATABASE_TYPE > /etc/container_environment/DATABASE_TYPE

if [ $DATABASE_TYPE == "mysql" ]; then
	echo "${MYSQL_USER_HOST:-%}" > /etc/container_environment/MYSQL_USER_HOST
	echo "${MYSQL_USER:-seafile}" > /etc/container_environment/MYSQL_USER
	echo "${MYSQL_PORT:-3306}" > /etc/container_environment/MYSQL_PORT

	# support db prefix
	DB_PREFIX="${DB_PREFIX:-seafile_}"
	echo $DB_PREFIX > /etc/container_environment/DB_PREFIX
	echo "${DB_PREFIX}${CCNET_DB:-ccnet}" > /etc/container_environment/CCNET_DB
	echo "${DB_PREFIX}${SEAFILE_DB:-seafile}" > /etc/container_environment/SEAFILE_DB
	echo "${DB_PREFIX}${SEAHUB_DB:-seahub}" > /etc/container_environment/SEAHUB_DB

	# require MYSQL_ROOT_PASSWD
	[ -z "$MYSQL_ROOT_PASSWD" ] && echo "Variable MYSQL_ROOT_PASSWD is required" && exit 1;
	echo ${MYSQL_ROOT_PASSWD} > /etc/container_environment/MYSQL_ROOT_PASSWD

	# require MYSQL_HOST
	[ -z "$MYSQL_HOST" ] && echo "Variable MYSQL_HOST is required" && exit 1;
	echo ${MYSQL_HOST} > /etc/container_environment/MYSQL_HOST

	# require MYSQL_USER_PASSWD
	[ -z "$MYSQL_USER_PASSWD" ] && echo "Variable MYSQL_USER_PASSWD is required" && exit 1;
	echo ${MYSQL_USER_PASSWD} > /etc/container_environment/MYSQL_USER_PASSWD

	# # require MYSQL_ROOT_PASSWD
	# [ -z "$MYSQL_ROOT_PASSWD" ] && echo "Variable MYSQL_ROOT_PASSWD is required" && exit 1;
	# echo ${MYSQL_ROOT_PASSWD} > /etc/container_environment/MYSQL_ROOT_PASSWD
fi



# require SERVER_NAME as the default would be the container id which is not very useful
[ -z "$SERVER_NAME" ] && echo "Variable SERVER_NAME is required" && exit 1;
echo ${SERVER_NAME} > /etc/container_environment/SERVER_NAME

# require SERVER_IP as the default ip would most likely not work
[ -z "$SERVER_IP" ] && echo "Variable SERVER_IP is required" && exit 1;
echo ${SERVER_IP} > /etc/container_environment/SERVER_IP


# require SEAFILE_ADMIN_MAIL
[ -z "$SEAFILE_ADMIN_MAIL" ] && echo "Variable SEAFILE_ADMIN_MAIL is required" && exit 1;
echo ${SEAFILE_ADMIN_MAIL} > /etc/container_environment/SEAFILE_ADMIN_MAIL

# require SEAFILE_ADMIN_PASS
[ -z "$SEAFILE_ADMIN_PASS" ] && echo "Variable SEAFILE_ADMIN_PASS is required" && exit 1;
echo ${SEAFILE_ADMIN_PASS} > /etc/container_environment/SEAFILE_ADMIN_PASS
