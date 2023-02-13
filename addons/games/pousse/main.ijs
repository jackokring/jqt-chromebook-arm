NB. run

NB. =========================================================
done=: 3 : 0
cred=. PRED straight BS
cgreen=. PGREEN straight BS
res=. cred ~: cgreen
if. res do.
  button_enable (4*SIZE)#0
  name=. (cgreen>cred) pick 'Red';'Green'
  txt=. log ,LF, name,' wins'
  wd 'set log text *', txt
  wd 'set log scroll ',": 1++/txt=LF
end.
res
)

NB. =========================================================
pousse=: ''&$: : (4 : 0)
if. 32= 3!:0 y do. y=. '' end.
SIZE=: {.y,DEFSIZE
WID=: 13
HITE=: 13
CELL=: 20
SEQ=: ''
BS=: (2#SIZE)$' '
PRED=: 'X'
run ":SIZE
x ps_run''
)

NB. =========================================================
ps_default=: 3 : 0
if. -. systype-:'button' do. '' return. end.
if. -. (<syschild) e. ,BUTTONS do. '' return. end.
if. IFGREENMOVE > IFTWO do. rungreen'' return. end.
run (":SIZE),' ',SEQ=: SEQ,' ',syschild
IFGREENMOVE=: -. IFGREENMOVE
psshow''
if. done '' do. return. end.
if. IFAUTO > IFTWO do. rungreen'' end.
)

NB. =========================================================
NB. auto run green
rungreen=: 3 : 0
if. IFTWO do. return. end.
run (":SIZE),' ',SEQ=: SEQ,' ',ev2 pickmove piece
IFGREENMOVE=: 0
psshow''
if. done '' do. return. end.
)

NB. =========================================================
writeenable=: 3 : 0
button_enable -.| (IFGREENMOVE{PRED,PGREEN) evrepeat allm
)

NB. =========================================================
wd^:('Android'-.@-:UNAME) :: ] 'psel ps;pclose'
pousse ''
