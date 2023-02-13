NB.  Script dwin.ijs
NB.  Functions for Windows based object graphics from J
NB.  by Cliff Reiter for "Fractals, Visualization and J, 4th edition"
NB.  Last modifications made Feb 2015. 
require 'trig gl2'
coclass 'fvj4'
coinsert 'trig jgl2 mkit'

IFJA_z_=: (IFJA"_)^:(0=4!:0<'IFJA')0

NB. ------------------------------------------------
NB. setWIN_WH v Sets the shape of the graphics window
NB. Example:
NB.    setWIN_WH 400 400
NB. sets a 400 by 400 pixel window
setWIN_WH=:3 : 'WIN_WH=:y'
setWIN_WH 500 500

NB. Set penstyle
PEN_style=:2 1

NB. function that defines the next window name
nx_WIN=:3 : 0
try. WIN_num=: WIN_num + 1 catch. WIN_num=: 0 end.
WIN_nam=:'p',": WIN_num
)

NB. ------------------------------------------------
NB. dwin v Opens a drawing window
NB. Example:  
NB.    _2 _3 2 3 dwin 'example'             
NB. opens a drawing window where coordinates range 
NB. from _2 to 2 in x and _3 to 3 in y and 
NB. window name "example"
dwin=: 3 : 0           NB. pixel sized window drawing
0 0 1 1 dwin y
:
a=. '' conew 'fvdwin'
xx__a=: x [ yy__a=: y
run__a`wd@.IFJA 'activity ',>a
EMPTY
)


NB. ------------------------------------------------
NB. dline v Draw lines in last openned window
NB. Draw lines (vertices listed in y) in color x
NB. Example:
NB.    255 0 0 dline 0 0 ,0 1,: 1 1
NB. draws two line segments: from 0 0 to 0 1 and 0 1 to 1 1
NB. coordinates may be Cartesian or Homogeneous
dline=: 3 : 0 "1 2    
0 0 0 dline y
:
Y=.x:^:_1 SC 2{."1 y
wd 'psel ',WIN_nam
glrgb x
glbrush ''
glpen PEN_style
gllines ,<.0.5+,Y
' '[glpaint ''
)

NB. ------------------------------------------------
NB. dfillcolor v Internal utility to set fill color
dfillcolor=: 3 : 0     NB. Start Fill Color
wd 'psel ',WIN_nam
if. _1 e.y do. glbrushnull '' 
   else. glrgb y
   glbrush''
end.
)

NB. ------------------------------------------------
NB. dpoly v Draws polygon in an open window
NB. Example:
NB.    255 0 0 dpoly 0 0,100 0,:100 100   
NB. draws a red triangle
dpoly=: 3 : 0 "1 2     
0 0 0 dpoly y
:
Y=.x:^:_1 SC 2{."1 y
wd 'psel ',WIN_nam
dfillcolor x
glpolygon ,Y
' '[glpaint''
)

NB. ------------------------------------------------
NB. dpixel v Draws pixel in an open window
NB. Example:
NB.    0 255 0 dpixel 0 0,100 0,:100 100   
NB. draws three green pixels
dpixel=: 3 : 0    NB. Show pixel
0 0 0 dpixel y
:
wd 'psel ',WIN_nam
glrgb x
Y=.x:^:_1 SC 2{."1 y
glpixel <.0.5+Y
' '[glpaint ''
)

NB. ------------------------------------------------
NB. dclear v Clears the screen
dclear=: 3 : 0
wd 'psel ',WIN_nam
glclear ''
glfill 255 255 255 255
' '[glpaint ''
)

NB. ------------------------------------------------
NB. delay v Internal delay utility for animations
delay=: 6!:3

NB. ------------------------------------------------
NB. dawin v  Open a 2-D animation window
NB. Draw animation window; x is xmin,ymin,xmax,ymax,delay
NB. Example:
NB.    0 0 1 4 2 dawin 'slow'
NB. opens a drawing window with x-values between 0 and 1,
NB. y-values between 0 and 4, and a 2 second frame delay.
dawin=: 3 : 0           
0 0 1 1 1 dawin y
:
a=. '' conew 'fvdawin'
xx__a=: x [ yy__a=: y
run__a`wd@.IFJA 'activity ',>a
EMPTY
)

NB. ------------------------------------------------
NB. dapoly v Displays animated list of 2-D polygons
dapoly=: 3 : 0     NB. Show polygon
0 0 0 dapoly y
:
if. (1=$$x) do. X=.(#y)$,:x else. X=.x end.
Y=.x:^:_1 SC 2{."1 y
wd 'psel ',WIN_nam
if. IFJA do.
  kk=: 0
  XX=: X [ YY=: Y
  wd 'ptimer ',":<.1000*DELAY
  return.
end.
k=.0
while. k<#y do.
  glclear ''
  dfillcolor k{X
  glpolygon ,k{Y
  glpaintx ''
  wd 'msgs'
  delay DELAY
  k=.>:k
end.
''
)

dapoly2=: 3 : 0      NB. animate polygon using ptimer
if. kk<#YY do.
  wd 'psel ',WIN_nam
  glsel 'g'
  glclear ''
  glfill 255 255 255 255
  dfillcolor kk{XX
  glpolygon ,kk{YY
  glpaint ''
  kk=:>:kk
else.
  kk=: 0
  wd 'ptimer 0'
end.
''
)

NB. ------------------------------------------------
NB. SETVPP v Set 3-D view parameters
NB. Example:
NB.   SETVPP 0 0 0;2 3 1;0 0 1 
NB. sets the center of interest to 0 0 0,
NB. the view position to 2 3 1 and sense of up to 0 0 1
NB. CIVPUP n Global variable giving the 3-D view parms
SETVPP=:3 : 'CIVPUP=:y'
SETVPP 0 0 0;2 3 1;0 0 1         

NB. ------------------------------------------------
NB. SETAXES v Set flag for drawing axes or not
NB. 0 for no, 1 for yes.
NB. SHOWAXES n Global Boolean flag for drawing axes or not
SETAXES=:3 : 'SHOWAXES=:y'
SETAXES 1

NB. ------------------------------------------------
NB. VPPXYZ v Projects 3-D coordinates into XYZ homog screen coords
VPPXYZ=: 3 : 0
CIVPUP VPPXYZ y
:
'ci vp up'=.x    
unit=. % +/&.(*:"_)
cross=.[: -/ . * (=i.3)"_,"1 2 ,:
n0=.unit vp-ci
v0=.unit up - n0 * n0 +/ . * up
u0=.v0 cross n0
t0=.u0,.v0,.n0
r=.-vp +/ . * t0
t=.(t0,.0),r,1
(4 {.!.1"1 y) +/ . * t
)

NB. VPP Gives the screen coords of the projection 
VPP=: 2&{."1@:VPPXYZ

NB. VPZ Gives the distance to the screen of the projection into screen 
VPZ=: 2&{"1@:VPPXYZ

NB. ------------------------------------------------
NB. d3win v Open a 3-D display window 
NB. x gives xmin,ymin,zmin,xmax,ymax,zmax
d3win=: 3 : 0           
0 0 0 1 1 1 d3win y
:
a=. '' conew 'fvd3win'
xx__a=: x [ yy__a=: y
run__a`wd@.IFJA 'activity ',>a
EMPTY
)

NB. ------------------------------------------------
NB. d3poly v Draws 3-D polygons in the 3-D window
NB. x gives colors, y gives polygons
d3poly=: 3 : 0 "1 2     
0 0 0 d3poly y
:
Y=.x:^:_1 SC 2{."1 VPP y
wd 'psel ',WIN_nam
if. SHOWAXES do. dline VPPAXES end.
dfillcolor x
glpolygon ,Y
' '[glpaint ''
)

NB. ------------------------------------------------
NB. d3awin v Open a 3-D animation drawing window
NB. x gives xmin,ymin,zmin,xmax,ymax,zmax,delay
NB. y is the window name
d3awin=: 3 : 0           
0 0 0 1 1 1 1 d3awin y
:
a=. '' conew 'fvd3awin'
xx__a=: x [ yy__a=: y
run__a`wd@.IFJA 'activity ',>a
EMPTY
)

NB. ------------------------------------------------
NB. d3apoly v Display 3-D polygons in an animation
NB. x gives colors, y gives polygons
d3apoly=: 3 : 0    
0 0 0 d3apoly y
:
if. (1=$$x) do. X=.(#y)$,:x else. X=.x end.
Y=.x:^:_1 SC 2{."1 VPP y
wd 'psel ',WIN_nam
if. IFJA do.
  kk=: 0
  XX=: X [ YY=: Y
  wd 'ptimer ',":<.1000*DELAY
  return.
end.
k=.0
while. k<#y do.
  glclear ''
  if. SHOWAXES do. dline VPPAXES end.
  dfillcolor k{X
  glpolygon ,k{Y
  glpaintx ''
  wd 'msgs'
  delay DELAY
  k=.>:k
end.
''
)

d3apoly2=: 3 : 0     NB. animate polygon using ptimer
if. kk<#YY do.
  wd 'psel ',WIN_nam
  glsel 'g'
  glclear ''
  glfill 255 255 255 255
  if. SHOWAXES do. dline VPPAXES end.
  dfillcolor kk{XX
  glpolygon ,kk{YY
  glpaintx ''
  kk=:>:kk
else.
  kk=: 0
  wd 'ptimer 0'
end.
''
)

NB. ------------------------------------------------
NB. rotx v Gives a homog. coord. matrix for rotation about the x-axis
NB.  Example:
NB.     rotx 1r2p1    
NB. give the homogeneous coordinate matrix rotating
NB. 90 degrees around the x-axis.
NB. Analagous functions roty and rotz are also defined.
rotx=:(1:,0:,0:,0:),(0:,cos , sin,0:),(0:,-@sin,cos,0:),:(0:,0:,0:,1:)
roty=:(cos , 0:,sin,0:),(0:,1:,0:,0:),(-@sin,0: ,cos,0:),:(0:,0:,0:,1:)
rotz=:(cos , sin, 0:,0:),(-@sin,cos,0:,0:),(0:,0:,1:,0:),:(0:,0:,0:,1:)

coclass 'base'

TRY1=: 0 : 0
sq=:#: 0 1 3 2
255 0 0 dpoly sq
dpoly -sq
0 255 0 dline (,{.)1+sq
)

try1=: 3 : 0
_1 _1 2 2 dwin 'try';T1
)

try=: 0 : 0
sq=:#: 0 1 3 2
_1 _1 2 2 dwin 'try'
255 0 0 dpoly sq
dpoly -sq
0 255 0 dline (,{.)1+sq
dclear''
255 0 0 dpixel ?20000 2$0 
wd'reset;'
_2 _2 2 2 0.1 dawin 'rot'
rot=:(cos,sin),:-@sin,cos
R=:(rot 1r40p1)&(+/ . *)"1
$pl=:R^:(i.120) sq
0 255 0 dapoly pl
wd'reset;'
_2 _2 _2 2 2 2 d3win '3d'
d3poly sq,.1
255 0 0 d3poly sq,.0
wd'reset;'
Rx=:(rotx 1r30p1)&(+/ . *)"1
Rz=:(rotz 1r30p1)&(+/ . *)"1
$pl1=:Rx^:(i.60) (sq,.0.5),.1
$pl2=:Rz^:(i.60) (sq,.0.5),.1
_2 _2 _2 2 2 2 0.1 d3awin '3d'
255 0 0 d3apoly pl1,pl2
)

NB. =========================================================
coclass 'fvdwin'
coinsert 'jgl2 fvj4'

create=: 0:

NB. JAndroid callback
onStart=: run

destroy=: 3 : 0
wd 'pclose'
codestroy ''
)

run=: 3 : 0           NB. pixel sized window drawing
x=. xx [ 'y cmd'=. 2{.boxopen yy
'a c b d'=.x        NB. note non-alphabetic order
SC_fvj4_=:WIN_WH&*@((-&(a,d)) %((b-a),c-d)"1)"1
sz=.":WIN_WH
if. IFJA do.
PN=.y,'; x: ',(":a),'/',(":b),' y: ',(":c),'/',":d
else.
PN=.y,';   Window bounds are x: ',(":a),' to ',(":b),'   y: ',(":c),' to ',":d
end.
nx_WIN_fvj4_ ''
". WIN_nam,'_close=: destroy'
if. #cmd do.
  CMD=: cmd
  ". WIN_nam,'_g_resize=: 3 : ''0!:100 CMD'''
end.
if. IFJA do.
z=.'pc ',WIN_nam,';pn "',PN,'";wh _1 _1;cc g isidraw;'
else.
z=.'pc ',WIN_nam,';pn "',PN,'";minwh ',sz,' ;cc g isidraw;'
end.
wd z,';pshow;'
''[glclear''
)

NB. =========================================================
coclass 'fvdawin'
coinsert 'jgl2 fvj4'

create=: 0:

NB. JAndroid callback
onStart=: run

destroy=: 3 : 0
wd 'pclose'
codestroy ''
)

run=: 3 : 0           NB. pixel sized window drawing
x=. xx [ 'y cmd'=. 2{.boxopen yy
'a c b d e'=.x
SC_fvj4_=:WIN_WH&*@((-&(a,d)) %((b-a),c-d)"1)"1
sz=.":WIN_WH
if. IFJA do.
PN=.y,'; x: ',(":a),'/',(":b),' y: ',(":c),'/',":d
else.
PN=.y,';   Animation window bounds are x: ',(":a),' to ',(":b),'   y: ',(":c),' to ',":d 
end.
nx_WIN_fvj4_ ''
". WIN_nam,'_timer=: dapoly2'
". WIN_nam,'_close=: destroy'
if. #cmd do.
  CMD=: cmd
  ". WIN_nam,'_g_resize=: 3 : ''0!:100 CMD'''
end.
if. IFJA do.
z=.'pc ',WIN_nam,';pn "',PN,'";wh _1 _1;cc g isidraw;'
else.
z=.'pc ',WIN_nam,';pn "',PN,'";minwh ',sz,' ;cc g isidraw;'
end.
wd z,';pshow;'
glclear''
DELAY_fvj4_=:e
)

NB. =========================================================
coclass 'fvd3win'
coinsert 'jgl2 fvj4'

create=: 0:

NB. JAndroid callback
onStart=: run

destroy=: 3 : 0
wd 'pclose'
codestroy ''
)

run=: 3 : 0           NB. pixel sized window drawing
x=. xx [ 'y cmd'=. 2{.boxopen yy
'a c e b d f'=.x    NB. note non-alphabetic order
'A C B D'=.,(<./,:>./) VPP >,{(a,b);(c,d);e,f
SC_fvj4_=:WIN_WH&*@((-&(A,D)) %((B-A),C-D)"1)"1
VPPAXES_fvj4_=:2{."1 VPP ((a,0 0),:b,0 0),((0,c,0),:0,d,0),:(0 0,e),:0 0,f
sz=.":WIN_WH
if. IFJA do.
PN=.y,'; x: ',(":a),'/',(":b),' y: ',(":c),'/',(":d),' z: ',(":e),'/',":f
else.
PN=.y,';   Bounds are x: ',(":a),' to ',(":b),'   y: ',(":c),' to ',(":d),'   z: ',(":e),' to ',":f
end.
nx_WIN_fvj4_ ''
". WIN_nam,'_close=: destroy'
if. #cmd do.
  CMD=: cmd
  ". WIN_nam,'_g_resize=: 3 : ''0!:100 CMD'''
end.
if. IFJA do.
z=.'pc ',WIN_nam,';pn "',PN,'";wh _1 _1;cc g isidraw;'
else.
z=.'pc ',WIN_nam,';pn "',PN,'";minwh ',sz,' ;cc g isidraw;'
end.
wd z,';pshow;'
glclear''
)

NB. =========================================================
coclass 'fvd3awin'
coinsert 'jgl2 fvj4'

create=: 0:

NB. JAndroid callback
onStart=: run

destroy=: 3 : 0
wd 'pclose'
codestroy ''
)

run=: 3 : 0           NB. pixel sized window drawing
x=. xx [ 'y cmd'=. 2{.boxopen yy
'a c e b d f g'=.x    NB. note non-alphabetic order
'A C B D'=.,(<./,:>./) VPP >,{(a,b);(c,d);e,f
SC_fvj4_=:WIN_WH&*@((-&(A,D)) %((B-A),C-D)"1)"1
VPPAXES_fvj4_=:2{."1 VPP ((a,0 0),:b,0 0),((0,c,0),:0,d,0),:(0 0,e),:0 0,f
DELAY_fvj4_=:g
sz=.":WIN_WH
if. IFJA do.
PN=.y,'; x: ',(":a),'/',(":b),' y: ',(":c),'/',(":d),' z: ',(":e),'/',":f
else.
PN=.y,';   Animation bounds are x: ',(":a),' to ',(":b),'   y: ',(":c),' to ',(":d),'   z: ',(":e),' to ',":f
end.
nx_WIN_fvj4_ ''
". WIN_nam,'_timer=: d3apoly2'
". WIN_nam,'_close=: destroy'
if. #cmd do.
  CMD=: cmd
  ". WIN_nam,'_g_resize=: 3 : ''0!:100 CMD'''
end.
if. IFJA do.
z=.'pc ',WIN_nam,';pn "',PN,'";wh _1 _1;cc g isidraw;'
else.
z=.'pc ',WIN_nam,';pn "',PN,'";minwh ',sz,' ;cc g isidraw;'
end.
wd z,';pshow;'
glclear''
)

NB. export to z locale
3 : 0''
wrds=. 'PEN_style SETAXES SETVPP VPP VPPXYZ VPZ'
wrds=. wrds, ' d3apoly d3awin d3poly d3win dapoly dawin'
wrds=. wrds, ' dclear dfillcolor dline dpixel dpoly'
wrds=. wrds, ' dwin rotx roty rotz setWIN_WH'
wrds=. > ;: wrds
cl=. '_fvj4_'
". (wrds ,"1 '_z_ =: ',"1 wrds ,"1 cl) -."1 ' '
EMPTY
)
