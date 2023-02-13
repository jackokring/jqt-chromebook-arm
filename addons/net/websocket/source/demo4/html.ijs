NB. html

th=: '<th>' , ,&'</th>'
tr=: '<tr>' , ,&('</tr>',LF)

NB. =========================================================
NB. format cube as html
cube2html=: 3 : 0
ax=. (0 pick AxisOrder) { AxisLabels
rws=. */ # &> ax
lab=. lab2html ax

ay=. (1 pick AxisOrder) { AxisLabels
cls=. */ # &> ay
hdr=. hdr2html ay

dat=. (rws,cls) $ (gridindex AxisOrder) { Data
ndx=. I. rws $ 1 0
td=: '<td>' , ": , '</td>'"_
cell=. (td each ndx{dat) ndx} (rws,cls) $ <''
ndx=. I. rws $ 0 1
td=: '<td class="alt">' , ": , '</td>'"_
cell=. (td each ndx{dat) ndx} cell
bdy=. ; <@;"1 (<'<tr>'),.lab,.cell,.<'</tr>',LF
'<table id="cube">',hdr,bdy,'</table>'
)

NB. =========================================================
NB. format header as html
hdr2html=: 3 : 0
rws=. #y
cnt=. # &> y
prd=. */\ cnt
len=. {:prd
spn=. len % prd
pfx=. '<th colspan=',(":#0 pick AxisOrder),'></th>'
r=. <pfx, ;th each len $ _1 pick y
for_i. i.- <:rws do.
  p=. i{prd
  s=. i{spn
  t=. ('<th colspan=',(":s),'>') , ,&'</th>'
  r=. (pfx, ;t each p $ i pick y);r
end.
; tr each r
)

NB. =========================================================
NB. format labels as html
lab2html=: 3 : 0
cls=. #y
cnt=. # &> y
prd=. */\ cnt
len=. {:prd
spn=. len % prd
h=. th each len $ _1 pick y
for_i. i.- <:cls do.
  p=. i{prd
  s=. i{spn
  n=. s * i.p
  t=. ('<th rowspan=',(":s),'>') , ,&'</th>'
  h=. ((t each p $ i pick y) ,each n{h) n} h
end.
)
