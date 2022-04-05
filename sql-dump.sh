#!/bin/sh
docker exec mariadb mysql --user=alfresco --password=alfresco --port=3306 --protocol=TCP --database alfresco -e "SET SESSION TRANSACTION READ ONLY;"

docker exec mariadb mysqldump --user=alfresco --password=alfresco --port=3306 --protocol=TCP --databases alfresco > dump-$(date +%F_%H-%M-%S).sql

docker exec -u root docker-alfresco-migrator-acs-1 mkdir backup

docker exec -u root docker-alfresco-migrator-acs-1 tar -zcvpf backup/alf-backup-acs-$(date +%F_%H-%M-%S)-tar.gz alf_data

docker cp docker-alfresco-migrator-acs-1:usr/local/tomcat/backup  .

docker exec -u root docker-alfresco-migrator-acs-1 rm backup/*.gz

docker exec -u root docker-alfresco-migrator-acs-1 rmdir backup

docker exec mariadb mysql --user=alfresco --password=alfresco --port=3306 --protocol=TCP --database alfresco -e "SET SESSION TRANSACTION READ WRITE;"
