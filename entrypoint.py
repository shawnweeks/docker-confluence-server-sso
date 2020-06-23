#!/usr/bin/python3

import shutil
from entrypoint_helpers import env, gen_cfg, str2bool, start_app

SSO_ENABLED = env['sso_enabled']

print("Checking for SSO env variable")
if SSO_ENABLED.lower() == 'true':
    print("Copying SSO related files")
    gen_cfg('login.vm.j2', '/opt/atlassian/confluence/confluence/login.vm')
    shutil.copyfile("/opt/atlassian/sso/seraph-config.xml.j2",
                    "/opt/atlassian/etc/seraph-config.xml.j2")
    shutil.copyfile("/opt/atlassian/sso/crowd.properties",
                    "/opt/atlassian/confluence/confluence/WEB-INF/classes/crowd.properties")

RUN_USER = env['run_user']
RUN_GROUP = env['run_group']
CONFLUENCE_INSTALL_DIR = env['confluence_install_dir']
CONFLUENCE_HOME = env['confluence_home']

gen_cfg('server.xml.j2', f'{CONFLUENCE_INSTALL_DIR}/conf/server.xml')
gen_cfg('seraph-config.xml.j2',
        f'{CONFLUENCE_INSTALL_DIR}/confluence/WEB-INF/classes/seraph-config.xml')
gen_cfg('confluence-init.properties.j2',
        f'{CONFLUENCE_INSTALL_DIR}/confluence/WEB-INF/classes/confluence-init.properties')
gen_cfg('confluence.cfg.xml.j2', f'{CONFLUENCE_HOME}/confluence.cfg.xml',
        user=RUN_USER, group=RUN_GROUP, overwrite=False)

start_app(f'{CONFLUENCE_INSTALL_DIR}/bin/start-confluence.sh -fg',
          CONFLUENCE_HOME, name='Confluence')
