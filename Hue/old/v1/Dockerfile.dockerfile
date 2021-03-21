# Set base image
FROM centos-hdoop:v2

# Parameters
ARG PARAM_DIR_DOWNLOAD_HUE=/downloads/hue
ARG PARAM_DIR_HUE_INSTALL_PATH=/usr/share
ARG PARAM_URL_GIT_HUE=https://github.com/cloudera/hue.git

# Install dependecies
RUN yum -y install git install ant asciidoc cyrus-sasl-devel cyrus-sasl-gssapi cyrus-sasl-plain g++ gcc gcc-c++ krb5-devel libffi-devel libxml2-devel libxslt-devel make mysql mysql-devel openldap-devel python-devel sqlite-devel gmp-devel
RUN yum -y install python-devel python-simplejson pythonsetuptools maven openssl-devel curl python-setuptools libsasl2-dev libsasl2-modules-gssapi-mit libkrb5-dev libtidy-0.99-0 mvn libldap2-dev

# Set up git basic config
RUN git config --global user.email "service@waage.com.br"
RUN git config --global user.name "Waage Service User"

# Python
RUN yum -y install centos-release-SCL scl-utils python27

# Install NodeJs
RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -
RUN yum -y install nodejs

# Define install folder
ENV PREFIX=$PARAM_DIR_HUE_INSTALL_PATH

# Download hue code
RUN mkdir $PARAM_DIR_DOWNLOAD_HUE
RUN git clone $PARAM_URL_GIT_HUE $PARAM_DIR_DOWNLOAD_HUE

# Set work dir for cloned repo
WORKDIR $PARAM_DIR_DOWNLOAD_HUE

# Fix for Mysql lib on new systems
RUN git cherry-pick 7a9100d4a7f38eaef7bd4bd7c715ac1f24a969a8
RUN git cherry-pick e67c1105b85b815346758ef1b9cd714dd91d7ea3
RUN git clean -fdx

# Install hue
RUN PREFIX=$PARAM_DIR_HUE_INSTALL_PATH make install

# core-site config
RUN sed -i 's@</configuration>@<property><name>hadoop.proxyuser.hue.hosts</name><value>*</value></property>\n</configuration>@g' $HADOOP_HOME/etc/hadoop/core-site.xml
RUN sed -i 's@</configuration>@<property><name>hadoop.proxyuser.hue.groups</name><value>*</value></property>\n</configuration>@g' $HADOOP_HOME/etc/hadoop/core-site.xml

# hdfs-site config
RUN sed -i 's@</configuration>@<property><name>dfs.webhdfs.enabled</name><value>true</value></property>\n</configuration>@g' $HADOOP_HOME/etc/hadoop/hdfs-site.xml

# Create hue user
RUN adduser hue
RUN usermod -aG wheel hue

# Install MySql database for hue
RUN yum -y install mariadb-server

# Set new configuration file
RUN mv $PARAM_DIR_HUE_INSTALL_PATH/hue/desktop/conf/pseudo-distributed.ini.tmpl $PARAM_DIR_HUE_INSTALL_PATH/hue/desktop/conf/pseudo-distributed.ini
RUN sed -i 's@\[\[database\]\]@[[database]]\n host=localhost\n port=3306\n engine=mysql\n user=hue\n password=hue\n name=hue@g' $PARAM_DIR_HUE_INSTALL_PATH/hue/desktop/conf/pseudo-distributed.ini

# Remove temp files
RUN rm -rf $PARAM_DIR_DOWNLOAD_HUE

# Copy start script and set execution permissions
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Set start.sh as startup script
CMD ["/usr/local/bin/start.sh"]
