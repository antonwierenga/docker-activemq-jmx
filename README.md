# docker-activemq-jmx

`docker run -d --name activemq -p 61616:61616 -p 8161:8161 -p 1099:1099 antonw/activemq-jmx`

This docker uses the following fixed port mappings:

```
 -Djava.rmi.server.hostname=localhost
 -Dcom.sun.management.jmxremote.port=1099
 -Dcom.sun.management.jmxremote.rmi.port=1099
```
