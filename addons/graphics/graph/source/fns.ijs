NB. gdfns

gdreset=: create
gdclear=: buf bind 'clear'
gdpen=: buf @ ('pen'&;)
gdcolor=: buf @ ('color'&;)
gdfont=: buf @ ('font'&;)
gdshow=: 3 : 'pshow__GDLOC y'
gdtextcolor=: buf @ ('textcolor'&;)

gdpng=: 3 : 'ppng__GDLOC y'

NB. =========================================================
gdadd=: 1 : 0
gdselopen''
gdshow u y
:
gdselopen''
gdshow x u y
)

NB. =========================================================
gdopen=: 3 : 0
y=. boxxopen y
y=. y, (0=#y) # <'graph'
ndx=. nameindex {. y
if. _1 = ndx do.
  a=. '' conew 'jzgraph'
  popen__a y
else.
  gdloc {: ndx { GDIDS
  gdclear''
end.
)

NB. =========================================================
gdclose=: 3 : 0
gdclean''
if. 0 = #y do.
  if. 0 = #>GDLOC do. EMPTY return. end.
  loc=. GDLOC
else.
  nam=. <,> y
  nms=. 0 {"1 GDIDS
  if. -. nam e. nms do.
    wdinfo 'graph';'Not found: ',>nam return.
  end.
  loc=. {: (nms i. nam) { GDIDS
end.
destroy__loc ''
EMPTY
)

NB. =========================================================
gdcloseall=: 3 : 0
gdclean''
if. 0=#GDIDS do. EMPTY return. end.
lcs=. {:"1 GDIDS
for_loc. lcs do.
  destroy__loc ''
end.
EMPTY
)

NB. =========================================================
gdselopen=: 3 : 0
y=. <'graph'
ndx=. nameindex {. y
if. _1 = ndx do.
  a=. '' conew 'jzgraph'
  popen__a y
else.
  gdloc {: ndx { GDIDS
end.
)

NB. =========================================================
gdselect=: 3 : 0
gdclean''
nam=. <,> y
nms=. 0 {"1 GDIDS
if. -. nam e. nms do.
  wdinfo 'graph';'Not found: ',>nam return.
end.
gdloc {: (nms i. nam) { GDIDS
EMPTY
)

NB. =========================================================
gddraw=: 1 : 0
gdopen''
gdshow''
u y
:
gdopen''
gdshow''
x u y
)

NB. =========================================================
NB.*gdpencolor v   set color for pen
NB. form: gdcolor color[;style]
gdpencolor=: 3 : 0
'c p'=. 2 {. boxopen y
if. #p do.
  buf 'pen';2 {. p
end.
buf 'pencolor';c
)

NB. =========================================================
NB. gdrgb
gdrgb=: 3 : 0
clr=. y
if. 1=#clr do. clr=. |. 256 256 256 #: {.clr end.
buf 'rgb';clr
)

NB. =========================================================
NB. drawing verbs:
f=. 1 : ' u : ($:@] [ gdcolor@[)'
g=. 1 : ' u : ($:@] [ gdpencolor@[)'
h=. 1 : ' u : ($:@] [ gdtextcolor@[)'

gdarc=: buf @ ('arc'&;) f "1 L: 0
gdchord=: buf @ ('chord'&;) f "1 L: 0
gdellipse=: buf @ ('ellipse'&;) f "1 L: 0
gdlines=: buf @ ('lines'&;) g "1 L: 0
gdpie=: buf @ ('pie'&;) f "1 L: 0
gdpixel=: buf @ ('pixel'&;) f "1 L: 0
gdpolygon=: buf @ ('polygon'&;) f "1 L: 0
gdrect=: buf @ ('rect'&;) f "1 L: 0
gdroundr=: buf @ ('roundr'&;) f "1 L: 0
gdtext=: buf @ ('text';<) h "1

gdarc01=: buf @ ('arc01'&;) f "1 L: 0
gdchord01=: buf @ ('chord01'&;) f "1 L: 0
gdellipse01=: buf @ ('ellipse01'&;) f "1 L: 0
gdlines01=: buf @ ('lines01'&;) g "1 L: 0
gdpie01=: buf @ ('pie01'&;) f "1 L: 0
gdpixel01=: buf @ ('pixel01'&;) f "1 L: 0
gdpolygon01=: buf @ ('polygon01'&;) f "1 L: 0
gdrect01=: buf @ ('rect01'&;) f "1 L: 0
gdroundr01=: buf @ ('roundr01'&;) f "1 L: 0
gdtext01=: buf @ ('text01';<) h "1
