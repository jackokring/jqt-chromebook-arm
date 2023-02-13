NB. base

SK=: SC=: 0

JFEconnect=: 0
Protocols=: ;: 'binary'
RestartMsg=: 'server halted - restart by running: restart'''''

NB. =========================================================
accept=: 3 : 0
addwait SK;'';''
'rc sc'=. sdaccept SK
if. rc=0 do. sc conew 'jws' end.
)

NB. =========================================================
addserver=: 3 : 0
log__y 'add';y
servers_jws_=: servers,y
sockets_jws_=: sockets,SC__y
addwait SC__y;'';''
)

NB. =========================================================
addwait=: 3 : 0
empty Waits_jws_=: ~.each Waits,each y
)

NB. =========================================================
endclient=: 3 : 0
if. -. x e. sockets do. return. end.
loc=. (sockets i. x){servers
destroy__loc''
)

NB. =========================================================
endserver=: 3 : 0
locs=. servers intersect conl 1
for_loc. locs do. destroy__loc'' end.
sdclose SK
log 'end';''
2!:55''
)

shutdown=: endserver

NB. =========================================================
NB. init port [,jfe]
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

NB. =========================================================
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

NB. =========================================================
interrupt=: 3 : 0
if. JFE do.
  stopjfe''
  smoutput RestartMsg
else.
  0$loop=: 0
end.
)

NB. =========================================================
removeserver=: 3 : 0
log__y 'rem';y
b=. servers~:y
servers_jws_=: b#servers
sockets_jws_=: b#sockets
Waits_jws_=: Waits intersect each <SK,sockets
)

NB. =========================================================
remwait=: 3 : 0
Waits_jws_=: Waits -. each y
)

NB. =========================================================
restart=: 3 : 0
if. -. restartjfe'' do.
  startbase''
end.
EMPTY
)

NB. =========================================================
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

NB. =========================================================
NB. check sdselect result
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

NB. =========================================================
startbase=: 3 : 0
setimmex 'initrun_jws_ 0'
)

NB. =========================================================
stopjfe=: 3 : 0
input_jfe_=: output_jfe_=: empty
jfe 0
JFEconnect_jws_=: 0
)
