#!/bin/sh
#copy current snapshot then compress it then delete all arhives older 2 days( stay 3 last snapshot)
 cd /var/lib/elasticsearch/backups

aws s3 cp --recursive  s3://bucketname-snapshot-$(date +%F) /var/lib/elasticsearch/currentbackup && tar cfvz bucketname-snapshot-$(date +%F).tar.gz /var/lib/elasticsearch/currentbackup && find /var/lib/elasticsearch/backups/es8-snapshot* -mtime +3 -delete

sleep 120
#clear transit data 
rm -r /var/lib/elasticsearch/currentbackup/*
sleep 120
# syncronazi aws directory and local 
aws s3 sync --delete /var/lib/elasticsearch/backups s3://BUCKET-NAME/ && aws s3 rb s3://bucketname-snapshot-$(date +%F) --force

