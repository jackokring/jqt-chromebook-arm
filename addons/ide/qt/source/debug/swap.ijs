NB. swap

NB. =========================================================
NB. jdb_swap
jdb_swap=: 3 : 0
'' jdb_swap y
:
jdb_lxsoff''
old=. TABCURRENT
TABCURRENT=: new=. y

if. -. jdb_isgui'' do.
  AUTODISSECT=: {.!.0 ". 'AUTODISSECT_jdebug_'  NB. Make autodissect sticky, with default 0
  autodissectlocale=: 0$a:
  jdb_wd JDEBUG
  HWNDP=: jdb_wd 'qhwndp'
  p=. WINPOS>.0 0,MINWIDTH,MINHEIGHT
  if. TABCURRENT -: 'jdbnone' do.
    p=. 0 (3}) p
  else.
    jdb_wd JDEBUGP
  end.
  jdb_wd 'pmove ',(":p),';pas 0 0;pshow'

else.
  jdb_wd 'psel ',HWNDP  NB. In case we were called externally, select the window
  if. new-:old do. return. end.
  if. #old do.
    (old,'_dun')~ 0
  end.
  if. -. (<'jdbnone') e. old;new do.
    jdb_wd 'set tabs active ', ":jdb_tabcurrent''
  else.
    hp=. HWNDP
    p=. -. new-:'jdbnone'
    fx=. 0 ". jdb_wd 'qform'
    jdb_wd JDEBUG, p#JDEBUGP
    HWNDP=: jdb_wd 'qhwndp'
    jdb_wd 'pmove ',":(3 {.fx),MINHEIGHT*p
    jdb_wd 'pas 0 0;pshow;ptop ',":PTOP
    jdb_wd 'psel ',hp,';pclose;psel ',HWNDP
  end.
  (new,'_ini')~ x
  if. -. new-:'jdbnone' do.
    jdb_wd 'set tabs active ', ":jdb_tabcurrent''
  end.
end.

if. IFDISSECT do.
  wd 'set tbar checked dissecttoggleauto ' , ": AUTODISSECT
end.

jdb_tbenable''
jdb_swapfkey''
)
