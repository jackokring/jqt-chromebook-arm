NB. table add
NB.
NB. if row not given, treat as empty row label
NB. if col not given, tread as empty col header

NB. =========================================================
TableTags=: <;._2 (0 : 0)
align
bold
col
data
gridh
gridv
high
row
top
)

NB. =========================================================
add=: 3 : 0
'off tag prm val'=. checktag2 y
set prm
val=. TableTags parseml val
if. -. (<'data') e. 1{"1 val do.
  throw '101 Data not given in table definition'
end.
msk=. (<1) = {."1 val
addopts msk # val

NB. ---------------------------------------------------------
NB. set data globals:
IfRow=: 0 < #Row
IfCol=: 0 < #Col

NB. ---------------------------------------------------------
select. IfRow,IfCol
case. 0 0 do.
  if. 0=#SHAPE do.
    throw '101 Shape not given in table definition'
  end.
  'Crws Ccls'=: SHAPE
  Clen=: Crws * Ccls
  Row=: Crws#<''
  Col=: Ccls#<''
  Top=: ''
case. 1 0 do.
  Clen=: #Data
  Crws=: #Row
  Ccls=: <. Clen % Crws
  Col=: Ccls#<''
  Top=: ''
case. 0 1 do.
  Clen=: #Data
  Ccls=: #Col
  Crws=: <. Clen % Ccls
  Row=: Crws#<''
case. 1 1 do.
  Crws=: #Row
  Ccls=: #Col
  Clen=: Crws * Ccls
end.
if. Clen ~: #Data do.
  msg=. LF,LF,'Expected data items: ',":Clen
  msg=. msg,LF,LF,'Given data items: ',":#Data
  throw '101 Table data does not match rows and cols',msg
end.

NB. ---------------------------------------------------------
CDlen=: 1 + +/@(LF&=) &> Data
CRlen=: >./"1 (Crws,Ccls) $ CDlen
IfMulti=: 1 e. 1 < CDlen

NB. ---------------------------------------------------------
if. IfMulti do.
  DataM=: ; CDlen {.each 1
  DataX=: ; <;._1 each LF ,each Data
end.

NB. ---------------------------------------------------------
hc=. <;._1 &> LF ,each Top;Col
Top=: {.hc
Col=: |:}.hc

if. Ccls ~: {:$Col do.
  msg=. LF,LF,'Expected header columns: ',":Ccls
  msg=. msg,LF,LF,'Given header columns: ',":{:$Col
  throw '101 Header columns do not match data',msg
end.

NB. ---------------------------------------------------------
Hrws=: #Col
Trws=: Hrws+Crws
Tcls=: 1 + Ccls
Tlen=: Trws * Tcls
)

NB. =========================================================
addopts=: 3 : 0
for_d. y do.
  'off nam prm val'=. d
  set prm
  val=. u2a val
  select. nam
  case. 'align' do.
    Align=: fix val
  case. 'bold' do.
    Bold=: fix val
  case. 'col' do.
    Col=: br2lf each cutlist val
  case. 'data' do.
    Data=: br2lf each cutlist val
  case. 'gridh' do.
    Gridh=: fix val
  case. 'gridv' do.
    Gridv=: fix val
  case. 'high' do.
    High=: fix val
  case. 'row' do.
    Row=: cutlist val
  case. 'top' do.
    Top=: br2lf deb val
  end.
end.
)
