NB. websocket class

SNDLIM=: 65000

NB. =========================================================
HSRESPONSE=: ' ' ,~ }: 0 : 0
HTTP/1.1 101 Switching Protocols
Upgrade: Websocket
Connection: Upgrade
Sec-WebSocket-Accept:
)

NB. =========================================================
badrequest=: 3 : 0
b=. '<!DOCTYPE HTML>',CRLF,'<html>',CRLF
b=. b,'<head><title>400 Bad Request</title></head>',CRLF
b=. b,'<body><h1>Bad Request</h1>',CRLF,'<p>',y,'</p></body></html>',CRLF
r=. 'HTTP/1.1 400 Bad Request',CRLF,'Content-length: ',":#b
r,CRLF,'Connection: Closed',CRLF,CRLF,b
)

NB. =========================================================
checklastuse=: 3 : 0
if. IdleTimeout do.
  if. IdleTimeout < 1000 * (6!:1'') - lastuse do.
    if. JFE do. Destroy=: 1 else. disconnect'' end.
  end.
end.
)

NB. =========================================================
checktermtime=: 3 : 0
if. TermTimeout do.
  if. TermTimeout < 1000 * (6!:1'') - connected do.
    if. JFE do. Destroy=: 1 else. disconnect'' end.
  end.
end.
)

NB. =========================================================
clearbuffers=: 3 : 0
clearread clearwrite''
)

NB. =========================================================
clearframe=: 3 : 0
datalen=: _1
readframe=: ''
)

NB. =========================================================
clearread=: 3 : 0
clearframe''
datafin=: 0
dataopn=: 0
data=: readdata=: ''
0
)

NB. =========================================================
clearwrite=: 3 : 0
senddata=: sendframe=: ''
)

NB. =========================================================
disconnect=: 3 : 0
writesock 136 0{a.
destroy''
)

NB. =========================================================
create=: 3 : 0
SC=: y
sdcheck sdioctl SC,FIONBIO,1
Destroy=: 0
clearbuffers''
connect=: 0
encoding=: 1
NextVar=: 0
lasterror=: ''
connected=: lastuse=: 6!:1''
addserver coname''
try.
  doconnect''
catch.
  writesock badrequest 'Websocket handshake failed'
  log 'err';'handshake failed'
  destroy''
end.
)

NB. =========================================================
destroy=: 3 : 0
if. JFE do.
  stopjfe''
  exit 0
end.
sdclose SC
removeserver coname''
codestroy''
)

NB. =========================================================
doconnect=: 3 : 0
try.
  handshake''
catch.
  (13!:12'')13!:8(13!:11'')   NB. shortcut the following lines
end.
if. JFE *. connect do. initjfe'' return. end.
if. Destroy do. destroy'' return. end.
addwait SC;'';''
)

NB. =========================================================
handshake=: 3 : 0
if. readsock'' do. return. end.
d=. <;._2 data -. CR
n=. d i.&> ':'
nam=. n {.each d
val=. deb each (n+1) }.each d
assert 'GET '-: 4 {. 0 pick nam
assert (<'upgrade') e. cutval (nam i. <'Connection') pick val
assert (<'websocket') e. cutval (nam i. <'Upgrade') pick val
key=. (nam i. <'Sec-WebSocket-Key') pick val
ver=. (nam i. <'Sec-WebSocket-Version') pick val
acc=. HSRESPONSE,(hasher key),LF
swp=. (nam i. <'Sec-WebSocket-Protocol') pick val,<''
prt=. Protocols intersect ',' cutopen swp -. ' '
if. #prt do.
  pro=. 0 pick prt
  acc=. acc,'Sec-WebSocket-Protocol: ',pro,LF
else.
  pro=. ''
end.
acc=. toCRLF acc,LF
writesock acc
clearread''
connect=: 1
)

NB. =========================================================
initjfe=: 3 : 0
s=. > coname''
input_jfe_=: ('input_',s,'_')~
output_jfe_=: ('output_',s,'_')~
JFEconnect_jws_=: 1
setimmex 'jfe_jws_ 1'
)

NB. =========================================================
NB. 0{x is 0=more to come, 1=finished
NB. 1{x is opcode, e.g. 0=continuation (not used), 1=text, 2=binary
NB. size is < SNDLIM so 8 byte lengths are not used
makeframe=: 4 : 0
'f t'=. x
h=. a. {~ t + 128*f
len=. #y
if. len<126 do.
  h=. h,a.{~len
elseif. len<65536 do.
  h=. h,a.{~126,(2#256) #: len
elseif. do.
  h=. h,a.{~127,(8#256) #: len
end.
h,y
)

NB. =========================================================
NB.*readbase v read socket frame
NB. reads and calls functions on frame
readbase=: 3 : 0
if. readsock'' do. return. end.
if. -. readcheck'' do. return. end.
if. dataopn>2 do.
  readbasex dataopn;readdata
else.
  ws_onmessage readdata
end.
clearread''
)

NB. =========================================================
readbasex=: 3 : 0
clearread''
'opn val'=. y
select. opn
case. 8 do.
  clearbuffers''
  writesock 136 0{a.
  Destroy=: 1
case. 9 do.
  writesock 1 10 makeframe val
end.
)

NB. =========================================================
NB. this tests if all data has been received
NB. returns success flag
readcheck=: 3 : 0
if. 0=#data do. 0 return. end.
if. datalen < 0 do.
  readframe=: readcheck1 data
  if. 0-:readframe do. 0 return. end.
else.
  readframe=: readframe,data
end.
data=: ''
if. datalen > #readframe do. 0 return. end.
dat=. datalen {. readframe
data=: datalen }. readframe
clearframe''
msk=. 4 {. dat
dat=. 4 }. dat
val=. charbin (binchar dat) ~: (#dat) $ binchar msk
readdata=: readdata,val
datafin
)

NB. =========================================================
NB. check initial frame block
NB. returning 0=not yet or data
NB. also defines:
NB. datafin if data finished
NB. datalen data length (including mask)
NB. dataopn operation code
readcheck1=: 3 : 0
if. 6>#y do. 0 return. end.
b1=. binchar 0{y
datafin=: {.b1
opn=. 2 #. 4 }. b1
if. 0=#readdata do.
  dataopn=: opn
  if. dataopn=2 do. encoding=: 2 end.
else.
  if. opn do. clearbuffers'' return. end.
end.
len=. a.i.1{y
if. len<128 do. clearbuffers'' return. end.
len=. 128|len
dat=. 2 }. y
if. len=126 do.
  if. 2>#dat do. 0 return. end.
  len=. 256 #. a.i.2{.dat
  dat=. 2 }. dat
elseif. len=127 do.
  if. 8>#dat do. 0 return. end.
  len=. 256 #. a.i.8{.dat
  dat=. 8 }. dat
end.
datalen=: len+4
dat
)

NB. =========================================================
NB.*readsock v read socket, update data
NB. returns 0=OK, 1=fail
readsock=: 3 : 0
'c d'=. sdrecv SC,SNDLIM
if. (c=0) *. 0<#d do.
  data=: data,d
  0 return.
end.
e=. sderror c
if. (<e) e. 'EAGAIN';'EWOULDBLOCK' do. 1 return. end.
if. (e-:'ECONNRESET') +. (c=0)*.0=#d do.
  clearbuffers''
  Destroy=: 1
else.
  clearbuffers''
  logerror 'read: ',e,' ',":c,SC
  1
end.
)

NB. =========================================================
NB. called on base server socket end wait
runbase=: 3 : 0
if. -. connect do. doconnect ::destroy'' return. end.
lastuse=: 6!:1''
'r w e'=. y
if. SC e. r do. readbase'' end.
if. SC e. w do. writesock'' end.
if. Destroy do. destroy'' else. addwait SC;'';'' end.
)

NB. =========================================================
NB. writesock
NB. the data size should be no more than SNDLIM
writesock=: 3 : 0
if. #y do. senddata=: y end.
NB. if. 0=#senddata do. ws_send'' return. end.
label_a1.
if. 0=#senddata do. 0&ws_send'' end.
if. 0=#senddata do. EMPTY return. end.
'c n'=. senddata sdsend SC,0
e=. sderror c
NB. if. e-:'EWOULDBLOCK' do.
NB. elseif. e-:'ECONNRESET' do.
if. e-:'EWOULDBLOCK' do. EMPTY return.
elseif. e-:'ECONNRESET' do. EMPTY return.
elseif. c=0 do.
  senddata=: n}.senddata
elseif. do.
  logerror 'write: ',e,' ',":c
  clearbuffers''
end.
if. #senddata do.
  addwait '';SC;''
else.
NB.   ws_send''
NB. check pending sendframe queue
  goto_a1.
end.
EMPTY
)

NB. =========================================================
NB. ws_send v write new data to sendframe
NB. sendframe is a boxed list of pending writes
NB. each write is flag;text where flag=1 all, 0 part
NB. x=0 suppress calling writesock again to prevent recursion
ws_send=: 3 : 0
1 ws_send y
:
if. #y do.
  ('var_',":NextVar)=: y
  sendframe=: sendframe,<1,NextVar,0
  NextVar=: >:NextVar
end.
if. (#senddata) +. 0=#sendframe do. '' return. end.
'flag vdat vpos'=. 0 pick sendframe
NB. vdat: variable name
NB. vpos: position offset
dat=. ('var_',":vdat)~
if. SNDLIM<vpos-~#dat do.
  senddata=: (0,flag*encoding) makeframe SNDLIM{.vpos}.dat
NB. update position offset
  sendframe=: (<0,vdat,SNDLIM+vpos) 0} sendframe
else.
  senddata=: (1,flag*encoding) makeframe vpos}.dat
  sendframe=: }. sendframe
NB. erase temp variable
  4!:55 <'var_',":vdat
end.
NB. writesock''
NB. do not call writesock if ws_send is called from writesock
if. x do. writesock'' end.
)
