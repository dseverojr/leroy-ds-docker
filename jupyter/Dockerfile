# Use official Jupyter base notebook image
FROM jupyter/base-notebook

# Set environment variables
ENV HADOOP_VERSION=3.4.1
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

# Install dependencies
USER root
RUN apt-get update && \
    apt-get install -y wget openjdk-11-jdk pigz && \
    rm -rf /var/lib/apt/lists/*

# Download and extract Hadoop
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    pigz -dc hadoop-$HADOOP_VERSION.tar.gz | tar -xv && \
    mv hadoop-$HADOOP_VERSION /usr/local/hadoop && \
    rm hadoop-$HADOOP_VERSION.tar.gz    

# Copy Hadoop configuration files from local directory into the image
COPY hadoop_conf/* $HADOOP_CONF_DIR/

# Ensure ownership and permissions for Hadoop directories
RUN chown -R root:root $HADOOP_HOME

# Install Python HDFS client
RUN pip install hdfs pyarrow pandas matplotlib seaborn fsspec pyarrow

# Switch back to non-root user
USER $NB_UID

