NB. table

NB. =========================================================
NB. draw table
NB.
NB. need also check for enough width
drawtable=: 3 : 0

NB. check for enough height
hit=. +/ (Hrws{.Dh),(Hrws+RowPos)}.Dh
if. Sh >: hit do.
  res=. drawrows Crws - RowPos
  setsxywhP Sx,Sy,Sw,Sh - hit
  0;res return.
end.

NB. ---------------------------------------------------------
NB. not enough room
NB. check if enough room on a new page:
if. hit <: {:Dxywh do.
  NewPage=: 1
  1;'' return.
end.

NB. ---------------------------------------------------------
NB. draw partial rows:
hit=. +/\ (Hrws{.Dh),(Hrws+RowPos)}.Dh
rws=. (Sh < hit) i. 1
max=. (({:Dxywh) < +/\ Dh) i. 1
req=. max <. 3 + Hrws
if. rws < req do. 1;'' return. end.
blk=. rws - Hrws
res=. drawrows blk
RowPos=: RowPos + blk
1;res
)

NB. =========================================================
drawrows=: 3 : 0
if. y = Crws do.
  drawall'' return.
end.
a=. cocreate''
coinsert__a coname''
res=. drawrows1__a y
coerase a
res
)

NB. =========================================================
NB. drawrows1 v this draws a block of rows
drawrows1=: 3 : 0
pos=. RowPos
dat=. (Crws,Ccls)$Data
Crws=: y
Clen=: Crws * Ccls
cndx=. RowPos + i.Crws
ndx=. (i.Hrws),Hrws + cndx
Dh0=: ndx { Dh0
Dh=: ndx { Dh
Dy=: Sy + Sh - +/\ 0,Dh
Data=: ,cndx { dat
Row=: cndx { Row
Align=: ndx { Align
Gridh=: ((1+Hrws) {. Gridh),(Hrws+cndx) { Gridh
Font=: ndx { Font
Thigh=: ndx { Thigh
Tw=: ndx { Tw
drawall''
)
