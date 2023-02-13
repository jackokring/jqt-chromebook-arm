NB. init

load 'socket'

cocurrent 'jws'
coinsert 'jsocket'

LogDir=: jpath '~temp/logs'
LogLen=: 3 NB. number of days to keep

NB. =========================================================
NB. timeouts (all milliseconds)
NB.
NB. WaitTimeout - socket select timeout. Other timeouts are checked after this returns.
NB.
NB. InitTimeout - if non-zero, exit J if no initial connection in given time
NB.
NB. IdleTimeout - if non-zero, close connection if no activity in given time
NB.
NB. TermTimeout - if non-zero, close connection after given term

NB. On IdleTimeout, a JFE session will exit J, otherwise only that connection will be closed
NB. and the server will wait for new connections.

WaitTimeout=: 5000
InitTimeout=: 0
IdleTimeout=: 600000
TermTimeout=: 0
