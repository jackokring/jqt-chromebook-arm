gl_Perspective=: (gl_I'')&$: : (4 : 0)
mat=. x
'fovy aspect znear zfar'=. y
if. (0=znear-zfar) +. (0=180|fovy) +. (0=aspect) do. mat return. end.

xymax=. znear * 3&o. fovy * 1p1%360
ymin=. -xymax
xmin=. -xymax

width=. xymax - xmin
height=. xymax - ymin

depth=. zfar - znear
q=. -(zfar + znear) % depth
qn=. _2 * (zfar * znear) % depth

w=. 2 * znear % width
w=. w % aspect
h=. 2 * znear % height

m=. w, 0 0 0
m=. m, 0, h, 0 0
m=. m, 0 0, q, _1
m=. m, 0 0, qn, 0

mat (+/ . *) _4[\m
)

NB. alternative implementation using gl_Frustum
gl_Perspective0=: (gl_I'')&$: : (4 : 0)
mat=. x
'fovy aspect znear zfar'=. y
size=. znear * 3&o. fovy * 1p1%360
gl_Frustum (-size*aspect), (size*aspect), (-size), (size), znear, zfar
)

gl_Frustum=: (gl_I'')&$: : (4 : 0)
mat=. x
'left right bottom top near far'=. y
if. (0=right-left) +. (0=top-bottom) +. (0=far-near) do. mat return. end.

m=. (2 * near % (right - left)), 0 0 0

m=. m, 0 ,(2 * near % (top - bottom)), 0 0

m=. m, (right + left) % (right - left)
m=. m, (top + bottom) % (top - bottom)
m=. m, -(far + near) % (far - near)
m=. m, _1

m=. m, 0 0, (_2 * far * near % (far - near)), 0

mat (+/ . *) _4[\m
)

gl_Ortho=: (gl_I'')&$: : (4 : 0)
mat=. x
'left right bottom top near far'=. y
if. (0=right-left) +. (0=top-bottom) +. (0=far-near) do. mat return. end.

r_l=. right - left
t_b=. top - bottom
f_n=. far - near
tx=. - (right + left) % (right - left)
ty=. - (top + bottom) % (top - bottom)
tz=. - (far + near) % (far - near)

m=. (2 % r_l), 0 0, tx

m=. m, 0, (2 % t_b), 0, ty

m=. m, 0 0, (2 % f_n), tz

m=. m, 0 0 0 1

mat (+/ . *) _4[\m
)
