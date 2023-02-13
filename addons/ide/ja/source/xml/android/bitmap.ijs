
NB. =========================================================
OR=: 23 b./
NOTALPHA=: 16bffffff
ALPHA=: 0 (26 b.) NOTALPHA

NB. =========================================================
NB. pixbuf utilities
NB. =========================================================
NB. new verb for reading file images to argb matrix using android
readimg=: 3 : 0

jniCheck bm=. 'android.graphics.BitmapFactory' ('decodeFile (LString;)LBitmap;' jniStaticMethod)~ <y
if. 0=bm do. 0 0$0 return. end.
jniCheck w=. bm ('getWidth ()I' jniMethod)~ ''
jniCheck h=. bm ('getHeight ()I' jniMethod)~ ''
d=. (w*h)#2-2

jniCheck colors=. >@{. NewIntArray <#d
NB. public void getPixels (int[] pixels, int offset, int stride, int x, int y, int width, int height)
jniCheck bm ('getPixels ([IIIIIII)V' jniMethod)~ colors;0;w;0;0;w;h
jniCheck d=. >@{: GetIntArrayRegion colors;0;(#d);d

NB. cleanup
jniCheck DeleteLocalRef"0 colors;bm

d=. fliprgb^:(-.RGBSEQ_j_) d (17 b.) NOTALPHA
(h,w)$d
)

NB. =========================================================
NB. new verb for reading file images from memory to argb matrix using android
getimg=: 3 : 0
jniCheck ba=. >@{. NewByteArray <#y
jniCheck SetByteArrayRegion ba;0;(#y);y
bm=. 'android.graphics.BitmapFactory' ('decodeByteArray ([BII)LBitmap;' jniStaticMethod)~ ba;0;#y
jniCheck DeleteLocalRef <ba
if. 0=bm do. 0 0$0 return. end.

jniCheck bm=. 'android.graphics.BitmapFactory' ('decodeFile (LString;)LBitmap;' jniStaticMethod)~ <y
if. 0=bm do. 0 0$0 return. end.
jniCheck w=. bm ('getWidth ()I' jniMethod)~ ''
jniCheck h=. bm ('getHeight ()I' jniMethod)~ ''
d=. (w*h)#2-2

jniCheck colors=. >@{. NewIntArray <#d
NB. public void getPixels (int[] pixels, int offset, int stride, int x, int y, int width, int height)
jniCheck bm ('getPixels ([IIIIIII)V' jniMethod)~ colors;0;w;0;0;w;h
jniCheck d=. >@{: GetIntArrayRegion colors;0;(#d);d

NB. cleanup
jniCheck DeleteLocalRef"0 colors;bm

d=. fliprgb^:(-.RGBSEQ_j_) d (17 b.) NOTALPHA
(h,w)$d
)

CompressFormat_JPEG=: 0
CompressFormat_PNG=: 1
CompressFormat_WEBP=: 2

NB. =========================================================
NB. write image data to file
NB. x rgb matrix
NB. y filename [ ; 'jpeg|png|ico|bmp' [ ; 'quality|compression' ; '[0,100]|[0,9]' ]]
writeimg=: 4 : 0
'h w'=. $x
d=. ,x
if. 2> #y=. boxopen y do.
  f=. >@{.y
  type=. tolower }. (}.~ i:&'.') f
  opt=. ''
elseif. 2= #y do.
  f=. >@{.y
  type=. >1{y
  opt=. ''
elseif. do.
  f=. utf8 >@{.y
  type=. >1{y
  opt=. 2{.2}.y
  opt=. (":&.>1{opt) 1}opt
end.
quality=. 75
if. ('jpeg'-:type)+.('jpg'-:type) do. type=. CompressFormat_JPEG
elseif. 'png'-:type do. type=. CompressFormat_PNG
elseif. 'webp'-:type do. type=. CompressFormat_WEBP
elseif. do. EMPTY return.
end.
d=. fliprgb^:(RGBSEQ_j_) d
d=. d OR ALPHA
if. IF64 do. d=. 2 ic d end.
NB. create new pixbuf from data
NB. public static Bitmap createBitmap (int[] colors, int offset, int stride, int width, int height, Bitmap.Config config)
jniCheck colors=. >@{. NewIntArray <#d
jniCheck SetIntArrayRegion colors;0;(#d);d
jniCheck bm=. ('createBitmap ([IIIIILBitmap$Config;)LBitmap;' jniStaticMethod)~ colors;0;w;w;h;0
jniCheck DeleteLocalRef <ba
if. bm do.
  jniCheck bos=. '' jniNewObject 'ByteArrayOutputStream'
  jniCheck bm ('compress (IILOutputStream;)Z' jniMethod)~ type;quality;bos
  jniCheck bmc=. bos ('toByteArray ()[B' jniMethod)~ ''
  jniCheck fos=. (<f) jniNewObject 'FileOutputStream LString;'
  jniCheck fos ('write ([B)V' jniMethod)~ bmc
  jniCheck fos ('flush ()V' jniMethod)~ ''
  jniCheck fos ('close ()V' jniMethod)~ ''
  jniCheck DeleteLocalRef"0 bos;bmc;fos
end.
jniCheck DeleteLocalRef <bm
EMPTY
)
