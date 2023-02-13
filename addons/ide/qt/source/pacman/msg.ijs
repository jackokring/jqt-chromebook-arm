NB. msg

NB. =========================================================
addon_info=: 3 : 0
if. 0=#PKGDATA do. return.end.
row=. DATAX{(I.DATAMASK),_1
if. row<0 do. return. end.
a=. (<row;1){:: PKGDATA
if. 'base library'-:a do. a=. 'JAL' else. a=. 'Addons/',a end.
browse_j_ 'http://code.jsoftware.com/wiki/',a
)

NB. =========================================================
loggui=: 3 : 0
LOGTXT=: LOGTXT,<;.2 y,LF -. {: y
if. window=0 do. return. end.
wd 'set blog value 1'
MSGX=: 3
pmview_showlog''
wd 'msgs'
)
