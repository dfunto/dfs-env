# Start zookeeper
$KAFKA_HOME/bin/zookeeper-server-start.sh -daemon $KAFKA_HOME/config/zookeeper.properties

# Start kafka-connect
$KAFKA_HOME/bin/connect-standalone.sh -daemon $KAFKA_HOME/config/connect-standalone.properties

# Start kafka server
$KAFKA_HOME/bin/kafka-server-start.sh  $KAFKA_HOME/config/server.properties
