#!/bin/sh

${CC} -m32 -o foo.exe $(mysql_config --cflags) mysqlconst.c
