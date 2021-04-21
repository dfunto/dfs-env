# Set base image
FROM gethue/hue:latest

# Set parameters for configuring hue
ARG PARAM_HADOOP_URL=http://10.32.18.218:50070
ARG PARAM_HIVE_URL=http://10.32.18.218

# Set Hadoop WebHDFS url
RUN sed -i "s@## webhdfs_url=http://localhost:50070/webhdfs/v1@webhdfs_url=$PARAM_HADOOP_URL/webhdfs/v1@g" /usr/share/hue/desktop/conf/hue.ini
RUN sed -i "s@## hive_server_host=localhost@hive_server_host=$PARAM_HIVE_URL@g" /usr/share/hue/desktop/conf/hue.ini

