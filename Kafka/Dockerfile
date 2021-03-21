# Set base image
FROM centos:centos7

# Parameter
ARG PARAM_DIR_DOWNLOAD=/downloads
ARG PARAM_DIR_KAFKA_HOME=/opt/kafka
ARG PARAM_URL_KAFKA=https://downloads.apache.org/kafka/2.6.1/kafka_2.13-2.6.1.tgz
ARG PARAM_KAFKA_HOST=10.32.18.218
ARG PARAM_KAFKA_CONNECT_PORT=8084

# Create target directories
RUN mkdir -p $PARAM_DIR_DOWNLOAD
RUN mkdir -p $PARAM_DIR_KAFKA_HOME

# Update yum and install dependencies
RUN yum -y update
RUN yum -y install wget

# Install java 8 sdk
RUN yum -y install java-1.8.0-openjdk

# Set Java environment variable and add to PATH
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
RUN echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
RUN source ~/.bashrc

# Download and extract kafka
RUN wget -P $PARAM_DIR_DOWNLOAD/ $PARAM_URL_KAFKA
RUN tar -xvzf $PARAM_DIR_DOWNLOAD/kafka_2.13-2.6.1.tgz -C $PARAM_DIR_DOWNLOAD
RUN mv $PARAM_DIR_DOWNLOAD/kafka_2.13-2.6.1/* $PARAM_DIR_KAFKA_HOME/

# Set kafka home env variable
ENV KAFKA_HOME=$PARAM_DIR_KAFKA_HOME
ENV KAFKA_HOST=$PARAM_KAFKA_HOST
ENV KAFKA_CONNECT_PORT=$PARAM_KAFKA_CONNECT_PORT
RUN echo "export KAFKA_HOME=$KAFKA_HOME" >> ~/.bashrc
RUN echo "export KAFKA_HOST=$KAFKA_HOST" >> ~/.bashrc
RUN echo "export KAFKA_CONNECT_PORT=$KAFKA_CONNECT_PORT" >> ~/.bashrc
RUN source ~/.bashrc

# Config kafka server
RUN sed -i "/advertised.listeners=/c\advertised.listeners=PLAINTEXT://$KAFKA_HOST:9092" $KAFKA_HOME/config/server.properties

# Configure kafka connect
RUN echo "rest.port=$KAFKA_CONNECT_PORT" >> $KAFKA_HOME/config/connect-standalone.properties

# Copy start script and set execution permissions
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Set start.sh as startup script
CMD ["/bin/bash", "/usr/local/bin/start.sh"]

