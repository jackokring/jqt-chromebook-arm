NB. complex.ijs
NB. Utilities for complex dynamics

IFJA_z_=: (IFJA"_)^:(0=4!:0<'IFJA')0
require^:(-.IFJA) '~addons/graphics/fvj4/raster.ijs'
require^:IFJA '~addons/graphics/fvj4/raster_ja.ijs'

NB. Escape time for complex iteration
NB. u is the function
NB. n is escape bound and iteration bound pair
NB. y is the array of complex inputs
escapetc=: 2 : 0
#@((,u@{:)^:(<&({:n)@# *. (<&({.n)@|@{:))^:_) f."0
) 

NB. create an array of uniformly spaced 
NB. complex numbers
NB. x is number of horizontal pixels
NB. y is pair of complex numbers giving the 
NB. center left and upper right corners of the array.
   zl_clur=: 4 : 0
w=.-~/9 o.y
h=.-~/11 o.y
xs=.({.y)+w*(i.%<:)1+x
ys=.h*(i:%j.)<.0.5+x*h%w
ys +/ xs
)

NB. make good julia set (for an elliptic curve)
NB. x scale factor for random coefficients
NB. y is pair giving minimal number of distinct 
NB. escape times and minimal number of white (bound) pixels.
mk_gjs=:3 : 0
1 mk_gjs y
:
'nnb rqw'=.y
whilst. (nnb>#~.,b) +. rqw>+/255=,b do.
  coef=: 1,~x*j./-/?2 2 3$0
  f=:[: %: coef&p.
  b=:f escapetc (10 255) 100 zl_clur _1.5 1.5j1.5
end.
b=: f escapetc (10 255) 500 zl_clur _1.5 1.5j1.5
view_image pal2;b
#~.,b
)

NB. Mandelbrot escape time of 0
mandelt=: (3 : 'y&+@*: escapetc (10 255) 0')"0
 
NB. center-center center-right 
NB. x is number of horizontal pixels
NB. y is pair of complex numbers giving the 
zl_cccr=: 4 : 0
w=.--/y
({.y)+w*((i:%j.) +/ (i:%])) <.-:x
)



