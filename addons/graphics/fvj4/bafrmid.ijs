NB. Best Analogs for Replacing Missing Image Data
NB. by Chen Ning and Cliff Reiter
NB. http://www.lafayette.edu/~reiterc/mvq/bafrmid/index.html
NB. January 2007
NB. 
NB. Assumes that Image3 addon  
NB. been installed in the addon directory
NB. 
NB. see the end of the script for how to run an example

load '~addons/media/imagekit/imagekit.ijs'

NB. standard marker for missing data is magenta
mag=:255 0 255

wt33=: 4 4 2 2 2 2 2 1
NB. wt33=: 8 8 3 3 3 3 3 1
NB. wt33=: 1 1 1 1 1 1 1 1
dist33=:+/@:,@:(*&wt33)@:*:@:-"2
wt34=: 4 4 2 2 2 2 1 1
NB. wt34=: 8 8 3 3 3 3 1 1
NB. wt34=: 1 1 1 1 1 1 1 1
dist34=:+/@:,@:(*&wt34)@:*:@:-"2
 
mk_hiho=:2 : 0
:
dp=.-x
$pat=.y {"2 m
$qat=.y {"1 n
$mq=. marker -:"1 pat         NB. mag pattern
$wom=. -.+./"1 mq             NB. patches without magenta
$hpat=. wom#pat
smoutput $hi=. dp }."2 hpat   NB. input patches 
$ho=. dp {."2 hpat    NB. output patches
wd 'msgs;'
$hqat=. wom#qat
$qhi=. dp }."1 hqat   NB. quan hist input patches 
$qho=. dp {."1 hqat   NB. quan hist output patches
keys=. 0 {"1 qhi
hi0=. <keys use_keys hi
ho0=. <keys use_keys ho
qho0=. <keys use_keys qho
keys=. 1 {"1 qhi
hi1=. <keys use_keys hi
ho1=. <keys use_keys ho
qho1=. <keys use_keys qho
hi0,ho0,qho0,hi1,ho1,qho1
)

use_keys=:4 : 0
z=.''
for_i. i. num_pqi do.
  z=.z,<(x=i)#y
end.
z
)

mk_newc33=: 2 : 0
:
'hi0 ho0 qho0 hi1 ho1 qho1'=.n
$pat=.,/"3 ,/,/3 3 ];._3 y
$pat=.x {"2 pat
$qat=.x {"1 ,/"2 ,/3 3 ];._3 qi
$mq=. marker -:"1 pat        NB. mag pattern
$upos=. 0 0 0 0 0 0 0 0 1 -:"1 mq 
for_i. I. upos do. 
 'ii0 ii1'=.0 1{i{qat
 rhi=.(>ii0{hi0),>ii1{hi1    NB. relevant history
 if. 0 ~: # rhi do. 
  inewc=.{.@/: rhi dist33 }:i{pat
  newc=.inewc{(>ii0{ho0),>ii1{ho1
  y=.newc (,<m+(_2+}:$y)#:i)}y
  newp=.inewc{(>ii0{qho0),>ii1{qho1
  qi=:newp (,<m+(_2+}:$y)#:i)}qi
 end. 
end.
y
)
mk_newc43=: 2 : 0
:
'hi0 ho0 qho0 hi1 ho1 qho1'=.n
$pat=. ,/"3 ,/,/(2 1,:4 3) ];._3 y
$pat=.x{"2 pat
$qat=. x{"1 ,/"2 ,/(2 1,:4 3) ];._3 qi
$mq=. marker -:"1 pat      NB. mag pattern
$upos=. 0 0 0 0 0 0 0 0 1 1-:"1 mq 
for_i. third I. upos do. 
 'ii0 ii1'=.0 1{i{qat
 rhi=.(>ii0{hi0),>ii1{hi1  NB. relevant history
 if. 0 ~: # rhi do. 
  inewc=.{.@/: rhi dist34 _2}.i{pat
  newc=.inewc{(>ii0{ho0),>ii1{ho1
  y=.newc (<"1 m+"1]2 1*S43#:i)}y
  newp=.inewc{(>ii0{qho0),>ii1{qho1
  qi=:newp (<"1 m+"1]2 1*S43#:i)}qi
  end.
 end.
y
)
mk_newc34=: 2 : 0
:
'hi0 ho0 qho0 hi1 ho1 qho1'=.n
 $pat=.  ,/"3 ,/,/(1 2,:3 4) ];._3 y
 $pat=. x{"2 pat
 $qat=. x{"1 ,/"2 ,/(1 2,:3 4) ];._3 qi
 $mq=. marker -:"1 pat     NB. mag pattern
 $upos=. 0 0 0 0 0 0 0 0 1 1-:"1 mq 
 for_i. third I. upos do. 
 'ii0 ii1'=.0 1{i{qat
 rhi=.(>ii0{hi0),>ii1{hi1  NB. relevant history
 if. 0 ~: # rhi do. 
  inewc=.{.@/: rhi dist34 _2}.i{pat
  newc=.inewc{(>ii0{ho0),>ii1{ho1
  y=.newc (<"1 m+"1]1 2*S34#:i)}y
  newp=.inewc{(>ii0{qho0),>ii1{qho1
  qi=:newp (<"1 m+"1]1 2*S34#:i)}qi
 end. 
 end.
y
)

NB. Selects one third of the indices
third=:{~ >.@(%&3)@# ? #

NB. y is RGB image; magenta is the default marker
imff=: 3 : 0
3 1 255 0 255 imff y
:
'ne_loops N_loops'=.2{.x
marker=:_3{.x
y0=.y
'pqi qi'=:256 quantize_image y  NB. quantized image
num_pqi=:#pqi
$pat34=:3 4 ];._3 y
$pat34=:,/,/pat34
$pat34=:,/"3 pat34
$pat43=:4 3 ];._3 y
$pat43=: ,/,/pat43
$pat43=:,/"3 pat43
$pat33=:3 3 ];._3 y
$pat33=: ,/,/pat33
$pat33=:,/"3 pat33
$qat34=:,/"2 ,/3 4 ];._3 qi
$qat43=:,/"2 ,/4 3 ];._3 qi
$qat33=:,/"2 ,/3 3 ];._3 qi
NB. nw ne se sw hist init;wts: 4 4 2 2 2 2 2 1 0
hiho_nw=:1 pat33 mk_hiho qat33 1 3 2 4 5 6 7 8 0  
hiho_ne=:1 pat33 mk_hiho qat33 1 5 0 3 4 7 8 6 2  
hiho_se=:1 pat33 mk_hiho qat33 5 7 1 2 3 4 6 0 8  
hiho_sw=:1 pat33 mk_hiho qat33 3 7 0 1 4 5 8 2 6
erase 'pat33 qat33'

NB. S E N W hist init; wts:   4 4 2 2 2 2 1  1  0  0 
hiho_S=:2 pat34 mk_hiho qat34 5 6 1 2 4 7 0  3  9 10
hiho_E=:2 pat43 mk_hiho qat43 4 7 1 3 6 10 0 9  5  8
hiho_N=:2 pat34 mk_hiho qat34 5 6 4 9 10 7 8 11 1  2
hiho_W=:2 pat43 mk_hiho qat43 4 7 1 5 8 10 2 11 3  6
erase 'pat34 pat43 qat34 qat43'
 
]S34=:2{.$(1 2,:3 4) ];._3 y
]S43=:2{.$(2 1,:4 3) ];._3 y
k=.0
whilst. -.lasty -: y do.
 lasty=: y
  NB. sw se ne nw loops
  for. i. ne_loops do. NB. number of ne loops per E
  y=. 1 3 2 4 5 6 7 8 0 (0 0)mk_newc33 hiho_nw y
  y=. 1 5 0 3 4 7 8 6 2 (0 2)mk_newc33 hiho_ne y
  y=. 5 7 1 2 3 4 6 0 8 (2 2)mk_newc33 hiho_se y
  y=. 3 7 0 1 4 5 8 2 6 (2 0)mk_newc33 hiho_sw y
  end.
  NB. W N E S loops
  for. i. N_loops do.
  y=. 5 6 1 2 4 7 0  3  9 10(2 1,:2 2)mk_newc34 hiho_S y
  y=. 4 7 1 3 6 10 0 9  5  8(1 2,:2 2)mk_newc43 hiho_E y
  y=. 5 6 4 9 10 7 8 11 1  2(0 1,:0 2)mk_newc34 hiho_N y
  y=. 4 7 1 5 8 10 2 11 3  6(1 0,:2 0)mk_newc43 hiho_W y
  end.
NB. whilst loop cleanup
smoutput k=.k+1
wd 'reset;'
view_image spix_sz spix y0,255,y
glpaint ''
wd 'msgs;'
end.
$y
)

NB. [x] m bafrmid n y
NB. x is num_ne_loops,num_N_loops, rgb_marker_for_missing data, blocksize_wh,blocksize_overlap
NB. m is image with missing data
NB. y is outputfile_name
bafrmid=: 1 : 0
3 1 255 0 255 512 512 4 m bafrmid y
:
'bw bh bo'=._3{.x   NB. block width, h and overlap
fn=.y               NB. filename for result
y=.m                NB. call the image data y
'ih iw'=.2{.$y      NB. image width and height
i=.0            NB. top
while. i<ih do.
  j=.0          NB. left
  while. j<iw do.
  Y=.(i,j)}. y
  'h w'=.(2{.$Y)<.bo+bh,bw
  (_3}.x) imff (h,w){.Y
  y=.lasty (<(i+i.h);j+i.w)}y 
  j=.j+w <. bw
  end.
i=.i+h <. bh
end.
lasty=:y
lasty write_image fn
view_image lasty
)

NB. superpixel size during preview
spix=:[ # #"_1
spix_sz=:2

NB. Sample Experiment
NB. run the lines inside "sample"
sample=:0 : 0

load '~addons/graphics/fvj4/bafrmid.ijs'                NB. load this script
load '~addons/media/imagekit/transform_m.ijs'           NB. load script for rotation
transform_image jpath '~addons/graphics/fvj4/keys.jpg'  NB. load image

SEL_pts_mkit_=: 44 118,:395  94         NB. create d, image with missing data in magenta
transformimage_rotateh_button ''
$c=:i_to_rgb image_from_hist''
$m=:255 255 255 -:"1 c
mag=:255 0 255
$d=:(c*-.m)+m*"0 _ mag
wd 'psel transformimage;pclose;'
view_image d                            NB. d has been created

d bafrmid jpath 'd:/temp/newkeys.png'            NB. run the best analog technique on d; save result as a file
)
