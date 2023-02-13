NB. main

NB. =========================================================
pmview_applycounts=: 3 : 0
dat=. y
if. 0=#dat do. 0 0 return. end.
'lib dat'=. splitlib dat
cnt=. 0 < #lib
siz=. cnt * 2 pick LIB
ind=. ({."1 ZIPS) i. 1 {"1 dat
(cnt + #ind),siz + +/>(<ind;4){ZIPS
)

NB. =========================================================
pmview_getmask=: 3 : 0
ndx=. IFSECTION { SELNDX
if. IFSECTION do.
  sel=. ndx pick SECTION
  select. sel
  case. 'All' do.
    DATAMASK=: (#PKGDATA) $ 1
  case. BASELIB do.
    DATAMASK=: (1 {"1 PKGDATA) = <BASELIB
  case. do.
    DATAMASK=: (<sel,'/') = (1+#sel) {.each 1 {"1 PKGDATA
  end.
else.
  select. ndx pick Status
  case. 'All' do.
    DATAMASK=: (#PKGDATA) $ 1
  case. 'Not installed' do.
    DATAMASK=: pkgnew''
  case. 'Upgrades' do.
    DATAMASK=: pkgups''
  case. 'Installed' do.
    DATAMASK=: -. pkgnew''
  end.
end.
DATAX=: DATAX <. <: +/DATAMASK
)

NB. =========================================================
pmview_init=: 3 : 0
if. -. checkaccess'' do. 0 return. end.
if. -. checkaddonsdir'' do. 0 return. end.
setfiles ''
readlocal''
if. -. checkonline'' do. 0 return. end.
pacman_init 1
NB. pmview_open''
wd 'activity ', >coname''
1
)

NB. =========================================================
pmview_selected=: 3 : 0
if. _1= {. selection=. 0 ". wd 'get pac select' do.
  ''
else.
  PKGDATA {~ selection{(I.DATAMASK)
end.
)

NB. =========================================================
pmview_show=: 3 : 0
wd 'psel pm'
pmview_getmask ''
sel=. IFSECTION pick Status;<SECTION
wd 'set sel items ',toDEL sel
wd 'set sel select ',":IFSECTION { SELNDX
wd 'set apply enable ',":ONLINE
pmview_showdata DATAMASK # PKGDATA
)

NB. =========================================================
pmview_sel=: 3 : 0
wd 'psel pm'
pmview_getmask ''
wd 'set apply enable ',":ONLINE
pmview_showdata DATAMASK # PKGDATA
)

NB. =========================================================
pmview_showdata=: 3 : 0
VIEWDATA=: y
n=. 1{"1 VIEWDATA
v1=. 2{"1 VIEWDATA
v2=. 3{"1 VIEWDATA
wd 'set pac items *',toDEL n ,&.> (<LF) ,&.> v1 ,&.> (<' / ') ,&.> v2
if. #selection=. I. ; {."1 VIEWDATA  do.
  wd 'set pac select ', ":selection
end.
)

NB. =========================================================
pmview_showlog=: 3 : 0
if. window=0 do. return. end.
if. MSGX=3 do.
  t=. ; LOGTXT
else.
  ndx=. DATAX{(I.DATAMASK),_1
  if. ndx<0 do.
    t=. _1
  else.
    p=. '~addons/',(<ndx;1){:: PKGDATA
    select. MSGX
    case. 0 do.
      t=. ndx pick 5{"1 PKGDATA
    case. 1 do.
      t=. fread jpath p,'/history.txt'
    case. 2 do.
      t=. fread jpath p,'/manifest.ijs'
    end.
  end.
end.
if. 2 = 3!:0 t do.
  textview (MSGX{::'Summary';'History';'Manifest';'Log');'';t
end.
)
