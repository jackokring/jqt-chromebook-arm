NB. Listen on a TCP address
NB. When a connection arrives, we create an object in the given class
NB. This returns a listener object which should be freed by the caller
require 'sockets/socklib/sockmux'
coclass 'socklistener'
coinsert 'sockmux'

NB. Create socket. y is socket info:
NB. port; callback x/cloneinfo; callback
NB. Return 0 if successful
NB. The callback, if not empty, is the routine to call when a connection is made.  We pass
NB. the callback x to it.
NB. The callback needs to return cloneinfo, which is cloneclass;parms to create for class
NB. An object of the given class is created for the transaction.
NB. If the callback is empty, the callbackx data is simply used as the cloneinfo.
create =: 3 : 0
'port cloneinfo callback' =: y default '';'';''
if. 0 ~: r =. create_sockmux_ f. 0 0 do. r return. end.
NB. Set the REUSEADDR attribute to ensure we sieze the port if it is in use
if. 0 ~: r =. sdsetsockopt_jsocket_ sock;SOL_SOCKET_jsocket_;SO_REUSEADDR_jsocket_;2-1 do. r return. end.
NB. Take control of the port
if. 0 ~: r =. sdbind_jsocket_ sock;AF_INET_jsocket_;'';port do. r return. end.
NB. Listen on the socket
if. 0 ~: r =. sdlisten_jsocket_ sock,100 do. r return. end.
NB. Now we wait for connections
0
)

destroy =: 3 : 0
destroy_sockmux_ f. ''
)

errhand =: 3 : 0
smoutput 'Error ' , (":y) , ' in listener!'
0
)

NB. Check timeout.  Current time is in y.  If time has expired, signal ETIMEDOUT
NB. We just listen forever, no timeout
checkto =: 3 : 0
''
)

NB. send handler.  Called when our socket is allowed to send.  Should happen only during create
send =: 3 : 0
0  NB. In case this happens, take us off the writable list
)

NB. recv handler.  Called when there is data for our socket.  For this listening
NB. socket, it ms mean a connection happened, and we just accept the connection
NB. and then use that clone socket to start a new async connection.  This connection
NB. will destroy itself when the connection is finished.
recv =: 3 : 0
NB. Create the clone socket
if. 0 = 0 {:: 'r c' =. sdaccept_jsocket_ sock do.
  NB. We have created the socket (c).  If there is a callback, call it now; it will reply
  NB. with the class and parms to create.  In any case, create an object for the conversation
  if. #callback do. cloneinfo =: cloneinfo callback~ c end.
  o =. conew > {. cloneinfo
  c create__o }. cloneinfo
else.
  smoutput 'Error ' , (":r) , ' in  accept!'
end.
''
)
