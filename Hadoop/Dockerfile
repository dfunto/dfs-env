# Set base image
FROM centos:centos7

# Set user
USER root

# PARAMETERS
ARG PARAM_HADOOP_VERSION=2.7.3
ARG PARAM_DIR_DOWNLOAD=/downloads
ARG PARAM_DIR_HADOOP_HOME=/usr/local/hadoop
ARG PARAM_URL_HADOOP=https://archive.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz
ARG PARAM_DEFAULT_HADOOP_DFS_IP=10.32.18.218

# Update yum
RUN yum -y update

# Install basic packages
RUN yum -y install wget
RUN yum -y install rsync
RUN yum -y install openssh openssh-server openssh-clients
RUN yum -y install which

# Create target directories
RUN mkdir $PARAM_DIR_DOWNLOAD
RUN mkdir $PARAM_DIR_HADOOP_HOME

# SSH Settings
ADD ssh-config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config
RUN echo "/usr/sbin/sshd" >> ~/.bashrc

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN /usr/bin/ssh-keygen -A


# Install java 8 sdk
RUN yum -y install java-1.8.0-openjdk

# Set Java environment variable and add to PATH
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
RUN echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
RUN source ~/.bashrc

# Download and extract hadoop
RUN wget -P $PARAM_DIR_DOWNLOAD/ $PARAM_URL_HADOOP
RUN tar -xvzf $PARAM_DIR_DOWNLOAD/hadoop-2.7.3.tar.gz -C $PARAM_DIR_DOWNLOAD
RUN mv $PARAM_DIR_DOWNLOAD/hadoop-2.7.3/* $PARAM_DIR_HADOOP_HOME/

# Set Hadoop environment variables
ENV HADOOP_HOME=$PARAM_DIR_HADOOP_HOME
ENV HADOOP_MAPRED_HOME=$PARAM_DIR_HADOOP_HOME 
ENV HADOOP_COMMON_HOME=$PARAM_DIR_HADOOP_HOME
ENV HADOOP_HDFS_HOME=$PARAM_DIR_HADOOP_HOME 
ENV YARN_HOME=$PARAM_DIR_HADOOP_HOME 
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$PARAM_DIR_HADOOP_HOME/lib/native 
ENV HADOOP_INSTALL=$PARAM_DIR_HADOOP_HOME
ENV HADOOP_DFS_DEFAULT=hdfs://$PARAM_DEFAULT_HADOOP_DFS_IP:9000 
ENV PATH=$PATH:$PARAM_DIR_HADOOP_HOME/sbin:$PARAM_DIR_HADOOP_HOME/bin 


# Be sure to make available in also bashrc
RUN echo "export HADOOP_HOME=$HADOOP_HOME" >> ~/.bashrc
RUN echo "export HADOOP_MAPRED_HOME=$HADOOP_MAPRED_HOME" >> ~/.bashrc
RUN echo "export HADOOP_COMMON_HOME=$HADOOP_COMMON_HOME" >> ~/.bashrc
RUN echo "export HADOOP_HDFS_HOME=$HADOOP_HDFS_HOME" >> ~/.bashrc
RUN echo "export YARN_HOME=$YARN_HOME" >> ~/.bashrc
RUN echo "export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_COMMON_LIB_NATIVE_DIR" >> ~/.bashrc
RUN echo "export HADOOP_INSTALL=$HADOOP_INSTALL" >> ~/.bashrc

RUN source ~/.bashrc

# Create hadoop user
RUN useradd hadoopusr
RUN echo 'hadoopusr:hadooppwd' | chpasswd

# Set folders for namenode and datanode
RUN mkdir -p /home/hadoopusr/hadoopinfra/hdfs/namenode
RUN mkdir -p /home/hadoopusr/hadoopinfra/hdfs/datanode

# Set Pseudo-Distributed Operation mode
# Set core-site config
RUN sed -i 's@</configuration>@<property><name>fs.defaultFS</name><value>'"$HADOOP_DFS_DEFAULT"'</value></property>\n</configuration>@g' $PARAM_DIR_HADOOP_HOME/etc/hadoop/core-site.xml
RUN sed -i 's@</configuration>@<property><name>hadoop.proxyuser.hadoopusr.hosts</name><value>*</value></property>\n</configuration>@g' $HADOOP_HOME/etc/hadoop/core-site.xml
RUN sed -i 's@</configuration>@<property><name>hadoop.proxyuser.hadoopusr.groups</name><value>*</value></property>\n</configuration>@g' $HADOOP_HOME/etc/hadoop/core-site.xml

# Set hdfs-site config
RUN sed -i 's@</configuration>@<property><name>dfs.replication</name><value>1</value></property>\n</configuration>@g' $PARAM_DIR_HADOOP_HOME/etc/hadoop/hdfs-site.xml
RUN sed -i 's@</configuration>@<property><name>dfs.name.dir</name><value>file:///home/hadoopusr/hadoopinfra/hdfs/namenode</value></property>\n</configuration>@g' $PARAM_DIR_HADOOP_HOME/etc/hadoop/hdfs-site.xml
RUN sed -i 's@</configuration>@<property><name>dfs.data.dir</name><value>file:///home/hadoopusr/hadoopinfra/hdfs/datanode</value></property>\n</configuration>@g' $PARAM_DIR_HADOOP_HOME/etc/hadoop/hdfs-site.xml

# Set yarn-site config
RUN sed -i 's@</configuration>@<property><name>yarn.nodemanager.aux-services</name><value>mapreduce_shuffle</value></property>\n</configuration>@g' $PARAM_DIR_HADOOP_HOME/etc/hadoop/yarn-site.xml
RUN sed -i 's@</configuration>@<property><name>yarn.nodemanager.disk-health-checker.max-disk-utilization-per-disk-percentage</name><value>98.5</value></property>\n</configuration>@g' $PARAM_DIR_HADOOP_HOME/etc/hadoop/yarn-site.xml

# Set mapred-site config
RUN cp $PARAM_DIR_HADOOP_HOME/etc/hadoop/mapred-site.xml.template $PARAM_DIR_HADOOP_HOME/etc/hadoop/mapred-site.xml
RUN sed -i 's@</configuration>@<property><name>mapreduce.framework.name</name><value>yarn</value></property>\n</configuration>@g' $PARAM_DIR_HADOOP_HOME/etc/hadoop/mapred-site.xml

# Enable webhdfs
RUN sed -i 's@</configuration>@<property><name>dfs.webhdfs.enabled</name><value>true</value></property>\n</configuration>@g' $HADOOP_HOME/etc/hadoop/hdfs-site.xml


# Allow hosts 
RUN ssh-keyscan -H -t rsa localhost >> ~/.ssh/known_hosts
RUN ssh-keyscan -H -t rsa 0.0.0.0 >> ~/.ssh/known_hosts
RUN ssh-keyscan -H -t rsa 127.0.0.1 >> ~/.ssh/known_hosts
RUN ssh-keyscan -H -t rsa $PARAM_DEFAULT_HADOOP_DFS_IP >> ~/.ssh/known_hosts

# Format hadoop file server
RUN hdfs namenode -format

# Copy start script and set execution permissions
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Set start.sh as startup script
CMD ["/bin/bash", "/usr/local/bin/start.sh"]
