NB. version
NB.
NB. set and test against JQt binary version

coclass 'jqtide'

NB. minimum required JQt binary version:
JQTREQ=: '1.8.1'

NB. =========================================================
JQTMSG=: 0 : 0
The JQt binary needs updating.

To do so, close this session, then load jconsole and run:

   getqtbin''
or
   getqtbin'slim'

or run XX in the J installation folder.
)

NB. =========================================================
checkjqtversion=: 3 : 0
f=. 1000 #. 0 ". ' ' I.@('.'=])} ]
ver=. wd 'version'
ver=. (ver i.'(') {. ver
JQTVER=: f (1+ver i.'/') }. ver
act=. f (<./ ver i.'/s') {. ver
req=. f JQTREQ
if. req <: act do. return. end.
msg=. JQTMSG rplc 'XX';'updatejqt.',IFWIN pick 'sh';'cmd'
sminfo 'JQt';msg
)

NB. =========================================================
checkjqtversion^:IFQT''
