NB. graph utils

deb=: #~ (+. (1: |. (> </\)))@(' '&~:)
info=: wdinfo @ ('graph'&;)
index=: #@[ (| - =) i.
intersect=: e. # [
roundint=: <.@:+&0.5
handles=: 1: {"1 <;._2;._2 @ wd @ ('qpx'"_)
parents=: 0: {"1 <;._2@wd@('qpx'"_)
isparent=: boxopen e. parents

NB. =========================================================
flipyarc=: 3 : 0
y=. _8[\,y
c=. H - (+/"1 [ 1 3{"1 y) ,. 5 7{"1 y
($y) $ ,c 1 5 7}"1 y
)

NB. =========================================================
flipxy=: 3 : 0
s=. $y
(s $ 0, H) + y * s $ 1 _1
)

NB. =========================================================
flipyrect=: 3 : 0
y=. _4 [\, y
c=. H - +/"1 [ 1 3{"1 y
($y) $ ,c 1}"0 1 y
)

NB. =========================================================
NB. y is file extension
gettemp=: 3 : 0
p=. jpath '~temp/'
d=. 1!:0 p,'*.',y
a=. 0, {.@:(0&".)@> _4 }. each {."1 d
a=. ": {. (i. >: #a) -. a
p,a,'.',y
)

NB. =========================================================
NB. init default globals
initdef=: 3 : 0
PEN=: 1
PENCOLOR=: 0 0 0
BRUSHCOLOR=: 255 255 255
TEXTCOLOR=: 0 0 0
FONT=: PROFONT
)

NB. =========================================================
NB. init globals
initwin=: 3 : 0
try.
  glsel HWNDC
catch. destroy'' return.
end.
wh=. glqwh''
'W H'=: wh
WH=: <./ wh
WH2=: -: WH
XY=: -: wh - WH
)

NB. =========================================================
NB. return index in GDIDS of name, or _1 if not found
nameindex=: 3 : '(0 {"1 GDIDS) index <,> y'

NB. =========================================================
NB. form:  opt rgb dat
NB.   opt = 0 integers to RGB   (default)
NB.   dat = red, green, blue values or 3-col matrix of same
NB.
NB.   opt = 1 RGB to integers
NB.   dat = one or more RGB values
NB.
NB. RGB format is a 4 byte integer: unused blue green red
NB.
NB. e.g.  RGB 255 255 0   =  RGB value for bright yellow
rgb=: 0&$: : (4 : 0)
if. x do. |."1[ 256 256 256 #: y
else. y +/ .* 1 256 65536
end.
)

NB. =========================================================
roundrect=: 3 : 0
shape=. $y
'x y w h'=. |: _4 [\ ,y
xw=. x+w
yh=. y+h
x=. roundint x
y=. roundint y
w=. roundint xw - x
h=. roundint yh - y
shape $ , |: x, y, w,: h
)

NB. =========================================================
spos=: 3 : 'flipxy (($y) $ XY) + WH2 * >: y'
spos01=: 3 : 'flipxy (($y) $ XY) + WH * y'

srec=: 3 : 'flipyrect (($y) $ (XY + WH2),0 0) + WH2 * y'
srec01=: 3 : 'flipyrect (($y) $ XY,0 0) + WH * y'

scalexy=: roundint @ spos
scalearc=: scalexy
scalerect=: roundrect @: srec

scalexy01=: roundint @ spos01
scalearc01=: scalexy01
scalerect01=: roundrect @: srec01
