#!/usr/bin/env python

"""
This script will update the settings.py file to make it more docker and kubernetes friendly.
Such as reading certain config values from the environment.

TODO: Add support for reading from config files that can be stored in configmaps or secrets
      File types should including:
      - YAML
      - JSON
      - ini

TODO: Add SECRET_KEY, it's currently in the Dockerfile

"""

import json
import argparse
import os.path
import re

parser = argparse.ArgumentParser()
parser.add_argument("--dry-run", help="Dry run, do not update file", action="store_true")
parser.add_argument("-f", help="settings.py file location", type=argparse.FileType('r+'), metavar="FILE", dest="file", required=True)
args = parser.parse_args()

newdbconfig = """
DATABASES = {
    'default': {
        'ENGINE': os.environ.get('DB_ENGINE'),
        'HOST': os.environ.get('DB_HOST'),
        'NAME': os.environ.get('DB_NAME'),
        'USER': os.environ.get('DB_USER'),
        'PASSWORD': os.environ.get('DB_PASSWORD'),
        'PORT': os.environ.get('DB_PORT'),
    }
}
"""

# This regex isn't bullet proof, the format isn't something the django team updates
# too often
regex  = r"^DATABASES =((.|\n)*)}$"
result = re.sub(regex, newdbconfig, args.file.read(), 0, re.MULTILINE)

if args.dry_run:
	print(result)
else:
	args.file.seek(0)
	args.file.write(result)
	args.file.close()
