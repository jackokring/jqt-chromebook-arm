#!/bin/sh

${CC} -m64 -o foo.exe $(mysql_config --cflags) mysqlconst.c
