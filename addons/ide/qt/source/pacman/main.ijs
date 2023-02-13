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
NB. if. -. checkaccess'' do. 0 return. end.
NB. if. -. checkaddonsdir'' do. 0 return. end.
HASFILEACCESS=: checkaccess''
HASADDONSDIR=: checkaddonsdir''
setfiles ''
readlocal''
NB. if. -. checkonline'' do. 0 return. end.
ONLINE=: checkonline''
pacman_init 1
pmview_open''
pmview_show''
1
)

NB. =========================================================
pmview_selected=: 3 : 'PKGDATA #~ > {."1 PKGDATA'

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
pmview_showdata=: 3 : 0
VIEWDATA=: y
dat=. ": each 5 {."1 VIEWDATA
wd 'set pac shape ',":$dat
wd 'set pac type 100 0 0 0 0'
NB. wd 'set pac protect 0 1 1 1 1'
wd 'set pac data *',toDEL dat
)

NB. =========================================================
pmview_showlog=: 3 : 0
if. window=0 do. return. end.
if. MSGX=3 do.
  t=. ; LOGTXT
else.
  ndx=. DATAX{(I.DATAMASK),_1
  if. ndx<0 do.
    t=. ''
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
if. 2 ~: 3!:0 t do. t=. '' end.
wd 'set edlog text *',t
if. MSGX=3 do. wd 'set edlog scroll max' end.
)
