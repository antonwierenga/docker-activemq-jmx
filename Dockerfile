FROM java:7 

ENV ACTIVEMQ_VERSION 5.13.3 
ENV ACTIVEMQ apache-activemq-$ACTIVEMQ_VERSION 
ENV ACTIVEMQ_TCP=61616 ACTIVEMQ_AMQP=5672 ACTIVEMQ_STOMP=61613 ACTIVEMQ_MQTT=1883 ACTIVEMQ_WS=61614 ACTIVEMQ_UI=8161 ACTIVEMQ_JMX=1099
ENV ACTIVEMQ_HOME /opt/activemq 
ENV ACTIVEMQ_RMI_SERVER_HOSTNAME localhost

RUN \
    curl -O http://archive.apache.org/dist/activemq/$ACTIVEMQ_VERSION/$ACTIVEMQ-bin.tar.gz && \
    mkdir -p /opt && \
    tar xf $ACTIVEMQ-bin.tar.gz -C /opt/ && \
    rm $ACTIVEMQ-bin.tar.gz && \
    ln -s /opt/$ACTIVEMQ $ACTIVEMQ_HOME && \
    useradd -r -M -d $ACTIVEMQ_HOME activemq && \
    chown activemq:activemq /opt/$ACTIVEMQ -R

RUN sed -i 's/<managementContext createConnector=\"false\"\/>/<managementContext connectorPort=\"1099\"\/>/g' /opt/apache-activemq-5.13.3/conf/activemq.xml
RUN chmod 600 /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/management/jmxremote.password
RUN echo '\nACTIVEMQ_OPTS="$ACTIVEMQ_OPTS -Djava.rmi.server.hostname=$ACTIVEMQ_RMI_SERVER_HOSTNAME -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.rmi.port=1099 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false "' >> /opt/apache-activemq-5.13.3/bin/env

USER activemq 
WORKDIR $ACTIVEMQ_HOME
EXPOSE $ACTIVEMQ_TCP $ACTIVEMQ_AMQP $ACTIVEMQ_STOMP $ACTIVEMQ_MQTT $ACTIVEMQ_WS $ACTIVEMQ_UI $ACTIVEMQ_JMX
CMD ["/bin/bash", "-c", "bin/activemq console"]