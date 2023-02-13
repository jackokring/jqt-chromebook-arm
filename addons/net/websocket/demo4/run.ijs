NB. util

cocurrent 'z'

bk=: '[' , ']' ,~ ]
fmt=: ,@(8!:2)
sep=: }.@;@:(','&,each)
sepfmt=: ' ' -.~ }.@,@(',' ,. >@{.@(8!:1)@,.)
isboxed=: 0 < L.
ischar=: 2=3!:0
isscalar=: 0 = #@$

NB. =========================================================
cutcommas=: 3 : 0
y=. ',',y
m=. ~:/\y='"'
m=. *./ (m < y=','), 0 = _2 +/\ @ (-/)\ m <"1 '{}[]'=/y
m <@dltb;._1 y
)

NB. =========================================================
dec=: 3 : 0
if. '[' ~: {.y do.
  0 ". ' ' (I.y=',')} y return.
end.
y=. }.}:y
if. '[' e. y do.
  dec each cutcommas y
else.
  dec y
end.
)

NB. =========================================================
enc=: 3 : 0
if. isboxed y do.
  bk sep enc each y
elseif. ischar y do.
  dquote y
elseif. do.
  bk@sepfmt`fmt @. isscalar y
end.
)

NB. =========================================================
NB. for development
reloadJ_z_=: 3 : 0
dat=. freads '~addons/net/websocket/demo4/run.ijs'
0!:100 dat {.~ ('load ''net/websocket''' E. dat) i: 1
)
NB. defs

cocurrent 'base'

a0=. ;: 'Ford GM Honda Toyota Total'
a1=. '2013';'2014'
a2=. ;: 'Hire Lease Sale'
a3=. ;: 'CA KS MN NY TX'
a4=. <;._1 '/Compact/Standard/Full Size/Luxury/MiniVan/SUV/Total'

AxisLabels=: a0;a1;a2;a3;<a4
AxisNames=: ;: 'Model Year Finance State Group'
AxisOrder=: , each 1 3;4;2 0;0 2
Shape=: # &> AxisLabels
d=. 3 + ?. 17 $~ _1 0 0 0 _1 + Shape
Data=: ,d,"1 0 +/"1 d=. d,"5 4 +/"5 d
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
NB. main

NB. =========================================================
griddefs=: 3 : 0
enc AxisNames;AxisLabels;<AxisOrder
)

NB. =========================================================
NB. get data for given axis order
griddata=: 3 : 0
if. ischar y do. y=. dec y end.
AxisOrder=: ,each y
cube2html''
)

NB. =========================================================
gridindex=: 3 : 0
'rws cls sel ndx'=. y
d=. (sel,rws,cls) |: i.Shape
r=. (sel{Shape),(*/rws{Shape),*/cls{Shape
,(<ndx) { r ($,) d
)

load 'net/websocket'
init_jws_ 5024
