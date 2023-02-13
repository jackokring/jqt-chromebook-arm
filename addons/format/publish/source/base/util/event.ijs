NB. publish event

FORCETHROW=: 0
throwtext=: ''

NB. =========================================================
NB. rcOK v prepend OK return code
rcOK=: 0;<

NB. =========================================================
dat=. 0 : 0
0   OK
1   Unknown error
101 Problem with source data
201 Problem with program code
)

dat=. a: -.~ <;._2 dat
RCN=: 0 ". 3 {.&> dat
ndx=. RCN i. 101
RCS=: (,ndx&{) (<&>RCN),.4 }.each dat

NB. =========================================================
getrc=: 3 : 'RCS {~ RCN i. y'

NB. =========================================================
NB. returns returncode;message
getreturncode=: 3 : 0
txt=. throwtext
if. 0 = #txt do.
  getrc 101 return.
end.
ndx=. txt i. ' '
rc=. _1 ". ndx {. txt
'rc msg'=. getrc rc
txt=. deb (ndx+1) }. txt
rc;msg,(0<#txt)#': ',txt
)

NB. =========================================================
NB. throw
NB.
NB. write y to throwtext
NB.
NB. if debug is on and not FORCETHROW, display y in
NB. an info box, and stop all verbs on stack,
NB. otherwise write text to the session and throw.
throw=: 3 : 0
throwtext__locB=: y
if. FORCETHROW < debugq'' do.
  debugss ; (2 }. {."1 debugstack'') ,each <' *:*,'
  info y
else.
  smoutput y
  throw.
end.
)