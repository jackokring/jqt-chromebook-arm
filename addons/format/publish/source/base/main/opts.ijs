NB. opts

NB. =========================================================
NB. option and types:
NB.
NB.  a=alignment (number or string)
NB.  c=character string
NB.  f=font
NB.  n=scalar number
NB.  s=style
NB.  v=numeric list
opts=. ;: ;._2 (0 : 0)
ALIGN a
ALIGNV a
BMLEVEL n
CLASS c
FONTH0 f
FONTH1 f
FONTH2 f
FONTH3 f
FONTH4 f
FONTH5 f
FONTH6 f
FONTC0 f
FONTC1 f
FONTC2 f
FONTC3 f
FONTC4 f
FONTC5 f
FONTC6 f
FONTP f
FONTTH v
FONTTC f
LEADING n
NAME c
PAGEMARGINS v
PAGESIZE v
PARASPACE n
SCALE v
SHAPE v
STYLE s
TOCLEVEL n
TOCALIGN a
)

DefOpts=: {."1 opts
DefOptx=: ; {:"1 opts

NB. =========================================================
set=: 3 : 0
if. 0 e. $y do. '' return. end.
if. 1 = #$y do. y=. _2 [\ y end.
nam=. toupper each {."1 y
val=. {:"1 y
opt=. <&> (DefOpts i. nam) { DefOptx
for_s. opt,.nam,.val do.
  't n v'=. s
  select. t
  case. 'a' do.
    v=. fixalign v
  case. 'c' do.
  case. 'f' do.
NB. !!! should validate font here
  case. 'n' do.
    v=. {. fix v
  case. 's' do.
    v=. toupper v
    if. 0 ~: nc <v do.
      throw '101 Style not found: ',v
    end.
    jset ". v return.
  case. 'v' do.
    v=. fix v
  end.
  (n)=: v
end.
)

NB. =========================================================
NB. namelist setfixx indices or namelist
setfixx=: 4 : 0
if. *./ y e. '0123456789 ' do.
  fix y
else.
  y=. ',',tolower y
  x i. a: -.~ (y e. ', ') <;._1 y
end.
)

NB. =========================================================
fixalign=: 3 : 0
if. -. ischar y do. y return. end.
n=. {. _1 ". y
if. n ~: _1 do. return. end.
{. ". 'i',toupper y
)

NB. =========================================================
fixaligns=: 3 : 0
ALIGN=: fixalign ALIGN
ALIGNV=: fixalign ALIGNV
)
