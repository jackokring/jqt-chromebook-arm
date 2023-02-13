NB. cover verbs for compress/decompress stream with lz4 wrapper

lz4_compress=: 3 : 0
if. 0=#@$y do. y=. ,y end.
if. 16b7e000000<#y do. ('data size too large') 13!:8]3 end.
rc=. LZ4_compressBound #y
if. 0>:rc do. ('error: ',":rc) 13!:8]3 end.
dst=. rc#{.a.
'rc dst'=. 0 2{cdrc=. LZ4_compress_default y; dst; (#y); rc
if. rc>0 do.
 rc{.dst
else.
 ('error: ',":rc) 13!:8]3
end.
)

NB. x. buffer size
lz4_uncompress=: 3 : 0
0 lz4_uncompress y
:
if. 0=#@$y do. y=. ,y end.
if. 0=x do.
 dst=. (2*10>.#y)#{.a.
else.
 dst=. x#{.a.
end.
whilst. rc<0 do.
 'rc dst'=. 0 2{cdrc=. LZ4_decompress_safe y; dst; (#y); (#dst)
 if. rc>:0 do.
  break.
 else.
  if. (0~:x) +. (_20<rc) +. (16b7e000000=#dst) +. (16b7e000000<2*#dst) +. (#dst)>256*#y do.
   ('error: ',":rc) 13!:8]3
  end.
  dst=. (16b7e000000<.2*#dst)#{.a.
 end.
end.
rc{.dst
)

NB. Block Independence flag: 0
lz4_compressframe0=: 3 : 0
if. 0=#@$y do. y=. ,y end.
rc=. LZ4F_compressFrameBound (#y);<<0
if. LZ4F_isError rc do.
 (memr (LZ4F_getErrorName rc ),0 _1) 13!:8]3
end.
dst=. rc#{.a.
'rc dst'=. 0 1{cdrc=. LZ4F_compressFrame dst; (#dst); y; (#y); <<0
if. LZ4F_isError rc do.
 (memr (LZ4F_getErrorName rc),0 _1) 13!:8]3
else.
 rc{.dst
end.
)

NB. Block Independence flag: 1
lz4_compressframe=: 3 : 0
if. 0=#@$y do. y=. ,y end.
'rc ctx ver'=. LZ4F_createCompressionContext (,00);LZ4F_VERSION
if. LZ4F_isError rc do.
 (memr (LZ4F_getErrorName ret),0 _1) 13!:8[3
end.
ctx=. {.ctx
chunk=. 1024*1024
rc=. LZ4F_compressFrameBound chunk;<<0
if. LZ4F_isError rc do.
 LZ4F_freeCompressionContext ctx
 (memr (LZ4F_getErrorName rc ),0 _1) 13!:8]3
end.
dst=. rc#{.a.
pdst=. 15!:14@<'dst'  NB. data address from name
rc=. >0{cdrc=. LZ4F_compressBegin ctx; (<pdst); (#dst);< <0
if. LZ4F_isError rc do.
 LZ4F_freeCompressionContext ctx
 (memr (LZ4F_getErrorName rc ),0 _1) 13!:8]3
end.
buf=. rc{.dst
psrc=. 15!:14@<'y'  NB. data address from name
isrc=. 0
p=. 0
whilst. do.
 ln=. 0 >. chunk <. (#y)-p*chunk
 if. 0=ln do. break. end.
 p=. 1+p
 rc=. >0{cdrc=. LZ4F_compressUpdate ctx; (<pdst); (#dst); (<isrc+psrc); ln;< <0
 if. LZ4F_isError rc do.
  LZ4F_freeCompressionContext ctx
  (memr (LZ4F_getErrorName rc ),0 _1) 13!:8]3
 end.
 buf=. buf, rc{.dst
 isrc=. isrc+ln
end.
rc=. >0{cdrc=. LZ4F_compressEnd ctx; (<pdst); (#dst);< <0
if. LZ4F_isError rc do.
 LZ4F_freeCompressionContext ctx
 (memr (LZ4F_getErrorName rc ),0 _1) 13!:8]3
end.
buf=. buf, rc{.dst
LZ4F_freeCompressionContext ctx
buf
)

lz4_uncompressframe=: 3 : 0
if. 0=#@$y do. y=. ,y end.
if. 11>#y do. ('invalid lz4 frame') 13!:8]3 end.
if. (|.16b18 16b4d 16b22 16b04{a.) -.@-:(i.4){y do. ('bad magic number') 13!:8]3 end.
'flg bd'=. a.i.4 5{y
NB. if. 1 ~: _6 (33 b.) 2b11000000 (17 b.) flg do. ('bad version number') 13!:8]3 end.
NB. bidp=. 0 ~: 2b100000 (17 b.) flg
NB. bchecksum=. 0 ~: 2b10000 (17 b.) flg
NB. csize=. 0 ~: 2b1000 (17 b.) flg
NB. dictid=. 0 ~: 2b1 (17 b.) flg
bdsize=. _4 (33 b.) 2b1110000 (17 b.) flg
dst=. ({.a.)#~ 1024 * bdsize{64 64 64 64 64 256 1024 4096
pdst=. 15!:14@<'dst'  NB. data address from name
'rc ctx ver'=. LZ4F_createDecompressionContext (,00);LZ4F_VERSION
if. LZ4F_isError rc do.
 (memr (LZ4F_getErrorName rc),0 _1) 13!:8[3
end.
ctx=. {.ctx
psrc=. 15!:14@<'y'  NB. data address from name
isrc=. 0              NB. offset
buf=. ''
whilst. 0~:rc do.
 'rc ctx ldst lsrc'=. 0 1 3 5{ cdrc=. LZ4F_decompress ctx; (<pdst); (,#dst); (<isrc+psrc); (,isrc-~#y) ;< <0
 if. LZ4F_isError rc do.
  LZ4F_freeDecompressionContext ctx
  (memr (LZ4F_getErrorName rc),0 _1) 13!:8[3
 end.
 buf=. buf, ({.ldst){.dst
 isrc=. isrc+({.lsrc)
end.
LZ4F_freeDecompressionContext ctx
buf
)
