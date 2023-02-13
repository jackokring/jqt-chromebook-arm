NB. back

NB. =========================================================
NB. draw table background
drawback=: 3 : 0

r=. '0.2 w',LF

NB. ---------------------------------------------------------
NB. row labels:
rx=. {.Dx
rw=. {.Dw
rh=. Dh0
ry=. (}:Dy) - rh
if. IfRow do.
  pos=. rx,.ry,.rw,.rh
  clr=. ({."1 Thigh) { Tbcolor
  r=. r,clr drawbackcolor pos
end.

NB. ---------------------------------------------------------
NB. top header:
if. IfCol do.
  cx=. (Hrws*Ccls) $ }.}:Dx
  cw=. (Hrws*Ccls) $ }. Dw
  ch=. Ccls # Hrws {. rh
  cy=. Ccls # Hrws {. ry
  pos=. cx,.cy,.cw,.ch
  clr=. (, }."1 Hrws {. Thigh) { Tbcolor
  r=. r,clr drawbackcolor pos
end.

NB. ---------------------------------------------------------
NB. cells:
x=. Clen$}.}:Dx
w=. Clen$}.Dw
h=. Ccls#Hrws}.Dh
y=. (Ccls#Hrws}.}:Dy) - h
pos=. x,.y,.w,.h
clr=. (, }."1 Hrws }. Thigh) { Tbcolor
r=. r,clr drawbackcolor pos

NB. ---------------------------------------------------------
r,'0 0 0 rg 0 0 0 RG',LF
)


NB. =========================================================
drawbackcolor=: 4 : 0

off=. 0 0 0.1 0.1
msk=. x ~: iWHITE
msk=. msk *. (0 < 2{"1 y) *. 0 < 3{"1 y
if. 0 = +/ msk do. '' return. end.

clr=. msk # x
pos=. msk # y

NB. ---------------------------------------------------------
NB. each cell:
pos=. clr </. pos -"1 off

nub=. ~.clr
r=. '0.2 w',LF
for_c. nub do.
  c=. ": c { Colors
  c=. c,' rg ', c, ' RG '
  c=. c ,"1 (pfmt c_index pick pos),"1 ' re B',LF
  r=. r,,c
end.
)
