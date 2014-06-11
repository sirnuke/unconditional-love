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

  cache = options.cache_directory()

  for library in options.data():
    archive = cache + library['archive']
    if args.clean:
      if os.path.isfile(archive):
        print "Removing '{}'".format(archive)
        os.remove(archive)
    else:
      if not os.path.isfile(archive):
        print "Downloading '{}'...".format(library['name'])
        execute("wget --directory-prefix={} {}".format(cache, library['source']))
      else:
        print "'{}' already downloaded".format(library['name'])
      if not os.path.isdir(library['directory']):
        print "Extracting '{}'...".format(library['name'])
        execute("tar -xf {}".format(archive))
      else:
        print "'{}' already extracted".format(library['name'])

  print
  print 'Done'
  exit(0)


