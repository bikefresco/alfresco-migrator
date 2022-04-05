FROM ${docker.acs.image}:${alfresco.platform.version}

ARG TOMCAT_DIR=/usr/local/tomcat
ARG USERNAME=${alfresco.platform.docker.user} 

USER root

RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Bratislava /etc/localtime

#Copy Mysql connector to tomcat/lib for Maria Db connections
RUN curl https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.49/mysql-connector-java-5.1.49.jar > $TOMCAT_DIR/lib/mysql-connector-java-5.1.49.jar

# Copy Dockerfile to avoid an error if no JARs exist
COPY Dockerfile extensions/*.jar $TOMCAT_DIR/webapps/alfresco/WEB-INF/lib/

# Copy Dockerfile to avoid an error if no AMPs exist
COPY Dockerfile extensions/*.amp $TOMCAT_DIR/amps/
RUN java -jar $TOMCAT_DIR/alfresco-mmt/alfresco-mmt*.jar install \
              $TOMCAT_DIR/amps $TOMCAT_DIR/webapps/alfresco -directory -nobackup -force

COPY alfresco-global.properties $TOMCAT_DIR/shared/classes/alfresco-global.properties
COPY dev-log4j.properties $TOMCAT_DIR/shared/classes/alfresco/extension
COPY disable-webscript-caching-context.xml $TOMCAT_DIR/shared/classes/alfresco/extension

# Copy Dockerfile to avoid an error if no license file exists
COPY Dockerfile license/*.* $TOMCAT_DIR/webapps/alfresco/WEB-INF/classes/alfresco/extension/license/

USER ${USERNAME}
