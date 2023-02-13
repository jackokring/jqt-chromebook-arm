NB. text draw

draw=: drawpara

NB. =========================================================
NB. drawpara
NB. returncode 0=ok, 1=more to come
drawpara=: 3 : 0

if. y do.
  Para=: Sw fit &> Data
end.

NB. ---------------------------------------------------------
NB. !!! need to allow for fullpage paras...
cls=. {:"1 each {:"1 Para
par=. LEADING * +/ &> cls
spc=. PARASPACE * {:&> cls
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
mx=. Sx + Sw * ALIGN { 0 0.5 1 0
my=. Sy + Sh - -: ALIGNV * Sh - tot
Textc=: Textf=: _1
r=. ''
for_d. dat do.
  'par siz'=. d
  for_p. par do.
    for_ln. p do.
      cnk=. > ln
      hit=. >./ ; 4{"1 cnk
      wid=. ; 3 {"1 cnk
      if. wid do.
        select. ALIGN
        case. iLEFT do.
          px=. mx + 0, +/\ }: wid
        case. iCENTER do.
          ext=. {: len=. +/\ wid
          px=. (mx - -: ext) + 0, }:len
        case. iRIGHT do.
          px=. mx - +/\. wid
        case. iJUST do.
          if. p_index < <: #par do.
            'wid cnk'=. Sw drawjust cnk
          end.
          px=. mx + 0, +/\ }: wid
        end.
        pos=. <"1 px,.my
        r=. r,drawtext pos,.3 {."1 cnk
      end.
      my=. my - prnd hit*LEADING
    end.
  end.
  my=. my - prnd hit*PARASPACE
end.

NB. ---------------------------------------------------------
setsxywhP Sx,Sy,Sw,(ALIGNV=0) * Sh-mov
rc;wraptext r
)

NB. =========================================================
drawjust=: 4 : 0
wid=. x
cnk=. fitdlb y
res=. i.0 4
for_d. cnk do.
  'c f t w h'=. d
  wid=. f fontcharwidth t
  msk=. 1, }. t=' '
  wid=. msk +/ ;.1 wid
  t=. msk <;.1 t
  res=. res, (<c),.(<f),.t,.(<&>wid),.<h
end.
wid=. ; 3{"1 res
if. 0.75 <: (+/wid) % x do.
  wid=. wid + (x - +/wid) % 1 >. <:#res
end.
wid;<res
)
