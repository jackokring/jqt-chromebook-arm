require 'arc/zlib arc/lz4'

t1=: 3 : 0
a0=. fread (1!:46''),'/',((UNAME-:'Darwin')+IFUNIX){::'j.dll';'libj.so';'libj.dylib'
echo 'zlib compress Level 1:   ', ":6!:2 'a1=. 1&zlib_compress a0'
echo 'zlib uncompress Leve1 1: ', ":6!:2 'a2=. zlib_uncompress a1'
echo 'zlib sizes: ', ":a0 ,&# a1
assert. a0-:a2
echo 'lz4 compress:   ', ":6!:2 'a1=. lz4_compressframe a0'
echo 'lz4 uncompress: ', ":6!:2 'a2=. lz4_uncompressframe a1'
echo 'lz4 sizes: ', ":a0 ,&# a1
assert. a0-:a2
''
)

t1''
