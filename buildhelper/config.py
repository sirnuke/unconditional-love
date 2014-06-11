# config.py - Generates configuration files
# Copyright (c) 2014 Bryan DeGrendel
#
# See LICENSE for licensing information

import argparse
from utilities import *

def do(args, options):
  parser = argparse.ArgumentParser(prog='build.py config',
      description='Configures UnconditionaLove for downloading and compilation')
  parser.add_argument('--arch',
        help='architecture for the build (32 or 64); default is {}'.format(options.get('arch')))
  args = parser.parse_args(args)

  if args.arch:
    if args.arch != '32' and args.arch != '64':
      error('build.py config', "Invalid arch setting of '{}'".format(args.arch))
    options.set('arch', args.arch)

  options.save()
  print 'Saved configuration options'
  print 'TODO: Check for compiler and required tools here'

  print
  print 'Configuration complete'
  exit(0)

