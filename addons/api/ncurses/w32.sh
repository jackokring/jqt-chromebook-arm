#!/bin/sh

export CFLAGS="-D_POSIX_SOURCE -I$HOME/mingw64/pdcurses -D_XOPEN_SOURCE_EXTENDED -DPDC_WIDE"
${CC} -m32 -o foo.exe ${CFLAGS} const.c
