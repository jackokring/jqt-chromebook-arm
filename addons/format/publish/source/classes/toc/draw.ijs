NB. draw

NB. =========================================================
draw=: 3 : 0
res=. 0;''
if. isempty Contents do. res return. end.
if. 3 = {:$Contents do. res return. end.

NB. ---------------------------------------------------------
pos=. {."1 Contents
msk=. (TOCLEVEL >: # &> pos) > 0 = {.&> pos
if. -. 1 e. msk do. res return. end.

NB. ---------------------------------------------------------
dat=. ~. 0 2 3 {"1 msk # Contents
off=. <: _1 pick {. dat
fts=. fontindex"1 ". 'FONTC' ,"1 ":,.1 + i.TOCLEVEL
r=. ''
p=. i.0 3
for_d. dat do.
  'pos txt num'=. d
  lvl=. <: #pos
  if. (#p) *. lvl=0 do.
    r=. r,<remlastLF p
    p=. i.0 3
  end.
  txt=. ((4*lvl)$' '),txt,(4$' '),(":num-off),LF
  p=. p,0;(lvl{fts);txt
end.

if. #p do. r=. r,<remlastLF p end.

NB. ---------------------------------------------------------
Data=: r
drawpara 1
)

NB. =========================================================
NB. drawpara
NB. returncode 0=ok, 1=more to come
drawpara=: 3 : 0
if. y do.
  Para=: fit each Data
end.

NB. ---------------------------------------------------------
cls=. ; each {:"1 each Para
par=. LEADING * +/ &> cls
spc=. PARASPACE * {: &> cls
scn=. +/\par + 0,}:spc
mov=. +/par + spc
tot=. {:scn
rc=. Sh < tot

NB. ---------------------------------------------------------
if. rc do.
  ndx=. (scn <: Sh) i. 0
  tot=. ndx { 0,scn
  dat=. ndx {. Para
  Para=: ndx }. Para
else.
  dat=. Para
end.

NB. ---------------------------------------------------------
mx=. Sx
my=. Sy + Sh
Textc=: Textf=: _1
r=. ''
for_d. dat do.
  for_ln. >d do.
    'clr fnt bgn end bwd ewd hit'=. ln
    if. #bgn do.
      r=. r,drawtext ,:(mx,my);clr;fnt;bgn
    end.
    if. #end do.
      r=. r,drawtext ,:((mx+Sw-ewd),my);clr;fnt;end
    end.
    my=. my - prnd hit*LEADING
  end.
  my=. my - prnd hit*PARASPACE
end.

NB. ---------------------------------------------------------
setsxywhP Sx,Sy,Sw,Sh-mov
rc;wraptext r
)

NB. =========================================================
NB. this should be done anyway when drawing paragraphs...
remlastLF=: 3 : 0
'c f txt'=. {:y
txt=. (-LF={:txt) }. txt
y=. (c;f;txt) _1 } y
)
