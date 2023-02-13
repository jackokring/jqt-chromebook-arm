NB.   readjpeg      read JPEG file, returning RGB data

NB. =========================================================
NB.*readjpeg v read JPEG file, returning RGB data
readjpeg=: 3 : 0

if. USEQTJPEG do.
  if. 0=# dat=. readimg_jqtide_ y do.
    'Qt cannot read JPEG file' return.
  end.
  0&setalpha dat return.  NB. remove dummy alpha channel
elseif. USEJAJPEG do.
  if. 0=# dat=. readimg_ja_ y do.
    'jandroid cannot read JPEG file' return.
  end.
  0&setalpha dat return.  NB. remove dummy alpha channel
elseif. USEJNJPEG do.
  if. 0=# dat=. readimg_jnet_ y do.
    'jnet cannot read JPEG file' return.
  end.
  0&setalpha dat return.  NB. remove dummy alpha channel
elseif. USEPPJPEG do.
  if. 0=# dat=. readimg_pplatimg_ y do.
    'pplatimg cannot read JPEG file' return.
  end.
  0&setalpha dat return.  NB. remove dummy alpha channel
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
NB.    smoutput a
    imageEncoding=. 0
    maxSampling=. (1<imageComponent){:: 1 1 ; >./ 2}."1 imageQuantization
  case. ;/ tagSOF0+ 4 12 -.~ 1 + i.15 do. otherEncoding=. 1 [ p=. #ibuf
  case. tagDHT do. decodeDHT 2+p
  case. tagSOS do. sos=. sos, 2+p
    a=. decodeSOS 2+p
    'Ns Sc Ss Se AhAl'=. a
NB.    smoutput a
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

NB. read scan
sos=. {.sos
len=. u16be (sos+i.2){ibuf
if. 1 e. b=. 255 0 E. a=. a.i.(eoi-sos+len){.(sos+len)}.ibuf do.
  a=. (1, }: -.b)#a
end.
hdata=: ,#:a
NB. preallocated ht(dc/ac)(id) outside of loop for efficiency
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
NB. number of MCU
nmcb=. */ >.@(%&(8*maxSampling)) imageHieght,imageWidth
mcb=. 0
while. (hp<#hdata) *. mcb<nmcb do.
NB. DU 8x8
  for_i. i.#Sc do.
    'cpt Td Ta'=. i{Sc
    chr=. 1~:cpt
    cpta=. cpt{::'X';'Y';'Cb';'Cr'
    DC=. 'DC_', cpta
    AC=. 'AC_', cpta
    sampling=. (1<imageComponent){:: 1 1 ;2}.imageQuantization {~ ({."1 imageQuantization) i. cpt
    for_j. i. */sampling do.
NB. DC
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
NB. AC
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

NB. process DU
for_i. i.#Sc do.
  'cpt Td Ta'=. i{Sc
  assert. cpt e. 1 2 3
  cpta=. cpt{::'X';'Y';'Cb';'Cr'
NB.   smoutput cpta
NB. combine DC and AC of each DU
  DC=. 'DC_', cpta
  AC=. 'AC_', cpta
  dc=. +/\ DC~
  ac=. _63]\ AC~
NB. du is rank-2 array of du, $du is n,64
  du=. dc,.ac
  qt=. quantTable {~ quantId i. 1{imageQuantization {~ ({."1 imageQuantization) i. cpt
NB. dequantization, de-zigzag ordering, inverse DCT, clamping
  du=. 255 <. 0 >. <. 128 + ,@:IDCT@:(8 8&$)@:((/:jpegNaturalOrder)&{)"1 <. du *"1 qt

NB. chroma upsampling
  if. 1 1 -.@-: maxSampling do.
    sampling=. (1<imageComponent){:: 1 1 ; 2}.imageQuantization {~ ({."1 imageQuantization) i. cpt
    if. (1~:cpt) do.
      du=. _64]\ , 2 4|: _8]\"3 [ _8]\"1 ((maxSampling%sampling)&upsampling)@:(8 8&$)"1 du
    end.
    du=. (maxSampling, 8 8) repack du
  end.

NB. flatten du to rank-2 array
  hw=. (>.@:(%&(8*maxSampling))) imageHieght,imageWidth
  d=. ,/"3 ,./"3[ (hw,(8*maxSampling))$,du
  (cpta)=. d
end.

NB. convert YUV to RGB
if. 1=imageComponent do.
  dat=. 0|: ('Y'~),('Y'~),:('Y'~)
else.
  dat=. 0|: ('Y'~),('Cb'~),:('Cr'~)
  RGBM=. 3 3 $ 1 0 1.4075 1 _0.3455 _0.7169 1 1.779 0
  dat=. 256 #. ([: <. 255 <. 0 >. RGBM"_ (+/ . *) ])"1 [ 0 _128 _128 +"1 dat
end.
NB. discard padding pixels
imageHieght{. imageWidth{."_1 dat
)

NB. x: h w m n
repack=: 4 : 0
(,/@:(,./"3)@:(x&$)@:,)"1 (-*/x)]\ ,y
)

upsampling=: 4 : 0
NB. x: vsampling hsampling
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

NB.return imageWidth;imageHieght;imageColor;imageComponent;imageQuantization
decodeSOF0=: 3 : 0
NB. smoutput 'SOF0'
q=. y
Color=. a.i. (2+q){ibuf          NB. 8=8 bit per component)
Hieght=. u16be (3+q+i.2){ibuf
Width=. u16be (5+q+i.2){ibuf
Component=. a.i. (7+q){ibuf      NB.  1 = grey scaled, 3 = color YCbCr or YIQ, 4 = color CMYK)
a=. |: _3]\ a.i.(8+q+i.(u16be (q+i.2){ibuf)-8){ibuf
componentid=. 0{a            NB. component id (1 = Y, 2 = Cb, 3 = Cr, 4 = I, 5 = Q)
vsamplingfactor=. 16|1{a     NB. sampling factors (bit 0-3 vert., 4-7 hor.)
hsamplingfactor=. 16<.@%~1{a NB. sampling factors (bit 0-3 vert., 4-7 hor.)
quantizationid=. 2{a         NB. quantization table number
Quantization=. componentid,. quantizationid,. vsamplingfactor,. hsamplingfactor

Width;Hieght;Color;Component;Quantization
)

decodeDQT=: 3 : 0
NB. smoutput 'DQT'
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

NB. HuffTable is bit code symbol
decodeDHT=: 3 : 0
NB. smoutput 'DHT'
q=. y
len=. u16be (q+i.2){ibuf
p=. 2+q
while. p<q+len do.
NB. class Y or Cb/Cr
NB. id    Dc or AC
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
NB. smoutput 'SOS'
q=. y
len=. u16be (q+i.2){ibuf
p=. 2+q
Ns=. a.i.p{ibuf                 NB. total number of components
a=. _2]\ a.i.(p+1+i.2*Ns){ibuf  NB. Component Specific Parameters
Cs=. {."1 a                     NB.   components selection index
Td=. 16 <.@%~ {:"1 a            NB.   DC table selector
Ta=. 16|{:"1 a                  NB.   AC table selector
Sc=. Cs,.Td,.Ta

Ss=. a.i.(p+1+2*Ns){ibuf        NB. used in progressive bitmaps
Se=. a.i.(p+2+2*Ns){ibuf
AhAl=. a.i.(p+3+2*Ns){ibuf

Ns;Sc;Ss;Se;AhAl
)
