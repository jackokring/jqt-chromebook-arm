NB. version
NB.
NB. set and test against JAndroid binary version

coclass 'ja'

NB. minimum required JAndroid binary version:
JAREQ=: '1.0.0'

NB. =========================================================
checkjaversion=: 3 : 0
f=. 1000 #. 0 ". ' ' I.@('.'=])} ]
ver=. wd 'version'
act=. f (<./ ver i.'/s') {. ver
req=. f JAREQ
if. req <: act do. return. end.
msg=. 'The JAndroid application needs updating.',LF2
msg=. msg,'Please download and install the latest Android apk.'
sminfo 'JAndroid';msg
)

NB. =========================================================
checkjaversion^:IFJA''
