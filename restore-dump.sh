#!/bin/sh

cp dump*.sql backup/dump.sql

docker exec mariadb mysql --user=alfresco --password=alfresco --port=3306 --protocol=TCP --database alfresco -e "SHOW TABLES;"

cat backup/dump.sql | docker exec -i mariadb mysql --user=alfresco --password=alfresco --port=3306 --protocol=TCP --database alfresco

docker exec mariadb mysql --user=alfresco --password=alfresco --port=3306 --protocol=TCP --database alfresco -e "SHOW TABLES;"

