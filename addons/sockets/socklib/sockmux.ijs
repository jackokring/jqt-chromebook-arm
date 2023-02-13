NB. Asynchronous socket multiplexer
require 'misc/miscutils/utils'
require 'sockets/socklib/loadmeter'
coclass 'sockmux'
require 'socket'

NB. This module includes the async socket handler.  All async socket ops
NB. come through here to create a socket object.  We open the socket and
NB. add it to our list.
NB.
NB. When a socket in this list becomes readable or writable, we call the
NB. recv or send entry point in the object.
NB.
NB. The entry point socket_checktimeout calls checkto for each object.
NB. The error handler must destroy the socket object.
NB.
NB. The entry point socket_listsockets returns our list of socket numbers
NB.
NB. The entry point reqwrite indicates that the socket has data to send.
NB. Sockets are created writable and become unwritable when their send says it sent nothing.
NB.

NB. support for finding the correct read length
NB. (>: readresultlastwrx_sockmux_) |. readresultlog_sockmux_
readresultlog   =: 32 4 $ 2  NB. socket, (". last,first flags), maxlen, actlen
readresultlastwrx   =: 0   NB. last location filled
NB. Initialize the globals for async connections
registerinit 0
initialize =: 3 : 0
NB. List of address translations
purgexlatecache ''
NB. This is our emergency table of translations, in case the DNS is unavailable
hardwiredaddrs =: ,: 'www.quizbowlmanager.com';'184.73.8.133'
NB. List of writable sockets
wsocklist =: 0$0
NB. List of sockets we own
socklist =: 0$0
NB. List of socket objects corresponding to those sockets
sockobj =: 0$a:
if. ifdefined 'interrupt_entry' do. else. interrupt_entry =: interrupt_exit =: ] end.
NB. Count of interrupts to assist in debugging socket errors
interruptcount=: 0
NB. time history for calculating load
loadmeterinit ''
NILRET
)

NB. **** Verbs in the object locale ****

NB. Create async socket object and mark it asynchronous and writable
NB. Returns 0 if successful, 1 if failed
NB. y is (timeout time)
NB. x, if given, is the socket number to use (it is being given to us to own, probably
NB. because it was created as a clone socket)
create =: 3 : 0
NB. Monad: create the socket
if. 0 ~: 0 {:: 'r s' =. sdsocket_jsocket_ ($0) do.
  sock =: 0    NB. Indicate no socket
  10038   NB. Signal create failure
else.
  s create_sockmux_ f. y
end.
:
NB. Dyad: x is the socket
'errto writable' =: y , (#y) }. 0 1
if. {. sdasync_jsocket_ x do.
  sdclose_jsocket_ x
  sock =: 0    NB. Indicate no socket; unable to make async
  10038   NB. Signal create failure
elseif. do.
  NB. Socket was created.  Add it and the object to the socket list, and to the writable list
  socklist_sockmux_ =: socklist_sockmux_ , sock =: x
  sockobj_sockmux_ =: sockobj_sockmux_ , coname''
  NB. Start sending anything we have to send, and make socket writable if there is unsent data
  if. writable do. wsocklist_sockmux_ =: wsocklist_sockmux_ , x end.
NB. debug handlerlog_sockmux_   =: handlerlog_sockmux_ ,~ 'create' ; (6!:0 '') ; sock ; (coname'')
  0
end.
)

NB. Destroy socket object. The only thing we allocated is the socket
destroy =: 3 : 0
if. sock do. sdclose_jsocket_ sock end.  NB. Don't try to close if error creating
NB. Remove the socket from the lists of eligibles
wsocklist_sockmux_ =: wsocklist_sockmux_ -. sock
keepsockmask =. socklist_sockmux_ ~: sock
socklist_sockmux_ =: keepsockmask # socklist_sockmux_
sockobj_sockmux_ =: keepsockmask # sockobj_sockmux_
NB. debug handlerlog_sockmux_   =: handlerlog_sockmux_ ,~ 'destroy' ; (6!:0 '') ; sock ; (coname'')
codestroy''
)

NB. The current object has received new data to write.  Send it, and add to writable
NB. list if there is more to send.  If no more, remove from writable
reqwrite =: 3 : 0
NB.?lintonly send =: 1:
wsocklist_sockmux_ =: wsocklist_sockmux_ -.`,`-.@.(send'') sock
NILRET
)

NB. **** below here runs in the sockmux locale ****

NB. Nilad, return socket list
socket_listsockets =: 3 : 0
socklist
)

NB. Nilad.  sockets that have exceeded their timeout value are processed through the
NB. callback with a TIMEOUT return
socket_checktimeout =: 3 : 0
NB. Since we sometimes seem to drop an interrupt on the listening
NB. socket, kick the socket handler before we claim a timeout, just in case
socket_handler 'checkto'
cktime =. todsts NIL
for_l. sockobj do.
  NB.?lintonly l =. <'sockconnxactn'
  checkto__l cktime
end. 
)

socket_handler =: 3 : 0
startsec =. {: tod NIL
NB. Signal interrupt entry so any error will be trapped properly
interrupt_entry NIL
interruptcount =: >: interruptcount
NB. Get status for all of our sockets - if there are any; if not, skip the work (should not occur)
if. #socklist do. 's r w e' =. sdselect_jsocket_ socklist;wsocklist;socklist;0 else. r =. w =. e =. $0 end.
NB. If there are errors, they are connections that didn't make it.  Process them through the error handler
if. #e do.
  for_l. sockobj {~ socklist i. e do.
    NB.?lintonly l =. <'sockconnxactn'
    err =. '' $ 4 {:: getsockoptJ_jsocket_ sock__l;SOL_SOCKET_jdefs_;SO_ERROR_jdefs_;(,_1);,4
    NB. The usual error is connection timeout or conn refused; warn on others
    if. -. err e. 10060 10061 do. smoutput 'Connection error: ' , ":err end.
    errhand__l err
  end.
  NB. Since we drove the error handler, and it drove the user callbacks AFTER destroying the socket, we
  NB. can't use the results of the previous select, since a socket number may have been reallocated.
  NB. So, remove any failing sockets from the readable and writable lists
  'r w' =. -.&e&.> r;w
end.
NB. If sockets have become writable, try sending
if. #w do.
  NB. presumptively remove the writable sockets from the writable list, since most of our replies go out in one send
  wsocklist =: wsocklist -. w
  for_l. sockobj {~ socklist i. w do.
    NB.?lintonly l =. <'sockconnxactn'
    select. send__l ''
    case. 1 do.
      NB. more data to send: return socket to writable list
      wsocklist =: wsocklist , sock__l
    case. _1 do.
      NB. socket failed; remove from readable list, since the socket number may have been reassigned
      NB. The locale has disappeared, so we must recover the socket number from w
      r =. r -. l_index { w
    NB. if socket is still writable, do nothing
    end.
  end.
end.
NB. Read from readable sockets
for_l. sockobj {~ socklist i. r do.
  NB.?lintonly l =. <'sockconnxactn'
  recv__l ''
end.

interrupt_exit NIL
NB. add the time spent in this interrupt to the load history
loadmeteradd startsec , {: tod NIL
)

NB. ******************** utility verb **********************
NB. We seem to get addr-xlate failures from time to time, so here we save the recent hits
NB. and use them if a translation fails.
NB. This MUST be called in sockmux locale, so if sockmux is in the path, it must be called
NB. explicitly
gethostbyname =: 3 : 0
NB. If we have a previous translation, use that.  That will include an emergency translation if the DNS is down.  Add TTL here?
h =. 0 ; AF_INET_jsocket_ ; ((1 {"1 xlatecache) , <'255.255.255.255') {~ (0 {"1 xlatecache) i. (<y)
NB. If we don't have a translation, look it up
NB. obsolete if. '255.255.255.255' -.@-: 2 {:: h do. h return. end.
if. ('10.0.0.1';'255.255.255.255') -.@e.~ 2 { h do. h return. end.
NB. Fall through to do the translation.  kludge in that a bad lookup will never be purged.  But being dependent on
NB. a bad DNS is worse
h =. sdgethostbyname_jsocket_ y
NB. If it STILL failed, use our private cache of addresses.  This would mean that the DNS has crashed
if. '255.255.255.255' -: 2 {:: h do.
  h =. 0 ; AF_INET_jsocket_ ; ((1 {"1 hardwiredaddrs) , <'255.255.255.255') {~ (0 {"1 hardwiredaddrs) i. (<y)
end.
if.
  if. -. fail =. (0 ~: 0 {:: h) do. fail =. '255.255.255.255' -: 2 {:: h end.
-. fail do.
  NB. success; remember the translation in case of failure.  This way we will consult a failed DNS only once
  if. (<y) e. 0 {"1 xlatecache do. xlatecache =: (2 { h) (<((0 {"1 xlatecache) i. (<y));1)} xlatecache
  else. xlatecache =: xlatecache , y ; 2{h
  end.
end.
h
)

NB. Call here when there is a connection failure - to purge our address cache
NB. y, if given, is the name(s) to purge
NB. This must be called in the sockmux locale
purgexlatecache =: 3 : 0
if. #y do.
  xlatecache =: (-. (0 {"1 xlatecache) e. boxopen y) # xlatecache
else.
NB. If y is empty, purge the whole cache (also used for initialization)
  xlatecache =: 0 2$a:
end.
NILRET
)

publishentrypoints 'socket_checktimeout socket_handler socket_listsockets gethostbyname'
