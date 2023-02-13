coclass 'jlz4'

3 : 0''
lib=. ((UNAME-:'Darwin')+IFUNIX){::'liblz4.dll';'liblz4.so';'liblz4.dylib'
lib1=. ((UNAME-:'Darwin')+IFUNIX){::'liblz4.dll';'liblz4.so.1';'liblz4.1.dylib'
if. IFWIN > IF64 do. lib=. lib1=. 'liblz4_32.dll' end.
if. 1=ftype a1=. jpath '~addons/arc/lz4/lib/',lib do.
 lz4=: a1
elseif. 1=ftype a1=. jpath '~addons/arc/lz4/lib/',lib1 do.
 lz4=: a1
elseif. 1=ftype a1=. (1!:46''),'/',lib do.
 lz4=: a1
elseif. 1=ftype a1=. (1!:46''),'/',lib1 do.
 lz4=: a1
elseif. do.
 lz4=: lib1
end.
EMPTY
)


LZ4F_VERSION=: 100

LZ4_versionNumber=: ('"', lz4, '" LZ4_versionNumber > i')&(15!:0)
LZ4_versionString=: ('"', lz4, '" LZ4_versionString > x')&(15!:0)
LZ4_compress_default=: ('"', lz4, '" LZ4_compress_default i *c *c i i')&(15!:0)
LZ4_decompress_safe=: ('"', lz4, '" LZ4_decompress_safe i *c *c i i')&(15!:0)
LZ4_compressBound=: ('"', lz4, '" LZ4_compressBound > i i')&(15!:0)
LZ4_compress_fast=: ('"', lz4, '" LZ4_compress_fast i *c *c i i i')&(15!:0)
LZ4_sizeofState=: ('"', lz4, '" LZ4_sizeofState i')&(15!:0)
LZ4_compress_fast_extState=: ('"', lz4, '" LZ4_compress_fast_extState i x *c *c i i i')&(15!:0)
LZ4_compress_destSize=: ('"', lz4, '" LZ4_compress_destSize i *c *c *i i')&(15!:0)
LZ4_decompress_safe_partial=: ('"', lz4, '" LZ4_decompress_safe_partial i *c *c i i i')&(15!:0)
LZ4_createStream=: ('"', lz4, '" LZ4_createStream x')&(15!:0)
LZ4_freeStream=: ('"', lz4, '" LZ4_freeStream i x')&(15!:0)
LZ4_resetStream_fast=: ('"', lz4, '" LZ4_resetStream_fast n x')&(15!:0)
LZ4_loadDict=: ('"', lz4, '" LZ4_loadDict i x *c i')&(15!:0)
LZ4_compress_fast_continue=: ('"', lz4, '" LZ4_compress_fast_continue i x *c *c i i i')&(15!:0)
LZ4_saveDict=: ('"', lz4, '" LZ4_saveDict i x *c i')&(15!:0)
LZ4_createStreamDecode=: ('"', lz4, '" LZ4_createStreamDecode x')&(15!:0)
LZ4_freeStreamDecode=: ('"', lz4, '" LZ4_freeStreamDecode i x')&(15!:0)
LZ4_setStreamDecode=: ('"', lz4, '" LZ4_setStreamDecode i x *c i')&(15!:0)
LZ4_decoderRingBufferSize=: ('"', lz4, '" LZ4_decoderRingBufferSize i i')&(15!:0)
LZ4_decompress_safe_continue=: ('"', lz4, '" LZ4_decompress_safe_continue i x *c *c i i')&(15!:0)
LZ4_decompress_safe_usingDict=: ('"', lz4, '" LZ4_decompress_safe_usingDict i *c *c i i *c i')&(15!:0)
LZ4_initStream=: ('"', lz4, '" LZ4_initStream LZ4_stream_t* x size_t')&(15!:0)
LZ4_compress=: ('"', lz4, '" LZ4_compress i *c *c i')&(15!:0)
LZ4_compress_limitedOutput=: ('"', lz4, '" LZ4_compress_limitedOutput i *c *c i i')&(15!:0)
LZ4_compress_withState=: ('"', lz4, '" LZ4_compress_withState i x *c *c i')&(15!:0)
LZ4_compress_limitedOutput_withState=: ('"', lz4, '" LZ4_compress_limitedOutput_withState i x *c *c i i')&(15!:0)
LZ4_compress_continue=: ('"', lz4, '" LZ4_compress_continue i x *c *c i')&(15!:0)
LZ4_compress_limitedOutput_continue=: ('"', lz4, '" LZ4_compress_limitedOutput_continue i x *c *c i i')&(15!:0)
LZ4_uncompress=: ('"', lz4, '" LZ4_uncompress i *c *c i')&(15!:0)
LZ4_uncompress_unknownOutputSize=: ('"', lz4, '" LZ4_uncompress_unknownOutputSize i *c *c i i')&(15!:0)
LZ4_create=: ('"', lz4, '" LZ4_create > x *c')&(15!:0)
LZ4_sizeofStreamState=: ('"', lz4, '" LZ4_sizeofStreamState i')&(15!:0)
LZ4_resetStreamState=: ('"', lz4, '" LZ4_resetStreamState i x *c')&(15!:0)
LZ4_slideInputBuffer=: ('"', lz4, '" LZ4_slideInputBuffer x x')&(15!:0)
LZ4_decompress_safe_withPrefix64k=: ('"', lz4, '" LZ4_decompress_safe_withPrefix64k i *c *c i i')&(15!:0)
LZ4_decompress_fast_withPrefix64k=: ('"', lz4, '" LZ4_decompress_fast_withPrefix64k i *c *c i')&(15!:0)
LZ4_decompress_fast=: ('"', lz4, '" LZ4_decompress_fast i *c *c i')&(15!:0)
LZ4_decompress_fast_continue=: ('"', lz4, '" LZ4_decompress_fast_continue i x *c *c i')&(15!:0)
LZ4_decompress_fast_usingDict=: ('"', lz4, '" LZ4_decompress_fast_usingDict i *c *c i *c i')&(15!:0)
LZ4_resetStream=: ('"', lz4, '" LZ4_resetStream n x')&(15!:0)

LZ4F_isError=: ('"', lz4, '" LZ4F_isError > i x')&(15!:0)
LZ4F_getErrorName=: ('"', lz4, '" LZ4F_getErrorName > x x')&(15!:0)
LZ4F_compressionLevel_max=: ('"', lz4, '" LZ4F_compressionLevel_max > i')&(15!:0)
LZ4F_compressFrameBound=: ('"', lz4, '" LZ4F_compressFrameBound > x x *')&(15!:0)
LZ4F_compressFrame=: ('"', lz4, '" LZ4F_compressFrame x *c x *c x *')&(15!:0)
LZ4F_getVersion=: ('"', lz4, '" LZ4F_getVersion > i')&(15!:0)
LZ4F_createCompressionContext=: ('"', lz4, '" LZ4F_createCompressionContext x *x i')&(15!:0)
LZ4F_freeCompressionContext=: ('"', lz4, '" LZ4F_freeCompressionContext x x')&(15!:0)
LZ4F_compressBegin=: ('"', lz4, '" LZ4F_compressBegin x x *c x *')&(15!:0)
LZ4F_compressBound=: ('"', lz4, '" LZ4F_compressBound > x x *')&(15!:0)
LZ4F_compressUpdate=: ('"', lz4, '" LZ4F_compressUpdate x x *c x *c x *')&(15!:0)
LZ4F_flush=: ('"', lz4, '" LZ4F_flush x x *c x *')&(15!:0)
LZ4F_compressEnd=: ('"', lz4, '" LZ4F_compressEnd x x *c x *')&(15!:0)
LZ4F_createDecompressionContext=: ('"', lz4, '" LZ4F_createDecompressionContext x *x i')&(15!:0)
LZ4F_freeDecompressionContext=: ('"', lz4, '" LZ4F_freeDecompressionContext x x')&(15!:0)
LZ4F_headerSize=: ('"', lz4, '" LZ4F_headerSize > x *c x')&(15!:0)
LZ4F_getFrameInfo=: ('"', lz4, '" LZ4F_getFrameInfo x x * *c *x')&(15!:0)
LZ4F_decompress=: ('"', lz4, '" LZ4F_decompress x x *c *x *c *x *')&(15!:0)
LZ4F_resetDecompressionContext=: ('"', lz4, '" LZ4F_resetDecompressionContext n x')&(15!:0)
checklibrary=: 3 : 0
try. LZ4_versionNumber''
catch. sminfo 'The arc/lz4 binary has not yet been installed.'
end.
EMPTY
)
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
pdst=. 15!:14@<'dst'
rc=. >0{cdrc=. LZ4F_compressBegin ctx; (<pdst); (#dst);< <0
if. LZ4F_isError rc do.
 LZ4F_freeCompressionContext ctx
 (memr (LZ4F_getErrorName rc ),0 _1) 13!:8]3
end.
buf=. rc{.dst
psrc=. 15!:14@<'y'
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
bdsize=. _4 (33 b.) 2b1110000 (17 b.) flg
dst=. ({.a.)#~ 1024 * bdsize{64 64 64 64 64 256 1024 4096
pdst=. 15!:14@<'dst'
'rc ctx ver'=. LZ4F_createDecompressionContext (,00);LZ4F_VERSION
if. LZ4F_isError rc do.
 (memr (LZ4F_getErrorName rc),0 _1) 13!:8[3
end.
ctx=. {.ctx
psrc=. 15!:14@<'y'
isrc=. 0
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
install=: 3 : 0
if. -. IFWIN do. return. end.
require 'pacman'
'rc p'=. httpget_jpacman_ 'http://www.jsoftware.com/download/', z=. 'winlib/',(IF64{::'x86';'x64'),'/liblz4.dll'
if. rc do.
 smoutput 'unable to download: ',z return.
end.
(jpath '~addons/arc/lz4/lib/',IF64{::'liblz4_32.dll';'liblz4.dll') 1!:2~ 1!:1 <p
1!:55 ::0: <p
smoutput 'done'
EMPTY
)
lz4_compress_z_=: lz4_compress_jlz4_
lz4_uncompress_z_=: lz4_uncompress_jlz4_
lz4_compressframe_z_=: lz4_compressframe_jlz4_
lz4_uncompressframe_z_=: lz4_uncompressframe_jlz4_
checklibrary$0
cocurrent 'base'
