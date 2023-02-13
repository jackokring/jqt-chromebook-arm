NB. watch manager

NB. =========================================================
jdbwatch_dun=: 3 : 0

NB. following can happen if user leaves watch open
NB. and a debug event occurs:
if. 0 ~: 4!:0 <'wlist' do. return. end.

txt=. ' ' (I. wlist=LF)} wlist
nms=. jdb_cutopen txt
nmc=. (4!:0 :: _2:)"0 nms
if. _2 e. nmc do.
  bad=. nmc = _2
  t=. ;: ^:_1 bad # nms
  jdb_info 'Invalid watch name',((1<+/bad)#'s'),': ',t
  return.
end.
WATCH=: nms
)

NB. =========================================================
jdbwatch_ini=: 3 : 0
txt=. jdb_tolist jdb_cutopen WATCH
jdb_wd 'set wlist text *',txt
jdb_wd 'setfocus wlist'
)

NB. =========================================================
jdebug_watchclear_button=: 3 : 0
jdb_wd 'set wlist text'
jdb_lxson''
)

NB. =========================================================
jdbwatch_stopwin_button=: 3 : 0
'' jdb_swap 'jdbstop'
jdb_lxson''
)

NB. =========================================================
jdebug_watchclose_button=: jdebug_mainwin
