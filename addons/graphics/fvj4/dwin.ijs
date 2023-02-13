NB.  Script dwin2.ijs
NB.  Functions for Windows based object graphics from J
NB.  by Cliff Reiter for "Fractals, Visualization and J, 4th edition"
NB.  Last modifications made Feb 2015. 
coinsert 'jgl2 fvj4'
require 'trig gl2'
coclass 'fvj4'

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
'a c b d'=.x        NB. note non-alphabetic order
SC=:WIN_WH&*@((-&(a,d)) %((b-a),c-d)"1)"1
sz=.":WIN_WH
PN=:y,';   Window bounds are x: ',(":a),' to ',(":b),'   y: ',(":c),' to ',":d
nx_WIN ''
z=.'pc ',WIN_nam,' closeok;pn "',PN,'";minwh ',sz,' ;cc g isidraw;'
wd z,';pshow;'
''[glclear''
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
gllines <.0.5+,Y
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
' '[glpaint ''
)

NB. ------------------------------------------------
NB. delay v Internal delay utility for animations
delay=:6!:3

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
'a c b d e'=.x
SC=:WIN_WH&*@((-&(a,d)) %((b-a),c-d)"1)"1
sz=.":WIN_WH
PN=.y,';   Animation window bounds are x: ',(":a),' to ',(":b),'   y: ',(":c),' to ',":d 
nx_WIN ''
z=.'pc ',WIN_nam,' closeok;pn "',PN,'";minwh ',sz,' ;cc g isidraw;'
wd z,';pshow;'
glclear''
DELAY=:e
)

NB. ------------------------------------------------
NB. dapoly v Displays animated list of 2-D polygons
dapoly=: 3 : 0     NB. Show polygon
0 0 0 dapoly y
:
if. (1=$$x) do. X=.(#y)$,:x else. X=.x end.
Y=.x:^:_1 SC 2{."1 y
wd 'psel ',WIN_nam
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
'a c e b d f'=.x    NB. note non-alphabetic order
'A C B D'=.,(<./,:>./) VPP >,{(a,b);(c,d);e,f
SC=:WIN_WH&*@((-&(A,D)) %((B-A),C-D)"1)"1
VPPAXES=:2{."1 VPP ((a,0 0),:b,0 0),((0,c,0),:0,d,0),:(0 0,e),:0 0,f
sz=.":WIN_WH
PN=:y,';   Bounds are x: ',(":a),' to ',(":b),'   y: ',(":c),' to ',(":d),'   z: ',(":e),' to ',":f
nx_WIN ''
z=.'pc ',WIN_nam,' closeok;pn "',PN,'";minwh ',sz,' ;cc g isidraw;'
wd z,';pshow;'
glclear''
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
'a c e b d f g'=.x    NB. note non-alphabetic order
'A C B D'=.,(<./,:>./) VPP >,{(a,b);(c,d);e,f
SC=:WIN_WH&*@((-&(A,D)) %((B-A),C-D)"1)"1
VPPAXES=:2{."1 VPP ((a,0 0),:b,0 0),((0,c,0),:0,d,0),:(0 0,e),:0 0,f
DELAY=:g
sz=.":WIN_WH
PN=.y,';   Animation bounds are x: ',(":a),' to ',(":b),'   y: ',(":c),' to ',(":d),'   z: ',(":e),' to ',":f
nx_WIN ''
z=.'pc ',WIN_nam,' closeok;pn "',PN,'";minwh ',sz,' ;cc g isidraw;'
wd z,';pshow;'
glclear''
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
)

NB. ------------------------------------------------
NB. rotx v Gives a homog. coord. matrix for rotation about the x-axis
NB.  Example:
NB.     rotx 1r2p1    
NB. give the homogeneous coordinate matrix rotating
NB. 90 degrees around the x-axis.
NB. Analagous functions roty and rotz are also defined.
rotx=:(1 0 0 0),(0,cos , sin,0:),(0,-@sin,cos,0:),:(0 0 0,1:)
roty=:(cos , 0,-@sin,0:),(0 1 0 0),(sin,0 ,cos,0:),:(0 0 0,1:)
rotz=:(cos , sin , 0 , 0:) , (-@sin , cos , 0 , 0:) , 0 0 1 0 ,: 0 0 0 , 1:

coclass 'base'

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