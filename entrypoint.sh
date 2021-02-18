#!/bin/bash

set -e
umask 0027

export JVM_SUPPORT_RECOMMENDED_ARGS=${ATL_JAVA_ARGS}
export JVM_MINIMUM_MEMORY=${ATL_MIN_MEMORY}
export JVM_MAXIMUM_MEMORY=${ATL_MAX_MEMORY}

entrypoint.py

if [[ -n ${ATL_TOMCAT_PROXY_NAME} ]]
then
    export CATALINA_OPTS='-Dsynchrony.proxy.enabled=true'
fi

unset "${!ATL_@}"

set +e
flock -x -w 30 ${HOME}/.flock ${CONFLUENCE_INSTALL_DIR}/bin/start-confluence.sh -fg &
CONFLUENCE_PID="$!"

echo "Confluence Started with PID ${CONFLUENCE_PID}"
wait ${CONFLUENCE_PID}

if [[ $? -eq 1 ]]
then
    echo "Confluence Failed to Aquire Lock! Exiting"
    exit 1
fi