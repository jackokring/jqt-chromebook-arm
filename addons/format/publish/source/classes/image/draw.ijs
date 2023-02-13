NB. image draw
NB.
NB. Shape = rws, cls (like J shape)
NB. Size, Scale are width, height

NB. =========================================================
draw=: 3 : 0

plot=. Loc e. Plots
scale=. |. 2 $ SCALE

'rws cls'=. scale * Shape__Loc

NB. ---------------------------------------------------------
NB. spacing
pre=. PARASPACE * fontheight fontindex FONTTH
pst=. pre

NB. ---------------------------------------------------------
NB. check enough height
NB. need check enough width
if. Sh < rws+pre do.
  1;'' return.
end.

mx=. Sx + (Sw-cls) * ALIGN { 0 0.5 1 0.5
my=. pre -~ Sy + (Sh-rws) * ALIGNV { 1 0.5 0

NB. ---------------------------------------------------------
if. plot do.
  dat=. draw__Loc''
  ts=. _1 |. 0 0,scale
else.
  dat=. '/',NAME__Loc,' Do'
  ts=. cls,0 0,rws
end.

NB. ---------------------------------------------------------
r=. 'q'
r=. r,LF,(":ts,mx,my),' cm'
r=. r,LF,dat
r=. r,LF,'Q',LF

NB. ---------------------------------------------------------
setsxywhP Sx,Sy,Sw,(ALIGNV=0)*Sh-rws+pre+pst
0;r
)
