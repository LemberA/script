#!/bin/bash

backdir="/var/lib/percona/backups/monthly" 

find $backdir -type d -mtime +95 -exec rm -rf {} \;

sleep 60

aws s3 sync --delete $backdir s3://BUCKET-NAME/monthly

