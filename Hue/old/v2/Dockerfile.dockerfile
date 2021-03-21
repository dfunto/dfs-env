# Set base image
FROM centos:centos7

# Parameters
ARG PARAM_DIR_DOWNLOAD_HUE=/downloads/hue
ARG PARAM_DIR_HUE_INSTALL_PATH=/usr/share
ARG PARAM_URL_GIT_HUE=https://github.com/cloudera/hue.git
ARG PARAM_HADOOP_URL=http://10.32.18.218:50070

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
RUN mkdir -p $PARAM_DIR_DOWNLOAD_HUE
RUN git clone $PARAM_URL_GIT_HUE $PARAM_DIR_DOWNLOAD_HUE

# Set work dir for cloned repo
WORKDIR $PARAM_DIR_DOWNLOAD_HUE

# Fix for Mysql lib on new systems
#RUN git cherry-pick 7a9100d4a7f38eaef7bd4bd7c715ac1f24a969a8
#RUN git cherry-pick e67c1105b85b815346758ef1b9cd714dd91d7ea3
#RUN git clean -fdx

# Install hue
RUN PREFIX=$PARAM_DIR_HUE_INSTALL_PATH make install

# Create hue user
RUN adduser hue
RUN usermod -aG wheel hue

# Set new configuration file
RUN mv $PARAM_DIR_HUE_INSTALL_PATH/hue/desktop/conf/pseudo-distributed.ini.tmpl $PARAM_DIR_HUE_INSTALL_PATH/hue/desktop/conf/pseudo-distributed.ini

# Set Hadoop WebHDFS url
RUN sed -i "s@## webhdfs_url=http://localhost:50070/webhdfs/v1@webhdfs_url=$PARAM_HADOOP_URL/webhdfs/v1@g" $PARAM_DIR_HUE_INSTALL_PATH/hue/desktop/conf/pseudo-distributed.ini

# Remove temp files
RUN rm -rf $PARAM_DIR_DOWNLOAD_HUE

# Allow write and exec in default sqlite hue db
RUN chown hue $PARAM_DIR_HUE_INSTALL_PATH/hue/desktop
RUN chown hue $PARAM_DIR_HUE_INSTALL_PATH/hue/desktop/desktop.db
RUN chmod u+rwx $PARAM_DIR_HUE_INSTALL_PATH/hue/desktop
RUN chmod u+rwx $PARAM_DIR_HUE_INSTALL_PATH/hue/desktop/desktop.db

# Copy start script and set execution permissions
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Set start.sh as startup script
CMD ["/bin/bash", "/usr/local/bin/start.sh"]
