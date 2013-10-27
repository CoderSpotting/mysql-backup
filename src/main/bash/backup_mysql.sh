

#!/bin/bash

# Update the value of these variables to reflect your local environment
BACKUPFOLDER="/folder/where/backups/should/be"
DEFAULTSFILE="/folder/where/config/file/is/located/mysql.conf"

# If you have MySQL installed somewhere else, change these values
# These are the values for a stock install on OS X
MYSQL="/usr/local/mysql/bin/mysql"
MYSQLDUMP="/usr/local/mysql/bin/mysqldump"

NOWDATE=$(date +"%Y%m%d-%H%M")

function backup_mysql
{
        CURRENT_HOST=$1

        echo Host: $CURRENT_HOST

        for DB in $(echo "show databases;" | $MYSQL --defaults-file=$DEFAULTSFILE -h ${CURRENT_HOST} -u root)
        do
                if [ $DB != 'Database' ] && [ $DB != 'information_schema' ] && [ $DB != 'performance_schema' ]
                then
                        echo Database: $DB on $CURRENT_HOST
                        $MYSQLDUMP --defaults-file=$DEFAULTSFILE -h ${CURRENT_HOST} -t -u root $DB | bzip2 > ${BACKUPFOLDER}/mysql-${CURRENT_HOST}-$DB-data-$NOWDATE.sql.bz2
                        $MYSQLDUMP --defaults-file=$DEFAULTSFILE -h ${CURRENT_HOST} -d -u root $DB | bzip2 > ${BACKUPFOLDER}/mysql-${CURRENT_HOST}-$DB-ddl-$NOWDATE.sql.bz2
                fi
        done
}

# Add a line for each hostname running a MySQL
backup_mysql "localhost"