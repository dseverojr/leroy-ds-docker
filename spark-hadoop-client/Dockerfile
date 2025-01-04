FROM apache/spark:3.4.1


# Configuracao de variaveis de ambiente
ENV HADOOP_VERSION=3.4.1
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin
ENV JAVA_HOME=/opt/java/openjdk


# Instalacao dos pacotes necessarios
USER root
RUN apt-get update && apt-get install -y wget tar && rm -rf /var/lib/apt/lists/*


# Download e extracao das bibliotecas Haoop Cliente
RUN wget https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -O /tmp/hadoop.tar.gz && \
    tar -xzf /tmp/hadoop.tar.gz -C /opt/ && \
    mv /opt/hadoop-${HADOOP_VERSION} /opt/hadoop && \
    rm /tmp/hadoop.tar.gz


# Remocao de componentes desnecessarios para manter a imagem leve+
RUN rm -rf $HADOOP_HOME/share/doc \
           $HADOOP_HOME/share/hadoop/mapreduce \
           $HADOOP_HOME/share/hadoop/tools \
           $HADOOP_HOME/share/hadoop/yarn \
           $HADOOP_HOME/share/hadoop/httpfs \
           $HADOOP_HOME/share/hadoop/kms \
           $HADOOP_HOME/share/hadoop/mapreduce1


# Copia arquivos de configuracao do Hadoop para dentro da imagem
COPY hadoop_conf/* $HADOOP_CONF_DIR/


# Altera onwer da pasta hadoop
RUN chown -R root:root $HADOOP_HOME


USER root