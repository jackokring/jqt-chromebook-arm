NB. latent expression

NB. =========================================================
jdb_debug=: 3 : 0
jdb_lxsoff''

if. -. jdb_isgui'' do.
  13!:15''
  13!:0[0
  HWNDP=: TABCURRENT=: ''
  return.
end.

stack=. jdb_getstack''
if. 0 e. #stack do.
  jdb_lxson'' return.
end.
stack=. {. stack

jdb_ppget 0

if. #y do.
  LOCALE=: y
else.
  LOCALE =: <'base'
end.
ERM_j_=: jdb_dberm''

NB. ---------------------------------------------------------
'NAME ERRNUM CURRENTLINE'=: 3 {. stack
MOVELINE=: CURRENTLINE
MOVELINES=: ,MOVELINE
ERRMSG=: (ERRNUM <. <:#ERRORS) >@{ ERRORS

NB. ---------------------------------------------------------
jdb_lexwin ''
if. (*#y) *. IFDISSECT *. AUTODISSECT do.
  NB. Before calling for another autodissect window, delete any one that exists
  jdb_destroyad''
  jdebug_dissectcurrent_run CURRENTLINE
else. jdb_restore ''
end.
:
NB. Dyad, must be a call from latent expression.  x is the name of name;type
LOCALTYPES =: x
jdb_debug y
)
