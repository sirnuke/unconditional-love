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

for cmd in $COMMANDS ; do
  echo $cmd
done

