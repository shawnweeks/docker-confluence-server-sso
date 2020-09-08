# Atlassian Docker UIDs
# These are based on the UIDs found in the Official Images
# to maintain compatability as much as possible.
# Jira          2001
# Confluence    2002
# Bitbucket     2003
# Crowd         2004
# Bamboo        2005

ARG BASE_REGISTRY=registry.cloudbrocktec.com
ARG BASE_IMAGE=redhat/ubi/ubi8
ARG BASE_TAG=8.2

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

ENV CONFLUENCE_USER confluence
ENV CONFLUENCE_GROUP confluence
ENV CONFLUENCE_UID 2002
ENV CONFLUENCE_GID 2002

ENV CONFLUENCE_HOME /var/atlassian/application-data/confluence
ENV CONFLUENCE_INSTALL_DIR /opt/atlassian/confluence

ARG CONFLUENCE_VERSION
ARG DOWNLOAD_URL=https://product-downloads.atlassian.com/software/confluence/downloads/atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz

RUN yum install -y java-11-openjdk-devel procps git python3 python3-jinja2 && \
    yum clean all

COPY [ "entrypoint.sh", "entrypoint.py", "entrypoint_helpers.py", "/tmp/scripts/" ]

COPY [ "templates/*.j2", "/opt/jinja-templates/" ]

RUN mkdir -p ${CONFLUENCE_HOME}/shared && \
    mkdir -p ${CONFLUENCE_INSTALL_DIR} && \
    groupadd -r -g ${CONFLUENCE_GID} ${CONFLUENCE_GROUP} && \
    useradd -r -u ${CONFLUENCE_UID} -g ${CONFLUENCE_GROUP} -M -d ${CONFLUENCE_HOME} ${CONFLUENCE_USER} && \
    curl --silent -L ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "$CONFLUENCE_INSTALL_DIR" && \
    sed -i -e 's/-Xms\([0-9]\+[kmg]\) -Xmx\([0-9]\+[kmg]\)/-Xms\${JVM_MINIMUM_MEMORY:=\1} -Xmx\${JVM_MAXIMUM_MEMORY:=\2} -Dconfluence.home=\${CONFLUENCE_HOME}/g' ${CONFLUENCE_INSTALL_DIR}/bin/setenv.sh && \
    sed -i -e 's/-XX:ReservedCodeCacheSize=\([0-9]\+[kmg]\)/-XX:ReservedCodeCacheSize=${JVM_RESERVED_CODE_CACHE_SIZE:=\1}/g' ${CONFLUENCE_INSTALL_DIR}/bin/setenv.sh && \
    sed -i -e 's/export CATALINA_OPTS/CATALINA_OPTS="\${CATALINA_OPTS} \${JVM_SUPPORT_RECOMMENDED_ARGS}"\n\nexport CATALINA_OPTS/g' ${CONFLUENCE_INSTALL_DIR}/bin/setenv.sh && \
    echo "confluence.home=${CONFLUENCE_HOME}" > ${CONFLUENCE_INSTALL_DIR}/confluence/WEB-INF/classes/confluence-init.properties && \
    chown -R "${CONFLUENCE_USER}:${CONFLUENCE_GROUP}" "${CONFLUENCE_INSTALL_DIR}" && \
    cp /tmp/scripts/* ${CONFLUENCE_INSTALL_DIR}/bin && \
    chown -R "${CONFLUENCE_USER}:${CONFLUENCE_GROUP}" "${CONFLUENCE_HOME}" && \
    chmod 755 ${CONFLUENCE_INSTALL_DIR}/bin/entrypoint.*

EXPOSE 8090

VOLUME ${CONFLUENCE_HOME}
USER ${CONFLUENCE_USER}
ENV JAVA_HOME=/usr/lib/jvm/java-11
ENV PATH=${PATH}:${CONFLUENCE_INSTALL_DIR}/bin
WORKDIR ${CONFLUENCE_HOME}
ENTRYPOINT [ "entrypoint.sh" ]