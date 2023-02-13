require 'sockets/socklib/sockconnxactn'
coclass 'textmsgvz'
(copath~ ~.@(('jsocket';'jdefs';'jgl2')&,)@:copath) @: coname ''

loginhiddenfields =: < ;._1 ;._2 (0 : 0)
 realm vzw
 gx_text UTF-8
 goto https://text.vzw.com:443/customer_site/secure/jsp/messaging_li.jsp
 gotoOnFail https://text.vzw.com:443/customer_site/jsp/login.jsp
 IDToken1 9196969551
 IDToken2 mary6279
 login Login
)
sendhiddenfields =: < ;._1 ;._2 (0 : 0)
 trackResponses No
 Send.x Yes
 translatorButton
 showgroup n
 DOMAIN_NAME @vtext.com
)

NB. Send a message.  x is (list of) boxed numbers to send to
NB. y is subject;text;replyaddr;callback;priority;retry count
NB. (,<'9196969551') sendtxtmsg 'Subj';'text';'';'';0
NB. **** This is not debugged, as txt2day seems to work ****
sendtxtmsg =: 4 : 0
sendfields =. loginhiddenfields
cbp =. (,<,<'') , (x,&<y) ; (inthislocale 'sendtxtmsg_reply1')  NB. default timeout
( cbp;'login.verizonwireless.com:443';'/amserver/UI/Login' ) webpostform afterconnecting sendfields

NILRET
)
sendtxtmsg2 =: 4 : 0"1
if. 0 ~: #x do.
  NB. Extract inputs, with default
  'sub txt rep cbk pri rct' =. y =. y default '';'';'';'';0;0
  pri =. ": pri

  recips =. ; }: , (,"0&(<',')) boxopen x
  sendfields =. sendhiddenfields , ('min';'text';'sender';'callback';'type';'subject') ,. recips;txt;rep;cbk;pri;'M'
  sendfields =. sendfields , 'disclaimer_submit';''
  cbp =. (,<,<'') , (x,&<y) ; (inthislocale 'sendtxtmsg_reply1')  NB. default timeout
  ( cbp;'text.vzw.com:443';'/customer_site/jsp/messaging_lo.jsp' ) webpostform afterconnecting sendfields
end.

NILRET
)

sendtxtmsg_reply1 =: 4 : 0
RPLX__   =: x
RPLY__   =: y
return.
if. 10054 = 0{::y do.
  if. 3 < rct =. (1;5) {:: x do.
    logerror 'abandoning text message'
  else.
    logerror 'retrying text message'
    (sendtxtmsg >:&.> onitemm 5)&>/ x
  end.
else.
  txt =. striphttp 1{::y
  if. -. 'STATUS_MSGID' isinstring 1{::txt do.
    if. 302 ~: 0 {:: txt do.
      ('RC=%d, TEXT=%s\n' sprintf 2 {. y) logerror 'Error sending text message'
    else.
      redirecttextmsg_debug_ =: y
      url =. 'http://' takeafter LF taketo 'Location:' takeafter 2{::txt
      'x yy' =. x
      'sub txt rep cbk pri rct' =. yy
      pri =. ": pri
      domain =. '/' taketo url
      page =. '/' dropto url
      recips =. ; }: , (,"0&(<',')) boxopen x
      sendfields =. sendhiddenfields , ('min';'subject';'text';'sender';'callback';'type') ,. recips;sub;txt;rep;cbk;pri
      sendfields =. sendfields , 'disclaimer_submit';''
      cbp =. (,<,<'') , (x,&<yy) ; (inthislocale 'sendtxtmsg_reply1')  NB. default timeout
      ( cbp;domain;page ) webpostform afterconnecting sendfields
      ('RC=%d, TEXT=%s\n' sprintf 2 {. y) logerror 'Text message redirected by Verizon'
    end.
  end.
end.
NILRET
)
sendtxtmsg_reply2 =: 4 : 0
  if. 0 ~: 0 {:: txt =. striphttp 1{::y do.
    ('RC=%d, TEXT=%s\n' sprintf 2 {. y) logerror 'Error sending text message'
  else.
    ('RC=%d, TEXT=%s\n' sprintf 2 {. y) logerrorquietly 'Response to redirected text message'
  end.
NILRET
)


NB.  Code for txt2txt -----------------------

sendhiddenfields =: < ;._1 ;._2 (0 : 0)
 refer txt2day
 submit submit
)

NB. Send a message.  x is (list of) boxed numbers to send to, each is <number;provider
NB. y is subject;text;replyaddr;callback;priority;retry count
NB. (<<'9196969551') sendtxtmsg 'Subj';'text';'M';'';0
sendtxtmsg =: 4 : 0"0 1
NB. Extract inputs, with default
'sub txt rep cbk pri rct' =. y =. y default '';'';'';'';0;0
pri =. ": pri

'recip provider' =. (>x) default '';'verizon'
SF__   =: sendfields =. sendhiddenfields , ('to';'from';'provider';'message') ,. recip;rep;provider;txt
cbp =. (,<,<'') , (x,&<y) ; (inthislocale 'sendtxtmsg_reply1')  NB. default timeout
( cbp;'www.txt2day.com';'/newsend.php' ) webpostform afterconnecting sendfields

NILRET
)

sendtxtmsg_reply1 =: 4 : 0
TXMY__   =: y
if. -. 'thanks.php' isinstring 1{::y do.
  ('RC=%d, TEXT=%s\n' sprintf 2 {. y) logerror 'Error sending text message'
end.
NILRET
)

NB. *** This is the Google version ***

NB. In case we have lots of messages to send, limit the number of simultaneous messages
smsoutstanding =: 0
smsmsgq =: 0 2$a:  NB. x, y of queued messages

sendhiddenfields =: < ;._1 ;._2 (0 : 0)
 gl US
 hl en
 client navclient-ffsms
 from 
 c 1
 subject 
 encrypted_captcha_answer mr_2_DtabLbeYR71kbNzlhUDg1cBAAAAFgAAAHPH_1teC93wGvNhrj8SKSdwBJkpoypyt6pkPVTjFBQ2
 user_captcha_answer com
 send-button Send
)
NB. Send a message.  x is (list of) boxed numbers to send to, each is <number;provider
NB. y is subject;text;replyaddr;callback;priority;retry count
NB. (<<'9196969551') sendtxtmsg 'Subj';'text';'M';'';0
sendtxtmsg =: 4 : 0"0 1
if. smsoutstanding > 3 do.
  smsmsgq =: smsmsgq , x ,&< y
else.
  NB. Extract inputs, with default
  'sub txt rep cbk pri rct' =. y =. y default '';'';'';'';0;0
  pri =. ": pri

  'recip provider' =. (>x) default '';'VERIZON'
  SF__   =: sendfields =. sendhiddenfields , ('mobile_user_id';'carrier';'text') ,. recip;provider;txt
  cbp =. (,<,<'') , (x,&<y) ; (inthislocale 'sendtxtmsg_reply1')  NB. default timeout
  ( cbp;'www.google.com';'/sendtophone' ) webpostform afterconnecting sendfields
  smsoutstanding =: >: smsoutstanding
end.

NILRET
)

sendtxtmsg_reply1 =: 4 : 0
TXMY__   =: y
if. -. 'Message sent!' isinstring 1{::y do.
  ('RC=%d, TEXT=%s\n' sprintf 2 {. y) logerror 'Error sending text message'
end.
NB. Decrement count of outstanding messages.  If there is a queued message
NB. go send it
smsoutstanding =: 0 >. <: smsoutstanding  NB. Could go below 0 on reload
if. #smsmsgq do.
display 'sending queued'
  sendtxtmsg&>/ {. smsmsgq  NB. Send the top one
  smsmsgq =: }. smsmsgq  NB. Delete it (if it was requeued, it was requeued at end)
end.
NILRET
)

NB. **** Following is the text-by-email code ***

registerinit 0
initialize =: 3 : 0
smtpserver =: 'smtp-server.nc.rr.com'
smtpmailaddr =: 'glasstrade@nc.rr.com'
)

carrierkl =: < ;._1 ;._2 (0 : 0)
 verizon @vtext.com
 alltel @message.alltel.com
 at&t @txt.att.net
 boost @myboostmobile.com
 cellularone @cellularone.txtmsg.com
 nextel @messaging.nextel.com
 sprint @messaging.sprintpcs.com
 suncom @tms.suncom.com
 tmobile @tmomail.net
 virgin @vmobl.com
 uscellular @email.uscc.net
)

NB. Get list of allowed carriers, as boxed names
getcarrierlist =: 3 : 0
/:~ keyskl carrierkl
)

NB. y is <number;provider
NB. Result is list of error strings (0$a: if no error)
audittxtaddr =: 3 : 0"0
'number carrier' =. (>y) default '';''
estgs =. 0$<''
if. +./ 10 ~: (# , +/@:(e.&'0123456789')) number -. '- ()',CR,LF,TAB do.
  estgs =. estgs , <'Bad number'
end.
if. 0 > (<carrier) indexkl carrierkl do. 
  estgs =. estgs , <'Bad carrier'
end.
estgs
)

NB. y is STMP server URL;mail account
NB. Sets those values
NB. Result is previous values
txtmsgsmtpaddrs =: 3 : 0
oldy =. smtpserver;smtpmailaddr
'smtpserver smtpmailaddr' =: y
oldy
)

NB. Send message via email to the provider.  Translate the provider to email address
NB. Send a message.  x is (list of) boxed numbers to send to, each is <number;provider
NB. y is subject;text[;replyaddr]
NB. (<'9196969551';'verizon') sendtxtmsg 'Subj';'text'
sendtxtmsg =: 4 : 0"0 1
'sub txt rep' =. y default '';'';''
'number carrier' =. (>x) default '';'verizon'
if.  0 > cx =. (<carrier) indexkl carrierkl do.
  logerror 'Unknown carrier %s' sprintf <carrier
else.
  NB. Don't send if server not defined
  smtpmail^:(*#smtpserver) smtpserver;smtpmailaddr;(number,(<cx,1){::carrierkl);sub;txt
end.
NILRET
)

NB. vzmsg =. (((<,<''));'www.vtext.com:443';'/customer_site/jsp/messaging_lo.jsp') webgetform 0 2$a:
publishentrypoints 'sendtxtmsg txtmsgsmtpaddrs audittxtaddr getcarrierlist'