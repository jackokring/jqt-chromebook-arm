NB. numbers

NB. =========================================================
NB. numbers
NB. adds page numbers to Contents and sections
NB. also builds any table of contents
NB.
NB. x = if front page flag
NB. y = sections
numbers=: 4 : 0

sec=. y
len=. # &> sec
sec=. ;sec
lvl=. 0 {"1 sec
msk=. ;1 {"1 sec
ndx=. lvl i. {."1 Contents
Contents=: Contents,.<&>ndx { +/\msk

NB. ---------------------------------------------------------
NB. if front page:
if. x do.
  top=. 1 i.~ 1 = {. &> lvl
  ini=. top {. sec
  mst=. top {. msk
  msk=. top }. msk
  sec=. top }. sec

NB. ---------------------------------------------------------
NB. redraw if table of contents:
  s=. {. Sections
  if. iTOC e. Locx__s do.
    setnewpage''
    setnewpage__s ''
    ini=. draw__s ''
    mst=. ;1 {"1 ini
    len=. (#ini) 0 } len
  end.

NB. ---------------------------------------------------------
  ndx=. I. 1 |. mst
  for_n. ndx do.
    s=. (<n;2) pick ini
    s=. s,drawpagenum roman 1+n_index
    ini=. (<s) (<n;2) } ini
  end.
else.
  ini=. 0 # sec
end.

NB. ---------------------------------------------------------
ndx=. I. 1 |. msk
for_n. ndx do.
  s=. (<n;2) pick sec
  s=. s,drawpagenum 1+n_index
  sec=. (<s) (<n;2) } sec
end.

NB. ---------------------------------------------------------
(pfl len) <;.1 ini,sec
)

NB. =========================================================
drawpagenum=: 3 : 0
p=. ":y
f=. fontindex FONTP
w=. f fontwidth p
h=. fontheight f
x=. Dx + -: Dw - w
y=. -: Dy + h
r=. '/F',(":f{AFMffi),' ',(":h),' Tf ',LF
r=. r,'1 0 0 1 ',(":x,y),' Tm (',p,') Tj',LF
wraptext r
)