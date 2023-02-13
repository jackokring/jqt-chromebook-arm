NB. log
NB. log tags:
NB.  add  - add server (as locale)
NB.  cmd  - command
NB.  err  - error
NB.  msg  - debug message
NB.  rem  - remove server (as locale)
NB.  res  - result (JFE)
NB.  use  - time used, return size (base)

LogDay=: ''
LogFile=: ''

NB. =========================================================
NB. log type;text
log=: 3 : 0
if. 0=#LogFile do. return. end.
ts=. logtime''
if. -. LogDay -: 8{.ts do. logday'' end.
if. 2=#y do.
  'type text'=. y
else.
  type=. 'bad'
  text=. }. ; ',' ,each srep each boxxopen y
end.
msg=. (8}.ts),' ',type,' ',(":SC),' ',text,LF
msg 1!:3 <LogFile
)

NB. =========================================================
logcmd=: 3 : 0
log 'cmd';srep y
)

NB. =========================================================
NB.*logday v define log globals for day
NB.-define log globals for day\
NB.-also remove old log files when creating a new log file
logday=: 3 : 0
LogDay=: 8{.logtime''
LogFile=: LogDir,'/',LogDay,'.log'
if. fexist LogFile do. return. end.
f=. (-LogLen) }. sort {."1[ 1!:0 LogDir,'/*.log'
ferase each (LogDir,'/')&, each f
)

NB. =========================================================
NB.*logerror v log error
logerror=: 3 : 0
r=. deb y
log 'err';r
r
)

NB. =========================================================
NB.*loginit v initialize log for day
loginit=: 3 : 0
if. 0=#LogDir do. return. end.
mkdir_j_ LogDir
logday''
log 'ini';y
)

NB. =========================================================
NB. log message for debugging
logmsg=: 3 : 0
log 'msg';":y
y
)

NB. =========================================================
logres=: 3 : 0
log 'res';srep y
)

NB. =========================================================
logtime=: 6!:0 bind 'YYYYMMDDhh:mm:ss.sss'

NB. =========================================================
NB. log usage
loguse=: 3 : 0
't r'=. y
log 'use';": (<. 0.5 + 1000 * t),#r
r
)
