NB. script

NB. =========================================================
makedefs=: 3 : 0
; makedef1 each y
)

NB. =========================================================
makedef1=: 3 : 0
r=. hdef 2 {. {:"1 y
r=. r, ; makedef2 "1 [ 3}.y
)

NB. =========================================================
makedef2=: 3 : 0
'id txt'=. y
if. id-:'desc' do.
  hdr=. ''
else.
  hdr=. h3 >TagNames {~ Tags i. <id
end.
<hdr,txt,LF2
)

NB. =========================================================
makelibhtm=: 3 : 0
)

NB. =========================================================
makemap=: 3 : 0
r=. h2 'Definitions'
'nms anchors'=. y
key=. toupper {.&> nms
nms=. mapsep each key </. anchors
key=. ~. key
a=. '<td class="key">'&, each key ,each <'</td>'
b=. '<td>'&, each nms ,each <'</td>'
c=. ;tr each a ,each b
r, '<table class="map">',c,'</table>',LF2
)

NB. =========================================================
makeonelines=: 3 : 0
if. 0=#y do. '' return. end.
r=. '<hr>'
t=. >(3{.{:"1) each y
v=. 0{"1 t
a=. '<td id="'&, each v ,each '" class="rid">'&, each v ,each <'</td>'
b=. '<td class="rtype">'&, each (1{"1 t) ,each <'</td>'
c=. '<td class="rdef">'&, each (2{"1 t) ,each <'</td>'
d=. ;tr each a ,each b ,each c
r,'<table class="rdef">',d,'</table>'
)

NB. =========================================================
makepost=: ]

NB. =========================================================
makescript=: 3 : 0
hdr=. <;._2 LF ,~ 0 pick y
id=. 0 pick splitname 0 pick hdr
nam=. (id i.'.') {. id
dat=. }. y
nms=. (<0 1){::each dat
ndx=. /:tolower each nms
dat=. ndx{dat
nms=. ndx{nms
typ=. ;(<1 1){::each dat
r=. h0 id
r=. r,lf2sep ; (}.hdr) ,each LF
r=. r,makemap nms;<anchor each nms
msk=. 3 = #&> dat
r=. r,makeonelines msk#dat
r=. r,makedefs adddesc each (-.msk)#dat
m=. jpath '~temp/joxygen.md'
h=. jpath '~temp/joxygen.htm'
r fwrite m
pandoc m;h
(freads h) fwritenew Target,'/',nam,'.htm'
)
