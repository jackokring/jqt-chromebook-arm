NB. outline
NB.
NB. Outlines is 3 column table:
NB.    level
NB.    page
NB.    text

NB. =========================================================
outlines=: 3 : 0

if. isempty Contents do. '' return. end.
msk=. BMLEVEL >: # &> {."1 Contents
if. -. 1 e. msk do. '' return. end.
dat=. 0 1 3 {"1 msk # Contents

dat=. dat #~ partition 1 {"1 dat
dat=. dat ,. (": each Next + 1 + i. #dat) ,each <' 0 R'
top=. dat #~ 1 = # &> {."1 dat
if. 0 = #top do. '' return. end.

RootOutlines=: Next
r=. '/Type /Outlines',LF
r=. r,'/First ',(_1 pick 0 { top),LF
if. 2 < #top do.
  r=. r,'/Next ',(_1 pick 1 { top),LF
end.
r=. r,'/Last ',(_1 pick _1 { top),LF
r=. dict r
here=. (":Next),' 0 R'
s=. here outlineset dat
r;s
)

NB. =========================================================
outlineset=: 4 : 0
nub=. ~: 0 1 {"1 y
dat=. nub # y
dat=. ({. &> {."1 dat) </. dat

NB. ---------------------------------------------------------
s=. ''
for_i. i.#dat do.
  sub=. i pick dat
  'pos lab pag obj'=. {. sub
  r=. '/Title (',lab,')',LF
  r=. r,'/Parent ',x,LF
  if. i do.
    r=. r, '/Prev ',(_1 pick {.(i-1) pick dat),LF
  end.
  if. i < _1 + #dat do.
    r=. r, '/Next ',(_1 pick {.(i+1) pick dat),LF
  end.

NB. ---------------------------------------------------------
  dest=. '/Dest [',pag,' /XYZ null null null]',LF
  if. 1 = #sub do.
    r=. r, dest
    s=. s, <dict r
  else.
    sub=. }. sub
    sub=. (}. each {."1 sub) ,. }."1 sub
    top=. sub #~ 1 = # &> {."1 sub
    r=. r, '/First ',(3 pick 0 { top),LF
    r=. r, '/Last ',(3 pick _1 { top),LF
    r=. r, dest
    s=. s, <dict r
    s=. s, obj outlineset sub
  end.

end.

)
