#!/usr/bin/python2

from entrypoint_helpers import env, gen_cfg

CONFLUENCE_HOME = env['CONFLUENCE_HOME']
CONFLUENCE_INSTALL_DIR = env['CONFLUENCE_INSTALL_DIR']

gen_cfg('server.xml.j2', '{}/conf/server.xml'.format(CONFLUENCE_INSTALL_DIR))

if 'CROWD_SSO_ENABLED' in env and env['CROWD_SSO_ENABLED'] == 'true':
    gen_cfg('seraph-config.xml.j2', '{}/confluence/WEB-INF/classes/seraph-config.xml'.format(CONFLUENCE_INSTALL_DIR))
    gen_cfg('login.vm.j2', '{}/confluence/login.vm'.format(CONFLUENCE_INSTALL_DIR))
    gen_cfg('crowd.properties.j2', '{}/confluence/WEB-INF/classes/crowd.properties'.format(CONFLUENCE_INSTALL_DIR))