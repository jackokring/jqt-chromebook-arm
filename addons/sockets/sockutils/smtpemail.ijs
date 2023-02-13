require 'sockets/socklib/sockconnxactn'
coclass 'smtp'
(copath~ ~.@(('jsocket';'jdefs')&,)@:copath) @: coname ''
require 'strings'

NB. When we call to 'getmail', we return whatever we have and
NB. start a new read if one is not running already

registerinit 0
initialize =: 3 : 0
queuedmail =: 0 5$a:
sendingmail =: 0  NB. number of mails outstanding
)

NB. Mail is host;from;to;subject;text.  If we are sending too many, queue the request for later
NB. RC is always 0; errors are asynchronous
NB. smtpmail 'smtp-server.nc.rr.com';'glasstrade@nc.rr.com';'9196969551@vtext.com';'Subj';'text'
NB. smtpmail 'smtp.aol.com';('quizbw@aol.com' ,&((0{a.)&,) 'Thespian2');'9196969551@vtext.com';'Subj';'text'
smtpmail =: 3 : 0"1
'domain from to subject text' =. y
if. sendingmail = 4 do.  NB. This is where we set the limit on mail
  queuedmail =: queuedmail , y
else.
NB. connect to SMTP server.
NB. (kludge) if from starts with NUL, it's uid/password, and we use SMTPE on port 587
  sendingmail =: >: sendingmail  NB. Do this before call, because the callback may fire immediately
  sk =. conew 'sockconnxactn'
  NB. kludge for timeout value
  NB. Send    addr port senddata callbackx callback to delim.  No initial send data.  Translate domain name
  NB. Use SMTP port if no password, or SUBMIT port if password given
  NB. But if the domain is GoDaddy, use the special GoDaddy port number
  port =. 25 587 {~ (0{a.) = {. from
  if. domain -: 'smtpout.secureserver.net' do. port =. 3535 end.
  #r =. create__sk (<domain);port;'';(0;from;to;subject;text);(inthislocale 'getmailcb');60;CRLF
end.
0
)

NB. y is 1 if error, 0 if good
finsendmail =: 3 : 0
'' finsendmail y
:
NB. obsolete smoutput 'finsendmail time=', (":tod NIL) 
sendingmail =: 0 >. <: sendingmail
if. y do.
  (5!:5 <'x') logerror 'Error %j sending SMTP mail' sprintf < 5!:5 <'x'
smoutput x
  smtperror_debug_ =: x
end.
if. #queuedmail do.
  smtpmail {. queuedmail
  queuedmail =: }. queuedmail
end.
$0
)

NB. x is state;data
NB. Negative states are the initial handshake; positive are message-reading states
NB. y is rc;data
NB. If rc is nonzero, we are done; otherwise process the state
NB. Result is empty list if we are done; otherwise
NB.   new callback x;new callback;new send data;new delim
getmailcb =: 4 : 0
'rc data' =. y
if. rc do. (y,&<x) finsendmail 1 return. end.
smtprc =. 999 ". 3 {. data
select. >{.x  NB. At the end of this we have the return result
case. 0 do.
  if. (0{a.) = {. 1{::x do.  NB. ESMTP
    ((<1) 0} x) ; (inthislocale 'getmailcb') ; ('EHLO ',('milton.mail.com'),CR,LF) ; <<inthislocale 'delimSMTP'
  else.  NB. old-fashioned SMTP
    ((<10) 0} x) ; (inthislocale 'getmailcb') ; ('HELO ',('@' takeafter 1{::x),CR,LF) ; (CR,LF)
  end.
case. 1 do.   NB. Must be response to EHLO.  Send AUTH
    ((10;(0{a.) taketo }. 1{::x) 0 1} x) ; (inthislocale 'getmailcb') ; ('AUTH PLAIN ',(base64 1{::x),CR,LF) ; (CR,LF)
case. 10 do.
  if. smtprc -.@e. 235 250 do. (10;smtprc;data) finsendmail 1 return. end.
  ((<11) 0} x) ; (inthislocale 'getmailcb') ; ('MAIL FROM:<',(1{::x),'>',CR,LF) ; (CR,LF)
case. 11 do.
  if. smtprc ~: 250 do. (11;smtprc;data) finsendmail 1 return. end.
  ((<12) 0} x) ; (inthislocale 'getmailcb') ; ('RCPT TO:<',(2{::x),'>',CR,LF) ; (CR,LF)
case. 12 do.
  if. smtprc ~: 250 do. 12 finsendmail 1 return. end.
  ((<13) 0} x) ; (inthislocale 'getmailcb') ; ('DATA',CR,LF) ; (CR,LF)
case. 13 do.
  if. smtprc ~: 354 do. 13 finsendmail 1 return. end.
NB. obsolete smoutput 'Mail text:',formatformail 1 2 3 4{x
  (14) ; (inthislocale 'getmailcb') ; (formatformail 1 2 3 4{x) ; (CR,LF)
case. 14 do.  
  if. smtprc ~: 250 do. 14 finsendmail 1 return. end.
  (15) ; (inthislocale 'getmailcb') ; ('QUIT',CR,LF) ; ('')
case. do. NB. Any other (must be state 6), stop
  finsendmail 0
  ''   NB. empty return means end the connection
end.
)

NB. check for delimiter: msg must be ddd,' ' before next-last CRLF
NB. Return the number of bytes in the delimited message
delimSMTP =: 3 : 0
if. CRLF -.@-: _2 {. y do. 0 return end.
(#y) * ' ' = 3 { 4 {.!.'x' ({.~ i.&LF)&.|. }: y
)

publishentrypoints 'smtpmail'