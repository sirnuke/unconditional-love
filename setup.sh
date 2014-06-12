#!/bin/bash
# setup.sh - Downloads, extracts, and configures third party libraries
# Copyright (c) 2014 Bryan DeGrendel
#
# See LICENSE for licensing information

APPNAME="setup.sh"
LIBRARY="all"
ARCHITECTURE="32"
REMOVE="both"
COMMANDS=""
SETUP="download extract patch configure"

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
      echo "$APPNAME: Help goes here!"
      exit 0
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

