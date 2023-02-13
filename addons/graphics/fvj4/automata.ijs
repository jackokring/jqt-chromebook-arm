NB. Script automata.ijs
NB. by Cliff Reiter for "Fractals, Visualization and J"
NB. October 2005
NB. January 2007 update for J601
NB. August 2015 update for J804 and FVJ4
NB. March 2017 update for J805 and FVJ4 Part2
coinsert 'fvj4'
require '~addons/media/imagekit/html_gallery.ijs'
IFJA_z_=: (IFJA"_)^:(0=4!:0<'IFJA')0
require^:(-.IFJA) '~addons/graphics/fvj4/raster.ijs'
require^:IFJA '~addons/graphics/fvj4/raster_ja.ijs'
coclass 'fvj4'

NB. Section 7.1

NB. 1-D Boolean automata rule
rule=: (8#2)&#:

NB. local function to apply a rule
lauto=: {~ #.

NB. periodic extension function
perext=: {: , ] , {.
   
NB. global automata function
auto=: 4 : '(3: x&lauto\ perext) y'

NB. function that evolves
autoevo=: auto ^:(i.@#@])

NB. super pixel function
spix=:[ # #"_1

NB. reverse rule function
rrule =: |.@rule

NB. function to make evolution pictures
mk_auto=:3 : 0
b=. (rule y) autoevo ?.64$2
((|.BW256);6 spix 255*b) write_image path,'auto',(nfmt y),'.png'
)

NB. 7.2

NB. probabilistic or
por=: (+ - *)"0

NB. probabilistic and
pand=: *

NB. local fuzzy automaton
lfauto=: 2 : 0
:
u/ (-.x##:i.8) v/ . (|@-) y
)

NB. Global Fuzzy Automoton
fauto=: 2 : 0
:
3 (x&(u lfauto v)\) perext y
)

NB. Fuzzy evolution
fautoevo=: 2 : 0
:
x(u fauto v)^:(i.@#@]) y
)

NB. scale [0,1] to integer 0 255
lin256=: <.@(255.99&*)

NB. specialized function to create examples 
NB. of fuzzy evolution
mk_fz_auto=:3 :0
b=: 6 spix lin256 (rule y) por fautoevo pand 0.01*?.64$101
(P256;b) write_image path,'p',(nfmt y),'.png'
)

NB. 7.3
L=. 1,1 9 1,:1

NB. local life
llife=: +/@:,@(L&*) e. 3 11 12"_

NB. 2-D periodic extension
perext2=: perext"1@:perext

NB. Gloal life function 
life=: 3 3&(llife;._3)@ perext2 

NB. used for color version in 10.4
neigh=: * 3 3"_ +/@,;._3 perext2

NB. Show automata adverb
show_auto=: 1 : 0
100 0.5 u show_auto y
:
'maxit delay'=.x
m0=.<.<./VRAWH%|.$y
VRAWH=:m0*|.$y
vwin 'auto'
y=.|.y
for. i. maxit do.
  VRA=:m0 spix <.255*y
  vfshow ''
  wd'msgs'
  y=.u y
  6!:3 delay 
end.
)

NB. 7.4

NB. local majority rule
lmajor=: (+/ > -:@#)@:, 

NB. global majority rule
major=: 3 3&(lmajor;._3)@ perext2 

NB. wider periodic extensions
nperext=: 1 : '(-m)&{. , ] , m&{.'

nperext2=: 1 : '({:m) nperext"1@:(({.m) nperext)'

NB. on a larger neighborhood
major2=:5 5&(lmajor;._3)@(2 nperext2) 

NB. an asymmetric variant 
major3=:5 5&(lmajor@(1 2 3&{);._3)@(2 nperext2) 

NB. 7.6 Hodgepodge

lhodge=: 1 : 0
'a b c N'=.m
ill=. #~ =&1
inf=. #~ ~:&0 *. ~:&1
case=. (~:&0 + =&1)@(4&{) 
avg=.+/ % #
forh1=. <.@:(*&(%a))@#@ill
forh2=. <.@:(*&(%b))@#@inf
forhea =. [: %&N forh1 + forh2
forinf=. 1 <. avg@inf + c"_
forill=. 0:
forhea`forinf`forill@.case@:, f.
) 

hodge=: 1 : '3 3&(m lhodge;._3)@ perext2' 

NB. 7.7 Packard Wolfram Snowflake

hxv=: 3 : '((# $ 2 0"_) |."0 1]) ''  '' ,"(1) 4j0 ": y'

hxvx=:3 : '((# $ 0 2"_) |."0 1]) ''  '' ,"(1) 4j0 ": y'

hx_init=: 3 : 0
hxSZ=: y
hxNV=:*: hxSZ
hxA=:hxNV$0
hxcen=:<:-:hxNV-hxSZ
nr0=. _1 1 |."0 _ i=. i. hxSZ
nr0=.nr0 ,_1 0 |."0 _ i+hxSZ
nr0=.nr0 ,_1 0 |."0 _ i-hxSZ
nr1=. _1 1 |."0 _ i=.i + hxSZ
nr1=.nr1 ,0 1|."0 _ i+hxSZ
nr1=.nr1 ,0 1|."0 _ i-hxSZ
$hxN=:hxNV|,/(hxSZ*i.&.-: hxSZ)+"0 _|:nr0,.nr1
)

packwolf=: 3 : 0
y+.1=+/"1 hxN{y
)

show_hx_auto=: 1 : 0
(0.1,~_2+<.-:%:#y) u show_hx_auto y
:
'maxiter delay'=.x
k=.0
szh=.<.+:hxSZ* 1 o. 2r3p1
rows=.<.(+:hxSZ%szh)*i.szh
VRAWH=:+:(+:hxSZ),szh
rot=.(1 1 0 0 $~ +:hxSZ)"_ |."0 1 ]
vwin 'Hex Auto'
while. k<maxiter do.
  y=. u y
  VRA=:2 spix rows{rot 2 spix (2#hxSZ)$ <.y*255
  vfshow ''
  wd'msgs'
  6!:3 delay
  k=.k+1
end.
hxSZ
)

NB. 7.8 Snowflake & Crystalization
avg=:+/ % #

cryst=: 3 : 0
0.001 cryst y
:
r=. +./"(1) 1=y,.hxN{y
nrv=.y*-.r
1 <. (avg"1 nrv,.hxN{nrv)+r*y+x
)

