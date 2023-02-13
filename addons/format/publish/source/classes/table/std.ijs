NB. standard draw

NB. =========================================================
draw_std=: 3 : 0
NB. ---------------------------------------------------------
NB. in standard class, no horizontal grids in middle
NB. of column headers:
Gridh=: 0 (1+i.Hrws) } Gridh

NB. ---------------------------------------------------------
'rc txt'=. drawit''
if. rc do. rc;txt return. end.

NB. ---------------------------------------------------------
s=. ''
rg=. (":TGRIDCOLOR),' RG '
if. IfCol do.
  x=. {.Dx
  xw=. {:Dx
  y=. ({.Dy) - +/ Hrws{.Dh0
  t=. rg,(":TGRIDSIZE),' w '
  s=. s,t,(":x,y),' m ',(":xw,y),' l S',LF
end.

NB. ---------------------------------------------------------
if. +/Gridh do.
  ndx=. I. Gridh > 0
  siz=. TGRIDSIZE * ndx { Gridh
  x=. {.Dx
  xw=. {:Dx
  y=. ndx { Dy
  t=. rg,"1 (": ,.siz) ,"1 ' w '
  p=. (": x,.y) ,"1 ' m ' ,"1 (":xw,.y)
  s=. s,,t,.p,"1 ' l S',LF
end.

NB. ---------------------------------------------------------
if. +/Gridv do.
  ndx=. I. Gridv > 0
  siz=. TGRIDSIZE * ndx { Gridv
  x=. ndx { Dx
  y=. {.Dy
  yh=. {:Dy
  t=. rg,"1 (": ,.siz) ,"1 ' w '
  p=. (": x,.y) ,"1 ' m ' ,"1 (":x,.yh)
  s=. s,,t,.p,"1 ' l S',LF
end.

NB. ---------------------------------------------------------
rc;txt,s
)
