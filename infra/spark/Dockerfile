FROM apache/spark:3.5.1

USER root

ARG HADOOP_AWS_VERSION=3.3.4
ARG AWS_SDK_VERSION=1.12.262
ARG WILDFLY_OPENSSL_VERSION=1.0.7.Final

RUN set -eux; \
    curl -fsSL "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_AWS_VERSION}/hadoop-aws-${HADOOP_AWS_VERSION}.jar" \
      -o "/opt/spark/jars/hadoop-aws-${HADOOP_AWS_VERSION}.jar"; \
    curl -fsSL "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_VERSION}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar" \
      -o "/opt/spark/jars/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar"; \
    curl -fsSL "https://repo1.maven.org/maven2/org/wildfly/openssl/wildfly-openssl/${WILDFLY_OPENSSL_VERSION}/wildfly-openssl-${WILDFLY_OPENSSL_VERSION}.jar" \
      -o "/opt/spark/jars/wildfly-openssl-${WILDFLY_OPENSSL_VERSION}.jar"; \
    chmod 0644 /opt/spark/jars/*.jar

USER spark
