#!/bin/bash

USER="root"
PASSWORD="password"
backdir="/var/lib/percona/backups/daily" 
date=`date "+%Y-%m-%d"`
 
mkdir $backdir/$date

find $backdir -type d -mtime +3 -exec rm -rf {} \;

databases="
pocketbook24_prod_es \
"

for db in $databases; do
        echo "Dumping database: $db"
        mysqldump --allow-keywords --single-transaction --quick --column-statistics=0 --host=10.10.10.30 --user=$USER --password=$PASSWORD --databases $db | bzip2 -fq | openssl enc -aes-256-cbc -k smilePocketbo0k > $backdir/$date/`date +%Y%m%d`.$db.sql.bz2.enc
        done
sleep 60

aws s3 sync --delete $backdir s3://BUCKET-NAME/daily

today=`date +"%d"`

if [[ $today -eq 1 ]]
then
mkdir /var/lib/percona/backups/monthly/$date
cp -R $backdir/$date/* /var/lib/percona/backups/monthly/$date
fi
