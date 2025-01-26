# Usdo da imagem oficial do Apache NiFi como base
FROM apache/nifi:1.21.0

# Muda para o usuario root para execucar operacoes com mais privilegios
USER root

# Configuracao de variaveis de ambiente
ENV NIFI_HOME=/opt/nifi/nifi-current
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$HADOOP_HOME/bin:$JAVA_HOME/bin
ENV POSTGRESQL_JDBC_VERSION=42.7.4

# Instalacao dos pacotes necessarios
RUN apt-get update && \
    apt-get install -y wget gnupg2 iputils-ping net-tools lsof vim openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

# Download PostgreSQL JDBC driver
RUN wget https://jdbc.postgresql.org/download/postgresql-${POSTGRESQL_JDBC_VERSION}.jar -O ${NIFI_HOME}/lib/postgresql-${POSTGRESQL_JDBC_VERSION}.jar

# Change ownership back to nifi user
RUN chown -R nifi:nifi ${NIFI_HOME}/lib/postgresql-${POSTGRESQL_JDBC_VERSION}.jar

# Download e extracao das bibliotecas Haoop Client
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz -O /tmp/hadoop.tar.gz && \
    tar -xzvf /tmp/hadoop.tar.gz -C /opt/ && \
    mv /opt/hadoop-3.4.1 /opt/hadoop && \
    rm /tmp/hadoop.tar.gz

# Copia arquivos de configuracao do Hadoop para dentro da imagem
COPY hadoop-config/* $HADOOP_CONF_DIR/

# Altera onwer da pasta hadoop
RUN chown -R nifi:nifi $HADOOP_HOME

# Volta para o usuario NiFi
USER nifi

# Expoe porta TCP WebUI do NiFi
EXPOSE 8084

# inicia NiFi
CMD ["bin/nifi.sh", "run"]
