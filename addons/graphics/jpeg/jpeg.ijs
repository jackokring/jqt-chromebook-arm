coclass 'jjpeg'

IFJNET=: (IFJNET"_)^:(0=4!:0<'IFJNET')0
3 : 0''
if. (IFJNET +. IFIOS +. UNAME-:'Android') do. USEQTJPEG=: USEPPJPEG=: 0 end.
if. 0~: 4!:0<'USEQTJPEG' do.
  USEQTJPEG=: IFQT
end.
if. 0~: 4!:0<'USEJAJPEG' do.
  USEJAJPEG=: IFJA
end.
if. 0~: 4!:0<'USEJNJPEG' do.
  USEJNJPEG=: IFJNET
end.
if. (0~: 4!:0<'USEPPJPEG') > IFIOS +. UNAME-:'Android' do.
  USEPPJPEG=: (0 < #1!:0 jpath '~addons/graphics/pplatimg/pplatimg.ijs')
  require^:USEPPJPEG 'graphics/pplatimg'
  if. USEPPJPEG *. UNAME-:'Linux' do.
    USEPPJPEG=: (LIBGDKPIX_pplatimg_,' dummyfunction + n')&cd :: (2={.@cder) ''
  end.
end.
require^:USEPPJPEG 'graphics/pplatimg'
EMPTY
)

tagAPP0=: 16be0
tagAPP1=: 16be1
tagCOM=: 16bfe
tagDHT=: 16bc4
tagDQT=: 16bdb
tagDRI=: 16bdd
tagEOI=: 16bd9
tagRST0=: 16bd0
tagSOF0=: 16bc0
tagSOI=: 16bd8
tagSOS=: 16bda

SHL=: 34 b.

FDCT=: (1&FDCT1"1)&.|:@:(0&FDCT1"1)

FDCT1=: 4 : 0
c1=. 1004
s1=. 200
c3=. 851
s3=. 569
r2c6=. 554
r2s6=. 1337
r2=. 181
'x0 x1 x2 x3 x4 x5 x6 x7'=. y
x8=. x7+x0
x0=. x0-x7
x7=. x1+x6
x1=. x1-x6
x6=. x2+x5
x2=. x2-x5
x5=. x3+x4
x3=. x3-x4
x4=. x8+x5
x8=. x8-x5
x5=. x7+x6
x7=. x7-x6
x6=. c1*(x1+x2)
x2=. x6+((-s1)-c1)*x2
x1=. x6+(s1-c1)*x1
x6=. c3*(x0+x3)
x3=. x6+((-s3)-c3)*x3
x0=. x6+(s3-c3)*x0
x6=. x4+x5
x4=. x4-x5
x5=. r2c6*(x7+x8)
x7=. x5+((-r2s6)-r2c6)*x7
x8=. x5+(r2s6-r2c6)*x8
x5=. x0+x2
x0=. x0-x2
x2=. x3+x1
x3=. x3-x1
(- 0 10 10 17 0 17 10 10 + 3*x) SHL"0 x6,(x2+x5+512),(x8+512),(65536+x3*r2),x4,(65536+x0*r2),(x7+512),((x2-x5)+512)
)

IDCT=: (1&IDCT1"1)&.|:@:(0&IDCT1"1)

IDCT1=: 4 : 0
c1=. 251
s1=. 50
c3=. 213
s3=. 142
r2c6=. 277
r2s6=. 669
r2=. 181
x0=. (0{y) SHL~ 9
x1=. (1{y) SHL~ 7
x2=. (2{y)
x3=. (3{y) *r2
x4=. (4{y) SHL~ 9
x5=. (5{y)*r2
x6=. (6{y)
x7=. (7{y) SHL~ 7
x8=. x7+x1
x1=. x1-x7
x7=. x0+x4
x0=. x0-x4
x4=. x1+x5
x1=. x1-x5
x5=. x3+x8
x8=. x8-x3
x3=. r2c6*(x2+x6)
x6=. x3+((-r2c6)-r2s6)*x6
x2=. x3+((-r2c6)+r2s6)*x2
x3=. x7+x2
x7=. x7-x2
x2=. x0+x6
x0=. x0-x6
x6=. c3*(x4+x5)
x5=. (x6+((-c3)-s3)*x5) SHL~ _6
x4=. (x6+((-c3)+s3)*x4) SHL~ _6
x6=. c1*(x1+x8)
x1=. (x6+((-c1)-s1)*x1) SHL~ _6
x8=. (x6+((-c1)+s1)*x8) SHL~ _6
x7=. x7+512
x2=. x2+512
x0=. x0+512
x3=. x3+512
(- 10 + x) SHL (x3+x4),(x2+x8),(x0+x1),(x7+x5),(x7-x5),(x0-x1),(x2-x8),(x3-x4)
)
cat=: <: 1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536

std_luminance_quant_tbl=: 8 8$ ". LF -.~ (0 :0)
    16  11  10  16  24  40  51  61
    12  12  14  19  26  58  60  55
    14  13  16  24  40  57  69  56
    14  17  22  29  51  87  80  62
    18  22  37  56  68 109 103  77
    24  35  55  64  81 104 113  92
    49  64  78  87 103 121 120 101
    72  92  95  98 112 100 103  99
)

std_chrominance_quant_tbl=: 8 8$ ". LF -.~ (0 :0)
    17  18  24  47  99  99  99  99
    18  21  26  66  99  99  99  99
    24  26  56  99  99  99  99  99
    47  66  99  99  99  99  99  99
    99  99  99  99  99  99  99  99
    99  99  99  99  99  99  99  99
    99  99  99  99  99  99  99  99
    99  99  99  99  99  99  99  99
)
bits_dc_luminance=: 0 1 5 1 1 1 1 1 1 0 0 0 0 0 0 0

val_dc_luminance=: 0 1 2 3 4 5 6 7 8 9 10 11

bits_dc_chrominance=: 0 3 1 1 1 1 1 1 1 1 1 0 0 0 0 0

val_dc_chrominance=: 0 1 2 3 4 5 6 7 8 9 10 11

bits_ac_luminance=: 0 2 1 3 3 2 4 3 5 5 4 4 0 0 1 16b7d

val_ac_luminance=: ". LF -.~ (0 :0)
      16b01 16b02 16b03 16b00 16b04 16b11 16b05 16b12
      16b21 16b31 16b41 16b06 16b13 16b51 16b61 16b07
      16b22 16b71 16b14 16b32 16b81 16b91 16ba1 16b08
      16b23 16b42 16bb1 16bc1 16b15 16b52 16bd1 16bf0
      16b24 16b33 16b62 16b72 16b82 16b09 16b0a 16b16
      16b17 16b18 16b19 16b1a 16b25 16b26 16b27 16b28
      16b29 16b2a 16b34 16b35 16b36 16b37 16b38 16b39
      16b3a 16b43 16b44 16b45 16b46 16b47 16b48 16b49
      16b4a 16b53 16b54 16b55 16b56 16b57 16b58 16b59
      16b5a 16b63 16b64 16b65 16b66 16b67 16b68 16b69
      16b6a 16b73 16b74 16b75 16b76 16b77 16b78 16b79
      16b7a 16b83 16b84 16b85 16b86 16b87 16b88 16b89
      16b8a 16b92 16b93 16b94 16b95 16b96 16b97 16b98
      16b99 16b9a 16ba2 16ba3 16ba4 16ba5 16ba6 16ba7
      16ba8 16ba9 16baa 16bb2 16bb3 16bb4 16bb5 16bb6
      16bb7 16bb8 16bb9 16bba 16bc2 16bc3 16bc4 16bc5
      16bc6 16bc7 16bc8 16bc9 16bca 16bd2 16bd3 16bd4
      16bd5 16bd6 16bd7 16bd8 16bd9 16bda 16be1 16be2
      16be3 16be4 16be5 16be6 16be7 16be8 16be9 16bea
      16bf1 16bf2 16bf3 16bf4 16bf5 16bf6 16bf7 16bf8
      16bf9 16bfa
)
bits_ac_chrominance=: 0 2 1 2 4 4 3 4 7 5 4 4 0 1 2 16b77

val_ac_chrominance=: ". LF -.~ (0 :0)
      16b00 16b01 16b02 16b03 16b11 16b04 16b05 16b21
      16b31 16b06 16b12 16b41 16b51 16b07 16b61 16b71
      16b13 16b22 16b32 16b81 16b08 16b14 16b42 16b91
      16ba1 16bb1 16bc1 16b09 16b23 16b33 16b52 16bf0
      16b15 16b62 16b72 16bd1 16b0a 16b16 16b24 16b34
      16be1 16b25 16bf1 16b17 16b18 16b19 16b1a 16b26
      16b27 16b28 16b29 16b2a 16b35 16b36 16b37 16b38
      16b39 16b3a 16b43 16b44 16b45 16b46 16b47 16b48
      16b49 16b4a 16b53 16b54 16b55 16b56 16b57 16b58
      16b59 16b5a 16b63 16b64 16b65 16b66 16b67 16b68
      16b69 16b6a 16b73 16b74 16b75 16b76 16b77 16b78
      16b79 16b7a 16b82 16b83 16b84 16b85 16b86 16b87
      16b88 16b89 16b8a 16b92 16b93 16b94 16b95 16b96
      16b97 16b98 16b99 16b9a 16ba2 16ba3 16ba4 16ba5
      16ba6 16ba7 16ba8 16ba9 16baa 16bb2 16bb3 16bb4
      16bb5 16bb6 16bb7 16bb8 16bb9 16bba 16bc2 16bc3
      16bc4 16bc5 16bc6 16bc7 16bc8 16bc9 16bca 16bd2
      16bd3 16bd4 16bd5 16bd6 16bd7 16bd8 16bd9 16bda
      16be2 16be3 16be4 16be5 16be6 16be7 16be8 16be9
      16bea 16bf2 16bf3 16bf4 16bf5 16bf6 16bf7 16bf8
      16bf9 16bfa
)

jpegNaturalOrder=: ". LF-.~ (0 : 0)
 0 1 8   16   9 2 3   10   17   24   32   25   18 11 4 5 12
 19 26   33   40 48   41   34   27   20   13   6 7 14 21 28
 35 42   49   56 57   50   43   36   29   22   15 23 30 37
 44 51   58   59 52   45   38   31   39   46   53 60 61 54
 47 55   62   63
)
writejpeg=: 4 : 0

dat=. x
'file quality subsampling'=. 3 {. (boxopen y), _1 ; 1 1

if. USEQTJPEG do.
  dat writeimg_jqtide_ (>file);'jpeg';'quality';(0>quality){quality,75
elseif. USEJAJPEG do.
  if. 805> ".}.(i.&'/' {. ])9!:14'' do.
    dat writeimg_ja_ (>file);'jpeg';'quality';(0>quality){quality,75
  else.
    writeimg_ja_ dat;(>file);'jpeg';(0>quality){quality,75
  end.
elseif. USEJNJPEG do.
  writeimg_jnet_ dat;(>file);'jpeg';(0>quality){quality,75
elseif. USEPPJPEG do.
  dat writeimg_pplatimg_ (>file);(0>quality){quality,75
elseif. do.
  (boxopen file) 1!:2~ (quality;subsampling) encodejpeg dat
end.
''
)
encodejpeg=: 4 : 0
'quality subsampling'=. x
quality=. <. 100 <. 0 >. (0>quality){quality,75
'sampH sampV'=. <. 15 <. 2{. 1 1,~ subsampling=. (_1-:subsampling){::subsampling;1 1

dat=. y

if. -.if3 dat do.
  dat=. 256 256 256 #:"(1 0) 16bffffff (17 b.) dat
end.

if. 1> <./sampH,sampV do.
  imageComponent=. 1
  'sampH sampV'=. 1
else.
  imageComponent=. 3
end.
'imageHeight imageWidth'=. 2{.$dat
YCbCr=. 3 3 $ 0.299 0.587 0.114 _0.1687 _0.3313 0.5 0.5 _0.4187 _0.0813
'Y Cb Cr'=. _128 + 0 1 |: ([: <. 255 <. 0 >. 0 128 128 +"1 YCbCr"_ (+/ . *) ])"1 dat
'h1 w1'=. >.&.(%&(8*sampV,sampH)) imageHeight, imageWidth
Y=. ,/ 1 3|: (_8*sampV)]\ (_8*sampH)[\"1 h1{. w1{."1 Y
if. 3=imageComponent do.
  Cb=. h1{. w1{."1 Cb
  Cr=. h1{. w1{."1 Cr
  if. 1=sampH*sampV do.
    Cb=. ,/ 1 3|: _8]\ (_8)]\"1 Cb
    Cr=. ,/ 1 3|: _8]\ (_8)]\"1 Cr
  else.
    Y=. ,/ ,/ 2 4|: (_8)]\"(3) (_8)]\"1 Y
    Cb=. ,/ 1 3|: (_8)]\"(3) (_8)]\"1 ([: (+/ <.@% #) ,)"(2) 1 3 |: (-sampV)[\ (-sampH)]\"1 Cb
    Cr=. ,/ 1 3|: (_8)]\"(3) (_8)]\"1 ([: (+/ <.@% #) ,)"(2) 1 3 |: (-sampV)[\ (-sampH)]\"1 Cr
  end.
end.
Y=. FDCT"2 Y
if. 3=imageComponent do.
  Cb=. FDCT"2 Cb
  Cr=. FDCT"2 Cr
end.
AANscaleFactor=. 1.0 1.387039845 1.306562965 1.175875602 1.0 0.785694958 0.541196100 0.275899379
div=. 1 [ 8 * AANscaleFactor */ AANscaleFactor
if. quality<50 do.
  q_scale=. <.5000%quality
else.
  q_scale=. 200-2*quality
end.
qy=. <. 255 <. 1 >. std_luminance_quant_tbl*q_scale%100
qc=. <. 255 <. 1 >. std_chrominance_quant_tbl*q_scale%100
Y=. <. 0.5+ Y %"2 qy*div
if. 3=imageComponent do.
  Cb=. <. 0.5+ Cb %"2 qc*div
  Cr=. <. 0.5+ Cr %"2 qc*div
end.
ht_dc_y=. bits_dc_luminance genDHT val_dc_luminance
ht_ac_y=. bits_ac_luminance genDHT val_ac_luminance
ht_dc_c=. bits_dc_chrominance genDHT val_dc_chrominance
ht_ac_c=. bits_ac_chrominance genDHT val_ac_chrominance

YDC=. ht_dc_y&encodeDC"0 ({.,-@:(2&(-/\))) {."1 a=. jpegNaturalOrder&{"1[ _64]\,Y
YAC=. (ht_ac_y&encodeAC)"1 }."1 a
if. 3=imageComponent do.
  CbDC=. ht_dc_c&encodeDC"0 ({.,-@:(2&(-/\))) {."1 a=. jpegNaturalOrder&{"1[ _64]\,Cb
  CbAC=. (ht_ac_c&encodeAC)"1 }."1 a
  CrDC=. ht_dc_c&encodeDC"0 ({.,-@:(2&(-/\))) {."1 a=. jpegNaturalOrder&{"1[ _64]\,Cr
  CrAC=. (ht_ac_c&encodeAC)"1 }."1 a
  YDCAC=. (-*/sampH,sampV) (<@:;)\ YDC (,&.>) YAC
  CbDCAC=. CbDC (,&.>) CbAC
  CrDCAC=. CrDC (,&.>) CrAC
  bitStream=. (#~ (1 + j.@(255&=))) #. _8]\ ; (-@{. <@:{. #:@{:)"(1) _2]\ ; YDCAC,. CbDCAC,. CrDCAC
else.
  bitStream=. (#~ (1 + j.@(255&=))) #. _8]\ ; (-@{. <@:{. #:@{:)"(1) _2]\ ; YDC,. YAC
end.
header=. 16bff, tagSOI
header=. header, (16bff,tagAPP0), addlength (a.i.'JFIF'),0, 1 2 0 100 100 0 0
header=. header, (16bff,tagDQT), addlength (0, jpegNaturalOrder{,qy), (1, jpegNaturalOrder{,qc)
header=. header, (16bff,tagSOF0), addlength 8, (256 256#:imageHeight), (256 256#:imageWidth),imageComponent, , imageComponent{. |:3 3$1 2 3,(16b11 16b11,~ 16#.sampH,sampV),0 1 1
header=. header, (16bff,tagDHT), addlength 16b0, bits_dc_luminance,val_dc_luminance, 16b1, bits_dc_chrominance, val_dc_chrominance, 1bf10, bits_ac_luminance,val_ac_luminance, 16b11, bits_ac_chrominance, val_ac_chrominance
header=. header, (16bff,tagSOS), addlength imageComponent, 63 0 0,~ ,imageComponent{. _2]\ 1 16b0 2 16b11 3 16b11
a.{~ header, (16bff,tagEOI),~ bitStream
)

encodeDC=: 4 : 0
ht=. x
'ss mag'=. cat ssmag y
r=. (2{. ht {~ ({:"1 ht) i. ss)
assert. 0~:{.r
if. 0=ss do.
  <r
else.
  <r,(ss,mag)
end.
)

encodeAC=: 4 : 0
assert. 63=#y
ht=. x
nz=. <: - 2 -/\ _1, msk=. I. 0~: y
s=. msk{y
t=. 0$0
for_i. i.#nz do.
  if. 15< z=. i{nz do.
    z=. 16|z [ zrl=. z<.@%16
    t=. t, , zrl# ,: (2{. ht {~ ({:"1 ht) i. 16bf0)
  end.
  'ss mag'=. cat ssmag i{s
  assert. 0~:ss
  sym=. ss+16*z
  t=. t, (2{. ht {~ ({:"1 ht) i. sym)
  t=. t, ss, mag
end.
if. 0={:y do.
  t=. t, (2{. ht {~ ({:"1 ht) i. 0)
end.
<t
)
genDHT=: 4 : 0
bits=. x
vals=. y
assert. (+/bits)=#vals
code=. 0
t=. 0 0$0
for_i. i.16 do.
  for_j. i. i{bits do.
    t=. t , (>:i), code
    code=. >:code
  end.
  code=. 2*code
end.
assert. (#vals)=(#t)
/:~ t,.vals
)
readjpeg=: 3 : 0

if. USEQTJPEG do.
  if. 0=# dat=. readimg_jqtide_ y do.
    'Qt cannot read JPEG file' return.
  end.
  0&setalpha dat return.
elseif. USEJAJPEG do.
  if. 0=# dat=. readimg_ja_ y do.
    'jandroid cannot read JPEG file' return.
  end.
  0&setalpha dat return.
elseif. USEJNJPEG do.
  if. 0=# dat=. readimg_jnet_ y do.
    'jnet cannot read JPEG file' return.
  end.
  0&setalpha dat return.
elseif. USEPPJPEG do.
  if. 0=# dat=. readimg_pplatimg_ y do.
    'pplatimg cannot read JPEG file' return.
  end.
  0&setalpha dat return.
end.
ibuf=: fread y
if. _1-:ibuf do. 'cannot read file' return. end.
if. 0=isJpeg ibuf do. 'invalid JPEG file' return. end.

quantId=: 0$0
quantTable=: 0 0$0

huffCid=: 0 0$0
huffTable=: 0$<0 0$0

imageEncoding=: _1
sos=. 0$0
eoi=. _1
rstIntv=. otherEncoding=. 0
p=. 0
while. (#ibuf) > p do.
  if. ({:a.)~:p{ibuf do. p=. 1+p continue. end.
  if. 0 = t=. a.i. (1+p){ibuf do. p=. 2+p continue. end.
  if. t e. tagSOI,tagEOI,tagRST0+i.8 do.
    len=. 0
  else.
    len=. u16be (2+p+i.2){ibuf
  end.
  select. t
  case. tagAPP0 do. ''
  case. tagAPP1 do. ''
  case. tagDQT do. decodeDQT 2+p
  case. tagSOF0 do.
    a=. decodeSOF0 2+p
    'imageWidth imageHieght imageColor imageComponent imageQuantization'=: a
    imageEncoding=. 0
    maxSampling=. (1<imageComponent){:: 1 1 ; >./ 2}."1 imageQuantization
  case. ;/ tagSOF0+ 4 12 -.~ 1 + i.15 do. otherEncoding=. 1 [ p=. #ibuf
  case. tagDHT do. decodeDHT 2+p
  case. tagSOS do. sos=. sos, 2+p
    a=. decodeSOS 2+p
    'Ns Sc Ss Se AhAl'=. a
  case. tagEOI do. p=. #ibuf [ eoi=. p
  case. tagDRI do. rstIntv=. u16be (4+p+i.2){ibuf
  end.
  p=. 2+p+len
end.
if. 1~:#sos do. 'not exactly one SOS tag' return. end.
if. _1=eoi do. 'missing EOI tag' return. end.
if. otherEncoding do. 'only baseline encoding supported' return. end.
if. rstIntv do. 'RSTn tag not supported' return. end.
if. -. imageComponent e. 1 3 do. 'only 1 or 3 image components supported' return. end.
sos=. {.sos
len=. u16be (sos+i.2){ibuf
if. 1 e. b=. 255 0 E. a=. a.i.(eoi-sos+len){.(sos+len)}.ibuf do.
  a=. (1, }: -.b)#a
end.
hdata=: ,#:a
try.
  ht00=. >huffTable{~ huffCid i. 0 0
catch. end.
try.
  ht01=. >huffTable{~ huffCid i. 0 1
catch. end.
try.
  ht10=. >huffTable{~ huffCid i. 1 0
catch. end.
try.
  ht11=. >huffTable{~ huffCid i. 1 1
catch. end.
DC_Y=. AC_Y=. DC_Cb=. AC_Cb=. DC_Cr=. AC_Cr=. 0$0
Y=. Cb=. Cr=. 0 0$0
hp=. 0
nmcb=. */ >.@(%&(8*maxSampling)) imageHieght,imageWidth
mcb=. 0
while. (hp<#hdata) *. mcb<nmcb do.
  for_i. i.#Sc do.
    'cpt Td Ta'=. i{Sc
    chr=. 1~:cpt
    cpta=. cpt{::'X';'Y';'Cb';'Cr'
    DC=. 'DC_', cpta
    AC=. 'AC_', cpta
    sampling=. (1<imageComponent){:: 1 1 ;2}.imageQuantization {~ ({."1 imageQuantization) i. cpt
    for_j. i. */sampling do.
      ht=. ('ht0',":Td)~
      'hp sym'=. ht decodeHuff hp
      if. 0= ssss=. sym do.
        (DC)=. (DC~), 0
      else.
        if. 1={. s=. (hp+i.ssss){hdata do.
          (DC)=. (DC~), #.s
        else.
          (DC)=. (DC~), (#.s)-(<:2^ssss)
        end.
      end.
      hp=. hp+ssss
      ht=. ('ht1',":Ta)~
      ac63=. 0$0
      while. 63>#ac63 do.
        'hp sym'=. ht decodeHuff hp
        if. 0=sym do. ac63=. ac63, 63#0 continue. end.
        if. 16bf0=sym do. ac63=. ac63, 16#0 continue. end.
        'nz ssss'=. 16 16#:sym
        assert. ssss>0
        if. 1={. s=. (hp+i.ssss){hdata do.
          ac63=. ac63, (nz#0), #.s
        else.
          ac63=. ac63, (nz#0), (#.s)-(<:2^ssss)
        end.
        hp=. hp+ssss
      end.
      (AC)=. (AC~), 63{.ac63
    end.
  end.
  mcb=. >:mcb
end.
for_i. i.#Sc do.
  'cpt Td Ta'=. i{Sc
  assert. cpt e. 1 2 3
  cpta=. cpt{::'X';'Y';'Cb';'Cr'
  DC=. 'DC_', cpta
  AC=. 'AC_', cpta
  dc=. +/\ DC~
  ac=. _63]\ AC~
  du=. dc,.ac
  qt=. quantTable {~ quantId i. 1{imageQuantization {~ ({."1 imageQuantization) i. cpt
  du=. 255 <. 0 >. <. 128 + ,@:IDCT@:(8 8&$)@:((/:jpegNaturalOrder)&{)"1 <. du *"1 qt
  if. 1 1 -.@-: maxSampling do.
    sampling=. (1<imageComponent){:: 1 1 ; 2}.imageQuantization {~ ({."1 imageQuantization) i. cpt
    if. (1~:cpt) do.
      du=. _64]\ , 2 4|: _8]\"3 [ _8]\"1 ((maxSampling%sampling)&upsampling)@:(8 8&$)"1 du
    end.
    du=. (maxSampling, 8 8) repack du
  end.
  hw=. (>.@:(%&(8*maxSampling))) imageHieght,imageWidth
  d=. ,/"3 ,./"3[ (hw,(8*maxSampling))$,du
  (cpta)=. d
end.
if. 1=imageComponent do.
  dat=. 0|: ('Y'~),('Y'~),:('Y'~)
else.
  dat=. 0|: ('Y'~),('Cb'~),:('Cr'~)
  RGBM=. 3 3 $ 1 0 1.4075 1 _0.3455 _0.7169 1 1.779 0
  dat=. 256 #. ([: <. 255 <. 0 >. RGBM"_ (+/ . *) ])"1 [ 0 _128 _128 +"1 dat
end.
imageHieght{. imageWidth{."_1 dat
)
repack=: 4 : 0
(,/@:(,./"3)@:(x&$)@:,)"1 (-*/x)]\ ,y
)

upsampling=: 4 : 0
'sv sh'=. x
if. 1~:sh do.
  y=. ,/"2@(0&|:)@:(+"1 (i.sh)*/(,{:)@:(%&sh)@(2&(-~/\)))"1 y
end.
if. 1~:sv do.
  y=. |: ,/"2@(0&|:)@:(+"1 (i.sv)*/(,{:)@:(%&sv)@(2&(-~/\)))"1 |:y
end.
<.@:(0.5&+) y
)

decodeDU=: 4 : 0
hp=. y
ht=. >huffTable{~ huffCid i.cpt,ac
for_i. i.64 do.
  'sym hp'=. ht decodeHuff hp
end.
)

decodeHuff=: 4 : 0
ht=. x
hp=. y
for_bits. ~.{."1 ht do.
  h=. ht#~bits=({."1 ht)
  if. (#h)> ix=. (1{"1 h) i. #.(hp+i.bits){hdata do.
    (hp+bits),(<ix,2){h return. end.
end.
assert. 0 [ 'no matching huffman code'
)
decodeSOF0=: 3 : 0
q=. y
Color=. a.i. (2+q){ibuf
Hieght=. u16be (3+q+i.2){ibuf
Width=. u16be (5+q+i.2){ibuf
Component=. a.i. (7+q){ibuf
a=. |: _3]\ a.i.(8+q+i.(u16be (q+i.2){ibuf)-8){ibuf
componentid=. 0{a
vsamplingfactor=. 16|1{a
hsamplingfactor=. 16<.@%~1{a
quantizationid=. 2{a
Quantization=. componentid,. quantizationid,. vsamplingfactor,. hsamplingfactor

Width;Hieght;Color;Component;Quantization
)

decodeDQT=: 3 : 0
q=. y
len=. u16be (q+i.2){ibuf
p=. 2+q
while. p<q+len do.
  'prec id'=. 16 16#: a.i. p{ibuf
  quantId=: quantId, id
  if. prec do.
    quantTable=: quantTable, u16be"(1) _2]\(1+p+i.64*2){ibuf
    p=. p+1+64*2
  else.
    quantTable=: quantTable, a.i.(1+p+i.64){ibuf
    p=. p+1+64
  end.
end.
)
decodeDHT=: 3 : 0
q=. y
len=. u16be (q+i.2){ibuf
p=. 2+q
while. p<q+len do.
  'class huffid'=. 16 16#: a.i. p{ibuf
  bits=. a.i.(1+p+i.16){ibuf
  vals=. a.i.(1+16+p+i.+/bits){ibuf
  code=. 0
  t=. 0 0$0
  for_i. i.16 do.
    for_j. i. i{bits do.
      t=. t , (>:i), code
      code=. >:code
    end.
    code=. 2*code
  end.
  assert. (#vals)=(#t)
  huffCid=: huffCid, class,huffid
  huffTable=: huffTable, < /:~ t,.vals
  p=. p+1+16++/bits
end.
)

decodeSOS=: 3 : 0
q=. y
len=. u16be (q+i.2){ibuf
p=. 2+q
Ns=. a.i.p{ibuf
a=. _2]\ a.i.(p+1+i.2*Ns){ibuf
Cs=. {."1 a
Td=. 16 <.@%~ {:"1 a
Ta=. 16|{:"1 a
Sc=. Cs,.Td,.Ta

Ss=. a.i.(p+1+2*Ns){ibuf
Se=. a.i.(p+2+2*Ns){ibuf
AhAl=. a.i.(p+3+2*Ns){ibuf

Ns;Sc;Ss;Se;AhAl
)
if3=: 3 : 0
(3=#$y) *. 3={:$y
)

u16be=: (256&#.)@(a.&i.)

isJpeg=: 3 : 0
+./ (255 216 255 224 74 70 73 70 0,:255 216 255 225 69 120 105 102 0)-:("1) 0 1 2 3 6 7 8 9 10 { a.&i.^:(2=3!:0) 11{.y
)

addlength=: 3 : 0
(256 256#: 2+#y), y
)

ssmag=: 4 : 0
if. 0=y do. 0 0 return. end.
bit=. x I. |y
if. y>0 do.
  bit, y
else.
  bit, y + bit{x
end.
)
readjpeg_z_=: readjpeg_jjpeg_
writejpeg_z_=: writejpeg_jjpeg_
