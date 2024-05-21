FROM openjdk:17

ENV ACTIVEMQ_VERSION 6.1.0
ENV ACTIVEMQ apache-activemq-$ACTIVEMQ_VERSION
ENV ACTIVEMQ_TCP=61616 ACTIVEMQ_AMQP=5672 ACTIVEMQ_STOMP=61613 ACTIVEMQ_MQTT=1883 ACTIVEMQ_WS=61614 ACTIVEMQ_UI=8161 ACTIVEMQ_JMX=1099
ENV ACTIVEMQ_HOME /opt/activemq
ENV ACTIVEMQ_RMI_SERVER_HOSTNAME localhost
ENV HAWTIO_VERSION 4.0.0
ENV ACTIVEMQ_OPTS -Djava.rmi.server.hostname=$ACTIVEMQ_RMI_SERVER_HOSTNAME -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.rmi.port=1099 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dhawtio.authenticationEnabled=false -Dhawtio.realm=activemq -Dhawtio.role=admins -Dhawtio.rolePrincipalClasses=org.apache.activemq.jaas.GroupPrincipal

RUN \
    curl -L http://archive.apache.org/dist/activemq/$ACTIVEMQ_VERSION/$ACTIVEMQ-bin.tar.gz > $ACTIVEMQ-bin.tar.gz && \
    mkdir -p /opt && \
    tar -xvzf $ACTIVEMQ-bin.tar.gz -C /opt/ && \
    rm $ACTIVEMQ-bin.tar.gz && \
    ln -s /opt/$ACTIVEMQ $ACTIVEMQ_HOME && \
    useradd -r -M -d $ACTIVEMQ_HOME activemq && \
    chown activemq:activemq /opt/$ACTIVEMQ -R

RUN microdnf update && \
    microdnf install --nodocs wget unzip && \
    microdnf clean all && \
    rm -rf /var/cache/yum

RUN \
	wget --no-verbose https://repo1.maven.org/maven2/io/hawt/hawtio-default/$HAWTIO_VERSION/hawtio-default-$HAWTIO_VERSION.war && \
	unzip -q hawtio-default-$HAWTIO_VERSION.war -d hawtio && \
	mv hawtio  /opt/$ACTIVEMQ/webapps  && \
	chown -R activemq:activemq /opt/$ACTIVEMQ

RUN sed -i 's/property name="host" value="127.0.0.1"\/>/property name="host" value="0.0.0.0"\/>/g' /opt/$ACTIVEMQ/conf/jetty.xml
RUN sed -i '/<ref bean="rewriteHandler"\/>.*/a <bean class="org.eclipse.jetty.webapp.WebAppContext">\n	<property name="contextPath" value="\/hawtio" \/>\n	<property name="resourceBase" value="${activemq.home}\/webapps\/hawtio" \/>\n	<property name="logUrlOnStart" value="true" \/>\n <\/bean>' /opt/$ACTIVEMQ/conf/jetty.xml
RUN sed -i 's/<managementContext createConnector=\"false\"\/>/<managementContext connectorPort=\"1099\"\/>/g' /opt/$ACTIVEMQ/conf/activemq.xml

USER activemq
WORKDIR $ACTIVEMQ_HOME
EXPOSE $ACTIVEMQ_TCP $ACTIVEMQ_AMQP $ACTIVEMQ_STOMP $ACTIVEMQ_MQTT $ACTIVEMQ_WS $ACTIVEMQ_UI $ACTIVEMQ_JMX

CMD ["/bin/bash", "-c", "bin/activemq console"]
