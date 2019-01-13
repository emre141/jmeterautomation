# 1
FROM alpine:3.6
# 2
LABEL maintainer="Vincenzo Marrazzo <pariamentz@gmail.com>"
# 3
ARG JMETER_VERSION="5.0"
# 4
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN  ${JMETER_HOME}/bin
ENV MIRROR_HOST https://archive.apache.org/dist/jmeter
ENV JMETER_DOWNLOAD_URL ${MIRROR_HOST}/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV JMETER_PLUGINS_DOWNLOAD_URL http://repo1.maven.org/maven2/kg/apc
ENV JMETER_PLUGINS_FOLDER ${JMETER_HOME}/lib/ext/
# 5
RUN    apk update \
        && apk upgrade \
        && apk add ca-certificates \
        && update-ca-certificates \
    && apk add --update openjdk8-jre tzdata curl unzip bash \
    && cp /usr/share/zoneinfo/Europe/Istanbul /etc/localtime \
    && echo "Europe/Istanbul" >  /etc/timezone \
        && rm -rf /var/cache/apk/* \
        && mkdir -p /tmp/dependencies  \
        && curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
        && mkdir -p /opt  \
        && tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
        && rm -rf /tmp/dependencies
# 6
RUN curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL}/jmeter-plugins-dummy/0.2/jmeter-plugins-dummy-0.2.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-dummy-0.2.jar
RUN curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL}/jmeter-plugins-cmn-jmeter/0.5/jmeter-plugins-cmn-jmeter-0.5.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-cmn-jmeter-0.5.jar
RUN curl -L --silent https://github.com/emqx/mqtt-jmeter/releases/download/1.0.1/mqtt-xmeter-1.0.1-jar-with-dependencies.jar -o ${JMETER_PLUGINS_FOLDER}/mqtt-xmeter-1.0.1-jar-with-dependencies.jar
RUN curl -L --silent http://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.3/jmeter-plugins-manager-1.3.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-manager-1.3.jar


# 7
ENV PATH $PATH:$JMETER_BIN

# 8
COPY launch.sh /
RUN chmod +x launch.sh

#9
WORKDIR ${JMETER_HOME}

#10
ENTRYPOINT ["/launch.sh"]
