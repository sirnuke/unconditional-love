#!/bin/bash
# setup.sh - Downloads, extracts, and configures third party libraries
# Copyright (c) 2014 Bryan DeGrendel
#
# See LICENSE for licensing information

shopt -s nullglob

APPNAME="setup.sh"
LIBRARY="all"
PLATFORM="32"
REMOVE="build"
COMMANDS=""
DEFAULT="build"
ALL="download extract build"
LIBRARIES="zlib libpng libjpeg luajit libsdl openal devil modplug ogg vorbis physfs mpg123 gme love2d"

PATCHES_DIR=patches
CACHE_DIR=.cache
EXTRACT_DIR=.build
OUT_DIR=out

if [ ! -d $CACHE_DIR ] ; then mkdir $CACHE_DIR ; fi
if [ ! -d $EXTRACT_DIR ] ; then mkdir $EXTRACT_DIR ; fi
if [ ! -d $OUT_DIR ] ; then mkdir $OUT_DIR ; fi

OUT_DIR_ABSOLUTE=`readlink -f $OUT_DIR`

zlib_set()
{
  LIB_NAME="zlib"
  LIB_VERSION="1.2.8"
  LIB_DOWNLOAD="http://downloads.sourceforge.net/libpng/zlib-1.2.8.tar.xz"
  LIB_ARCHIVE="zlib-1.2.8.tar.xz"
  LIB_DIRECTORY="zlib-1.2.8/"
  LIB_CONFIGURE="zlib_configure"
  LIB_BUILD="zlib_build"
}

zlib_configure()
{
  export CFLAGS="-m$PLATFORM"
  export LDFLAGS="-m$PLATFORM"
  ./configure --prefix=$OUT_DIR_ABSOLUTE
}

zlib_build()
{
  make
  make install
}

libpng_set()
{
  LIB_NAME="libpng"
  LIB_VERSION="1.6.12"
  LIB_DOWNLOAD="http://downloads.sourceforge.net/libpng/libpng-1.6.12.tar.xz"
  LIB_ARCHIVE="libpng-1.6.12.tar.xz"
  LIB_DIRECTORY="libpng-1.6.12/"
  LIB_CONFIGURE="libpng_configure"
  LIB_BUILD="libpng_build"
}

libpng_configure()
{
  export CFLAGS="-m$PLATFORM"
  export LDFLAGS="-m$PLATFORM"
  ./configure --enable-shared --disable-static --prefix=$OUT_DIR_ABSOLUTE \
    --with-zlib-prefix=$OUT_DIR_ABSOLUTE
}

libpng_build()
{
  make
  make install
}

libjpeg_set()
{
  LIB_NAME="libjpeg"
  LIB_VERSION="1.3.1"
  LIB_DOWNLOAD="http://download.sourceforge.net/libjpeg-turbo/1.3.1/libjpeg-turbo-1.3.1.tar.gz"
  LIB_ARCHIVE="libjpeg-turbo-1.3.1.tar.gz"
  LIB_DIRECTORY="libjpeg-turbo-1.3.1/"
  LIB_CONFIGURE="libjpeg_configure"
  LIB_BUILD="libjpeg_build"
}

libjpeg_configure()
{
  export JPEG_LIB_VERSION=80
  export CFLAGS="-m$PLATFORM"
  export LDFLAGS="-m$PLATFORM"
  case $PLATFORM in
    32)
      export ARCH="i686"
      local build="--build i686-linux-gnu"
      ;;
    64)
      export ARCH="x86_64"
      local build="--build x86_64-linux-gnu"
      ;;
    *)
      echo "$APPNAME: Unknown platform $PLATFORM"
      exit 2
      ;;
  esac
  ./configure --enable-shared --disable-static --prefix=$OUT_DIR_ABSOLUTE $build
}

libjpeg_build()
{
  make
  make install
}

luajit_set()
{
  LIB_NAME="LuaJIT"
  LIB_VERSION="2.0.3"
  LIB_DOWNLOAD="http://luajit.org/download/LuaJIT-2.0.3.tar.gz"
  LIB_ARCHIVE="LuaJIT-2.0.3.tar.gz"
  LIB_DIRECTORY="LuaJIT-2.0.3/"
  LIB_CONFIGURE="luajit_configure"
  LIB_BUILD="luajit_build"
}

luajit_configure()
{
  sed -i 's:^ARCH?=.*$:ARCH?='$PLATFORM':' Makefile
  sed -i 's:^export PREFIX=.*$:export PREFIX= '$OUT_DIR_ABSOLUTE':' Makefile
}

luajit_build()
{
  make
  make install
}

libsdl_set()
{
  LIB_NAME="LibSDL"
  LIB_VERSION="2.0.3"
  LIB_DOWNLOAD="http://libsdl.org/release/SDL2-2.0.3.tar.gz"
  LIB_ARCHIVE="SDL2-2.0.3.tar.gz"
  LIB_DIRECTORY="SDL2-2.0.3/"
  LIB_CONFIGURE="libsdl_configure"
  LIB_BUILD="libsdl_build"
}

libsdl_configure()
{
  export CFLAGS="-m$PLATFORM"
  export LDFLAGS="-m$PLATFORM"
  ./configure --enable-shared --enable-static --enable-audio --enable-video --enable-render \
    --enable-events --enable-joystick --enable-haptic --enable-power --enable-filesystem \
    --enable-threads --enable-timers --enable-file --enable-loadso --enable-cpuinfo \
    --enable-assembly --enable-ssemath --enable-mmx --enable-3dnow --enable-sse --enable-sse2 \
    --enable-altivec --enable-oss --enable-alsa --enable-alsa-shared --disable-esd \
    --enable-pulseaudio --enable-pulseaudio-shared --enable-arts --enable-arts-shared --enable-nas \
    --enable-nas-shared --disable-sndio --disable-sndio-shared --enable-diskaudio --enable-dummyaudio \
    --enable-video-wayland --enable-video-wayland-qt-touch --enable-wayland-shared \
    --disable-video-mir --disable-mir-shared --enable-video-x11 --enable-x11-shared \
    --enable-video-x11-xcursor --enable-video-x11-xinerama --enable-video-x11-xinput \
    --enable-video-x11-xrandr --enable-video-x11-scrnsaver --enable-video-x11-xshape \
    --enable-video-x11-vm --disable-video-cocoa --disable-video-directfb --disable-directfb-shared \
    --disable-fusionsound --disable-fusionsound-shared --enable-video-dummy --enable-video-opengl \
    --enable-video-opengles --enable-libudev --enable-dbus --enable-input-tslib --enable-pthreads \
    --enable-pthread-sem --disable-directx --enable-sdl-dlopen --enable-clock_gettime \
    --disable-rpath --disable-render-d3d --prefix=$OUT_DIR_ABSOLUTE
}

libsdl_build()
{
  make
  make install
}

openal_set()
{
  LIB_NAME="OpenAL"
  LIB_VERSION="1.15.1"
  LIB_DOWNLOAD="http://kcat.strangesoft.net/openal-releases/openal-soft-1.15.1.tar.bz2"
  LIB_ARCHIVE="openal-soft-1.15.1.tar.bz2"
  LIB_DIRECTORY="openal-soft-1.15.1/"
  LIB_CONFIGURE="openal_configure"
  LIB_BUILD="openal_build"
}

openal_configure()
{
  export CFLAGS="-m$PLATFORM"
  export LDFLAGS="-m$PLATFORM"
  cmake -DCMAKE_INSTALL_PREFIX=$OUT_DIR_ABSOLUTE -DUTILS=OFF -DEXAMPLES=OFF -DPORTAUDIO=OFF
}

openal_build()
{
  make
  make install
}

devil_set()
{
  LIB_NAME="DevIL"
  LIB_VERSION="1.7.8"
  LIB_DOWNLOAD="http://downloads.sourceforge.net/openil/DevIL-1.7.8.tar.gz"
  LIB_ARCHIVE="DevIL-1.7.8.tar.gz"
  LIB_DIRECTORY="devil-1.7.8/"
  LIB_CONFIGURE="devil_configure"
  LIB_BUILD="devil_build"
}

devil_configure()
{
  export CFLAGS="-m$PLATFORM"
  export CXXFLAGS="-m$PLATFORM"
  export LDFLAGS="-m$PLATFORM"
  export PKG_CONFIG_PATH="$OUT_DIR_ABSOLUTE/lib/pkgconfig"
  case $PLATFORM in
    32) local platform="--enable-x86 --disable-x86_64" ;;
    64) local platform="--disable-x86 --enable-x86_64" ;;
    *)
      echo "$APPNAME: Unknown platform $PLATFORM"
      exit 2
      ;;
  esac
  ./configure $platform --enable-shared --disable-static --enable-release --disable-ILUT \
    --disable-ILU --enable-game-formats=no --disable-blp --enable-bmp --disable-dcx --disable-dds \
    --disable-dicom --disable-doom --disable-exr --disable-fits --disable-gif --disable-hdr \
    --disable-icns --disable-icon --disable-iff --disable-ilbm --enable-jpeg --disable-jp2 \
    --disable-lcms --disable-lif --disable-iwi --disable-mdl --disable-mng --disable-mp3 \
    --disable-pcx --disable-pcd --disable-pic --disable-pix --enable-png --disable-pnm \
    --disable-psd --disable-psp --disable-pxr --disable-raw --disable-rot --disable-sgi \
    --disable-sun --disable-texture --enable-tga --disable-tpl --disable-tiff --disable-utx \
    --disable-vtf --disable-wal --disable-wbmp --disable-wdp --disable-xpm --disable-allegro \
    --disable-directx8 --disable-directx9 --enable-opengl --disable-sdl --disable-w32 \
    --enable-x11 --disable-shm --enable-render --with-examples=no --prefix=$OUT_DIR_ABSOLUTE
}

devil_build()
{
  make
  make install
}

modplug_set()
{
  LIB_NAME="ModPlug"
  LIB_VERSION="0.8.8.5"
  LIB_DOWNLOAD="http://downloads.sourceforge.net/project/modplug-xmms/libmodplug/0.8.8.5/libmodplug-0.8.8.5.tar.gz"
  LIB_ARCHIVE="libmodplug-0.8.8.5.tar.gz"
  LIB_DIRECTORY="libmodplug-0.8.8.5/"
  LIB_CONFIGURE="modplug_configure"
  LIB_BUILD="modplug_build"
}

modplug_configure()
{
  export CFLAGS="-m$PLATFORM"
  export CXXFLAGS="-m$PLATFORM"
  export LDFLAGS="-m$PLATFORM"
  export PKG_CONFIG_PATH="$OUT_DIR_ABSOLUTE/lib/pkgconfig"
  ./configure --disable-static --enable-shared --prefix=$OUT_DIR_ABSOLUTE
}

modplug_build()
{
  make
  make install
}

ogg_set()
{
  LIB_NAME="OGG"
  LIB_VERSION="1.3.4"
  LIB_DOWNLOAD="http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.xz"
  LIB_ARCHIVE="libogg-1.3.2.tar.xz"
  LIB_DIRECTORY="libogg-1.3.2/"
  LIB_CONFIGURE="ogg_configure"
  LIB_BUILD="ogg_build"
}

ogg_configure()
{
  export CFLAGS="-m$PLATFORM"
  export LDFLAGS="-m$PLATFORM"
  export PKG_CONFIG_PATH="$OUT_DIR_ABSOLUTE/lib/pkgconfig"
  ./configure --prefix=$OUT_DIR_ABSOLUTE --disable-static --enable-shared 
}

ogg_build()
{
  make
  make install
}

vorbis_set()
{
  LIB_NAME="Vorbis"
  LIB_VERSION="1.3.4"
  LIB_DOWNLOAD="http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.xz"
  LIB_ARCHIVE="libvorbis-1.3.4.tar.xz"
  LIB_DIRECTORY="libvorbis-1.3.4/"
  LIB_CONFIGURE="vorbis_configure"
  LIB_BUILD="vorbis_build"
}

vorbis_configure()
{
  export CFLAGS="-m$PLATFORM"
  export LDFLAGS="-m$PLATFORM"
  export PKG_CONFIG_PATH="$OUT_DIR_ABSOLUTE/lib/pkgconfig"
  ./configure --prefix=$OUT_DIR_ABSOLUTE --disable-static --enable-shared 
}

vorbis_build()
{
  make
  make install
}

love2d_set()
{
  LIB_NAME="Love2D"
  LIB_VERSION="0.9.1"
  LIB_DOWNLOAD="https://bitbucket.org/rude/love/downloads/love-0.9.1-linux-src.tar.gz"
  LIB_ARCHIVE="love-0.9.1-linux-src.tar.gz"
  LIB_DIRECTORY="love-0.9.1/"
  LIB_CONFIGURE="love2d_configure"
  LIB_BUILD="love2d_build"
}

physfs_set()
{
  LIB_NAME="PhysFS"
  LIB_VERSION="2.0.3"
  LIB_DOWNLOAD="https://icculus.org/physfs/downloads/physfs-2.0.3.tar.bz2"
  LIB_ARCHIVE="physfs-2.0.3.tar.bz2"
  LIB_DIRECTORY="physfs-2.0.3/"
  LIB_CONFIGURE="physfs_configure"
  LIB_BUILD="physfs_build"
}

physfs_configure()
{
  export CFLAGS="-m$PLATFORM"
  export CXXFLAGS="-m$PLATFORM"
  export LDFLAGS="-m$PLATFORM"
  export PKG_CONFIG_PATH="$OUT_DIR_ABSOLUTE/lib/pkgconfig"
  cmake -DCMAKE_INSTALL_PREFIX=$OUT_DIR_ABSOLUTE -DPHYSFS_BUILD_STATIC=false \
    -DPHYSFS_BUILD_TEST=false
}

physfs_build()
{
  make
  make install
}

mpg123_set()
{
  LIB_NAME="mpg123"
  LIB_VERSION="1.20.1"
  LIB_DOWNLOAD="http://downloads.sourceforge.net/project/mpg123/mpg123/1.20.1/mpg123-1.20.1.tar.bz2"
  LIB_ARCHIVE="mpg123-1.20.1.tar.bz2"
  LIB_DIRECTORY="mpg123-1.20.1/"
  LIB_CONFIGURE="mpg123_configure"
  LIB_BUILD="mpg123_build"
}

mpg123_configure()
{
  export CFLAGS="-m$PLATFORM"
  export CPPFLAGS="-m$PLATFORM"
  export LDFLAGS="-m$PLATFORM"
  export PKG_CONFIG_PATH="$OUT_DIR_ABSOLUTE/lib/pkgconfig"
  case $PLATFORM in
    32) local platform="--with-cpu=x86" ;;
    64) local platform="--with-cpu=x86-64" ;;
    *)
      echo "$APPNAME: Unknown platform $PLATFORM"
      exit 2
      ;;
  esac
  ./configure $platform --prefix=$OUT_DIR_ABSOLUTE --disable-static --enable-shared \
    --with-audio=alsa,dummy,oss --with-optimization=3
}

mpg123_build()
{
  make
  make install
}

gme_set()
{
  LIB_NAME="gme"
  LIB_VERSION="1.20.1"
  LIB_DOWNLOAD="https://game-music-emu.googlecode.com/files/game-music-emu-0.6.0.tar.bz2"
  LIB_ARCHIVE="game-music-emu-0.6.0.tar.bz2"
  LIB_DIRECTORY="game-music-emu-0.6.0/"
  LIB_CONFIGURE="gme_configure"
  LIB_BUILD="gme_build"
}

gme_configure()
{
  export CFLAGS="-m$PLATFORM"
  export CXXFLAGS="-m$PLATFORM"
  export LDFLAGS="-m$PLATFORM"
  export PKG_CONFIG_PATH="$OUT_DIR_ABSOLUTE/lib/pkgconfig"
  cmake -DCMAKE_INSTALL_PREFIX=$OUT_DIR_ABSOLUTE
}

gme_build()
{
  make
  make install
}

love2d_configure()
{
  export CFLAGS="-m$PLATFORM -I$OUT_DIR_ABSOLUTE/include -I$OUT_DIR_ABSOLUTE/include/gme"
  export CXXFLAGS="-m$PLATFORM -I$OUT_DIR_ABSOLUTE/include -I$OUT_DIR_ABSOLUTE/include/gme"
  export LDFLAGS="-m$PLATFORM -L$OUT_DIR_ABSOLUTE/lib"
  export PKG_CONFIG_PATH="$OUT_DIR_ABSOLUTE/lib/pkgconfig"
  ./configure --enable-shared --disable-static --disable-osx --enable-gme --with-lua=luajit \
    --prefix=$OUT_DIR_ABSOLUTE
}

love2d_build()
{
  make
  make install
}

print_help()
{
  echo "\
Usage: $APPNAME [options] [command..]

Options:
 -h, --help                 Display this usage message
 -l, --library <library>    Library to use; Love2D, LuaJIT, LibSDL,
                            OpenAL, DevIL, ModPlug, Vorbis, mpg123, gme,
                            zlib, libpng, libjpeg, or all [$LIBRARY]
 -p, --platform <platform>  Platform to target; 32 or 64 [$PLATFORM]
 -r, --remove <type>        Components to remove during a clean; archive,
                            build, or both [$REMOVE]
Commands:
[command..] specifies one or more actions to be executed, in order.

* DOWNLOAD downloads library source archives, if not already cached
* EXTRACT extracts and patches the library source code, if not already extracted
* BUILD runs library configuration scripts and compiles; platform setting is
  only useful for this command (default)
* ALL is equivalent to 'download extract build'
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

case ${REMOVE,,} in
  both)
    REMOVE="build archive"
    ;;
  build)
    REMOVE="build"
    ;;
  archive)
    REMOVE="archive"
    ;;
  *)
    echo "$APPNAME: Invalid clean type '$REMOVE'"
    exit 1
    ;;
esac



while [[ $# > 0 ]] ; do
  case ${1,,} in
    download) COMMANDS="$COMMANDS download" ;;
    extract) COMMANDS="$COMMANDS extract" ;;
    clean) COMMANDS="$COMMANDS clean" ;;
    build|compile) COMMANDS="$COMMANDS build" ;;
    all) COMMANDS="$COMMANDS $ALL" ;;
    *)
      echo "$APPNAME: Unknown command $1"
      exit 1
  esac
  shift
done

if [ -z "$COMMANDS" ] ; then
  COMMANDS="$DEFAULT"
fi

if [ "$LIBRARY" == "all" ]; then
  LIBRARY="$LIBRARIES"
fi

for lib in $LIBRARY ; do
  case ${lib,,} in
    luajit) luajit_set ;;
    libsdl) libsdl_set ;;
    love2d) love2d_set ;;
    openal) openal_set ;;
    devil)  devil_set  ;;
    modplug) modplug_set ;;
    vorbis) vorbis_set ;;
    physfs) physfs_set ;;
    ogg) ogg_set ;;
    mpg123) mpg123_set ;;
    gme) gme_set ;;
    zlib) zlib_set ;;
    libjpeg) libjpeg_set ;;
    libpng) libpng_set ;;
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
          echo "Extracting and patching $LIB_NAME..."
          tar -C $EXTRACT_DIR -xf $CACHE_DIR/$LIB_ARCHIVE
          for patch in $PATCHES_DIR/$LIB_DIRECTORY/*.patch ; do
            patch -p 0 -t -u -r - --forward -d $EXTRACT_DIR < $patch
          done
        else
          echo "$LIB_NAME already extracted (remove with CLEAN command)"
        fi
        ;;
      build)
        echo "Building $LIB_NAME..."
        pushd $EXTRACT_DIR/$LIB_DIRECTORY > /dev/null
        $LIB_CONFIGURE
        $LIB_BUILD
        popd > /dev/null
        ;;
      clean)
        echo "Removing $LIB_NAME ($REMOVE)..."
        for remove in $REMOVE ; do
          case $remove in
            build)
              pushd $EXTRACT_DIR > /dev/null
              rm -r $LIB_DIRECTORY
              popd > /dev/null
              ;;
            archive)
              pushd $CACHE_DIR > /dev/null
              rm $LIB_ARCHIVE
              popd > /dev/null
              ;;
            *)
              echo "$APPNAME: Unhandled remove type $remove"
              exit 2
              ;;
          esac
        done
        ;;
      *)
        echo "$APPNAME: Internal error: Unhandled command $cmd"
        exit 2
    esac
  done
  echo
done

