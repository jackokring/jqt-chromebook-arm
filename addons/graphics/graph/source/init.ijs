NB. initialize graph
NB.
NB. GDCMD is 2 column table:
NB.    command, parameter
NB.
NB. in jzgraph:
NB. GDIDS    3 column: name;handle;locale
NB. GDLOC    active locale

require 'png'

coclass 'jzgraph'
coinsert 'jgl2'

GDLOC=: <''
GDIDS=: 0 3 $ <''
EMPTY=: i. 0 0

NB. =========================================================
create=: 3 : 0
HWNDP=: ''
reset''
)

NB. =========================================================
reset=: 3 : 0
GDCMD=: i.0 2
)

NB. =========================================================
destroy=: 3 : 0
wd :: ] 'psel ',HWNDP,';pclose'
gddel HWNDP
codestroy''
)
