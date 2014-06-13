#!/bin/bash
# setup.sh - Downloads, extracts, and configures third party libraries
# Copyright (c) 2014 Bryan DeGrendel
#
# See LICENSE for licensing information

shopt -s nullglob

APPNAME="setup.sh"
LIBRARY="all"
PLATFORM="32"
REMOVE="source"
COMMANDS=""
SETUP="download extract patch configure"
MAGIC="#UNCONDITIONAL#LOVE#"

PATCHES_DIR=patches
CACHE_DIR=cache
EXTRACT_DIR=build
OUT_DIR=out

if [ ! -d $CACHE_DIR ] ; then mkdir $CACHE_DIR ; fi
if [ ! -d $EXTRACT_DIR ] ; then mkdir $EXTRACT_DIR ; fi
if [ ! -d $OUT_DIR ] ; then mkdir $OUT_DIR ; fi

luajit_set()
{
  LIB_NAME="LuaJIT"
  LIB_VERSION="2.0.3"
  LIB_DOWNLOAD="http://luajit.org/download/LuaJIT-2.0.3.tar.gz"
  LIB_ARCHIVE="LuaJIT-2.0.3.tar.gz"
  LIB_DIRECTORY="LuaJIT-2.0.3/"
  LIB_CONFIGURE="luajit_configure"
}

luajit_configure()
{
  sed -i 's:^ARCH.*'$MAGIC'.*$:ARCH?='$PLATFORM' '$MAGIC':' Makefile
  sed -i 's:^export PREFIX.*'$MAGIC'.*$:export PREFIX=../../'$OUT_DIR' '$MAGIC':' Makefile
}

libsdl_set()
{
  LIB_NAME="LibSDL"
  LIB_VERSION="2.0.3"
  LIB_DOWNLOAD="http://libsdl.org/release/SDL2-2.0.3.tar.gz"
  LIB_ARCHIVE="SDL2-2.0.3.tar.gz"
  LIB_DIRECTORY="SDL2-2.0.3/"
  LIB_CONFIGURE="true"
}

love2d_set()
{
  LIB_NAME="Love2D"
  LIB_VERSION="0.9.1"
  LIB_DOWNLOAD="https://bitbucket.org/rude/love/downloads/love-0.9.1-linux-src.tar.gz"
  LIB_ARCHIVE="love-0.9.1-linux-src.tar.gz"
  LIB_DIRECTORY="love-0.9.1/"
  LIB_CONFIGURE="true"
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

if ! options=$(getopt --options hl:p:r: --long help,library:,platform:,remove: --name $APPNAME -- "$@") ; then
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
    -p|--platform)
      PLATFORM="$2"
      shift
      ;;
    -r|--remove)
      REMOVE="$2"
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
    luajit) luajit_set ;;
    libsdl) libsdl_set ;;
    love2d) love2d_set ;;
    *)
      echo "$APPNAME: Unknown library $lib"
      exit 1
  esac
  for cmd in $COMMANDS ; do
    case $cmd in
      download)
        pushd $CACHE_DIR > /dev/null
        if [ ! -f "$LIB_ARCHIVE" ] ; then
          echo "Downloading $LIB_NAME..."
          wget $LIB_DOWNLOAD
        else
          echo "$LIB_NAME already downloaded (remove with CLEAN command)"
        fi
        popd > /dev/null
        ;;
      extract)
        if [ ! -d "$EXTRACT_DIR/$LIB_DIRECTORY" ] ; then
          echo "Extracting $LIB_NAME..."
          tar -C $EXTRACT_DIR -zxf $CACHE_DIR/$LIB_ARCHIVE
        else
          echo "$LIB_NAME already extracted (remove with CLEAN command)"
        fi
        ;;
      patch)
        echo "Patching $LIB_NAME..."
        for patch in $PATCHES_DIR/$LIB_DIRECTORY/*.patch ; do
          patch -p 0 -t -u -r - --forward -d $EXTRACT_DIR < $patch
        done
        ;;
      configure)
        echo "Configuring $LIB_NAME..."
        pushd $EXTRACT_DIR/$LIB_DIRECTORY > /dev/null
        $LIB_CONFIGURE
        popd > /dev/null
        ;;
      clean)
        ;;
      *)
        echo "$APPNAME: Internal error: Unhandled command $cmd"
        exit 2
    esac
  done
  echo
done

