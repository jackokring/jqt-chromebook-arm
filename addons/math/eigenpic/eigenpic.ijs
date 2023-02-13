require 'gl2'

coclass 'eigenpic'
coinsert 'jgl2'

BLUE=: 0 0 255
RED=: 255 0 0
WHITE=: 255 255 255
BLACK=: 0 0 0

FORECOLOR=: BLACK
BACKCOLOR=: WHITE
AXISCOLOR=: BLUE
EIGENCOLOR=: RED

XMARGIN=: 0.07
YMARGIN=: 0.07
TICMAJOR=: 0.01
TICMINOR=: 0.007

MATCHAR=: MATDEFAULT=: '4 3 1 5 % 2'
MATRIX=: 2 2$ ". MATCHAR

IFSPOKES=: 1
SPOKES=: 60

SYSNAME=: 'Eigenpicture'
deb=: #~ (+. 1: |. (> </\))@(' '&~:)

dist=: +/ &. (*:"_)

info=: sminfo @ (SYSNAME&;)

int01=: i.@>: % ]

iscomplex=: -.@(-: +)
isnumeric=: 3!:0 e. 1 4 8 16 64 128"_

log10=: 10&^.
mp=: +/ . *

fp=: x:^:_1

pow10=: 10&^

rnd=: [ * [: <. 0.5"_ + %~
rnd0=: <.@:+&0.5
rnddn=: [ * [: <. %~
rndup=: [ * [: >. %~
rndint=: <.@(0.5&+)

setcolor=: glbrush @ glrgb

tolist=: }.@;@:((10{a.)&,@,@":&.>)
tomatrix=: (_2 {. 1 1 , $) $ ,
tominus=: '-'&(I. @(e.&'_')@]})
unitvec=: % dist

wdpclose=: [: wd :: empty 'psel ' , ';pclose' ,~ ":

addLF=: tominus @ }. @ , @ (LF&,.) @ ":
cleanit=: 3 : 0
1e_7 cleanit y
:
if. 16 ~: 3!:0 y do.
  y * x <: |y
else.
  j./"1 y * x <: | y=. +.y
end.
)
getfontsize=: 13 : '{.1{._1 -.~ _1 ". y'
setfontsize=: 4 : 0
b=. ~: /\ y='"'
nam=. b#y
txt=. ;:(-.b)#y
ndx=. 1 i.~ ([: *./ e.&'0123456789.') &> txt
nam, ; ,&' ' &.> (<fmt x) ndx } txt
)
calc=: 3 : 0

RIM=: spokes SPOKES

'LV EV RV'=: cleanit each dgeev MATRIX

IFCOMPLEX=: iscomplex RV

if. IFCOMPLEX=0 do.
  RV=: {.@+. RV
  rv=. (,-) |:RV
  RIM=: rv, RIM
end.

END=: RIM + MATRIX mp"2 1 RIM
WID=: >. >./ | , END
)
spokes=: 3 : 0
|: 2 1 o./ o. +: }: int01 y
)
dgeev=: 3 : 0
'a b c d'=. ,y
'm n'=. 1 pick p. ((a*d)-b*c), (-a+d), 1
e0=. norm 1,~ -b % a - m
e1=. norm 1,~ -b % a - n
(|.e1,.e0);(m,n);e0,.e1
)
norm=: 3 : 0
n=. (i.>./) (*+) y
if. {: +. n{y do. y=. y * + n{y end.
y % %: +/ | *: y
)
EPD=: 0 : 0
pc epd closeok;
minwh 450 450;
cc g isidraw flush;
pas 0 0;
)
epd_close=: 3 : 0
wd'pclose'
)
epd_g_mmove=: 3 : 0
'x y w h'=. 4 {. 0 ". sysdata
y=. h - y
rim=. unitvec (x,y) - -: w,h
end=. rim + MATRIX mp rim
j=. (MX,MY) + rim * X1,Y1
pts=. flipypos 2 4$(MX,MY), j, j, (MX,MY) + end * X1,Y1
glsel 'g'
glclear''
drawframe ''
glpen 2 1
drawpin LASTPTS
setcolor EIGENCOLOR
glpen 2 1
drawpin pts
drawpic''
glpaint ''
LASTPTS=: pts
)
epd_g_resize=: epdraw
epd_cancel_button=: epd_close
epdraw=: 3 : 0

if. opened=. 0=wdisparent 'epd' do.
  wd EPD
  wd 'pn *',SYSNAME
  wd 'pmove 600 50 -1 -1'
end.
wd'pshow'

wd 'psel epd'
glsel 'g'
'w h'=. glqwh''
CX=: CY=: w <. h

OFF=: rndint -: (w-CX), h-CY

glrgb BACKCOLOR
glpen 1 1 [ glbrush''
glrect 0 0,w,h

glrgb FORECOLOR
glbrush''
glpen 1 1
gltextcolor ''
drawframe''
genpic WID * _1 _1 2 2

if. opened do. wd'pshow' end.

drawpic''
)

ABOUT=: 0 : 0
An eigenpicture for a 2x2 matrix M is constructed as follows:

A set of spokes is drawn from the origin to a unit circle centered
on the origin.

For each spoke, draw an additional line equal to the the matrix
product of M with the position on the unit circle. If a spoke
happens to be an eigenvector, the additional line will be colinear with
the original.

Note that if you negate the matrix, the directions of these
additional lines are reversed.

In the drawings, the eigenvectors are shown in blue, and the value
corresponding to the current mouse direction is shown in red.

In the case of a double eigenvector, the two blue lines are superimposed.

In the case of complex eigenvectors, there is no spoke with a colinear
matrix product, and hence no blue line.
)
drawlines=: 3 : 0
y=. tomatrix y
gllines OFF movepos~ flipypos rndint (y scalepos X1,Y1) movepos MX,MY
)
drawpin=: 3 : 0
y=. rndint tomatrix y
f=. (,&2 2) @: <: @: (_2&{.)
gllines OFF movepos~ y
glellipse OFF moverect~ f"1 y
)

drawpic=: 3 : 0
setcolor FORECOLOR
glpen 1 1
drawpin FOREPIN
if. #AXISPIN do.
  setcolor AXISCOLOR
  glpen 2 1
  drawpin AXISPIN
end.
)
genpic=: 3 : 0

'x y w h'=. y

X1=: (CX * 1 - +:XMARGIN) % w
MX=: - CX * x % w

Y1=: (CY * 1 - +:YMARGIN) % h
MY=: - CY * y % h

rim=. (RIM *"1 X1,Y1) +"1 MX,MY
rimpts=. flipypos (MX,MY) ,"1 rim

pts=. (END *"1 X1,Y1) +"1 MX,MY
endpts=. flipypos rim ,"1 pts

if. IFCOMPLEX do.
  FOREPIN=: rimpts,endpts
  AXISPIN=: i.0 0
else.
  FOREPIN=: (4}.rimpts), (4}.endpts)
  AXISPIN=: (4{.rimpts), (4{.endpts)
end.

)
flipypos=: 3 : 0
ry=. $y
(ry $ 0, CY) + y * ry $ 1 _1
)
movepos=: [ + $@[ $ ]
moverect=: 13 : 'x + ($x)$y,0 0'
scalepos=: [ * $@[ $ ]
scalerect=: 4 : 0
new=. y * old=. 2 3{x
((2{.x)+-:old-new),new
)
drawframe=: 3 : 0

'x y w h'=. WID * _1 _1 2 2
'bx tx'=. rndint CX * (,-.) XMARGIN-TICMAJOR
'by ty'=. rndint CY * (,-.) YMARGIN-TICMAJOR

gllines OFF movepos~ bx,by,bx,ty,tx,ty,tx,by,bx,by
'minor pos'=. gettics x,x+w

len=. >: (1+minor) * <: #pos
mark=. len $(1,minor)#rndint CX * TICMAJOR, TICMINOR

x=. rndint bx + (tx-bx) * int01 len - 1
gllines OFF movepos~x ,. by ,. x ,. by+mark
gllines OFF movepos~x ,. ty ,. x ,. ty-mark
x=. bx + (tx-bx) * int01 (#pos) - 1
labs=. tominus@": each pos
glfont FONT
glfontextent FONT
off=. <. -: {."1 glqextent &> labs
p=. OFF movepos~ (x-off) ,. ty + CY * TICMAJOR
labs (gltext@>@[ gltextxy)"0 1 p
'minor pos'=. gettics y,y+h

len=. >: (1+minor) * <: #pos
mark=. len $(1,minor)#rndint CY * TICMAJOR, TICMINOR

y=. rndint by + (ty-by) * int01 len - 1
gllines OFF movepos~bx ,. y ,. (bx+mark) ,. y
gllines OFF movepos~tx ,. y ,. (tx-mark) ,. y
y=. (by - FONTSIZE%2) + (ty-by) * int01 (#pos) - 1
labs=. tominus@": each |. pos
glfont FONT
glfontextent FONT
off=. {."1 glqextent &> labs
p=. OFF movepos~ (bx-off + CX*TICMAJOR) ,. y

labs (gltext@>@[ gltextxy)"0 1 p
)
gettics=: 3 : 0

def=. 9

'min max'=. y

wid=. max-min

t=. 0.5 1 2 5 10 20 * pow10 <: <. log10 wid
ndx=. +/ def < wid%t

step=. ndx { t
min=. step rnddn min
pos=. min+step*i.>:>.(max-min)%step

max=. 3 + '5' e. ": step
minor=. (1,max) {~ max <: <. 40 % #pos

minor;pos
)
EP=: 0 : 0
pc ep closeok escclose;
menupop "Examples";
menu default "&Default" "" "" "";
menusep;
menu onezero "&Zero Eigenvalue" "" "" "";
menusep;
menu double "&Double Eigenvalue" "" "" "";
menusep;
menu complex "&Complex Eigenvalues (1)" "" "" "";
menusep;
menu complex2 "C&omplex Eigenvalues (2)" "" "" "";
menupopz;
menupop "Help";
menu about "&About" "" "" "";
menupopz;
bin vh;
groupbox "Matrix";
cc mat edit;
cc matrix static;
bin hs;
cc negate button;cn "Negate";
bin z;
groupboxend;
bin v;cc run button;cn "Run";
bin szzh;
groupbox "Eigenvalues";
cc ev1 static;
cc ev2 static;
groupboxend;
groupbox "Eigenvectors";
cc rv1 static;
cc rv2 static;
groupboxend;
bin zz;
pas 4 4;
)
ep_run=: 3 : 0
wdpclose 'ep'
wdpclose 'epd'
epinit''
wd EP
wd 'pn *',SYSNAME
wd 'set mat text *',":,MATCHAR
wd 'set matrix text *', addLF MATRIX
wd 'setfont mat fixfont'
wd 'setfont matrix fixfont'
wd 'setfont ev1 fixfont'
wd 'setfont ev2 fixfont'
wd 'setfont rv1 fixfont'
wd 'setfont rv2 fixfont'
wd 'set ev1 text;set ev2 text;set rv1 text;set rv2 text'
wd 'pmove 50 20 400 300'
wd 'pshow'
)
ep_close=: 3 : 0
smoutput 'ep_close'
try. wd 'psel epd;pclose' catch. end.
wd 'psel ep;pclose'
)
ep_about_button=: 3 : 0
wd 'mb about About *',topara ABOUT
)
ep_complex_button=: 3 : 0
MATRIX=: 2 2 $ ". MATCHAR=: '-1 2 _1 1'
epdoit''
)
ep_complex2_button=: 3 : 0
MATRIX=: 2 2 $ ". MATCHAR=: '-3 2 _1 1'
epdoit''
)
ep_default_button=: 3 : 0
MATRIX=: 2 2$ ". MATCHAR=: MATDEFAULT
epdoit''
)
ep_double_button=: 3 : 0
MATRIX=: 2 2 $ ". MATCHAR=: '(4-%:3), 1 _3, 4+%:3'
epdoit''
)
ep_negate_button=: 3 : 0
MATCHAR=: mat
if. '-' = {. MATCHAR do.
  MATCHAR=: }.MATCHAR
else.
  MATCHAR=: '-',MATCHAR
end.
MATRIX=: 2 2$ ". MATCHAR
epdoit''
)
ep_onezero_button=: 3 : 0
MATRIX=: 2 2$ ". MATCHAR=: '1 _1 _1 1'
epdoit''
)
ep_run_button=: 3 : 0
x=. ,@". :: 0: mat
if. (4~:$x) +. 0=isnumeric x do.
  info 'Invalid matrix definition'
else.
  if. iscomplex x do.
    info 'Matrix should be real'
  else.
    MATCHAR=: deb mat
    MATRIX=: 2 2$ x
    epdoit''
  end.
end.
)
ep_mat_button=: ep_run_button
ep_cancel=: ep_cancel_button=: ep_close
epdoit=: 3 : 0
FONT=: 0 1 {:: wd'qtstate profont'
FONTSIZE=: getfontsize FONT
calc''
wd 'set mat text *',":,MATCHAR
wd 'set matrix text *', addLF MATRIX
'x1 y1 x2 y2'=. tominus@": each , RV
'e1 e2'=. tominus@": each , EV
wd 'set rv1 text *',x1,LF,x2
wd 'set ev1 text *', e1
wd 'set rv2 text *', y1,LF,y2
wd 'set ev2 text *', e2
epdraw''
glpaint''
)
epinit=: 3 : 0
LASTPTS=: i.0 0
SPOKES=: 2 * >. -: SPOKES
)
ep_run''
