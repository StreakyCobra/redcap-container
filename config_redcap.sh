#!/usr/bin/env bash

REDCAP_CONF=/etc/redcap.conf
DATABASE_PHP=/var/www/html/database.php

source ${REDCAP_CONF}

sed -i 's/^\(\$hostname\s*=\).*$/\1 '"'redcap-db';/" ${DATABASE_PHP}
sed -i 's/^\(\$db\s*=\).*$/\1 '"'$MYSQL_DATABASE';/" ${DATABASE_PHP}
sed -i 's/^\(\$username\s*=\).*$/\1 '"'$MYSQL_USER';/" ${DATABASE_PHP}
sed -i 's/^\(\$password\s*=\).*$/\1 '"'$MYSQL_PASSWORD';/" ${DATABASE_PHP}
sed -i 's/^\(\$salt\s*=\).*$/\1 '"'$REDCAP_SALT';/" ${DATABASE_PHP}
