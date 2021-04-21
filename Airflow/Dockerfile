# Set base image
FROM centos:centos7

# PARAMETERS
ARG PARAM_URL_PYTHON=https://www.python.org/ftp/python/3.6.2/Python-3.6.2.tar.xz
ARG PARAM_DIR_PYTHON=/downloads

# Update yum
RUN yum -y update

# Install dependencies
RUN yum -y install wget make
RUN yum -y install gcc openssl-devel
RUN yum -y install sqlite-devel

# Get Python3
RUN wget -P $PARAM_DIR_PYTHON $PARAM_URL_PYTHON  

# Build and install Python3
RUN tar -xvf $PARAM_DIR_PYTHON/Python-3.6.2.tar.xz -C $PARAM_DIR_PYTHON
RUN $PARAM_DIR_PYTHON/Python-3.6.2/configure --prefix=/opt/python3
RUN make altinstall
RUN ln -s /opt/python3/bin/python3.6 /usr/bin/python3.6
RUN ln -s /opt/python3/bin/pip3.6 /usr/bin/pip3.6

# Install python packages dependencies
RUN pip3.6 install gunicorn
RUN pip3.6 install "apache-airflow==1.10.14" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-1.10.14/constraints-3.6.txt"

# Add airflow to path
RUN ln -s /opt/python3/bin/airflow /usr/bin/airflow 
RUN ln -s /opt/python3/bin/gunicorn /usr/bin/gunicorn

# Initialize airflow database 
RUN airflow db init

# Set admin user
RUN airflow users create \
    --username admin \
    --password password \
    --firstname Admin \
    --lastname Admin \
    --role Admin \
    --email Admin@airflow.org
    
# Initialize web server and scheduler
#RUN airflow webserver -D --port 8080
#RUN airflow scheduler -D
