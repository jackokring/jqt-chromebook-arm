NB. Utilities and viewing parameters for a
NB. creating POV-Ray files from J
NB. For use with Fractals, Visualization and J, 4th Edition
NB. by Cliff Reiter
NB. Last updated 2015

require 'files'
coinsert 'fvj4'
coclass 'fvj4'

NB. ------------------------------------------------
NB.* view_pars_sample n Sample viewing parameters
view_pars_sample=:0 : 0
// set viewing parameters
camera{
	location <20,30,10>
    angle 30
    up <0,0,1>
	right <0,1,0>
    sky <0,0,1>
    look_at<0,0,0>
	}
//#default{finish{ambient 0.3}}
object{light_source{<200,100,50> color rgb<2,2,2>}}
background {color rgb<1,1,1>}
)

NB. ------------------------------------------------
NB.* view_pars_menger n Menger Sponge viewing params
view_pars_menger=:0 : 0
camera{
	location <40,18,12>
//	location <44*cos(2*pi*clock),44*sin(2*pi*clock),12>
    angle 5
    up <0,0,1>
	right <0,1,0>
    sky <0,0,1>
    look_at<0,0,0>
	}
#default{finish{ambient 0.5 diffuse 0.5}}
object{light_source{<200,100,50> color rgb<2,2,2>}}
background {color rgb<1,1,1>}
)

NB. ------------------------------------------------
NB.* menger_ini File used to create an animation
menger_ini=: 0 : 0
Initial_Frame=0
Final_Frame=99
Subset_Start_Frame=0
Subset_End_Frame=99
Input_File_Name=menger_ani.pov

Cyclic_animation=On
Pause_when_Done=Off
Output_File_Type=S

Sampling_Method=1
Antialias_Threshold=0.5
Antialias_Depth=2
Jitter=Off
Test_Abort_Count=100
)

NB. ------------------------------------------------
NB.* view_pars_life n Game of Life view params
view_pars_life=:0 : 0
camera{
	location <30,40,20>
    angle 3.1
    up <0,0,1>
	right <0,1,0>
    sky <0,0,1>
    look_at<0,0,0>
	}
#default{finish{ambient 0.3}}
object{light_source{<200,100,50> color rgb<2,2,2>}}
background {color rgb<1,1,1>}
)

NB. ------------------------------------------------
NB.* life_evo_pov v Function to create Life 3D scene
   life_evo_pov=: 4 : 0
]colors=:1,(],-.,0&*)=i.3
k=.0
dx=:2%>./$x
xy=:_1+dx*>{<@i."0 $ x
view_pars_life fwrite y
while. k<#x do.
  m=.,x
  c=.(m#,neigh x){colors
  xyz=.m#,/xy,"1]_1+dx*k
  (c fmtbox xyz,"1 xyz+dx) fappends y
  x=.life x
  k=.k+1
end.
)

NB. ------------------------------------------------
NB.* view_pars_3sines n View paras for 3 sines surface
view_pars_3sines=:0 : 0
camera{
	location <-40,-60,40>
    angle 40
    up <0,0,1>
	right <0,1,0>
    sky <0,0,1>
    look_at<0,0,0>
	}
#default{finish{ambient 0.35}}
object{light_source{<-200,-100,80> color rgb<2,2,2>}}
background {color rgb<1,1,1>}
)

NB. ------------------------------------------------
NB.* randunif v Gives random uniform arrays
NB. Example:
NB.    randunif 2 3
NB. gives a random uniform 2 by 3 array. Optional x
NB. gives interval range.
randunif=: ?@($&0) : ({.@[+({:-{.)@[*$:@])

NB. ------------------------------------------------
NB.* cos v cosine
cos=:2&o.

NB. ------------------------------------------------
NB.* randsn v Gives random standard normal numbers
NB.    randsn 2 3
NB. gives a 2 by 3 array of standard normal numbers
randsn=:cos@+:@o.@randunif * %:@-@+:@^.@randunif

NB. ------------------------------------------------
NB.* interp v Interpolation function from FVJ2
interp=:(}. + }:)@:(2:#-:)

NB. ------------------------------------------------
NB.* osz v Size boundary case utility for random walks
osz=:%:@-.@(2&^)@+:@<:@[

NB. ------------------------------------------------
NB.* sz v  Size case utility for random walks
sz=:osz * %@+:@<:@#@] ^ [

NB. ------------------------------------------------
NB.* randadd v Makes random additions w/ Hurst exponent
NB. Example:
NB.    0.7 randadd 4 4$0
NB. makes random (Hurst exponent 0.7) additions to the
NB. 4 by 4 zero matrix.
randadd=:] + sz * randsn@$@]

NB. ------------------------------------------------
NB.* interp2 v 2D interpolation utility for FVJ2
interp2=:interp"1@:interp

NB. ------------------------------------------------
NB.* plasma v Plasma cloud maker
NB. x is the Hurst exponent
NB. y is the number of refinements to use
plasma=:4 : 0
x ([randadd interp2@])^:y (x osz 1)*randsn 2 2
)

NB. ------------------------------------------------
NB.* fm a Fractal mountain maker
NB. Similar to plasma except the intial configuration is m
fm=:1 : 0
:
x ([randadd interp2@])^:y m
)

NB. ------------------------------------------------
NB.* m0 n An initial configuration
m0=:".;._2]0 : 0
_3  _3    2.2  1    _2
_1   1.5  1    0.5  _1
_0.5 1   _1   _2    _2
_1   0.5 _0.5  0.6  _1
_3  _2.5 _2.5 _1  _2.5
)
NB. ------------------------------------------------
NB.* view_pars_fm n Viewing parameters for the fractal mountain
view_pars_fm=:0 : 0
camera{
	location <50,0,10>
    angle 11
    up <0,0,1>
	right <0,1,0>
    sky <0,0,1>
    look_at<0,0,1>
	}
#default{finish{ambient 0.25}}
object{light_source{<120,100,180> color rgb<2,2,2>}}
object{plane{<0,0,1>,0}
  pigment{rgb<0.15,0.15,0.45>}
  normal{ripples 0.7}
  scale<0.1,1,0.01>
  finish{reflection 0.4 diffuse 0.2}}
object{plane{<1,0,0>,-9} 
  pigment{bozo turbulence 0.6
    color_map{
    [0   0.5 color rgb<0.34,0.75,1> color rgb<0.38,0.84,1>]
    [0.5 0.7 color rgb<0.38,0.84,1> color rgb<1,1,1>]
    [0.7 1   color rgb<1,1,1>     color rgb<0.75,0.75,0.75>]}}
  scale<1.3,1.3,0.4>
  finish{ambient 1 diffuse 0}
}
)

NB. ------------------------------------------------
NB.* view_pars_tetra n Viewing parameters for the tetrahedron
view_pars_tetra=:0 : 0
camera{
	location <30,40,20>
    angle 1.7
    up <0,0,1>
	right <0,1,0>
    sky <0,0,1>
    look_at<0.5,0.5,0.5>
	}
#default{finish{ambient 0.3}}
object{light_source{<200,100,50> color rgb<2,2,2>}}
background {color rgb<1,1,1>}
)
NB. ------------------------------------------------
NB.* view_pars_sier n View params for the n-D Sierpinski Fractal
view_pars_sier=:0 : 0
// set viewing parameters
camera{
	location <-12,40,10>
    angle 5
    up <0,0,1>
	right <0,1,0>
    sky <0,0,1>
    look_at<0,0,0.5>
	}
#default{finish{ambient 0.3}}
object{light_source{<-100,100,50> color rgb<2,2,2>}}
background {color rgb<1,1,1>}
)
NB. ------------------------------------------------
NB.* view_pars_weier n Viewing parameters for the Weierstrass Model
view_pars_weier=:0 : 0
// set viewing parameters
camera{
	location <0,35*cos(0.5*pi*clock),5+35*sin(0.5*pi*clock)>
    angle 40
    up <0,0,1>
	right <0,1,0>
    sky <0,0,1>
    look_at<0,0,5>
	}
#default{finish{ambient 0.4}}
object{light_source{<50,100,200> color rgb<2,2,2>}}
object{light_source{<50,-100,0> color rgb<1,1,1>}}
background {color rgb<1,1,1>}
)

NB. ------------------------------------------------
NB.* weier_ini File used to create an animation
weier_ini=: 0 : 0
Initial_Frame=0
Final_Frame=49
Subset_Start_Frame=0
Subset_End_Frame=49
Input_File_Name=weier.pov

Cyclic_animation=On
Pause_when_Done=Off
Output_File_Type=S

Sampling_Method=1
Antialias_Threshold=0.5
Antialias_Depth=2
Jitter=Off
Test_Abort_Count=100
)

NB. ------------------------------------------------
NB.* yellow_plane n A yellow plane
yellow_plane=:0 : 0
object{plane{<0,0,1>,0} texture{pigment{rgb<1,1,0>}}}
)

NB. view parameters for 3d cyclic cellular automata
view_pars_cca3d=:0 : 0
camera{
location <40,60,40>
angle 2.2
up <0,0,1>
right <0,1,0>
sky <0,0,1>
look_at<0,0,0>
      }
#default{finish{ambient 0.35}}
object{light_source{<200,100,80> color rgb<2,2,2>}}
background {color rgb<1,1,1>}
)

NB. view specified states in pov file
cca3d_pov=:1 : 0
:
colors=.Hue1 5r6*(i.%<:)#x
view_pars_cca3d fwrite y
's0 s1 s2'=.$m
dx=.2%>./$m
xyz=.,/,/_1+dx*(i.s0) ,"0 1/ (i.s1),"0/i.s2
for_k. i.#x do.
  M=.,m=k{x
  ((k{colors)fmtbox (, dx&+)"1 M#xyz)fappends y
end.  
fsize y
)

NB. For replicating a 0-1 cube data into 2 by 2 by 2
NB. repetitions. For chaotic attractors in 3D
pov222=:2 : 0
0.01 m pov222 n y
:
view_pars_menger fwrite y
for_dx. _1+2 2 2#:i.8 do.
  (m fmtsph (n+"1 dx),.x)fappends y
end.
fsize y
)

NB. Section of basic formatting utilities

NB. ------------------------------------------------
NB.* fmtn v Povray form formated number
fmtn=:rplc&'_-'  @ ":

NB. ------------------------------------------------
NB.* fmtvec v Povray formated vector
fmtvec=: '<'"_ , rplc&('_- ,')@": , '>'"_

NB. ------------------------------------------------
NB.* fmtsph v Povray formated sphere
NB. x is color
NB. y is a 4-tuple giving center and radius
fmtsph=:3 : 0"1
1 0 0 fmtsph y
:
z=.'object{sphere{',fmtvec }: y
z=.z,',',": {:y
z,'}pigment{rgb',(fmtvec x),'}}'
)

0.1 0.9 0.9 fmtsph 1 2 3 4

NB. ------------------------------------------------
NB.* fmtbox v Povray formated box
NB. x is color
NB. y is 6-tuple giving diagonal corners
fmtbox=:3 : 0"1
1 0 0 fmtbox y
:
z=.'object{box{',fmtvec 3 {. y
z=.z,',',fmtvec 3 }. y
z,'}pigment{rgb',(fmtvec x),'}}'
)

0 0 0 fmtbox 1 2 3 4 4 4

NB. ------------------------------------------------
NB.* fmtsph v Povray formated cylinder
NB. x is color
NB. y is a 7-tuple giving ends and radius
fmtcyl=:3 : 0"1
1 0 0 fmtcyl y
:
z=.'object{cylinder{',fmtvec 3 {. y
z=.z,',',fmtvec 3{. 3 }. y
z=.z,',',": {:y
z,'}pigment{rgb',(fmtvec x),'}}'
)

0 1 0 fmtcyl 1 2 3 4 4 4 1

NB. ------------------------------------------------
NB.* fmttri v Povray formated triangle
NB. x is color
NB. y is a 3 by 3 array of vertices

fmttri=:3 : 0"1 2
1 0 0 fmttri y
:
z=.'object{triangle{',fmtvec 0 { y
z=.z,',',fmtvec 1 { y
z=.z,',',fmtvec 2 { y
z,'}pigment{rgb',(fmtvec x),'}}'
)

NB. ------------------------------------------------
NB.* fmtquad v Povray formated quadralateral
NB. x is color
NB. y is 4 by 3 array of vertices
fmtquad=:3 : 0"1 2
1 0 0 fmtquad y
:
(x fmttri 0 1 3 { y),:(x fmttri 1 2 3 { y)
)

NB. ------------------------------------------------
NB.* fmtsphb v Povray formatted sphere of blob type
fmtsphb=:3 : 0"1
1 0 0 fmtsphb y
:
z=.'sphere{',fmtvec 3 {. y
z=.z,',',rplc&' ,'@": 3}.y
z,' pigment{rgb',(fmtvec x),'}}'
)

NB. ------------------------------------------------
fmtsphb 1 2 3 4 5

NB. ------------------------------------------------
NB.* fmtblob a Povray blob
NB. m gives the blob threshold
NB. x is the color
NB. y specify the sphere centers
fmtblob=:1 : 0
1 0 0 m fmtblob y
:
z=.'blob{threshold ',(": m),' '
z=.z,x fmtsphb y
z,'} '
)
NB. ------------------------------------------------
NB.* cile v Function for creating equicontours
cile=:$@] $ ((/:@/:@] <.@:* (%#)),)

NB. ------------------------------------------------
NB.* pwlin v Piecewise linear utility
pwlin=: 3 : 0
:
p=.>{.x
c=.>{:x
i=.i.&0 p<y
((1-r),r=.(y-~i{p)%-/(i-0 1){p)+/ .* (i- 0 1){c
)

NB. ------------------------------------------------
NB.* hue1 v function to create hues on 0-1 scale
Hue1=:((((i.7)%6);|."1#:7|3^i.7)&pwlin)"0 f.

coclass 'base'
