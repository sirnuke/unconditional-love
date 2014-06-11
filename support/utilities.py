# utilities.py - Utility code shared between various configuration and installation scripts
# Copyright (c) 2014 Bryan DeGrendel
#
# See LICENSE for licensing information

import json, os, subprocess

class Options:
  def __init__(self):
    self._data =  [
        {
          'name'      : 'LuaJIT',
          'version'   : '2.0.3',
          'source'    : 'http://luajit.org/download/LuaJIT-2.0.3.tar.gz',
          'archive'   : 'LuaJIT-2.0.3.tar.gz',
          'directory' : 'LuaJIT-2.0.3/',
          'build'     : 'make ARCH={arch}',
          'patches'   : [ 'Makefile.patch' ],
        },
        {
          'name'      : 'Love2D',
          'version'   : '0.9.1',
          'source'    : 'https://bitbucket.org/rude/love/downloads/love-0.9.1-linux-src.tar.gz',
          'archive'   : 'love-0.9.1-linux-src.tar.gz',
          'directory' : 'love-0.9.1/',
          'build'     : 'true',
          'patches'   : [ ],
        },
        {
          'name'      : 'LibSDL',
          'version'   : '2.0.3',
          'source'    : 'http://libsdl.org/release/SDL2-2.0.3.tar.gz',
          'archive'   : 'SDL2-2.0.3.tar.gz',
          'directory' : 'SDL2-2.0.3/',
          'build'     : 'true',
          'patches'   : [ ],
        },
      ]
    self._patches = 'patches/'
    self._build = '.build/'
    self._cache = '.cache/'
    self._output = 'out'
    self._options = {
        'arch' : '32',
        }
    self._filename = '.configuration.json'
    self._version = [2014, 6, 10, 'dev']

    if not os.path.isdir(self._cache):
      os.makedirs(self._cache)
    if not os.path.isdir(self._build):
      os.makedirs(self._build)
    if not os.path.isdir(self._output):
      os.makedirs(self._output)

  def build_directory(self):
    return self._build

  def cache_directory(self):
    return self._cache

  def patches_directory(self):
    return self._patches

  def output_directory(self):
    return self._output

  # Attempt to load the options
  # Returns False on error (typically means source file isn't found)
  def load(self):
    if not os.path.isfile(self._filename):
      error("Options", "'{}' isn't readable! (did you run 'build.py config'?)".format(self._filename))
    try:
      options_cache = open(self._filename, 'r')
      self._options = json.load(options_cache)
      options_cache.close()
    except IOError, e:
      error("Options", "IOError while reading '{}': {}".format(self._filename, e))

  # Save the options
  # Does NOT save the generated configuration values
  def save(self):
    try:
      options_cache = open(self._filename, 'w')
      json.dump(self._options, options_cache)
      options_cache.close()
    except IOError, e:
      error("Options", "IOError while writing '{}': {}".format(self._filename, e))

  # Return the value for an option
  def get(self, key):
    return self._options[key]

  # Set a option
  def set(self, key, value):
    self._options[key] = value

  def data(self):
    return self._data

  def options(self):
    return self._options

# Executes a shell command.  If ignore_results is True, then subprocess exceptions are caught and
# ignored.  This is helpful when the command may return non-zero and succeed.  stdout is returned.
# TODO: Better ignore_results behavior.  Still throw exceptions on certain errors?
def execute(command, ignore_results = False):
  if not ignore_results:
    subprocess.check_call(command, shell=True)
  else:
    try:
      subprocess.check_call(command, shell=True)
    except subprocess.CalledProcessError as e:
      pass

def error(tag, message):
  print "Error! [{}]: {}".format(tag, message)
  exit(1)

