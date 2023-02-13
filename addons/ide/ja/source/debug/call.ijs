NB. call

NB. =========================================================
NB. restore various settings before running user code
NB. If y is nonempty, it is (line to dissect);(x options for dissect)
jdb_restore=: 3 : 0
jdb_ppset''
jdb_lxson ''
xsstg =. 'jdb_imxhandler_jdebug_ 1'
if. #y do.
  'line dissectopts' =. y
  xsstg =. ('((', (5!:5 <'dissectopts') , ') dissect ',(jdb_quote line), ') ') , xsstg
end.
jdb_imxs xsstg
jdb_imxss 1
)

NB. =========================================================
jdb_imxhandler=: 3 : 0
if. 1 >: # 13!:13'' do. jdb_clear'' end.
empty''
:
NB. Dyad: x is result from dissect
NB. if x is a scalar (box), remember it as the open autodissect locale
if. '' -: $x do. autodissectlocale =: x
elseif. *#x do. wdinfo 'Dissect message';x
end.
jdb_imxhandler 1  NB. finish up through monad
)

jdb_destroyad =: 3 : 0
NB. In case user destroyed the locale already, check before we do
if. #autodissectlocale do.
  if. autodissectlocale e. 18!:1 (1) do. destroy__autodissectlocale '' end.
end.
autodissectlocale =: 0$a:
empty''
)

NB. =========================================================
jdb_inactive=: 3 : '0 e. #NAME'

NB. =========================================================
NB. jdb_clear
jdb_clear=: 3 : 0
hx=. HWNDPX
jdb_debugreset''
if. jdb_isparent <'jdebug' do.
  jdb_destroyad''
  jdb_wd 'psel jdebug'
  jdb_swap 'jdbnone'
end.
if. #hx do.
  jdb_wd :: jdb_smact 'psel ',hx
else.
  jdb_smact ''
end.
13!:0 [ 1
jdb_lxson''
)

NB. =========================================================
jdb_close=: 3 : 0
if. jdb_isgui'' do.
  jdb_wd 'psel ',HWNDP
  WINPOS=: 0 ". jdb_wd 'qform'
  jdb_wd 'pclose'
end.
HWNDP=: ''
TABCURRENT=: ''
jdb_lxsoff ''
jdb_imxss 0
jdb_imxs ''
jdb_destroyad''
jdb_debuginit''
13!:0 [ 0
)

NB. =========================================================
jdb_open=: 3 : 0
a=. jdb_getactive''
jdb_debuginit''
ERM_j_=: ''
if. #jdb_getstack'' do.
  jdb_debug ''
else.
  jdb_ppget 0
  jdebug_run 0
  jdb_restore''
end.
jdb_setactive a
)
