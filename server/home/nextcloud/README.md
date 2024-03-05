# Usage

Change the following environment variables in `deployment.yaml` to strong values:

* mariadb container
	* `MYSQL_PASSWORD`
	* `MYSQL_ROOT_PASSWORD`
* nextcloud container
	* `MYSQL_PASSWORD` (must match mariadb container `MYSQL_PASSWORD` value)

Be sure to record these values in a secure password manager to avoid losing the
values when updates are copied to this directory.

Install the server.

	./setup/nextcloud/install.sh

Start the server.

	./setup/nextcloud/start.sh
