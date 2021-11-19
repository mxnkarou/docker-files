FROM jboss/wildfly:13.0.0.Final

ENV MYSQL_URL wktdev-mysql-cluster-1-instance-1.chnqvuctmgas.eu-central-1.rds.amazonaws.com:3306
ENV MYSQL_DB dev
ENV MYSQL_USER root
ENV MYSQL_PWD
ENV MYSQL_MIN_POOL_SIZE 5

ENV WILDFLY_MEMORY 2g
ENV JAVA_OPTS="-Xms${WILDFLY_MEMORY} -Xmx${WILDFLY_MEMORY} -XX:MetaspaceSize=128M -XX:MaxMetaspaceSize=256m -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=org.jboss.byteman -Djava.awt.headless=true"

COPY deploy /opt/jboss/wildfly/standalone/deployments/
COPY standalone-wkt.xml /opt/jboss/wildfly/standalone/configuration/standalone.xml

RUN /opt/jboss/wildfly/bin/add-user.sh root root
RUN /opt/jboss/wildfly/bin/add-user.sh -a ejbclient wildfly

USER root
RUN localedef -c -i de_DE -f UTF-8 de_DE.UTF-8
ENV LC_ALL=de_DE.UTF-8

RUN ln -f -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime

USER jboss

EXPOSE 8080
EXPOSE 9990

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
