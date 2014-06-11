# download.py - Downloads and extracts third party libraries
# Copyright (c) 2014 Bryan DeGrendel
#
# See LICENSE for licensing information

import argparse, os
from utilities import *

def do(args, options):
  parser = argparse.ArgumentParser(prog='build.py download',
      description='Downloads third party libraries, and extracts them')
  parser.add_argument('--clean', action='store_true', help='removed cached archives')
  args = parser.parse_args(args)

  os.chdir(options.cache_directory())
  for library in options.data():
    if args.clean:
      if os.path.isfile(library['archive']):
        print "Removing '{}'".format(library['archive'])
        os.remove(library['archive'])
      else:
        print "'{}' not downloaded".format(library['archive'])
    else:
      if not os.path.isfile(library['archive']):
        print "Downloading '{}'...".format(library['archive'])
        execute("wget {}".format(library['source']))
      else:
        print "'{}' already downloaded".format(library['archive'])

  exit(1)


