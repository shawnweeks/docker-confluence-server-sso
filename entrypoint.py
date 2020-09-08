#!/usr/bin/python3

from entrypoint_helpers import env, gen_cfg, set_props

CONFLUENCE_HOME = env['CONFLUENCE_HOME']
CONFLUENCE_INSTALL_DIR = env['CONFLUENCE_INSTALL_DIR']

gen_cfg('server.xml.j2', f'{CONFLUENCE_INSTALL_DIR}/conf/server.xml')

if 'CROWD_SSO_ENABLED' in env and env['CROWD_SSO_ENABLED'] == 'true':
    gen_cfg('seraph-config.xml.j2', f'{CONFLUENCE_INSTALL_DIR}/confluence/WEB-INF/classes/seraph-config.xml')
    gen_cfg('login.vm.j2', f'{CONFLUENCE_INSTALL_DIR}/confluence/login.vm')
    gen_cfg('crowd.properties.j2', f'{CONFLUENCE_INSTALL_DIR}/confluence/WEB-INF/classes/crowd.properties')