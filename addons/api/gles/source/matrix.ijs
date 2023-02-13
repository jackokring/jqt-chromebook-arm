
gl_I=: =@i.@(4"_)

gl_GetFloatv=: 3 : 0
1&fc ,y
)

gl_mp=: +/ . *

NB. row-major, pre-mulitplication
NB. current matrix on the left
NB. _no_ need to transpose when passing to OpengGL

NB. x - current matrix

gl_Rotate=: (gl_I'')&$: : (4 : 0)
mat=. x
'a x y z'=. y
s=. 1 o. a * 1p1 % 180
c=. 2 o. a * 1p1 % 180

xx=. x * x
xy=. x * y
xz=. x * z
yy=. y * y
yz=. y * z
zz=. z * z

NB. build rotation matrix

m=. (xx * (1 - c)) + c
m=. m, (xy * (1 - c)) - z * s
m=. m, (xz * (1 - c)) + y * s
m=. m, 0

m=. m, (xy * (1 - c)) + z * s
m=. m, (yy * (1 - c)) + c
m=. m, (yz * (1 - c)) - x * s
m=. m, 0

m=. m, (xz * (1 - c)) - y * s
m=. m, (yz * (1 - c)) + x * s
m=. m, (zz * (1 - c)) + c
m=. m, 0

m=. m, 0 0 0 1

mat (+/ . *) _4]\m
)

gl_Translate=: (gl_I'')&$: : (4 : 0)
mat=. x
'x y z'=. y

m=. 1 0 0 0
m=. m, 0 1 0 0
m=. m, 0 0 1 0
m=. m, x,y,z,1

mat (+/ . *) _4]\m
)

gl_Scale=: (gl_I'')&$: : (4 : 0)
mat=. x
'x y z'=. y

m=. x,0 0 0
m=. m,  0,y,0 0
m=. m,  0 0,z,0
m=. m,  0 0 0 1

mat (+/ . *) _4]\m
)
