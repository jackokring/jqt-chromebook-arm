load 'socket'

cocurrent 'jws'
coinsert 'jsocket'

LogDir=: jpath '~temp/logs'
LogLen=: 3
WaitTimeout=: 5000
InitTimeout=: 0
IdleTimeout=: 600000
TermTimeout=: 0
binchar=: (8$2)#:a.&i.
charbin=: a. {~ #.
jfe=: 0 0$15!:16
intersect=: e. # [
remLF=: }.~ [: - LF = {:
sha1sum=: 1 & (128!:6)

BASE64=: (a.{~ ,(a.i.'Aa') +/i.26),'0123456789+/'
MaxRep=: 100
boxj2utf8=: 3 : 0
if. 1 < #$y do. y return. end.
b=. (16+i.11) { a.
if. -. 1 e. b e. y do. y return. end.
y=. ucp y
a=. ucp '┌┬┐├┼┤└┴┘│─'
x=. I. y e. b
utf8 (a {~ b i. x { y) x } y
)
checktimes=: 3 : 0
for_loc. servers intersect conl 1 do.
  try.
    checklastuse__loc''
    checktermtime__loc''
  catch. end.
end.
)
cutval=: 3 : 0
deb each <;._1 ',',tolower y
)
flatten=: 3 : 0
dat=. ": y
select. # $ dat
case. 1 do.
case. 2 do.
  }. , LF ,. dat
case. do.
  dat=. 1 1}. _1 _1}. ": < dat
  }: (,|."1 [ 1,.-. *./\"1 |."1 dat=' ')#,dat,.LF
end.
)
hasher=: 3 : 0
s=. y,'258EAFA5-E914-47DA-95CA-C5AB0DC85B11'
tobase64 a.{~ 16 #. _2[\ '0123456789abcdef' i. sha1sum s
)
macinit=: 3 : 0
if. UNAME-:'Darwin' do.
  ioctlsocketJ_jsocket_=: 'ioctl i i x *i' scdm_jsocket_
  FIONBIO_jdefs_=: 16b8004667e
end.
)
mrep=: 3 : 0
y=. (LF={.y)}.(-LF={:y)}.y
r=. y rplc LF;','
if. MaxRep<#r do.
  (MaxRep{.r),'..'
end.
)
setimmex=: 3 : 0
9!:27 y
9!:29 [ 1
EMPTY
)
srep=: 3 : 0
y=. (-LF={:y)}.y
if. LF e. y do.
  r=. y rplc LF;','
else.
  r=. 5!:5 <'y'
end.
if. MaxRep<#r do.
  (MaxRep{.r),'..'
end.
)
tobase64=: 3 : 0
res=. BASE64 {~ #. _6 [\ , (8#2) #: a. i. y
res, (0 2 1 i. 3 | # y) # '='
)
wsreset=: 3 : 0
for_loc. servers intersect conl 1 do.
  destroy__loc''
end.
)
SK=: SC=: 0

JFEconnect=: 0
Protocols=: ;: 'binary'
RestartMsg=: 'server halted - restart by running: restart'''''
accept=: 3 : 0
addwait SK;'';''
'rc sc'=. sdaccept SK
if. rc=0 do. sc conew 'jws' end.
)
addserver=: 3 : 0
log__y 'add';y
servers_jws_=: servers,y
sockets_jws_=: sockets,SC__y
addwait SC__y;'';''
)
addwait=: 3 : 0
empty Waits_jws_=: ~.each Waits,each y
)
endclient=: 3 : 0
if. -. x e. sockets do. return. end.
loc=. (sockets i. x){servers
destroy__loc''
)
endserver=: 3 : 0
locs=. servers intersect conl 1
for_loc. locs do. destroy__loc'' end.
sdclose SK
log 'end';''
2!:55''
)

shutdown=: endserver
init=: 3 : 0
'Port JFE'=: 2{.y,0
loginit''
macinit''
servers=: ''
sockets=: ''
SK=: 0 pick sdcheck sdsocket''
sdcheck sdioctl SK,FIONBIO,1
sdcheck sdbind SK;AF_INET;'';Port
sdcheck sdlisten SK,1
smoutput (JFE pick 'base';'jfe'),' server running on port ',":Port
initrun''
)
initrun=: 3 : 0
Waits=: (SK,sockets);'';''
inito=. InitTimeout * 0=#sockets
wtime=. 0
loop=: 1
while. loop do.
  r=. runcheck sdselect Waits,<WaitTimeout
  if. 0=#;r do.
    wtime=. wtime + WaitTimeout
    if. (0 < inito) *. wtime >: inito do. exit 0 return. end.
    checktimes''
    continue.
  end.
  inito=. 0
  remwait r
  if. SK e. 0 pick r do. accept'' end.
  s=. (sockets e. ~.;r)#servers
  for_x. s do. runbase__x r end.
  if. JFEconnect do. EMPTY return. end.
end.
smoutput RestartMsg
)
interrupt=: 3 : 0
if. JFE do.
  stopjfe''
  smoutput RestartMsg
else.
  0$loop=: 0
end.
)
removeserver=: 3 : 0
log__y 'rem';y
b=. servers~:y
servers_jws_=: b#servers
sockets_jws_=: b#sockets
Waits_jws_=: Waits intersect each <SK,sockets
)
remwait=: 3 : 0
Waits_jws_=: Waits -. each y
)
restart=: 3 : 0
if. -. restartjfe'' do.
  startbase''
end.
EMPTY
)
restartjfe=: 3 : 0
if. -. JFE do. 0 return. end.
if. 0 = #sockets do. 0 return. end.
sk=. {. sockets
if. 0 ~: 0 pick sdgetsockopt sk;SOL_SOCKET;SO_ERROR do. 0 return. end.
lc=. {. servers
initjfe__lc''
1
)

restart_z_=: restart_jws_
runcheck=: 3 : 0
rc=. >{.y
res=. }.y
if. 0=rc do. return. end.
if. 'ENOTSOCK' -: sderror rc do.
  for_x. ;res do.
    c=. sdgetsockopt x;SOL_SOCKET;SO_ERROR
    log 'err';'sdgetsocketopt result for ',(":x),': ',srep c
    if. >{.c do.
      if. x=SK do.
        endserver''
      else.
        endclient x
      end.
      0 return.
    end.
  end.
end.
res
)
startbase=: 3 : 0
setimmex 'initrun_jws_ 0'
)
stopjfe=: 3 : 0
input_jfe_=: output_jfe_=: empty
jfe 0
JFEconnect_jws_=: 0
)
SNDLIM=: 65000
HSRESPONSE=: ' ' ,~ }: 0 : 0
HTTP/1.1 101 Switching Protocols
Upgrade: Websocket
Connection: Upgrade
Sec-WebSocket-Accept:
)
badrequest=: 3 : 0
b=. '<!DOCTYPE HTML>',CRLF,'<html>',CRLF
b=. b,'<head><title>400 Bad Request</title></head>',CRLF
b=. b,'<body><h1>Bad Request</h1>',CRLF,'<p>',y,'</p></body></html>',CRLF
r=. 'HTTP/1.1 400 Bad Request',CRLF,'Content-length: ',":#b
r,CRLF,'Connection: Closed',CRLF,CRLF,b
)
checklastuse=: 3 : 0
if. IdleTimeout do.
  if. IdleTimeout < 1000 * (6!:1'') - lastuse do.
    if. JFE do. Destroy=: 1 else. disconnect'' end.
  end.
end.
)
checktermtime=: 3 : 0
if. TermTimeout do.
  if. TermTimeout < 1000 * (6!:1'') - connected do.
    if. JFE do. Destroy=: 1 else. disconnect'' end.
  end.
end.
)
clearbuffers=: 3 : 0
clearread clearwrite''
)
clearframe=: 3 : 0
datalen=: _1
readframe=: ''
)
clearread=: 3 : 0
clearframe''
datafin=: 0
dataopn=: 0
data=: readdata=: ''
0
)
clearwrite=: 3 : 0
senddata=: sendframe=: ''
)
disconnect=: 3 : 0
writesock 136 0{a.
destroy''
)
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
destroy=: 3 : 0
if. JFE do.
  stopjfe''
  exit 0
end.
sdclose SC
removeserver coname''
codestroy''
)
doconnect=: 3 : 0
try.
  handshake''
catch.
  (13!:12'')13!:8(13!:11'')
end.
if. JFE *. connect do. initjfe'' return. end.
if. Destroy do. destroy'' return. end.
addwait SC;'';''
)
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
initjfe=: 3 : 0
s=. > coname''
input_jfe_=: ('input_',s,'_')~
output_jfe_=: ('output_',s,'_')~
JFEconnect_jws_=: 1
setimmex 'jfe_jws_ 1'
)
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
runbase=: 3 : 0
if. -. connect do. doconnect ::destroy'' return. end.
lastuse=: 6!:1''
'r w e'=. y
if. SC e. r do. readbase'' end.
if. SC e. w do. writesock'' end.
if. Destroy do. destroy'' else. addwait SC;'';'' end.
)
writesock=: 3 : 0
if. #y do. senddata=: y end.
label_a1.
if. 0=#senddata do. 0&ws_send'' end.
if. 0=#senddata do. EMPTY return. end.
'c n'=. senddata sdsend SC,0
e=. sderror c
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
  goto_a1.
end.
EMPTY
)
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
dat=. ('var_',":vdat)~
if. SNDLIM<vpos-~#dat do.
  senddata=: (0,flag*encoding) makeframe SNDLIM{.vpos}.dat
  sendframe=: (<0,vdat,SNDLIM+vpos) 0} sendframe
else.
  senddata=: (1,flag*encoding) makeframe vpos}.dat
  sendframe=: }. sendframe
  4!:55 <'var_',":vdat
end.
if. x do. writesock'' end.
)
inputj=: 0
inputbuf=: ''
cleanerror=: ]
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
wsselect=: 3 : 0
r=. runcheck sdselect Waits,<WaitTimeout
remwait r
checktermtime''
if. SC e. 1 pick r do. writesock'' end.
if. SC e. 0 pick r do. readsock'' else. 0 end.
)
LogDay=: ''
LogFile=: ''
log=: 3 : 0
if. 0=#LogFile do. return. end.
ts=. logtime''
if. -. LogDay -: 8{.ts do. logday'' end.
if. 2=#y do.
  'type text'=. y
else.
  type=. 'bad'
  text=. }. ; ',' ,each srep each boxxopen y
end.
msg=. (8}.ts),' ',type,' ',(":SC),' ',text,LF
msg 1!:3 <LogFile
)
logcmd=: 3 : 0
log 'cmd';srep y
)
logday=: 3 : 0
LogDay=: 8{.logtime''
LogFile=: LogDir,'/',LogDay,'.log'
if. fexist LogFile do. return. end.
f=. (-LogLen) }. sort {."1[ 1!:0 LogDir,'/*.log'
ferase each (LogDir,'/')&, each f
)
logerror=: 3 : 0
r=. deb y
log 'err';r
r
)
loginit=: 3 : 0
if. 0=#LogDir do. return. end.
mkdir_j_ LogDir
logday''
log 'ini';y
)
logmsg=: 3 : 0
log 'msg';":y
y
)
logres=: 3 : 0
log 'res';srep y
)
logtime=: 6!:0 bind 'YYYYMMDDhh:mm:ss.sss'
loguse=: 3 : 0
't r'=. y
log 'use';": (<. 0.5 + 1000 * t),#r
r
)
ws_onmessage=: 3 : 0
logcmd y
if. encoding=1 do.
  ws_exec_z_=. ".
  try.
    t=. 6!:1''
    r=. ws_exec__ y
    t=. t -~ 6!:1''
    if. 4!:0<'r' do. 2+ end.
    r=. loguse t;boxj2utf8 flatten r
  catch.
    r=. logerror 'could not execute: ',y
  end.
else.
  t=. 6!:1''
  r=. |. y
  t=. t -~ 6!:1''
  r=. loguse t;r
end.
ws_send r
)
