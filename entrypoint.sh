#!/bin/bash

set -e
umask 0027

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

export JAVA_OPTS="${JAVA_OPTS}"
export CATALINA_OPTS="${CATALINA_OPTS}"

startup() {
    echo Starting Confluence Server
    ${CONFLUENCE_INSTALL_DIR}/bin/start-confluence.sh
    sleep 15
    tail -n +1 -F ${CONFLUENCE_HOME}/logs/atlassian-confluence.log
}

shutdown() {
    echo Stopping Confluence Server
    ${CONFLUENCE_INSTALL_DIR}/bin/stop-confluence.sh
}

trap "shutdown" INT
entrypoint.py
startup