#!/bin/sh

export CFLAGS="-D_POSIX_SOURCE -I/usr/include/ncursesw -D_XOPEN_SOURCE_EXTENDED"
gcc -m64 -o foo ${CFLAGS} const.c
