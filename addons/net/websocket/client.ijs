NB. client
NB.
NB. this script has examples of calling the J websocket server from a Jqt client.
NB.
NB. first run the server in jconsole, as:
NB.    load 'net/websocket'
NB. then:
NB.    init_jws_ 5020           NB. base server
NB. or
NB.    init_jws_ 5020 1         NB. JFE server
NB.
NB. then run this script and step through the examples in Notes.
NB.
NB. Note that in JFE mode, the first character of returned messages is result type,
NB. and 2 messages are returned - the result, and the next prompt.

Port=: 5020

NB. =========================================================
wscln_handler_z_=: 3 : 0
'event socket'=: y
res=. y;wsc0_jrx_;wsc1_jrx_
select. event
case. jws_onClose_jqtide_ do.
  smoutput 'close handler called';res
case. jws_onError_jqtide_ do.
  smoutput 'error handler called';res
case. jws_onMessage_jqtide_ do.
  wscln_handler_message socket
case. jws_onOpen_jqtide_ do.
  smoutput 'open handler called';res
case. jws_onSslError_jqtide_ do.
  smoutput 'ssl error handler called';res
case. jws_onStateChange_jqtide_ do.
  smoutput 'state change handler called';res
end.
)

NB. =========================================================
wscln_handler_message_z_=: 3 : 0
res=. wsc0_jrx_
typ=. wsc1_jrx_
if. res-:a. do. res=. 'a.' end.
if. 1e3<#res do. res=. (":#res),'$''',(20{.res),'...''' end.
smoutput 'message handler called';y;res;typ
)

NB. =========================================================
NB. close existing socket
3 : 0''
if. 0=nc <'socket' do. wd 'ws close ',socket end.
)

NB. =========================================================
NB. open socket should get 3 events:
NB. state change - connecting
NB. state change - connected
NB. open
socket=: wd 'ws connect ws://localhost:',":Port

NB. =========================================================
NB. text socket (executed in both base and jfe)
Note''
wd 'ws send ',socket,' *?~10'
wd 'ws send ',socket,' *+/\i.5'
wd 'ws send ',socket,' *''hello there'''
wd 'ws send ',socket,' *2+'
wd 'ws send ',socket,' *A=:?~5'
wd 'ws send ',socket,' *A__'
wd 'ws send ',socket,' *nc<''A__'''
wd 'ws send ',socket,' *nc<''A_z_'''
wd 'ws send ',socket,' *#''',(1e6$'hello there'),''''
wd 'ws send ',socket,' *1e6$''hello there'''
)

NB. =========================================================
NB. base only - change to binary socket (permanent for this connection)
NB. reverse message
Note''
wd 'ws sendb ',socket,' *initial message'
wd 'ws sendb ',socket,' *hello there'
wd 'ws sendb ',socket,' *',|.a.
)

NB. =========================================================
NB. JFE - change to binary socket (permanent for this connection)
NB. execute messages
Note''
wd 'ws sendb ',socket,' *?~5'
)
