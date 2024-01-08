#!/bin/sh

 # create aws bucket

aws s3api create-bucket  --bucket bucketname-snapshot-$(date +%F) --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1  
sleep 120
#create snapshot and start it 
current_time=$(date +%F)
baseUrl="http://10.10.10.118:9202/_snapshot/backup-$current_time"
contentTypeJson="Content-Type: application/json"
credentials="{ \"type\": \"s3\", \"settings\": { \"bucket\": \"es8-snapshot-$current_time\" } }"
res="$(curl -XPUT "$baseUrl" -H "$contentTypeJson" -d "$credentials")"
echo "${res}"

response="${res}"
sleep 30
baseUrl2="http://10.10.10.118:9202/_snapshot/backup-$(date +%F)/snapshot_all"

res2="$(curl -XPUT "$baseUrl2")"
echo "${res2}"

start="${res2}"

