# docker-activemq-jmx
Unable to find an ActiveMQ docker that allows for remote JMX access I created one based on the Dockerfile from [rmohr/activemq](https://hub.docker.com/r/rmohr/activemq/). The docker also includes the [hawtio](https://hawt.io) web console.

To run the container:
```
docker run -p 61616:61616 -p 8161:8161 -p 1099:1099 antonw/activemq-jmx
```
Environment Variabes
--------

|Name|Default Value|
|----|---|
|ACTIVEMQ_RMI_SERVER_HOSTNAME|localhost|
|ACTIVEMQ_BASE|/opt/activemq|
|ACTIVEMQ_CONF|/opt/activemq/conf|
|ACTIVEMQ_DATA|/var/activemq/data|

The default configuration allows for remote JMX access if the JMX client runs on localhost *and* localhost is also the docker host.

If the docker host is a virtual machine or the JMX client does not run on localhost then ACTIVEMQ_RMI_SERVER_HOSTNAME must be set to the *externally accessible* IP address of the ActiveMQ server, for example:
```
docker run -e ACTIVEMQ_RMI_SERVER_HOSTNAME='192.168.0.10' -p 61616:61616 -p 8161:8161 -p 1099:1099 antonw/activemq-jmx
```

Port Map
--------

|Port|Protocol|
|----|---|
|8161|HTTP (ActiveMQ Web Console root context path: "/", hawtio context path: "/hawtio")|
|61616|OPENWIRE|
|5672|AMQP|
|61613|STOMP|
|1883|MQTT|
|61614|WS|
|1099|JMX|




# activemq-cli
[activemq-cli](https://github.com/antonwierenga/activemq-cli) is a command-line utility I developed to interact with a Apache JMX enabled ActiveMQ message broker. Check out [GitHub](https://github.com/antonwierenga/activemq-cli) for more information.

Assuming both the [activemq-cli](https://github.com/antonwierenga/activemq-cli) utility and the [activemq-jmx](https://hub.docker.com/r/antonw/activemq-jmx/) docker are running on localhost, below is the configuration that will allow activemq-cli to connect to the ActiveMQ broker.

```
broker {
	local {
		amqurl = "tcp://localhost:61616"
		jmxurl = "service:jmx:rmi:///jndi/rmi://localhost:1099/jmxrmi"
		username = "amq"
		password = "amq"
		prompt-color = "light-blue" 
	}
}
```
