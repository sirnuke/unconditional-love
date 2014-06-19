Required Packages
==========================

Ubuntu 14.04:

sudo apt-get install build-essential gcc-4.8-multilib g++-4.8-multilib \
  cmake wget libjpeg8-dev libjpeg8:i386 zlib1g-dev zlib1g:i386 \
  libgl1-mesa-glx:i386 libgl1-mesa-dev libpng12-0:i386 libpng12-dev \
  libasound2-dev libasound2:i386 libltdl7:i386 libltdl-dev

A few words on Symlinks
=============

Since you can't have the i386 and amd64 version of development packages
installed at the same time (typically), you'll need to manually
symlink some things, and copy over a few headers.  libjpeg and zlib
both have headers installed to /usr/include/x86\_64-linux-gnu (jconfig.h
and zconf.h).  As far as I can tell, these are identical in the i386
platforms.  You'll need to create /usr/include/i386-linux-gnu (if it
doesn't already exist), and copy or symlink these two headers into it.
The -dev packages also symlink shared libraries, which will be to be
replicated in libjpeg, zlib, libpng, and libgl.  Note symlinks in
/usr/lib/x86\_64-linux-gnu that do not have a corresponding link in
/usr/lib/i386-linux-gnu, and create them with ln -s.

In the future, zlib, libjpeg, and libpng might be added to the build
system.  For now, the three are reasonably safe to expect on the user's
system.  libgl is unlikely to be safely packaged, but should be fairly
dependable.

A few more on libtool
==============

It appears the libtool file for libltdl-dev
(/usr/lib/x86\_64-linux-gnu/libltdl.la) breaks everything forever.
More specifically, libtool in mpg123 finds that file and attempts
to force the use of the 64-bit libltdl.  While building mpg123, the
easiest workaround is to simply rename libltdl.la.  As there's nothing
particularly weird about linking to libltdl, it doesn't appear necessary
for compilation.

