NB. Script alan.ijs
NB. This script is the solution to a linear algebra 
NB. class laboratory exercise by Alan Marchiori.
NB. Used with permission for a homework exercise in 
NB. Cliff Reiter's Fractals, Visualization and J, 3rd ed.
NB. March 8, 2000  
NB. Minor J6.01 changes Jan 2007
NB. Minor J8.04 changes June 2016

load '~addons/graphics/fvj4/dwin.ijs'
_4 _4 _4 4 4 4 0.05 d3awin 'J'

]H=:0 0 0,1 0 0, 1 2 2, 1 4 0, 0 4 0,0 2 2,:0 0 0
]H=:H,.1

mp=:+/ . *

]mx=:4 4$1 0 0 0, 0 1 0 0, 0 0 1 0, 0.1 0 0 1
]my=:4 4$1 0 0 0, 0 1 0 0, 0 0 1 0, 0 0.1 0 1
]my2=:4 4$1 0 0 0, 0 1 0 0, 0 0 1 0, 0 _0.1 0 1
]mz=:4 4$1 0 0 0, 0 1 0 0, 0 0 1 0, 0 0 0.1 1

]sx=:4 4$1.1 0 0 0, 0 1 0 0, 0 0 1 0, 0 0 0 1
]sx2=:4 4$0.9 0 0 0, 0 1 0 0, 0 0 1 0, 0 0 0 1
]sy=:4 4$1 0 0 0, 0 1.1 0 0, 0 0 1 0, 0 0 0 1
]sz=:4 4$1 0 0 0, 0 1 0 0, 0 0 1.1 0, 0 0 0 1

Tz=:mp&(rotz 1r10p1)
Tx=:mp&(rotx 1r10p1)
Ty=:mp&(roty 1r10p1)

Mx=:mp&(mx)
My=:mp&(my)
My2=:mp&(my2)
Mz=:mp&(mz)

Sx=:mp&(sx)
Sx2=:mp&(sx2)
Sy=:mp&(sy)
Sz=:mp&(sz)

T=:mp&(sx)
H1 =: My^:(20) H
H2 =: Sx^:(20) H1

255 0 0 d3apoly Tz^:(i.21) H
255 0 0 d3apoly My^:(i.21) H
255 0 0 d3apoly Sx^:(i.21) H1
255 0 0 d3apoly Tx^:(i.21) H2
255 0 0 d3apoly Sx2^:(i.21) H2
255 0 0 d3apoly My2^:(i.21) H1
255 0 0 d3apoly Ty^:(i.21) H
