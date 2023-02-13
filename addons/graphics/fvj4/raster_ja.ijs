NB. Script raster.ijs
NB. These utilities allow reading and writing and creating some raster image formats
NB. Script by Cliff Reiter for "Fractals, Visualization and J, 4th edition"
NB. Last modifications made January 2016 for J8.04.
require 'trig gl2'
require '~addons/media/imagekit/imagekit.ijs'
coclass 'fvj4'
coinsert 'trig jgl2 mkit'

IFJA_z_=: (IFJA"_)^:(0=4!:0<'IFJA')0

NB. Virtural Raster Array utilities begin here

NB. ------------------------------------------------
NB.* setVRAWH v sets VRA width and height in pixels
NB. global variable VRAWH contains the size information; 
NB. the default value for size of VRA is 500 by 500
NB. example:
NB.    setVRAWH 1440 1440
NB. sets the size to be larger for high resolution experiments
setVRAWH=:3 : 'VRAWH=:y'
setVRAWH 500 500

NB. ------------------------------------------------
NB.* vclear v clear VRA
NB. clears the contents from the virtual raster array (VRA) 
NB. without closing the window. Example:
NB.    vclear ''
vclear=:3 : 0
VRA_fvj4_=:(|.VRAWH) $ 0
try. vshow '' catch. end.
)

NB. function that defines the next window name
nx_WIN=:3 : 0
try. WIN_num=: WIN_num + 1 catch. WIN_num=: 0 end.
WIN_nam=:'p',": WIN_num
)

NB. ------------------------------------------------
NB.* vwin v open a new VRA window
NB. opens a virtual raster array drawing window 
NB. default bounds are 0 0 1 1 (first and last pairs give diagonal corners)
NB. example
NB.    _1 _1 1 1 vwin 'bob'
NB. opens a drawing window with both coordinate bounds between _1 and 1 and named "bob"
vwin=: 3 : 0           NB. pixel sized window drawing
0 0 1 1 vwin y
:
a=. '' conew 'fvwin'
xx__a=: x [ yy__a=: y
run__a`wd@.IFJA 'activity ',>a
EMPTY
)


NB.* vinwin v results in pixels in window range
NB. "v in win"
vinwin=:3 : 0
(*./"1 (y>:0)*.y<"1 VRAWH)#y
)

NB. ------------------------------------------------
NB.* vpixel v mark specified pixels
NB. sets pixels, Cartesian or homogeneous, with the drawing window bounds
NB. example:
NB.    vpixel 0.5 1
NB. or
NB.    vpixel 0.5 0.8 1
NB. would set the pixel the virtual raster array corresponding to the point 0.5 0.8
vpixel=: 3 : 0
1 vpixel y
:
''[VRA_fvj4_=:(|.VRAWH)$x((vinwin SCvra 2{."1 y) +/ . * 1,{.VRAWH)},VRA
)

NB. ------------------------------------------------
NB.* vline v sets line segments, 
NB. in Cartesian or homogeneous coordinates,
NB. in the virtual raster array drawing window
vline=: 3 : 0
1 vline y
:
d=.{:$y
pts=.SCvra y
lras=.[: vinwin {: ,~ [: <.@(0.5&+) {. +"1 ((i.%[)@(>./)@:| */ ])@({:-{.)
xpts=.;2 <@lras\ pts
''[VRA_fvj4_=:(|.VRAWH)$x(xpts +/ . * d{.1,{.VRAWH)},VRA
)

NB. ------------------------------------------------
NB.* vshow v display VRA data
NB. show the data in the Virtual Raster Array in the
NB. drawing window; palette is the optional left argument
vshow=: 3 : 0 
if. 0=#y do. pal=.255,:0 0 0 else. pal=.y end.
wd 'psel ',WIN_nam
NB. glsel 'win'
glclear ''
glpixels (0 0,VRAWH),,|.VRA{rgb_to_i pal
glpaintx ''
wd 'msgs'
)

NB. ------------------------------------------------
NB.* vfpixel v mark pixels tracking frequecy of visits
NB. adds pixel counts (thereby accumulating frequencies)
NB. to the virtual raster array
NB. 
vfpixel=: 3 : 0
nub=.~.s=.(vinwin SCvra 2{."1 y)+/ . * 1,{.VRAWH
freq=.#/.~s
''[VRA_fvj4_=:VRA+(|.VRAWH)$freq nub}(*/VRAWH)$0
)

NB. ------------------------------------------------
NB.* vfshow v show the frequency based VRA array 
vfshow=: 3 : 0 
if. 0=#y do. pal=.P254 else. pal=.y end.
wd 'psel ',WIN_nam
NB. glsel 'win'
glpixels (0 0,VRAWH),,(|.VRA<.255){rgb_to_i pal
glpaintx ''
)

NB. A cover function to iterate a random function "rt"
NB. used mainly in chapter 4
NB. "rt" must be defined by the user
rtiter=: 3 : 0
100 rtiter y
:
k=.0	
vwin 'IFS'	
vshow''
seed=.rt^:(100) 0.1 0.3 1
while. k<x do.
  d=.rt^:(i.y)seed
  seed=.{:d		
  vpixel d		
  vshow ''	
  k=.k+1
end.
''
)

NB. =========================================================
coclass 'fvwin'
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
NB. SCvra=:VRAWH&*@((-&(a,d)) %((b-a),c-d)"1)"1
SCvra_fvj4_=:<.@:((-&(a,c))"1 %(((b-a),d-c)%|.0.999999*|.VRAWH)"1)
sz=.":VRAWH
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
vclear''
NB. glclear''
NB. glshow''
)

NB. export to z locale
3 : 0''
wrds=. 'rtiter setVRAWH vclear vfpixel vfshow vinwin'
wrds=. wrds, ' vline vpixel vshow vwin'
wrds=. > ;: wrds
cl=. '_fvj4_'
". (wrds ,"1 '_z_ =: ',"1 wrds ,"1 cl) -."1 ' '
EMPTY
)

coclass 'base'
