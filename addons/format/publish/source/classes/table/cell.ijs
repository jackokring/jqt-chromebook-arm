NB. cell

NB. =========================================================
drawcell=: 3 : 0

vw=. Dw -"1 Tw
dy=. Dy - (#Dy) {. PadHeader

NB. ---------------------------------------------------------
NB. row labels:
if. IfRow do.
  x=. ({.Dx) + -: ({."1 Align) * ({."1 vw) - PadLabel
  x=. x + PadLabel * {.Gridv NB. space from vertical grid
  pos=. x,.}:dy
  clr=. ({."1 Thigh) { Tfcolor
  dat=. Top,Row
  fnt=. {."1 Font
else.
  pos=. i. 0 2
  clr=. dat=. fnt=. ''
end.

NB. ---------------------------------------------------------
NB. column headers:
s=. Hrws,Ccls
a=. ,}."1 Hrws{.Align
x=. ,s $ }:}.Dx
x=. x + -: (a * , }."1 Hrws {. vw) - (a-1) * PadCell
y=. Ccls # Hrws {. dy
pos=. pos,x,.y
clr=. <&> clr,(, }."1 Hrws {. Thigh) { Tfcolor
fnt=. <&> fnt,,}."1 Hrws{.Font
dat=. dat,,Col
r=. drawtext (<"1 pos),.clr,.fnt,.dat

NB. ---------------------------------------------------------
NB. cells
s=. Crws,Ccls
a=. ,}."1 Hrws}.Align
x=. ,s $ }:}.Dx
x=. x + -: (a * ,}."1 Hrws }. vw) - (a-1) * PadCell
y=. ,Ccls # Hrws }.}: dy
clr=. <&> (, }."1 Hrws }. Thigh) { Tfcolor
fnt=. <&> ,}."1 Hrws}.Font

if. IfMulti do.
  a=. CDlen#a
  h=. ; (Fh1m * i.) each CDlen
  y=. h -~ CDlen#y
  x=. (CDlen#x) - Twx * -: a
  clr=. CDlen#clr
  fnt=. CDlen#fnt
  dat=. DataX
else.
  dat=. Data
end.

NB. ---------------------------------------------------------
r=. r,drawtext (<"1 x,.y),.clr,.fnt,.dat
wraptext r
)
