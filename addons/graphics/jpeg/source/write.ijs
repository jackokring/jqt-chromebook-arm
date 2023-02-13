NB.   readjpeg      read JPEG file, returning RGB data

NB. =========================================================
NB.*writejpeg v write jpeg file from RGB data
NB.
NB. Form:  data writejpeg filename [;quality] [;horsubsampling, versubsampling]
NB. quanlity: 0 to 100
NB. horsubsampling versubsampling: chroma sampling every n pixels (0: gray scaled no subsampling)
NB. common values (1 1) (2 2)
NB. Qt does not support horsubsampling, versubsampling

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

NB. =========================================================
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

NB. RGB to YUV
YCbCr=. 3 3 $ 0.299 0.587 0.114 _0.1687 _0.3313 0.5 0.5 _0.4187 _0.0813
'Y Cb Cr'=. _128 + 0 1 |: ([: <. 255 <. 0 >. 0 128 128 +"1 YCbCr"_ (+/ . *) ])"1 dat
NB. chroma subsampling
'h1 w1'=. >.&.(%&(8*sampV,sampH)) imageHeight, imageWidth
Y=. ,/ 1 3|: (_8*sampV)]\ (_8*sampH)[\"1 h1{. w1{."1 Y
if. 3=imageComponent do.
  Cb=. h1{. w1{."1 Cb
  Cr=. h1{. w1{."1 Cr
  if. 1=sampH*sampV do. NB. no subsampling
    Cb=. ,/ 1 3|: _8]\ (_8)]\"1 Cb
    Cr=. ,/ 1 3|: _8]\ (_8)]\"1 Cr
  else.
    Y=. ,/ ,/ 2 4|: (_8)]\"(3) (_8)]\"1 Y
    Cb=. ,/ 1 3|: (_8)]\"(3) (_8)]\"1 ([: (+/ <.@% #) ,)"(2) 1 3 |: (-sampV)[\ (-sampH)]\"1 Cb
    Cr=. ,/ 1 3|: (_8)]\"(3) (_8)]\"1 ([: (+/ <.@% #) ,)"(2) 1 3 |: (-sampV)[\ (-sampH)]\"1 Cr
  end.
end.

NB. DCT
Y=. FDCT"2 Y
if. 3=imageComponent do.
  Cb=. FDCT"2 Cb
  Cr=. FDCT"2 Cr
end.

NB. no need
AANscaleFactor=. 1.0 1.387039845 1.306562965 1.175875602 1.0 0.785694958 0.541196100 0.275899379
div=. 1 [ 8 * AANscaleFactor */ AANscaleFactor

NB. quantization
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

NB. huffman encoding
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

NB. write header
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

NB. standard huffman table
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
