NB. addons
NB.
NB. addons called from JAndroid

NB. =========================================================
addons_msg=: 0 : 0
The XX are not yet installed.

To install, select menu Tools|Package Manager and install package YY.
)

NB. =========================================================
addons_missing=: 3 : 0
'name addon script'=. y
if. fexist script do. 0 return. end.
sminfo name;addons_msg rplc 'XX';name;'YY';addon
1
)

NB. =========================================================
demoja=: 3 : 0
p=. jpath '~addons/ide/ja/demo/jademo.ijs'
if. addons_missing 'jandroid demos';'ide/ja';p do. return. end.
load p
)

NB. =========================================================
demowd=: 3 : 0
p=. jpath '~addons/demos/wd/demos.ijs'
if. addons_missing 'Showcase demos';'demos/wd';p do. return. end.
load p
)

NB. =========================================================
labs_run=: 3 : 0

NB. temporary patch
smfocus_jijs_=: 0:
closewindows_jijs_=: 0:
smclose_jijs_=: 0:
smopen_jijs_=: open
smsel_jijs_=: 0:
smselout_jijs_=: 0:
smsetsaved_jijs_=: 0:
smwrite_jijs_=: 0:
tile_jijs_=: 0:
coinsert_jijs_ (,copath) coname''

p=. jpath '~addons/labs/labs/lab.ijs'
if. addons_missing 'labs';'labs/labs';p do. return. end.
require p
if. 0 e. $y do.
  require '~addons/labs/labs/labs805.ijs'
  labselect_jlab805_'' return.
end.
if. y -: 1 do. y=. ':' end.
empty lab_jlab_ y
)
