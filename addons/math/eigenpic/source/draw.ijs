NB. draw

NB. =========================================================
drawlines=: 3 : 0
y=. tomatrix y
gllines OFF movepos~ flipypos rndint (y scalepos X1,Y1) movepos MX,MY
)

NB. =========================================================
NB. drawpin
NB. argument is vector or matrix
drawpin=: 3 : 0
y=. rndint tomatrix y
f=. (,&2 2) @: <: @: (_2&{.)
gllines OFF movepos~ y
glellipse OFF moverect~ f"1 y
)


NB. =========================================================
NB. draws picture
drawpic=: 3 : 0
NB. if. 0=IFSPOKES do. return. end.
setcolor FORECOLOR
glpen 1 1
drawpin FOREPIN
if. #AXISPIN do.
  setcolor AXISCOLOR
  glpen 2 1
  drawpin AXISPIN
end.
)

NB. =========================================================
NB. generate picture
NB. defines globals X1 Y1 MX MY FOREPIN AXISPIN
genpic=: 3 : 0

'x y w h'=. y

X1=: (CX * 1 - +:XMARGIN) % w
MX=: - CX * x % w

Y1=: (CY * 1 - +:YMARGIN) % h
MY=: - CY * y % h

rim=. (RIM *"1 X1,Y1) +"1 MX,MY
rimpts=. flipypos (MX,MY) ,"1 rim

pts=. (END *"1 X1,Y1) +"1 MX,MY
endpts=. flipypos rim ,"1 pts

if. IFCOMPLEX do.
  FOREPIN=: rimpts,endpts
  AXISPIN=: i.0 0
else.
  FOREPIN=: (4}.rimpts), (4}.endpts)
  AXISPIN=: (4{.rimpts), (4{.endpts)
end.

)
