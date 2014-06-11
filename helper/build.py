# download.py - Downloads and extracts third party libraries
# Copyright (c) 2014 Bryan DeGrendel
#
# See LICENSE for licensing information

import argparse, os
from utilities import *

def do(args, options):
  parser = argparse.ArgumentParser(prog='build.py build',
      description='Compiles the whole mess')
  args = parser.parse_args(args)

  root = os.getcwd()
  for library in options.data():
    os.chdir(options.build_directory() + library['directory'])
    print "Building '{}'...".format(library['name'])
    execute(library['build'].format(**options.options()))
    print
    os.chdir(root)

  print 'Done'
  exit(0)

