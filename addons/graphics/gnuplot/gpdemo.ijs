NB. gpdemo.ijs  - gnuplot examples
NB.
NB. try:
NB.    gp1''
NB.    gp2''
NB.    gp3''
NB.    gp4''

require 'graphics/gnuplot numeric trig'

NB. =========================================================
gp1=: 3 : 0
SC=: (;sin@^,:cos@^) steps _1 2 100
gset 'grid'
gset 'title "sin(exp) vs cos(exp)"'
gset 'xlabel "x-axis"'
gset 'ylabel "y-axis"'
'with lines title "sin(exp)", with lines title "cos(exp)"' gplot SC
)

NB. =========================================================
gp2=: 3 : 0
wiggle=. 4
points=. 200
X=. (3 % <:points) * i.points
fn=. +/@((0.9&^) * cos@((3&^ * (+/&X))))@i.
XY=: fn wiggle
'with lines' gplot X;XY
)

NB. =========================================================
gp3=: 3 : 0
x=. range _3 3 0.2
y=. range _3 3 0.2
z=. sin x +/ sin y
CP=: x;y;z
gset 'title "sin(x+sin(y))"'
gset 'parametric'
'with lines' gsplot CP
)

NB. =========================================================
gp4=: 3 : 0
x=. range _3 3 0.1
y=. range _3 3 0.1
SP=: x;y;(sin x) */ sin y
gset 'title "sin(x)*sin(y)) contour plot"'
gset 'parametric;contour;cntrparam levels 20;view 0,0,1;nosurface'
'with lines' gsplot SP
)