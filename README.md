# docker-activemq-jmx

`docker run -d --name activemq -p 61616:61616 -p 8161:8161 -p 1099:1099 antonw/activemq-jmx`

This docker uses the following fixed port mappings:

```
 -Djava.rmi.server.hostname=localhost
 -Dcom.sun.management.jmxremote.port=1099
 -Dcom.sun.management.jmxremote.rmi.port=1099
```

Pass environment variable ACTIVEMQ_RMI_SERVER_HOSTNAME to set a different java.rmi.server.hostname:

`docker run  -e ACTIVEMQ_RMI_SERVER_HOSTNAME='192.168.0.10' -d --name activemq -p 61616:61616 -p 8161:8161 -p 1099:1099 antonw/activemq-jmx`

Port Map
--------

|Port|Protocol|
|----|---|
|8161|HTTP (WEB UI)|
|61616|OPENWIRE|
|5672|AMQP|
|61613|STOMP|
|1883|MQTT|
|61614|WS|
|1099|JMX|
