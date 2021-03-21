# Installing Spark over existing Hadoop Installations
FROM centos-hdoop:v2

# PARAMETERS
ARG PARAM_DIR_DOWNLOAD=/downloads
ARG PARAM_DIR_SPARK_HOME=/usr/local/spark
ARG PARAM_URL_SPARK=https://downloads.apache.org/spark/spark-2.4.7/spark-2.4.7-bin-without-hadoop.tgz

# Create target directories
RUN mkdir $PARAM_DIR_SPARK_HOME

# Download and extract spark
RUN wget -P $PARAM_DIR_DOWNLOAD/ $PARAM_URL_SPARK
RUN tar -xvzf $PARAM_DIR_DOWNLOAD/spark-2.4.7-bin-without-hadoop.tgz -C $PARAM_DIR_DOWNLOAD
RUN mv $PARAM_DIR_DOWNLOAD/spark-2.4.7-bin-without-hadoop/* $PARAM_DIR_SPARK_HOME/

# Set Spark environment variables
ENV YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV SPARK_HOME=$PARAM_DIR_SPARK_HOME
ENV PATH=$PATH:$SPARK_HOME/bin

# Be sure to make available in also bashrc
RUN echo "export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop" >> ~/.bashrc
RUN echo "export SPARK_HOME=$PARAM_DIR_SPARK_HOME" >> ~/.bashrc
RUN echo "export PATH=$PATH:$SPARK_HOME/bin" >> ~/.bashrc
RUN source ~/.bashrc
