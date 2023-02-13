cocurrent 'jfiles'

NB. jfiles

NB. j component file functions
NB.
NB. this script supports j component file systems.
NB.
NB. See jfiles.txt for more information.

NB. main functions:
NB.
NB.   jappend
NB.   jcreate
NB.   jdup
NB.   jerase
NB.   jread
NB.   jreplace
NB.   jsize
NB.
NB. other functions:
NB.
NB.   jopen
NB.   jclose
NB.   jseqno
NB.
NB. header structure:
NB.
NB.   [0]   v  version
NB.   [1]   s  starting component
NB.   [2]   c  number of components
NB.   [3]   l  file length
NB.   [4]   d  directory pointer
NB.   [5]   f  freelist pointer
NB.   [6]   q  sequence number
NB.
NB. error results:
NB.
NB.   _1   file not found
NB.   _2   invalid component
NB.   _3   invalid data
NB.   _4   host access error

NB.*jcreate v create jfile, jcreate 'dat'
NB.*jappend v append to jfile, (<i.2 3) jappend 'dat'
NB.*jdup v duplicate jfile, 'new' jdup 'dat'
NB.*jerase v erase jfile, jerase 'dat'
NB.*jread v read jfile, jread 'dat';2
NB.*jreplace v replace in jfile, ('new value';123) jreplace 'dat';2 5
NB.*jsize v return size of jfile, jsize 'dat'

NB. keyfiles

NB. j component file functions
NB. keyed-file database functions
NB.
NB. this script supports simple keyed file systems.
NB.
NB. This is a modification and enhancement of the "kfiles" system.
NB.
NB. See keyfiles.txt for more information.

NB.*keycreate v    create file
NB.*keydir v       keyword directory
NB.*keydrop v      drop keywords
NB.*keyerase v     erase file
NB.*keyread v      read data
NB.*keywrite v     write data
NB.*keyreadx v     read extra data
NB.*keywritex v    write extra data

