#!/bin/sh

cp backup/alf*.gz backup/alf_data_backup.gz

docker exec cron ls -l usr/local/tomcat/alf_data

docker cp ./backup/alf_data_backup.gz cron:usr/local/tomcat/backup

docker exec cron tar -xvf usr/local/tomcat/backup/alf_data_backup.gz usr/local/tomcat/alf_data

docker exec cron ls -l usr/local/tomcat/alf_data



