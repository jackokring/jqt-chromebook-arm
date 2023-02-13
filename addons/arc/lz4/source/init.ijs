NB. init.ijs

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

NB. =========================================================
checklibrary=: 3 : 0
try. LZ4_versionNumber''
catch. sminfo 'The arc/lz4 binary has not yet been installed.'
end.
EMPTY
)
