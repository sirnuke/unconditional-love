#!/bin/bash
# setup.sh - Downloads, extracts, and configures third party libraries
# Copyright (c) 2014 Bryan DeGrendel
#
# See LICENSE for licensing information

APPNAME="setup.sh"
LIBRARY="all"
PLATFORM="32"
REMOVE="source"
COMMANDS=""
SETUP="download extract patch configure"

set_luajit()
{
  LIB_NAME="LuaJIT"
  LIB_VERSION="2.0.3"
  LIB_DOWNLOAD="http://luajit.org/download/LuaJIT-2.0.3.tar.gz"
  LIB_ARCHIVE="LuaJIT-2.0.3.tar.gz"
  LIB_DIRECTORY="LuaJIT-2.0.3/"
}

set_libsdl()
{
  LIB_NAME="LibSDL"
  LIB_VERSION="2.0.3"
  LIB_SOURCE="http://libsdl.org/release/SDL2-2.0.3.tar.gz"
  LIB_ARCHIVE="SDL2-2.0.3.tar.gz"
  LIB_DIRECTORY="SDL2-2.0.3/"
}

set_love2d()
{
  LIB_NAME="Love2D"
  LIB_VERSION="0.9.1"
  LIB_SOURCE="https://bitbucket.org/rude/love/downloads/love-0.9.1-linux-src.tar.gz"
  LIB_ARCHIVE="love-0.9.1-linux-src.tar.gz"
  LIB_DIRECTORY="love-0.9.1/"
}


print_help()
{
  echo "\
Usage: $APPNAME [options] [command..]

Options:
 -h, --help                 Display this usage message
 -l, --library <library>    Library to use; Love2D, LuaJIT, LibSDL,
                            or all [$LIBRARY]
 -p, --platform <platform>  Platform to target; 32 or 64 [$PLATFORM]
 -r, --remove <type>        Components to remove during a clean; source,
                            extract, or both [$REMOVE]
Commands:
[command..] specifies one or more actions to be executed, in order.

* DOWNLOAD downloads library source archives, if not already cached
* EXTRACT extracts the library source code, if not already extracted
* PATCH applies any local patches, and will print errors if already
  patched
* CONFIGURE runs any library configuration scripts; platform setting is
  only useful for this command
* SETUP is equivalent to 'download extract patch configure' (default)
* CLEAN removes source archives, or extracted source, or both; remove
  setting is only valid for this command"
  exit 0
}

getopt -T
if [ $? -ne 4 ] ; then
  echo "$APPNAME: Requires GNU getopt application (for now)" 
  exit 1
fi

if ! options=$(getopt --options hl:a:r: --long help,library:,architecture:,remove: --name $APPNAME -- "$@") ; then
  exit 1
fi

eval set -- "$options"

while [[ $# > 0 ]] ; do
  case $1 in
    -h|--help)
      print_help
      ;;
    -l|--library)
      LIBRARY="$2"
      shift
      ;;
    -a|--architecture)
      ARCHITECTURE="$1"
      shift
      ;;
    -r|--remove)
      REMOVE="$1"
      shift
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "$APPNAME: Internal error: unhandled flag $1"
      exit 2
      ;;
  esac
  shift
done

while [[ $# > 0 ]] ; do
  case ${1,,} in
    download) COMMANDS="$COMMANDS download" ;;
    extract) COMMANDS="$COMMANDS extract" ;;
    patch) COMMANDS="$COMMANDS patch" ;;
    configure) COMMANDS="$COMMANDS configure" ;;
    clean) COMMANDS="$COMMANDS clean" ;;
    setup) COMMANDS="$COMMANDS $SETUP" ;;
    *)
      echo "$APPNAME: Unknown command $1"
      exit 1
  esac
  shift
done

if [ -z "$COMMANDS" ] ; then
  COMMANDS="$SETUP"
fi

if [ "$LIBRARY" == "all" ]; then
  LIBRARY="luajit love2d libsdl"
fi

for lib in $LIBRARY ; do
  case ${lib,,} in
    luajit) set_luajit ;;
    libsdl) set_libsdl ;;
    love2d) set_love2d ;;
    *)
      echo "$APPNAME: Unknown library $lib"
      exit 1
  esac
  for cmd in $COMMANDS ; do
    case $cmd in
      download)
        ;;
      extract)
        ;;
      patch)
        ;;
      configure)
        ;;
      clean)
        ;;
      setup)
        ;;
      *)
        echo "$APPNAME: Internal error: Unhandled command $cmd"
        exit 2
    esac
  done
done

