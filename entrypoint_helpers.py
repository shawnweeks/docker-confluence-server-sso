import sys
import os
import logging
import jinja2 as j2
import re

env = {k: v
    for k, v in os.environ.items()}

jenv = j2.Environment(loader=j2.FileSystemLoader('/opt/jinja-templates/'))

def gen_cfg(tmpl, target):
    print("Generating {} from template {}".format(target, tmpl))
    cfg = jenv.get_template(tmpl).render(env)
    with open(target, 'w') as fd:
        fd.write(cfg)