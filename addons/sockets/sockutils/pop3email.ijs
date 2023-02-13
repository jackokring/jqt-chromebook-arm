require 'sockets/socklib/sockconnxactn'
coclass 'pop3'
(copath~ ~.@(('jsocket';'jdefs')&,)@:copath) @: coname ''
require 'strings'

NB. When we call to 'getmail', we return whatever we have and
NB. start a new read if one is not running already

registerinit 0
initialize =: 3 : 0
mailbox =: 0 7$a:
readingmail =: 0
)

getmail =: 3 : 0"1
'domain user pass' =. y
if. -. readingmail do.
  readingmail =: 1  NB. Do this before call, because the callback may fire immediately
  sk =. conew 'sockconnxactn'
  NB. kludge for timeout value
  NB. Send    addr port senddata callbackx callback to delim.  Translate host addr
  #r =. create__sk (<domain);110;'';(_10;user;pass);(inthislocale 'getmailcb');10;CRLF
end.
if. #mailbox do.
  NB. obsolete display mailbox
end.
mailbox
if. mailbox =: 0 7$a: do. end.
)

fingetmail =: 3 : 0
readingmail =: 0
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
if. rc do. fingetmail'' return. end.
if. -. '+OK' -: 3 {. data do. ('getmail error in state %j\n' printf >{.x) ] fingetmail'' return. else. data =. 4 }. data end.
select. >{.x  NB. At the end of this we have the return result
case. _10 do.
  ((<_9) 0} x) ; (inthislocale 'getmailcb') ; ('USER ',(1{::x),CR,LF) ; (CR,LF)
case. _9 do.
  (_8) ; (inthislocale 'getmailcb') ; ('PASS ',(2{::x),CR,LF) ; (CR,LF)
case. _8 do.
  (_7) ; (inthislocale 'getmailcb') ; ('STAT ',CR,LF) ; (CR,LF)
fcase. _7 do.
  if. nmsgs =. 0 ". ' ' taketo data do.
  else. fingetmail'' return. end.
  x =. 1,1,nmsgs
case. 1 do.  NB. first read-message state.  Send RETR
  (2,}.x) ; (inthislocale 'getmailcb') ; ('RETR ',(":1{x),CR,LF) ; (CR,LF,'.',CR,LF)
case. 2 do.  NB. Second read-message state.  Handle the message, then DELE it
  txt =. (CR,LF) takeafter data
  hdr =. ,&(CR,LF)@((CR,LF,CR,LF)&taketo) txt
  from =. (CR,LF)&taketo@('From: '&takeafter) txt
  sender =. '<'&taketo from
  if. 0 = #sendaddr =. '<'&takeafter@('>'&taketo) from do. sendaddr =. sender end.
  subj =. (CR,LF)&taketo@('Subject: '&takeafter) hdr
  body =. (CR,LF,CR,LF)&takeafter txt
  NB. Remove doubled leading '.', and final '.CRLF'
  body =. _3&}.@(#~ -.@(_2&|.)@((CR,LF,'..')&E.))&.((CR,LF)&,) body
  NB. Append time and attachments
  mailbox =: mailbox , '' ; sender ; sendaddr ; subj ; body ; 0 ; ''
  NB. DELE the message; if there are more, return to state 1, else state 0 to QUIT
  (x + (_1 - =/}.x),1 0) ; (inthislocale 'getmailcb') ; ('DELE ',(":1{x),CR,LF) ; (CR,LF)
case. 0 do.  NB. End of messages.  Send QUIT, wait for connection to close
  (3) ; (inthislocale 'getmailcb') ; ('QUIT',CR,LF) ; ('')
case. do. NB. Any other (must be state 3), stop
  fingetmail''
end.
)

publishentrypoints 'getmail'