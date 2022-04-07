#!/bin/sh
docker exec mariadb mysql --user=alfresco --password=alfresco --port=3306 --protocol=TCP --database alfresco -e "SET SESSION TRANSACTION READ ONLY;"

docker exec mariadb mysqldump --user=alfresco --password=alfresco --port=3306 --protocol=TCP --databases alfresco > dump-$(date +%F_%H-%M-%S).sql

docker exec cron tar -zcvpf usr/local/tomcat/backup/alf-backup-acs-$(date +%F_%H-%M-%S)-tar.gz usr/local/tomcat/alf_data

docker exec cron ls -l usr/local/tomcat/alf_data

docker cp cron:usr/local/tomcat/backup  .

docker exec mariadb mysql --user=alfresco --password=alfresco --port=3306 --protocol=TCP --database alfresco -e "SET SESSION TRANSACTION READ WRITE;"
