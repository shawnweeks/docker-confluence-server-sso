#!/bin/bash

set -e
umask 0027

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

export JAVA_OPTS="${JAVA_OPTS}"
export CATALINA_OPTS="${CATALINA_OPTS}"

shutdownCleanup() {
    if [[ -f ${CONFLUENCE_HOME}/lock ]]
    then
        echo "Cleaning Up Confluence Locks"
        rm ${CONFLUENCE_HOME}/lock
    fi
}

entrypoint.py
trap "shutdownCleanup" INT
${CONFLUENCE_INSTALL_DIR}/bin/start-confluence.sh -fg