NB. jfile  utilities

V64L=: 1718235186  NB. J64 little endian
V32L=: 1718235187  NB. J32 little endian (default new 32bit)
V32B=: 1718235188  NB. J32 big endian
V64B=: 1718235189  NB. J64 big endian (default new 64bit)

M32=: 4294967296  NB. 2^32

B4=: 4 # 256
B8=: 8 # 256

NB. =========================================================
j_blk=: [: <. >.&.(2&^.)@#
j_box=: <^:(L. = 0:)
j_ischar=: 3!:0 e. 2 131072 262144"_
j_nos=: [: ; [: {."1 (1!:20)
j_read=: 3!:2 @ (1!:11)
j_rep=: 3!:1
j_take0=: {.!.({.a.)
j_writerep=: j_rep&.>@[ j_write ]
j_vcur=: 3 : '(2 * IF64) }. V32L,V32B,V64B'

NB. =========================================================
NB. j_compress  - compress free list
j_compress=: 3 : 0
f=. /:~ y
bgn=. {."1 f
end=. bgn + {:"1 f
min=. 0, }: end
bgn=. bgn >. min
b=. bgn ~: min
if. 0 e. b do.
  f=. (b#bgn) ,. b +/;.1 (end-bgn)
end.
f /: {:"1 f
)

NB. =========================================================
j_dir=: 3 : 0
hdr=. 1!:11 y;0 512
try.
  <. each 7 {. 3!:2 :: 0: hdr
catch.
  <. each 7 {. (3!:2) 256 {. hdr
end.
)

NB. =========================================================
NB. add .ijf  extension if none given
j_ext=: 3 : 0
y=. jpathsep 7 u: y
y=. y,'.ijf' #~ (0<#y) > '.' e. (-.+./\.y='/')#y
8 u: y
)

NB. =========================================================
NB. get effective version
j_getver=: 3 : 0
h=. y
'v s c l d f q'=. j_dir h
if. v >: V64L do. v return. end.
if. c = 0 do. V32L return. end.
free=. j_read h;f
dir=. j_readdir V32B,h,c,d
if. 1 e. l < {."1 dir do. V32L return. end.
r=. /:~ f,d,dir,free
p=. {.{.r
y=. p,+/"1 r
(y -: ({."1 r),l) { V32L,V32B
)

NB. =========================================================
NB. j_name
NB. returns file name (or handle if given)
j_name=: 3 : 0
y=. >y
if. j_ischar y do.
  j_ext y
end.
)

NB. =========================================================
NB. j_open        - open file
NB. returns 2 elements: handle,ifopened
j_open=: 3 : 0
y=. >y
if. 0 e. #y do. _1 return. end.
if. j_ischar y do.
  y=. j_ext y
  j=. 1!:11 :: _1: y;0 0
  if. _1 -: j do. return. end.
  n=. ;{."1 [ 1!:20''
  h=. 1!:21 <y
  h,-.h e. n
else.
  y,0
end.
)

NB. =========================================================
NB. j_readcpt read directory for given components
j_readcpt=: 4 : 0
'v h d'=. x
select. v
case. V64B do.
  <. B8 #. _8 [\"1 a. i. 1!:11 h,.(d+y*16),.16
case. V32L do.
  <. B4 #. _4 |.\"1 a. i. 1!:11 h,.(d+y*8),.8
case. V32B do.
  <. B4 #. _4 [\"1 a. i. 1!:11 h,.(d+y*8),.8
case. V64L do.
  <. B8 #. _8 |.\"1 a. i. 1!:11 h,.(d+y*16),.16
end.
)

NB. =========================================================
NB. j_readdir read all component directory
NB.
NB. v version
NB. h file handle
NB. c number of components
NB. d starting position
NB. e ignored
j_readdir=: 3 : 0
'v h c d e'=. y
select. v
case. V64B do.
  _2[\ <. B8 #. _8 [\ a. i. 1!:11 h,d,c*16
case. V32L do.
  _2[\ <. B4 #. _4 |.\ a. i. 1!:11 h,d,c*8
case. V32B do.
  _2[\ <. B4 #. _4 [\ a. i. 1!:11 h,d,c*8
case. V64L do.
  _2[\ <. B8 #. _8 |.\ a. i. 1!:11 h,d,c*16
end.
)

NB. =========================================================
NB. j_upver
NB. update version number to current
j_upver=: 3 : 0
h=. y
'v s c l d f q'=. j_dir h
if. v e. j_vcur '' do. return. end.
v=. j_getver h
dir=. j_readdir v,h,c,d
if. IF64 +. v = V64L do. v=. V64B end.
dir=. , v j_tochar dir
dir=. (512 >. #dir) j_take0 dir
d=. 512 >. d
free=. j_read h;f
free=. j_compress d,f,free
'l free new'=. (<dir) j_write l;free;h
'l f'=. j_writefree l;free;h
d=. ,new
q=. >:{.q,0
res=. v;s;c;l;d;f;q
(512 j_take0 j_rep res) 1!:12 h;0
res
)

NB. =========================================================
NB. following used for creating directory entries
j_tochar=: 4 : 0
select. x
case. V64B do.
  ,"2 a. {~ B8 #: y
case. V32L do.
  ,"2 |."1 a. {~ B4 #: y
case. V32B do.
  ,"2 a. {~ B4 #: y
case. V64L do.
  ,"2 |."1 a. {~ B8 #: y
end.
)

NB. =========================================================
NB. j_write     - write data to file
NB. x = data as boxed list
NB. y = filelength;freelist;file
NB. result = filelength;freelist;position
j_write=: 4 : 0
'l f h'=. y
x=. ,x
d=. i.0 2
while. #x do.
  blk=. j_blk dat=. >{.x
  x=. }.x
  if.
    (#f) > ndx=. 1 i.~ blk <: {:"1 f
  do.
    'p s'=. ndx{f
    d=. d,p,blk
    if. blk < s do.
      f=. ((p+blk),s-blk) ndx } f
    else.
      f=. (ndx{.f),(>:ndx)}.f
    end.
    dat 1!:12 h;p
  else.
    d=. d,l,blk
    l=. l+blk
    (blk{.dat) 1!:3 h
  end.
end.
l;f;d
)

NB. =========================================================
NB. j_writefree   - write freelist to file
NB. y = filelength;freelist;file
NB. result = filelength;position
j_writefree=: 3 : 0
'l f h'=. y
blk=. 256 >. j_blk dat=. j_rep f
if.
  (#f) > ndx=. 1 i.~ blk <: {:"1 f
do.
  'p s'=. ndx{f
  d=. p,blk
  if. blk < s do.
    f=. ((p+blk),s-blk) ndx } f
  else.
    f=. (ndx{.f),(>:ndx)}.f
  end.
  (j_rep f) 1!:12 h;p
else.
  d=. l,blk
  l=. l+blk
  (blk{.dat) 1!:3 h
end.
l;d
)
