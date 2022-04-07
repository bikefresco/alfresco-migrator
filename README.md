
# Backup and restore Alfresco from Docker Instance

### Based on Alfresco SDK with build tools: Maven, Java 11, Docker, GitBash

#### Only reason using Alfresco SDK is replacement of Postgres database with Maria DB

First start Maria Db, Activemq, with build of cron-logrotate-backup helping container with backup volume.

    ./first-last.sh up

Start Alfresco Instance with SDK build, changes to SDK docker compose are related to database change and docker volumes.

    ./run.sh build_start

Open Alfresco in browser with url [http://localhost:8180/share/](http://localhost:8180/share/) user admin, password admin, spend a little time creating sites 
uploading documents for later review of restored backup data.

Stop Alfresco with Ctrl-C and purge Solr volume data, Alfresco repository volume and Maria data volume are not purged.   

    ./run.sh purge

Run backup of Sql database and Alfresco data file repository, script will generate .sql and .gz in local file system outside of docker containers.

    ./sql-dump.sh  

Backup files are saved on local file system, now it is safe to purge all docker containers

    ./first-last.sh purge

Verify sql backup file is present in local file system

    ls -l *.sql

Verify repository backup file is present in local file system

    ls -l backup/*.gz

## Restore Backup steps

Start Maria DB and create volumes where backup data will be restored.

    ./first-last.sh up    

Verify Alfresco database exist.

    docker exec mariadb mysql --user=alfresco --password=alfresco --port=3306 --protocol=TCP --database alfresco -e "SHOW DATABASES;"

Verify Alfresco database is empty.

    docker exec mariadb mysql --user=alfresco --password=alfresco --port=3306 --protocol=TCP --database alfresco -e "SHOW TABLES;"

Restore Alfresco Sql database

    ./restore-dump.sh

Verify Alfresco Sql tables are created

    docker exec mariadb mysql --user=alfresco --password=alfresco --port=3306 --protocol=TCP --database alfresco -e "SHOW TABLES;"

Verify Alfresco data file system is empty 

    docker exec cron ls -l usr/local/tomcat/alf_data

Restore Alfresco data from backup file

    ./data-restore.sh

Verify Alfresco data file system is not empty

    docker exec cron ls -l usr/local/tomcat/alf_data

Start Alfresco instance again

    ./run.sh build_start

Open Alfresco [http://localhost:8180/share/](http://localhost:8180/share/) and verify backup data are restored.


## Generated Alfresco SDK instructions

# Alfresco AIO Project - SDK 4.4

This is an All-In-One (AIO) project for Alfresco SDK 4.4.

Run with `./run.sh build_start` or `./run.bat build_start` and verify that it

 * Runs Alfresco Content Service (ACS)
 * Runs Alfresco Share
 * Runs Alfresco Search Service (ASS)
 * Runs PostgreSQL database
 * Deploys the JAR assembled modules
 
All the services of the project are now run as docker containers. The run script offers the next tasks:

 * `build_start`. Build the whole project, recreate the ACS and Share docker images, start the dockerised environment composed by ACS, Share, ASS and 
 PostgreSQL and tail the logs of all the containers.
 * `build_start_it_supported`. Build the whole project including dependencies required for IT execution, recreate the ACS and Share docker images, start the 
 dockerised environment composed by ACS, Share, ASS and PostgreSQL and tail the logs of all the containers.
 * `start`. Start the dockerised environment without building the project and tail the logs of all the containers.
 * `stop`. Stop the dockerised environment.
 * `purge`. Stop the dockerised container and delete all the persistent data (docker volumes).
 * `tail`. Tail the logs of all the containers.
 * `reload_share`. Build the Share module, recreate the Share docker image and restart the Share container.
 * `reload_acs`. Build the ACS module, recreate the ACS docker image and restart the ACS container.
 * `build_test`. Build the whole project, recreate the ACS and Share docker images, start the dockerised environment, execute the integration tests from the
 `integration-tests` module and stop the environment.
 * `test`. Execute the integration tests (the environment must be already started).

# Few things to notice

 * No parent pom
 * No WAR projects, the jars are included in the custom docker images
 * No runner project - the Alfresco environment is now managed through [Docker](https://www.docker.com/)
 * Standard JAR packaging and layout
 * Works seamlessly with Eclipse and IntelliJ IDEA
 * JRebel for hot reloading, JRebel maven plugin for generating rebel.xml [JRebel integration documentation]
 * AMP as an assembly
 * Persistent test data through restart thanks to the use of Docker volumes for ACS, ASS and database data
 * Integration tests module to execute tests against the final environment (dockerised)
 * Resources loaded from META-INF
 * Web Fragment (this includes a sample servlet configured via web fragment)

# TODO

  * Abstract assembly into a dependency so we don't have to ship the assembly in the archetype
  * Functional/remote unit tests
