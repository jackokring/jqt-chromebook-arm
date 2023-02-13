NB. Transactions that connect to an address using TCP, send, and listen
NB. These xactns use the async socket mux for async operation; not otherwise
NB. No object is returned: if this is async, this object destroys itself after
NB. the callback; if sync, it destroys itself before returning this data
require 'sockets/socklib/sockmux'
coclass 'sockconnxactn'
coinsert 'sockmux'
DEBUGSYNC =: 0  NB. Set to display sync xactn
NB. Create socket. y is socket info:
NB. address/sock; port (numeric); data; callback x; callback; timeout[,debug][; delimiter]
NB. If there is no callback, we do synchronous transfer
NB. Return empty if async sfer (it will finish on its own)
NB. If sync xfer, return rc ; data
NB. If port number is negative, that means that a connection has already
NB. been established, and addr is the socket number.  We don't need to
NB. connect in this case, just do data-transfer (async only)
NB. If the port number is a boxed list, that means that there was an error
NB. somewhere upstream, and we are going through here only to keep to the
NB. callback protocol.  Just return the 'port number' as the rc;data to the callback
NB. If addr is boxed, it is a domain name and we look it up here
NB. If x is given, it is the clone socket number, and we
NB. replace addr;port with sock;_1
create =: 3 : 0
NB. Save the parameters before creating the socket, in case it's an aync socket and
NB. we do all the data-transfer there
'addr port senddata callbackx callbackv to delim' =: y default '';'';'';'';'';0;''
'to debugconn' =: to default 10 0
recvdata =: ''
NB. The activity flag is set when we have socket activity, and cleared in the timeout.
NB. After a period of inactivity, we time out the socket
commactive =: 1
NB. Convert domain name to IP address.  If xlation fails, force us through the error path
NB. Save the initial domain, if any
if. (32 = 3!:0 addr) *. (32 ~: 3!:0 port) do.
  NB. If the domainname contained a port number, use it to override the port number given
  domainname =: ({.~  i.&':')&.> addr
  if. domainname ~:&(#@>) addr do.
    port =: 0 ". (>: #>domainname) }. > addr
  end.
  NB. Note that we must call gethostbyname in _sockmux_ directly.  If we call it in this locale
  NB. it will be found without a locale switch, and the translation will be saved in this locale
  NB. where it will be unavailable for others
  if. 0 ~: 0 {:: h=. gethostbyname_sockmux_ >domainname do. port =: 0 2 { h
  elseif. '255.255.255.255' -: 2 {:: h do. port =: (<553) 0} 0 2 { h
  elseif. do. addr =. 2 {:: h
  end.
else.
  domainname =: ''
end.

NB. debug smoutput 'time=', (":tod NIL) , ' timeout=',":to
NB. Create a socket and start the connection.  If the transfer is synchronous, this will transfer all
NB. the data and return what was read (and the object will have been destroyed).
NB. If asynchronous, the return is immaterial
NB.?lintonly 'sock errto recvdata' =: 0;0;''
if. *#callbackv do.
  if. 32 = 3!:0 port do. callbackx callbackv~ port [ r =. 0  NB. If forced error, drive callback
  elseif. port < 0 do.
    NB. Here for clone sockets, which already exist
    if. 0 ~: r =. addr create_sockmux_ f. (to + todsts NIL) , *#senddata do. errhand r end.
  elseif. 0 ~: r =. create_sockmux_ f. (to + todsts NIL) , *#senddata do. errhand r
  elseif. 0 10035 -.@e.~ r =. > {. sdconnect_jsocket_ sock;AF_INET_jsocket_;addr;port do.
    errhand r
  end.
  if. debugconn do. smoutput 'Connect (',(":sock),') to ' , addr , ':' , (":port) , ' rc=',(":r) end.
  ''   NB. Return empty if the operation is asynchronous
else.
  NB. Here the transfer is synchronous.  Handle it directly
  if. 32 = 3!:0 port do. 'rc recvdata' =. 2 {. port
  elseif. 0 = rc =. 0 {:: 'r s' =. sdsocket_jsocket_ ($0) do.
    if. 0 do. NB. if. 0 ~: > {. sdioctl_jsocket_ s,FIONBIO_jsocket_,1 do. rc =. 10038
    elseif.
    if. DEBUGSYNC do. smoutput 'Connect to ',addr,':',": port end.
    sdconnect_jsocket_ s;AF_INET_jsocket_;addr;port  NB. Start the connection
    0 ~: 0 {:: 'v r w e' =. sdselect_jsocket_ ($0);s;($0);1000*to
    do.
      rc =. 10038
      if. #domainname do. purgexlatecache_sockmux_ domainname end.
    elseif. s -.@e. w do. rc =. 10060
    elseif.
      if. DEBUGSYNC do. smoutput 'HTTP request: ',CRLF,senddata end.
      while. #senddata do.
        if. 0 ~: 0 {:: 'r l' =. senddata sdsend_jsocket_ s,0 do. break. end.
        senddata =: l }. senddata   NB. slow but rare
      end.
      #senddata
      do. rc =. r
    elseif. do.
      NB. Now, read the response until the socket is closed.
      NB. If we time out, return whatever we have
      whilst. #rd do.
        if. 0 ~: 0 {:: 'v r w e' =. sdselect_jsocket_ s;($0);($0);1000*to do. rc =. 10038 break. end.
        if. s -.@e. r do. rc =. 10060 break. end.
        if. 0 ~: 0 {:: 'v rd' =. sdrecv_jsocket_ s,10240 0 do. rc =. v break. end.
        if. DEBUGSYNC do. smoutput 'recv ' , ": # rd end.
        recvdata =: recvdata , rd
      end.
    end.
    NB. Now rc has the error code if any
    sdclose_jsocket_ s
  end.
  NB. rc and recvdata are set
  codestroy ''
  rc;recvdata   NB. Return data (if any) and retcode for sync xactn
end.
:
NB. dyadic case - x is clone socket, ignore addr/port
create (x;_1) 0 1} y
)

NB. Destroy is handled in sockmux, since we don't have any private resources

NB. Drive the callback.  y is the return code to append to the data, and
NB. we return the value from the callback, which may contain continuation
callback =: 4 : 0
if. debugconn do. smoutput 'Callback (',(":sock),') rc=' , (":y) end.
callbackx ((,&'_base_'^:('_'&~:@{:@])) callbackv)~   y ; x
)

destroy =: 3 : 0
destroy_sockmux_ f. ''
)

NB. Handle error.  We destroy the socket first, in case there is an error
NB. in the callback
errhand =: 3 : 0
NB. If we died sending, we may have a bad address translation - purge it
if. #senddata do.
  if. #domainname do. purgexlatecache_sockmux_ domainname end.
NB. obsolete     smoutput (disphms todhms NIL), ' timeout holding send buffer: ',senddata
end.
destroy''
recvdata callback y
)

NB. Check timeout.  Current time is in y.  If time has expired, signal ETIMEDOUT
checkto =: 3 : 0
NB. If we have had socket activity, extend the timeout period
if. commactive do.
  errto =: to + y
  commactive =: 0
end.
NB. After a period of inactivity, pull the plug
if. y >!.0 errto do.
  if. #recvdata do. smoutput (disphms todhms NIL), ' timeout holding recv buffer: ',recvdata end.
  'r d' =. sdrecv_jsocket_ sock,100,0
  if. #d do. smoutput (disphms todhms NIL), ' timeout holding unread data: ',d end.
  errhand 10060
end.
''
)

NB. send handler.  Called by sockmux (with empty y) when our socket is allowed to send.  We send senddata until
NB. it's all been sent.  Result is _1 0 1 to indicate (error-socket closed)/(send finished)/(more to send)
send =: 3 : 0
if. debugconn do. smoutput 'Call to send (',(":sock),') #senddata=',(":#senddata) end.
if. #senddata do.
  'r l' =. senddata sdsend_jsocket_ sock,0
  if. r do.
    errhand r
    _1 return.
  else.
    commactive =: 1  NB. Indicate something happened
    if. debugconn do. smoutput 'Sent (',(":sock),'):',(l{.senddata),':' end.
    senddata =: l }. senddata
  end.
end.
*#senddata
)

NB. Append data to the send buffer, and jab the sender
addtosend =: 3 : 0
senddata =: senddata , y
reqwrite''
)

NB. recv handler.  Called when there is data for our socket.  We read what is
NB. available; if we get all the data, or there is an error, or we match a
NB. delimiter, we drive the callback.  If there is a return from the callback
NB. that indicates that we should continue, append any new data to the
NB. outbound queue and kick that queue.  If the return does not call for continuation,
NB. destroy our object & be finished.
recv =: 3 : 0
NB. Read the data.  We have 4 ways to terminate a read:
NB. 0. read until close (delim is empty string)
NB. 1. read until a string is found (delim is the string, usually CRLF).  To save
NB.   searching the data we check only the end of the receive message for the
NB.   delimiter, since that's how SMTP works
NB. 2. read until a specific number of bytes are read (delim is numeric)
NB. 3. user-coded delimiter (delim is boxed and is a gerund)
NB. To avoid having to loop through multiple commands, in case 2 we limit
NB. the amount of data we read to the amount requested by the delimiter
if. (*#delim) *. 1 4 8 e.~ 3!:0 delim do. lentord =. delim - #recvdata else. lentord =. 30000 end.
'r d' =. sdrecv_jsocket_ sock,lentord,0
NB. If there is no data, that's a should-not-occur.  Dump some info
if. 10035 = r do.
NB. obsolete   smoutput 'EWOULDBLOCK on read to socket ' , (": sock) , ' length ' , (": lentord)
NB. obsolete   qprintf 'handlerlog_sockmux_ '
  '' return.  NB. we should never have been called
end.
commactive =: 1   NB. we have found data
NB. Append to our inbound data buffer
recvdata =: recvdata , d
if. debugconn do. smoutput 'Rcvd (',(":sock),'):',(d),':',' (',(":a. i. _2 {. d),')' end.
NB. If we have received a complete message, return it to the user
if. (r~:0) +. (0=#d) do.
  NB. buffsizedebug NB. if there is a previous fragment, flag this fragment as last and log it out
  NB. buffsizedebug if.   (0=#d) *. (*#recvdata) *. (0=#delim) do.
  NB. buffsizedebug   readresultlog_sockmux_   =: (0 2 0 0 + sockrcd) (readresultlastwrx_sockmux_   =: (#readresultlog_sockmux_) | >: readresultlastwrx_sockmux_)} readresultlog_sockmux_
  NB. buffsizedebug end.
  NB. If the other end closes while we have outbound data, that's an error
  if. (r=0) *. (0=#d) *. (0~:#senddata) do. r =. 10099 end.
  NB. Error or connection closed: end the conversation
  errhand r
elseif. 0 = #delim do.
  NB. undelimited message not at close: do nothing, wait for more data
  NB. buffsizedebug NB. If this is not the first read, write out the info for the previous read; then create info for this read, which will be written
  NB. buffsizedebug NB. when the next read completes (at which time we will have the last flag for the fragment)
  NB. buffsizedebug if.   -. first   =. (d =&# recvdata) do.
  NB. buffsizedebug   readresultlog_sockmux_   =: sockrcd (readresultlastwrx_sockmux_   =: (#readresultlog_sockmux_) | >: readresultlastwrx_sockmux_)} readresultlog_sockmux_
  NB. buffsizedebug end.
  NB. buffsizedebug sockrcd   =: sock,first,lentord,#d
elseif. do.
  NB. Delimited message(s).  See if the delimiter is present
  whilst. #recvdata do.
    select. 3!:0 delim
    case. 2 do.
      dp =. delim (#@] (>: * ]) #@[ + i.&1@:E.) recvdata  NB. string delimiter: look for match, 0 if none
    case. 1;4;8 do.
      dp =. delim ([ * <:) #recvdata  NB. numeric delim: check length
    case. 32 do.
      dp =. delim `: 6 recvdata
    NB.?lintonly case. do. dp  =. 0
    end.
    if. 0=dp do. break. end.  NB. if delimiter not found, exit loop
    NB. Delimiter is present.  dp is the length of the msg.  Drive the callback
    if. #dret =. (dp {. recvdata) callback r do.
      NB. callback requests continuation: append any new data to the send queue, clear recv buffer
      recvdata =: dp }. recvdata
      'callbackx callbackv newdata delim' =: dret
      if. #newdata do. addtosend newdata end.
    else. destroy'' break. NB. no continuation, we are through
    end.
  end.   NB. loop back if there is more data
end.
0
)
