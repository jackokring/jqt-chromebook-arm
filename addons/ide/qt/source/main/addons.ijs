NB. addons
NB.
NB. addons called from Qt

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
demoqt=: 3 : 0
p=. jpath '~addons/demos/qtdemo/qtdemo.ijs'
if. addons_missing 'qt demos';'demos/qtdemo';p do. return. end.
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
