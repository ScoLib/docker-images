# Seafile Pro Image

## Use

```sh
docker run \
	-ti \
	-v /docker-data/seafile:/data \
	-e SERVER_NAME=TESTSERVER \
	-e SERVER_IP=localhost.localdomain \
	-e SEAFILE_ADMIN_MAIL=admin@example.com \
	-e SEAFILE_ADMIN_PASS=123456 \
	-p 8000:8000 \
	-p 8082:8082 \
	scolib/seafile-pro:<tag>
```



## Environment Variables

| Variable               | Default | Description                                                  |
| ---------------------- | ------- | ------------------------------------------------------------ |
| DATABASE_TYPE          | sqlite  | Which database to use, supported options: "sqlite", "mysql". Note: MySQL requires additional MYSQL_* variables |
| **SERVER_NAME**        | none    | The name of the seafile server                               |
| **SERVER_IP**          | none    | The address which user use to reach the seafile server       |
| ENABLE_CRON_GC         | 0       | If garbage collect cron should run, set to "1" to enable, requires MySQL as database |
| **SEAFILE_ADMIN_MAIL** | none    | The initial seafile admin e-mail address                     |
| **SEAFILE_ADMIN_PASS** | none    | The initial seafile admin password, password is not updated after initial setup |

__Bold variables are required__



## Setup with MySQL and Database Environment Variables
This container supports non-interactive setup via environment variables.
See <https://manual.seafile.com/deploy/using_mysql.html#setup-in-non-interactive-way> for reference.

| Variable              | Default  | Description                                                                                                                              |
| ---                   | ---      | ---                                                                                                                                      |
| DATABASE_TYPE         | sqlite   | Which database to use, supported options: "sqlite", "mysql". Note: MySQL requires additional MYSQL_* variables                           |
| **MYSQL_HOST**        | none     | MySQL database hostname to connect to                                                                                                    |
| MYSQL_PORT            | 3306     | MySQL database port                                                                                                                      |
| **MYSQL_ROOT_PASSWD** | none     | The name of the seafile server                                                                                                           |
| MYSQL_USER            | seafile  | The user to create for seafile                                                                                                           |
| **MYSQL_USER_PASSWD** | none     | MySQL password to user for the seafile user                                                                                              |
| MYSQL_USER_HOST       | %        | MySQL user host (access control) for the seafile user, defaults to any host                                                              |
| DB_PREFIX             | seafile_ | Database tables are prefixed with a unique identifier that groups them and allows multiple seafile installations with the same database. |
| CCNET_DB              | ccnet    | The database name to use for CCNET                                                                                                       |
| SEAFILE_DB            | seafile  | The database name to use for SEAFILE                                                                                                     |
| SEAHUB_DB             | seahub   | The database name to use for SEAHUB                                                                                                      |

###  Example run configuration for MySQL:

```
docker run \
	-ti \
	-v /docker-data/seafile:/data \
	-e SERVER_NAME=TESTSERVER \
	-e SERVER_IP=localhost.localdomain \
	-e SEAFILE_ADMIN_MAIL=admin@example.com \
	-e SEAFILE_ADMIN_PASS=123456 \
	-e DATABASE_TYPE=mysql \
	-e MYSQL_HOST=mysql.localdomain \
	-e MYSQL_ROOT_PASSWD=SomeRootPass \
	-e MYSQL_USER_PASSWD=SomeSeafileDbUserPass \
	-p 8000:8000 \
	-p 8082:8082 \
	scolib/seafile-pro:<tag>
```



## Thanks

https://gitlab.com/dhswt/docker/seafile.git

https://github.com/simplificuk/docker-seafile-pro.git

