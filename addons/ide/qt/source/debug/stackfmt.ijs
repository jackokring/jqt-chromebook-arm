NB. jdb_stackrep
NB.
NB. format current stack into the 3 parts of the Debug window:
NB.   lines
NB.   stack
NB.   values
NB.
NB. also defines various (UPPERCASE) globals required by Debug

NB. =========================================================
NB.*jdb_stackrep v jdb_stackrep stack
NB.
NB. optional left argument is used by Debug:
NB.    moveline;error message  (default currentline ; J error message)
jdb_stackrep=: 3 : 0
'' jdb_stackrep y
:

if. 0 = #y do. y=. jdb_getstack'' end.
if. 0 = #y do. '' return. end.

NB. ---------------------------------------------------------
NB. define various globals:

NB. split up stack to minimize time used:
LOCALVALS=: 7 {"1 y
y=. 7 {."1 y

STACKLOCALS=: {."1 &.> LOCALVALS

NB. redefine LOCALVALS for current definition only:
LOCALVALS=: {:"1 > {. LOCALVALS  NB. local values
LOCALNAMES=: > {. STACKLOCALS    NB. local names

'NAME ERRNUM CURRENTLINE'=: 3 {. {. y

NB. exit if no-name definition (not initialized)
if. 0 e. #NAME do. '' return. end.

LDEFS=. GDEFS=. ''

NB. ---------------------------------------------------------
NB. line number ; error message:

if. #x do.
  'linenum errmsg'=. x
else.
  linenum=. CURRENTLINE
  errmsg=. (ERRNUM <. <:#ERRORS) >@{ ERRORS
end.

NB. ---------------------------------------------------------
nms=. 0{"1 y
lns=. linenum , }. ; 2{"1 y
nmc=. ; 3{"1 y        NB. 1 2 3
rps=. 4{"1 y
arglen=. # &> 6{"1 y

NB. ---------------------------------------------------------
NB. get valence of definitions on stack
NB.   0 = monad
NB.   1 = dyad
NB.  _1 = dont know
val=. (#nmc) # _1
if. 1 e. b=. nmc=3 do.
  val=. (<: b # arglen) (I. b)} val
end.

NB. test on presence of x if adverb or conjunction,
NB. and one of m n u v is present
if. 1 e. b=. (nmc~:3) *. (1: e. MNUV&e.) &> STACKLOCALS do.
  sel=. (<'x')&e. &> b # STACKLOCALS
  val=. sel (I. b)} val
end.

NB. ---------------------------------------------------------
NB. fix up dyad nameclass
nmc=. nmc + (nmc=3) *. val=1

NB. tacit if no locals:
tac=. 0 = # &> STACKLOCALS

NB. ---------------------------------------------------------
NB. convert reps into boxed lists:

brp=. (>: 0 >. val) >@{ &.> (<"1 tac,.nmc) jdb_boxrep &.> rps
bln=. # &> brp

if. 0=#brp do.
  jdb_info 'Unable to display Debug stack'
  '' return.
end.

if. 0={.bln do.
  jdb_info 'Unable to display top of stack'
  '' return.
end.

if. 0 e. bln do.
  brp=. (<'display not available') (I. bln)} brp
end.

NB. ---------------------------------------------------------
NB. top of stack:
'nam lnm typ'=. (<0;0 2 3) { y

NB. ---------------------------------------------------------
NB. lines:
dep=. 0 >@{ brp
LINES=: jdb_dtb &.> dep

dax=. jdb_indices &.> i.#dep
lines=. dax ,&.> dep

NUMLINES=: #lines
CODELINES=: jdb_codelines dep
VALENCE=: {. val
NMC=: {.nmc

NB. ---------------------------------------------------------
NB. stack:
lns=. lns <. bln
exl=. ;lns ({ ,& (<'{unknown}')) &.> brp
NB. Create line-number indices
NB. tacit definitions contain no linefeeds, and no instance of [1234] :
tacitlines =. -. +./ (LF;'1 :';'2 :';'3 :';'4 :') +./@:E.&>/ rps
NB. Indicate tacit definitions by '[tacit]'; header lines by '[header]'.
NB. header lines are tacit lines that contain the debug suffix
headerlines =. tacitlines *. DEBUGNAMESUFFIX&(+./@:E. ,)@> exl  NB. , needed because interp puts in scalar ':' line
NB. remove the debug suffix from the definition of a header line
exl =. headerlines DEBUGNAMESUFFIX&(taketo , takeafter)&.> exl
NB. format the line number; 0=explicit,1=tacit,2=header
ind=. jdb_indices&.> (tacitlines+headerlines) ({ ;&('tacit';'header'))"0 lns
NB. Remove the debugname suffix from the debug name
nmd =. ((-#DEBUGNAMESUFFIX) * (<DEBUGNAMESUFFIX) = (-#DEBUGNAMESUFFIX)&{.&.> nms) }.&.> nms
stack=. nmd ,&.> ind ,&.> exl

st0=. errmsg
if. ERRNUM e. ERRORCODES do.
  erm=. <;._2 ERM_j_
  if. (3=#erm) *. linenum=CURRENTLINE do.
    st0=. st0,LF,NAME,'[',(":linenum),'] ',jdb_dlb }.1 >@{ erm
    stack=. }.stack
  end.
end.

stack=. st0 ; stack

NB. ---------------------------------------------------------
NB. values:
wat=. jdb_cutopen WATCH
dfs=. jdb_getdefs 0 >@{ exl
dfs=. dfs -. MNUVXY
dfs=. ~. wat, ((MNUVXY e. LOCALNAMES)#MNUVXY), dfs
ndx=. LOCALNAMES i. dfs
msk=. ndx = #LOCALNAMES
lcs=. LOCALNAMES jdb_fixlocal &.>&(((-.msk)#ndx)&{) LOCALVALS
glb=. LOCALE jdb_showglobals msk#dfs
vls=. (/:/:msk) { lcs,glb
values=. dfs ,&.> ' ' ,&.> vls

NB. ---------------------------------------------------------
lines;stack;<values
)
