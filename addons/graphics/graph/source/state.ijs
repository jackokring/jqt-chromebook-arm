NB. state read & write
NB.
NB. defstate
NB. getstate
NB. putstate
NB. readstate

NB. =========================================================
getstate=: 3 : 0
if. 0=readstate'' do.
  defstate''
else.
  if. 0=#ccgraphstate do.
    defstate''
  else.
    cc=. 8 {. 0 ". ccgraphstate
    PEN=: 0 1 { cc
    PENCOLOR=: 2 3 4 { cc
    BRUSHCOLOR=: 5 6 7 { cc
  end.
end.
)

NB. =========================================================
NB. readstate
NB. defines global ccgraphstate
NB. returns 1 if ccgraphstate is in form
readstate=: 3 : 0
ccgraphstate=: ''
name=. <'ccgraphstate'
qd=. wd 'qd'
nms=. {."1 qd
if. name e. nms do.
  ccgraphstate=: > {: (nms i. name) { qd
  1
else.
  0
end.
)

NB. =========================================================
putstate=: 3 : 0
if. readstate'' do.
  wd 'set ccgraphstate *',":PEN
end.
)
