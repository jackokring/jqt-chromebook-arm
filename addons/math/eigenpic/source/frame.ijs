NB. frame

NB. =========================================================
drawframe=: 3 : 0

'x y w h'=. WID * _1 _1 2 2

NB. ---------------------------------------------------------
NB. draw edges:
'bx tx'=. rndint CX * (,-.) XMARGIN-TICMAJOR
'by ty'=. rndint CY * (,-.) YMARGIN-TICMAJOR

gllines OFF movepos~ bx,by,bx,ty,tx,ty,tx,by,bx,by

NB. ---------------------------------------------------------
NB. x tics:
'minor pos'=. gettics x,x+w

len=. >: (1+minor) * <: #pos
mark=. len $(1,minor)#rndint CX * TICMAJOR, TICMINOR

x=. rndint bx + (tx-bx) * int01 len - 1
gllines OFF movepos~x ,. by ,. x ,. by+mark
gllines OFF movepos~x ,. ty ,. x ,. ty-mark

NB. ---------------------------------------------------------
NB. x labels:
x=. bx + (tx-bx) * int01 (#pos) - 1
labs=. tominus@": each pos
glfont FONT
glfontextent FONT
off=. <. -: {."1 glqextent &> labs
p=. OFF movepos~ (x-off) ,. ty + CY * TICMAJOR
labs (gltext@>@[ gltextxy)"0 1 p

NB. ---------------------------------------------------------
NB. y tics:
'minor pos'=. gettics y,y+h

len=. >: (1+minor) * <: #pos
mark=. len $(1,minor)#rndint CY * TICMAJOR, TICMINOR

y=. rndint by + (ty-by) * int01 len - 1
gllines OFF movepos~bx ,. y ,. (bx+mark) ,. y
gllines OFF movepos~tx ,. y ,. (tx-mark) ,. y

NB. ---------------------------------------------------------
NB. y labels:

y=. (by - FONTSIZE%2) + (ty-by) * int01 (#pos) - 1
labs=. tominus@": each |. pos
glfont FONT
glfontextent FONT
off=. {."1 glqextent &> labs
p=. OFF movepos~ (bx-off + CX*TICMAJOR) ,. y

labs (gltext@>@[ gltextxy)"0 1 p
)
