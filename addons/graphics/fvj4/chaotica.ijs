NB. Script chaotica.ijs
NB. by Cliff Reiter for "Fractals, Visualization and J, 4th ed."
NB. Last major update, June 2016
NB. for J8.03
require 'files numeric trig'
require '~addons/media/imagekit/html_gallery.ijs'
IFJA_z_=: (IFJA"_)^:(0=4!:0<'IFJA')0
require^:(-.IFJA) '~addons/graphics/fvj4/raster.ijs'
require^:IFJA '~addons/graphics/fvj4/raster_ja.ijs'
coclass 'fvj4'

NB. Sets random seed randomly
randomize ''

NB. ------------------------------------------------
NB.* randunif v Gives random uniform numbers
randunif=: ?@($&0) : ({.@[+({:-{.)@[*$:@])

NB. 5.1 utilities
lg=: * * -.@]

lgrun=: 4 : 0
k=.0
x vwin 'logistic'
while. k<#y do.
  lam=.k{y
  vfpixel lam ,. lam lg^:(1000+i.10000) 0.1
  vfshow ''
  wd 'msgs'
  k=.k+1
end.
)

NB. later utilities

NB. ------------------------------------------------
NB.* P a Gives polynomial functions from coefficients
P=:1 : '((m"_ +/ . * {:) +/ . * {.)@(^/&(i.3))'

NB. ------------------------------------------------
NB.* diag v creates a specified diagonal matrix
diag =:+/@:* =@i.@#

NB. ------------------------------------------------
NB.* QR v Gives QR matrix factorization
QR=:128!:0

NB. ------------------------------------------------
NB.* ippp v Applies one step of QR on a parallelepiped and point
ippp=:1 : 0
'q r'=.128!:0 }.}:y
(u {.y),((|:u D. 1 {.y)+/ . * q),^. diag r
)

NB. ------------------------------------------------
NB.* avg v Gives average
avg=:+/%#

NB. ------------------------------------------------
NB.* Lexp a Estimates Ljapunov exponents
NB. u is the function
NB. x is the presample and sample size
NB. y is the seed point
Lexp=:1 : 0 ("1)
100 100 u Lexp y
:
avg {:"2 u ippp^:((+i.)/x) y,(=i.#y),1
)

NB. Two variable henon map
henon=: ({:+1:-1.4 * *:@{.),0.3*{.

NB. ------------------------------------------------
NB.* Lmin n Minimum acceptable Ljapunov exponent
NB. likewise Lmax
Lmin=:0.01
Lmax=:0.6

NB. ------------------------------------------------
NB.* ts v Tests time and space used to execute an expression
ts=:6!:2 , 7!:2@]

NB. ------------------------------------------------
NB.* clq v Collinear query
clq=:1e_6&$: : ([>({:"1 ([:>./@:|[-]+/ . * %.)1: ,.}:"1)@])

NB. ------------------------------------------------
NB.* perq v Periodic query to tolerance
perq=:1e_6&$: : (({: e. }:)@:<.@:%~)

NB. ------------------------------------------------
NB.* ca_create v This is the main Chaotic Attractor creator
NB. See fvj2 for the global objects needed to create the desired symmetry. 
NB. x gives the number of images to attempt to create
NB. y gives the file name prefix
ca_create=:3 : 0
2 ca_create y
:
'' fwrite y,'.ijs'
k=.0
seed=.0.3 0.2
while. k < x do.
  L=._1
  while. try. (perq X)+. (clq _10{.X)+.(Lmax<{.L)+.Lmin>{.L 
         catch. 1 end. do.
    try.
      f=:'' mkrandf
      X=.f^:(100+i.100) seed
      L=. f Lexp {:X
    catch.
    L=._1
    end.
  end.
  try.
    xy=.f^:(100+i.100000) seed
    win=:winbd xy
    win vwin 0
    vfpixel xy
    if. {.full=.fullness VRA do.
      (P254;|.cln254 VRA) write_image y,(nfmt k),'.png'
      fname=:'f',(short_fn y),nfmt k
      (LF,~s=.fname,'=:',5!:5<'f') fappends y,'.ijs'
      ".s
      k=.>:k
    end.
  catch.
    full=.0 _1
  end.
  smoutput 'k: ',(":k),' ful: ',(":}.full),' L: ',":L
  wd 'msgs'
  if. fexist y,'.break' do. return. end.
end.  
k
)

NB. ------------------------------------------------
NB.* arraywrite v Write an integer array to a file
NB. x is the array
NB. y is the filename
NB. Inverse arrayread also exists
arraywrite=:(3!:1)@[ fwrite ]
arrayread=: (3!:2)@fread

NB. y is a literal list of J names.
NB. to_script_form y
to_script_form=:3 : 0
;(,&.>  <@:('=:'&,)@(,&LF)@(5!:5)"0) ;:y
)

NB. ------------------------------------------------
NB.* ca_hr v Create a high resolution attractor
NB. Image of attractor f is created and frequency table/seed stored
NB. in a form suitable for subsequent enhancement
NB. x is number of preiterates and iterations to use 
NB. y is the filename prefix
ca_hr=:3 : 0
10000 1000000 ca_hr y
:
'preiter numiter'=.x
xy=.f^:(preiter+i.numiter) 0.2 0.3
win=:winbd xy
seed=:{:xy
win vwin 0
vfpixel xy
f=:f f.
(to_script_form 'f seed VRAWH win') fwrites y,'.ijs'
VRA arraywrite y,'.vra'
(P254;|.cln254 VRA) write_image y,'.png'
)

NB. ------------------------------------------------
NB.* ca_hr_add v Make additions to a Chaotic Attractor
NB. x is number of repetitions and iterations to use 
NB. y is the filename prefix
ca_hr_add=:3 : 0"1"1 _
19 1000000 ca_hr_add y
:
'reps numiter'=.x
0!:0< y,'.ijs'
win vwin 0
VRA=:arrayread y,'.vra'
k=.0
while. k<reps   do.
  xy=.f^:(i.numiter) seed
  seed=:{:xy
  vfpixel xy
  k=.k+1
end.
(to_script_form 'f seed VRAWH win') fwrites y,'.ijs'
VRA arraywrite y,'.vra'
(P254;|.cln254 VRA) write_image y,'.png'
)
NB. ------------------------------------------------
NB.* cile254 v Gives equiv-contour discretization
NB. From Section 5.1
cile254=:3 : 0
nnz=.+/*,y
nz=.nnz-~#rk=./:/:,y
(*y)*($ y)$1+<.(rk-nz)* 254%nnz
)
NB. ------------------------------------------------
NB.* lin254 v Gives linear discretization
lin254=:3 : 0
max=.>./@,y
(y>0)*1+<.(253.999%max-1)*y-1
)
NB. ------------------------------------------------
NB. cln254 v Gives log-bias cummulative discretization  
NB. cln254=:3 : 0
NB.  o=./:~ ,y
NB.  m=.(}.~:}:) o
NB.  p=.I. m,1
NB.  n=.p{o
NB.  ($y)$(n i. ,y){ 0 , >:@<.@(253.99&*)@(+/\ % +/)@:^.@(}.-}:) p
NB.)
cln254=:3 : 0
'n f'=.|:({.,#)/.~ /:~0,~,y
($y)$(n i. ,y){ 0 , >:@<.@(253.99&*)@(+/\ % +/)@:^. }.f
)

NB. ------------------------------------------------
NB. mkrandP a Make a random polynomial; see P early in script
mkrandP=:1 : '(_1.5 1.5 randunif 2 3 3) P'

NB. ------------------------------------------------
NB.* wincen v Automatic window range centering
wincen=:3 : '_1 _1 1 1 *1.05*>./|,y'

NB. ------------------------------------------------
NB.* mkrandf a Global make function adverb for ca_create
NB. likewise, winbd gives global for ca_create
mkrandf=:mkrandP
winbd=:wincen

NB. ------------------------------------------------
NB.* non0p v Fullness measure
NB. tests whether all rows and columns have been visited
NB. and appends the counts; 
NB. fullness is the global used by ca_create
non0p=:3 : '((+:+/$y)&<,])+/,* y'

fullness=:non0p

NB. 5.4 Utilities

NB. gives an y-fold rotation matrix
rotn=: ((cos,-@sin),:sin,cos)@+:@o.@%

NB. computes group closure of matrices
prods=:\:~@(~.!.1e_12)@(*!.1e_12*|)@([,(,/)@:((+/ . *)"2/))

NB. cyclic/dihedral group generator
NB. CD 4 gives the cylic group on four elements
NB. CD _4 gives the dihedral group on four elements
CD=: prods^:_~@:(rotn,:1 0,:0,*)

NB. sum of conjugates conjunction
sumcon=: 2 : 0
mp=.+/ . *
+/@((%.n) mp" 2 1 ])@:(u"1)@(n&mp) f.
)

NB. make random cyclic symmetry function  
mkrandCD=: 1 : 0
((_0.7 0.7 randunif 2 3 3) P)sumcon (CD (<:+:?2)*3+?4)
)

NB. trig product builder
T=: 1 : '[: (+/"1^:2) 1 2&(o./)@:(1 2 3&*)"0 * m"_ '

NB. trig functions with symmetry
mkrandCDT=: 1 : 0
((_0.4 0.4 randunif 2 2 3) T)sumcon (CD (<:+:?2)*3+?10)
)

NB. 5.5 Hyperbolic utilities and Symmetry builders
W2P=: (}: % >:@{:)"1		

P2W=: ( ](-.@] %~ +:@[,>:@]) (+/)@:*:)"1

mkA=: 4 : 0
b=.arccosh (cos 1p1%y)%sin 1p1%x
((-@cosh,0:,sinh), (0:, 1:, 0:) ,: -@sinh, 0:, cosh) 2*b
)
   
mkB=: (1 _1 1*=i.3)"_
   
mkC=: 4 : 0
(((cos , sin),: sin , -@cos),0 0 1"_ ) 2p1%x
)
   
mkT=: mkA +/ . * mkC
   
mkS=: mkC +/ . * mkB
      
ABCST=: mkA,mkB,mkC,mkS,:mkT

pq=: 4 : 0
'a b c s t'=.x ABCST y
cp=.prods^:_~ ,:c
pp=.prods^:_~ ,:s
qp=.prods^:_~ ,:t
pp prods cp prods qp prods pp
)

pQ=: 4 : 0
'a b c s t'=.x ABCST y		
pp=.prods^:_~ ,:s			
qp=.prods^:_~ ,:t
pp prods qp prods pp
)

Pq=: 4 : 0
'a b c s t'=.x ABCST y
ap=.prods^:_~ ,:a
pp=.prods^:_~ ,:s
ap prods pp prods ap prods pp
)

rat=: 1 : ' +/ . * (?@((#m)"_)){m"_'

det=: -/ . *

area=: |@det@:(}.-"1{.)"2

rwat=: 2 : 0
{&m@(i.&1)@(<&(+/\(%+/)n))@randunif@(''"_) +/ . * ]
)

mkhyp=: 2 : 0
raff=.m rat
pts=. (1e_3*#:i.3)+"1 }: raff^:(100) 0.6 0.4 1
wt=. area W2P n (+/ . *)"2 1"2 _ P2W pts
rpq=. n rwat wt		
W2P@rpq@P2W@:((}:@raff@(,&1) f.)`]@.(?@2:)) f.
)

mask=: + (+./\. 255&*@:-.@:*. +./\.&.|.)@:*

NB. 5.6 Frieze Utilities
four=: 1 , sin , cos , sin@+: , cos@+:

PY=: 1 : 0
1 0 | (m +/ . * {: ^ (i.3)"_) +/ . * four@(2p1&*)@{.
)

mkrandPY=: 1 : '((m*_1 1) randunif 2 5 3) PY'

winfrz=: 3 : ',0 1 ,._1 1 *1.05*>./|{:"1 y'

fullfrz=: 3 : '((#=+/),+/)+./*y'

tile_image=:3 : 0"1
2 2 tile_image y
:
b=.read_image y
'r s'=.<.x * 2{.$ b
b=.s$"_1 r$b
b write_image y
)

prods2=:  (\:*)@prods

]tr=. 0,0,:1 1 0

Prods=: [: ~. tr"_ f. |"2 prods2

frzcon=: 2 : 0
mp=.+/ . *
1 0"_ | 1 0&* + }:@(+/)@(] mp"1 2 (%.n)"_)@:((,1:)@u@}:"1)@(] mp"1 2 n"_)@(,1:) f.
)
frzcon=: 2 : 0
mp=.(+/ . *)"1 2
1 0 | 1 0&* + }:@(+/)@(] mp (%.n)"_)@:((,1:)@u@}:"1)@(] mp n"_)@(,1:) f.
)

mkrandfrz=: 2 : ' 0.5 mkrandPY frzcon n'

]mr0=. _1 0 0,0 1 0,:0 0 1

]gl1=. 1 0 0, 0 _1 0,:0.5 0 1

]pma2=: Prods^:_~ gl1,:mr0

]id=. =i. 3

]in1=. _1 0 0,0 _1 0,:0 0 1

]mr1=. 1 0 0,0 _1 0,:0 0 1

$p111=: Prods^:_~ ,:id

$p112=: Prods^:_~ ,:in1

$pm11=: Prods^:_~ ,:mr0

$p1m1=: Prods^:_~ ,:mr1

$p1a1=: Prods^:_~ ,:gl1

$pmm2=: Prods^:_~ mr0,:mr1

NB. 5.7

DF=:1 : '1 |((m +/ .*{:)+/ . *{.)@:(four"0)@(2p1&*)'

mkrandDF=: 2 : '((m*_1 1) randunif 2 5 5) DF'

L_randf =: 3 : 'f Lexp (f=:0 mkrandf)^:(200) 0.3 0.2'"0

crycon=: 2 : 0
mp=.(+/ . *)"1 2
1 | ] + }:@(+/)@(] mp (%.n)"_)@:((,1:)@u@}:"1)@(] mp n"_)@(,1:) f.
)

mkrandcry=: 2 : ' m mkrandDF 0 crycon n'

winsq=: 0 0 1 1"_ 

fullsq=: 3 : '(([:*./#=+/),+/)(+./,.+./"1)*y'

NB. 5.8

unit=: % +/&.:*:

]v2=. +. r. 2r3p1

]v1=. 1 0

]Lat_hx=: v1,.v2

underhx=: 1 : '1 0 | u&.(%.&Lat_hx)'
   
modhx=: 1&| underhx

mkrandhx=: 2 : '(m mkrandDF 0) underhx'

hxcon=: 2 : 0
mp=.(+/ . *)"1 2
[: modhx (+/)@(] mp (%.n)"_)@:(u"1)@(] mp n"_) f.
)

hxwh=: [: <. *&(1,1 o. 2r3p1)
   
winhx=: (0 0 1 ,1 o. 2r3p1)"_ 

fullhx=: 3 : '(*./@(VRAWH&=),])(+/@(+./),+/@:(+./"1))*y'

pal_read=:3 : 0
if. 'bmp'-:_3{. y do. pb=.pal_read_bmp y
                 else. pb=.pal_read_png y end.
pb
)

hx_rep=: 3 : 0
'p b'=.pal_read y
b=.,.~b
(p;((<.-:-:{:$b)|."1 b),b) write_image y
)

NB. 5.9
DFc=: 1 : 0
1&|&.(0.5&+)@((m"_ +/ . * {: )+/ . * {.)@:(four"0)@(2p1&*)
)

mkrandDFc=: 2 : '((m*_1 1) randunif 2 5 5) DFc'

sqforcon=: 2 : 0
mp=.(+/ . *)"1 2
1&|&.(0.5&+)@(+/)@(]mp(%.n)"_)@:(u"1)@(] mp n"_)f.
)

winsqfor=: _0.5 _0.5 0.5 0.5"_

mkrandsqfor=: 2 : ' m mkrandDFc 0 sqforcon (CD n)'

NB. 10.6 Lorenz Attractor

NB. Lorenz attractor with general parameters
LZ=: 1 : 0
'S B R'=.m
M=.((-S),S,0 0 0),(R,_1 0 0 _1),:0 0,(-B),1 0
M&(+/ . *)@(],{.*}.)
)

NB. classic parameters
lz=:(10,(8%3),28) LZ

NB. classic Runge-Kutta 4th order
RK=: 1 : 0
:
h2=.x%2
k1=.u y
k2=.u y+h2*k1
k3=.u y+h2*k2
k4=.u y+x*k3
y+(x%6)*k1+k4++:k2+k3
)


coclass 'base'
