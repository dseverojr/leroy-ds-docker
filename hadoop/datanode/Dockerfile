# Utilizando base image oficial hadoop
FROM apache/hadoop:3.4.1

# Muda para o usuario root para execucar operacoes com mais privilegios
USER root

# Configuracao de variaveis de ambiente
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
ENV HADOOP_DATA_DIR=/opt/hadoop/data
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$HADOOP_HOME/bin

# Copia arquivos de configuracao do Hadoop para dentro da imagem
COPY haddoop_conf/* $HADOOP_CONF_DIR/

# Criacao dos arquivos necessarios e permissoes
RUN mkdir -p $HADOOP_DATA_DIR/dfs/data && \
    chown -R root:root $HADOOP_DATA_DIR && \
    chmod -R 755 $HADOOP_DATA_DIR

# Exposicao das portas tcp do DataNode 
EXPOSE 9864

# Inicia o processo Hadoop DataNode em modo daemon
CMD ["/bin/bash", "-c", "$HADOOP_HOME/bin/hdfs datanode"]
