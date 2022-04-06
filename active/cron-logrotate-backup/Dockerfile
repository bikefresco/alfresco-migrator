FROM centos:8.4.2105

USER root

RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*


RUN yum update -y
RUN dnf -y install dos2unix
RUN dnf -y install logrotate
COPY logrotate-alfresco.conf /etc/logrotate.d/alfresco
RUN dos2unix /etc/logrotate.d/alfresco
RUN dnf install -y cronie && dnf clean all

RUN mkdir "/usr/local/tomcat"
RUN mkdir "/usr/local/tomcat/alf_data"
RUN mkdir "/usr/local/tomcat/logs"
RUN mkdir "/usr/local/tomcat/backup"

RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Bratislava /etc/localtime

RUN crontab -l | { cat; echo "0 4 * * * root /usr/sbin/logrotate /etc/logrotate.d/alfresco"; } | crontab -

CMD ["crond","-n"]


