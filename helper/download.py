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

  for library in options.data():
    archive = options.cache_directory() + library['archive']
    if args.clean:
      if os.path.isfile(archive):
        print "Removing '{}'".format(archive)
        os.remove(archive)
    else:
      if not os.path.isfile(archive):
        print "Downloading '{}'...".format(library['name'])
        execute("wget --directory-prefix={} {}".format(options.cache_directory(),
          library['source']))
      else:
        print "'{}' already downloaded".format(library['name'])
      if not os.path.isdir(options.build_directory() + library['directory']):
        print "Extracting '{}'...".format(library['name'])
        execute("tar -C {} -xf {}".format(options.build_directory(), archive))
        print "Applying patches to '{}'...".format(library['name'])
        for patch in library['patches']:
          execute("patch -d {} -p 0 < {}".format(options.build_directory(),
            options.patches_directory() + library['directory'] + patch))
      else:
        print "'{}' already extracted".format(library['name'])
      print

  print 'Done'
  exit(0)


