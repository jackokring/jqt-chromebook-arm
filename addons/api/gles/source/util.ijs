NB. workaround for Linux64
NB. http://www.opengl.org/sdk/docs/man/xhtml/gluLookAt.xml
NB.
NB. definiton of cross product from labs/livetexts/linearalgebra.ijt
NB. rl=: 1&|.                                   NB. rotate to left
NB. rr=: _1&|.                                  NB. rotate to right
NB. cross=: (rl@:[ * rr@:]) - (rr@:[ * rl@:])   NB. cross product
glu_LookAt=: 3 : 0
'eye center up'=. _3]\,>y
F=. center - eye
f=. (% +/&.:*:)F
UPP=. (% +/&.:*:)up
s=. f ((1&|.@:[ * _1&|.@:]) - _1&|.@:[ * 1&|.@:]) UPP
u=. s ((1&|.@:[ * _1&|.@:]) - _1&|.@:[ * 1&|.@:]) f
M=. _4]\ s, 0, u, 0, (-f), 0 0 0 0 1
(|:M) gl_mp~ gl_Translate -eye
)
