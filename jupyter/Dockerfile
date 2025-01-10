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
    apt-get install -y wget openjdk-11-jdk pigz git && \
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

# Set Git user identity inside the container
RUN git config --global user.name "Daniel Severo" && \
    git config --global user.email "dsevero@gmail.com"


# Clone the Git repository (replace URL with your actual repo)
RUN git clone https://github.com/dseverojr/leroy-ds-notebook.git /home/jovyan/notebooks

# Configure Jupyter to use the Git repository as workspace
ENV NOTEBOOK_DIR=/home/jovyan/notebooks
RUN mkdir -p $NOTEBOOK_DIR && chown -R $NB_UID $NOTEBOOK_DIR

# Set the cloned repo as the default working directory
WORKDIR $NOTEBOOK_DIR

# Create Jupyter configuration folder if it doesn't exist
RUN mkdir -p /home/jovyan/.jupyter/

# Copy the Jupyter configuration file
COPY jupyter_notebook_config.py /home/jovyan/.jupyter/jupyter_notebook_config.py

# Set permissions to ensure the notebook user can run Git
RUN chown -R $NB_UID /home/jovyan/.jupyter/

# Switch back to non-root user
USER $NB_UID

# Start Jupyter Notebook with the cloned repository as the workspace
CMD ["start-notebook.sh", "--notebook-dir=/home/jovyan/notebooks"]