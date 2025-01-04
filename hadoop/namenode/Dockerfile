# Utilizando base image oficial hadoop
FROM apache/hadoop:3.4.1

# Configuracao de variaveis de ambiente
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
ENV HADOOP_DATA_DIR=/opt/hadoop/data
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$HADOOP_HOME/bin

# Copia do arquivo de configuracao de Hadoop para dentro da imagem
COPY config/* $HADOOP_CONF_DIR/

# Criacao dos arquivos necessarios e permissoes
RUN mkdir -p $HADOOP_DATA_DIR/dfs/name

# Alteracao do arquivo hdfs-site.xml para usar o novo diretorio de dados

# Exposicao das portas tcp do NameNode 
EXPOSE 9870 9000

# Inicia o processo Hadoop NameNode em modo daemon
CMD ["/bin/bash", "-c", "if [ ! -d $HADOOP_DATA_DIR/dfs/name/current ]; then $HADOOP_HOME/bin/hdfs namenode -format -force -nonInteractive; fi; $HADOOP_HOME/bin/hdfs namenode"]
