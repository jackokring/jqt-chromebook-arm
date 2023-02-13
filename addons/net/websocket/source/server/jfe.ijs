NB. jfe
NB.
NB. first char in sent messages is type:  0=input, >0 output type

inputj=: 0 NB. set to 1 to allow subsequent output
inputbuf=: ''
cleanerror=: ]

NB. =========================================================
NB. JE calls for input, y is prompt
input=: 3 : 0
inputj=: 1
if. 0=#inputbuf do.
  logged=: 0
  ws_send '0',y
  clearread''
  while. -. Destroy do.
    addwait SC;'';''
    if. wsselect'' do. lastuse=: 6!:1'' continue. end.
    if. -. readcheck'' do. checklastuse'' continue. end.
    lastuse=: 6!:1''
    if. dataopn > 2 do. readbasex dataopn;readdata continue. end.
    break.
  end.
  if. Destroy do.
    clearread''
    13!:0 [ 0
    log 'end';''
    disconnect'' return.
  end.
  if. LF e. readdata do. inputbuf=: <;._2 readdata,LF end.
end.
if. #inputbuf do.
  readdata=: 0 pick inputbuf
  inputbuf=: }. inputbuf
end.
logcmd readdata
readdata
)

NB. =========================================================
NB. y output string
NB. x output types
NB.  MTYOFM   1 formatted result array
NB.  MTYOER   2 error
NB.  MTYOLOG  3 log
NB.  MTYOSYS  4 system assertion failure
NB.  MTYOEXIT 5 exit - not used
NB.  MTYOFILE 6 output 1!:2[2
output=: 4 : 0
if. JFEconnect *. inputj *. x ~: 3 do.
  if. x e. 2 4 do.
    inputbuf=: ''
    y=. cleanerror y
  end.
  logres (":x),y
  ws_send (":x),y
end.
EMPTY
)

NB. =========================================================
NB. jfe select read
NB. return 0=ok, 1=fail
wsselect=: 3 : 0
r=. runcheck sdselect Waits,<WaitTimeout
remwait r
checktermtime''
if. SC e. 1 pick r do. writesock'' end.
if. SC e. 0 pick r do. readsock'' else. 0 end.
)
