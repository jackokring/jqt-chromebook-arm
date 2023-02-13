NB. main

NB. =========================================================
makedocs=: 3 : 0
f=. Files
if. 0 = L.f do. f=. cutopen f end.
dat=. makedoc1 each f
dat=. dat #~ -. (0 e. $) &> dat
hdr=. 0 {:: each dat
scp=. makescripts hdr
nms=. }. each dat
ndx=. /: tolower each 0 {:: ::] each nms
hdr=. ndx{hdr
nms=. ndx{nms
lnk=. ; hdr makelink each nms
nms=. ;nms
ndx=. /: tolower each nms
lnk=. ndx{lnk
nms=. ndx{nms
map=. makemap nms;<lnk
r=. IndexHdr,LF2
r=. r,scp,map
m=. jpath '~temp/joxygen.md'
h=. jpath '~temp/joxygen.htm'
r fwrite m
pandoc m;h
(freads h) fwritenew Target,'/index.htm'
)

NB. =========================================================
makedoc1=: 3 : 0
txt=. 'b' fread Source,'/',y
if. txt -: _1 do.
  smoutput 'not found: ',y
else.
  smoutput 'reading: ',y
  dat=. parse txt
  if. 0 e. $dat do. return. end.
  makescript dat
  hdr=. 0 pick dat
  hdr=. splitname (hdr i. LF){.hdr
  (<hdr),(<0 1){:: each }.dat
end.
)

NB. =========================================================
makelink=: 4 : 0
s=. (i.&'.' {.]) 0 pick x
'[' ,each y ,each (<'](',s,'.htm#') ,each y ,each ')'
)

NB. =========================================================
makerefs=: 3 : 0
ndx=. y i.&>']'
lnk=. (ndx+2)}.each }:each y
; lnk ,each LF
)

NB. =========================================================
makescripts=: 3 : 0
a=. anchorscript each {.&>y
b=. {:&>y
r=. h2 'Scripts'
a=. '<td class="noun">'&, each a ,each <'</td>'
b=. '<td class="noun">'&, each b ,each <'</td>'
c=. ;tr each a,each b
r,'<table class="noun">',c,'</table>',LF2
)