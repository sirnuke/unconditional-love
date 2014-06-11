#!/usr/bin/env python
# build.py - Core build system interface
# Copyright (c) 2014 Bryan DeGrendel
#
# See LICENSE for licensing information

import sys

from buildhelper.utilities import *
from buildhelper import config, download

def print_help():
  print "USAGE: build.py command [arguments]"
  print
  print "Where command is one of the following:"
  print "  configure    Configure for downloading and compilation"
  print
  exit(0)

if len(sys.argv) < 2:
  error('build.py', 'Need a command')

cmd = sys.argv[1].lower()

if cmd == '--help' or cmd == '-h' or cmd == 'help':
  print_help()
args = sys.argv[2:]
options = Options()
if cmd == 'configure' or cmd == 'config':
  config.do(args, options)

options.load()
if cmd == 'download':
  download.do(args, options)

error('build.py', "Unknown command %s".format(sys.argv[1]))

