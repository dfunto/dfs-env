# Set base image
FROM dfunto/hadoop-base:main

# # Set user
# USER root

# # Set parameters 
# ARG PARAM_DIR_DOWNLOAD=/downloads
# ARG PARAM_DIR_SQOOP_HOME=/usr/lib/sqoop
# ARG PARAM_URL_SQOOP=https://downloads.apache.org/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
# ARG PARAM_DIR_HIVE_HOME=/usr/lib/hive
# ARG PARAM_URL_HIVE=https://downloads.apache.org/hive/hive-2.3.8/apache-hive-2.3.8-bin.tar.gz

# # Create target directories (if not exists)
# RUN mkdir -p $PARAM_DIR_DOWNLOAD
# RUN mkdir -p $PARAM_DIR_SQOOP_HOME
# RUN mkdir -p $PARAM_DIR_HIVE_HOME

# ### Configure Hue
	
# 	# Set configuration for Hue
# 	RUN sed -i 's@</configuration>@<property><name>hadoop.proxyuser.hue.hosts</name><value>*</value></property>\n</configuration>@g' $HADOOP_HOME/etc/hadoop/core-site.xml
# 	RUN sed -i 's@</configuration>@<property><name>hadoop.proxyuser.hue.groups</name><value>*</value></property>\n</configuration>@g' $HADOOP_HOME/etc/hadoop/core-site.xml

# ### Install Sqoop

# 	# Download and extract sqoop
# 	RUN wget -P $PARAM_DIR_DOWNLOAD/ $PARAM_URL_SQOOP
# 	RUN tar -xvzf $PARAM_DIR_DOWNLOAD/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz -C $PARAM_DIR_DOWNLOAD
# 	RUN mv $PARAM_DIR_DOWNLOAD/sqoop-1.4.7.bin__hadoop-2.6.0/* $PARAM_DIR_SQOOP_HOME/

# 	# Change sqoop dir owner
# 	RUN chown -R hadoopusr $PARAM_DIR_SQOOP_HOME

# 	# Set sqoop environment variables
# 	ENV SQOOP_HOME=$PARAM_DIR_SQOOP_HOME
# 	ENV PATH=$PATH:$PARAM_DIR_SQOOP_HOME/bin

# 	# Be sure to make available in also bashrc
# 	RUN echo "export SQOOP_HOME=$SQOOP_HOME" >> ~/.bashrc
# 	RUN source ~/.bashrc


# ### Install Hive

#         # Download and extract sqoop
#         RUN wget -P $PARAM_DIR_DOWNLOAD/ $PARAM_URL_HIVE
#         RUN tar -xvzf $PARAM_DIR_DOWNLOAD/apache-hive-2.3.8-bin.tar.gz -C $PARAM_DIR_DOWNLOAD
#         RUN mv $PARAM_DIR_DOWNLOAD/apache-hive-2.3.8-bin/* $PARAM_DIR_HIVE_HOME/

#         # Change hive dir owner
#         RUN chown -R hadoopusr $PARAM_DIR_HIVE_HOME

#         # Set hive environment variables
#         ENV HIVE_HOME=$PARAM_DIR_HIVE_HOME
#         ENV PATH=$PATH:$PARAM_DIR_HIVE_HOME/bin

#         # Be sure to make available in also bashrc
#         RUN echo "export HIVE_HOME=$HIVE_HOME" >> ~/.bashrc
#         RUN source ~/.bashrc

#         # Set configuration for hive user
#         RUN sed -i 's@</configuration>@<property><name>hadoop.proxyuser.hive.hosts</name><value>*</value></property>\n</configuration>@g' $HADOOP_HOME/etc/hadoop/core-site.xml
#         RUN sed -i 's@</configuration>@<property><name>hadoop.proxyuser.hive.groups</name><value>*</value></property>\n</configuration>@g' $HADOOP_HOME/etc/hadoop/core-site.xml

# 	# Configure hive
# 	RUN cp $HIVE_HOME/conf/hive-default.xml.template $HIVE_HOME/conf/hive-site.xml
# 	RUN sed -i "s@</configuration>@<property><name>system:java.io.tmpdir</name><value>/tmp/hive/java</value></property><property><name>system:user.name</name><value>hadoopusr</value></property></configuration>@g" $HIVE_HOME/conf/hive-site.xml
	
# 	# Create hadoop necessary folders
# 	#RUN hadoop fs -mkdir -p    /tmp
# 	#RUN hadoop fs -mkdir -p    /user/hive/warehouse
# 	#RUN hadoop fs -chmod g+w   /tmp
# 	#RUN hadoop fs -chmod g+w   /user/hive/warehouse

# 	# Initialize metastore
# 	#RUN cd $HIVE_HOME && schematool -dbType derby -initSchema

# 	# Run hiveserver detached
# 	#RUN hive --service hiveserver2 &	

# ### Install HBase (next)
	
