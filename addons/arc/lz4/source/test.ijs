NB. dbr 1
load 'arc/lz4'
NB. load '../lz4.ijs'

test1=: 3 : 0
for_i. 1 10 100 1e4 1e6 1e8 do.
 b=. lz4_compress a=. i$a.
 c=. lz4_uncompress b
 assert. a-:c
 b=. lz4_compress a=. a.{~?i#256
 c=. lz4_uncompress b
 assert. a-:c
end.
EMPTY
)

test2=: 3 : 0
for_i. 1 10 100 1e4 1e6 1e8 do.
 b=. lz4_compressframe a=. i$a.
 c=. lz4_uncompressframe b
 assert. a-:c
 b=. lz4_compressframe a=. a.{~?i#256
 c=. lz4_uncompressframe b
 assert. a-:c
end.
EMPTY
)

test1 ''
test2 ''
4!:55 ;:'test1 test2'
