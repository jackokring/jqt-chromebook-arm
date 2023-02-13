NB. table util

NB. =========================================================
NB. convert <br/> to LF
br2lf=: 3 : 0
m=. '<br/>' E. y
if. -. 1 e. m do. y return. end.
((m i. 1) {. y), ; LF ,each 5 }. each m <;.1 y
)

NB. =========================================================
drawall=: 3 : 0
res=. drawback''
res, drawcell''
)

NB. =========================================================
NB. for historical compatibility
draw_keskey=: draw_std

NB. =========================================================
NB. get alignment all table
setalign=: 3 : 0
aln=. ,Align
select. #aln
case. 0 do.
  Trws$,:0,Ccls$1
case. 1;Ccls;Clen do.
  0,.((Hrws,Ccls)$1),(Crws,Ccls)$aln
case. (Ccls + 1);Tlen do.
  (Trws,Tcls) $ aln
case. do.
  throw '101 Invalid align setting'
end.
)

NB. =========================================================
NB. get font all table
NB. returns font table, biggest header font, data font
setfont=: 3 : 0
f0=. fontindex FONTTH
f1=. fontbold f0
f2=. fontindex FONTTC
f3=. fontbold f2
bld=. ,Bold
select. #bld
case. 0 do.
  r=. ((Hrws,Ccls+1)$1),1,.(Crws,Ccls)$2
case. 1;Ccls;Clen do.
  r=. 1,.((Hrws,Ccls)$1),(Crws,Ccls)$2+bld
case. (Ccls + 1);Tlen do.
  r=. ((Trws,Tcls) $ bld) + (-Trws,Tcls) {. (Crws,Ccls)$2
case. do.
  throw '101 Font values do not match table size'
end.
tab=. r { f0,f1,f2,f3
hdr=. ({."1 r),,Hrws{.r
F0=. (>./hdr) { f0,f1
dat=. (}."1 r),,Hrws}.r
F1=. (_2+>./hdr) { f2,f3
tab;F0;F1
)

NB. =========================================================
NB. get gridh all table
setgridh=: 3 : 0
gh=. ,Gridh
select. #gh
case. 0 do.
  (1+Trws)$0
case. 1;1+Trws do.
  (1+Trws)$gh
case. do.
  throw '101 Gridh values do not match table size'
end.
)

NB. =========================================================
NB. get gridv all table
setgridv=: 3 : 0
gv=. ,Gridv
select. #gv
case. 0 do.
  (1+Tcls)$0
case. 1;1+Tcls do.
  (1+Tcls)$gv
case. do.
  throw '101 Gridv values do not match table size'
end.
)

NB. =========================================================
NB. get highlight indices for all table
NB.
NB. result is indices into table colors
sethigh=: 3 : 0
clr=. ,High
def=. (-Trws) {. 1,.(Crws,Ccls)$2
select. #clr
case. 0 do.
  def
case. 1 do.
  def sethighx {.clr
case. Ccls;Clen do.
  ndx=. <(Hrws+i.Crws);1+i.Ccls
  (2 sethighx (Crws,Ccls) $ clr) ndx } def
case. (Ccls + 1);Tlen do.
  def sethighx (Trws,Tcls) $ clr
case. do.
  throw '101 Color values do not match table size'
end.
)

NB. =========================================================
NB. sethighx
NB. x = default value
NB. y = given color index
NB. returns index into table colors
sethighx=: 4 : '(x * y=0) + (y+2) * y>0'