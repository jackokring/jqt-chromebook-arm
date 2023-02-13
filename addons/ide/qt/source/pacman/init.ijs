NB. init.ijs

require 'pacman'
coclass 'jpacman'

Status=: cutopen 0 : 0
All
Upgrades
Not installed
Installed
)

NB. =========================================================
create=: 3 : 0
log=: loggui
window=: 0
written=: matched=: 0
DATAMASK=: 0
DATAX=: _1
IFSECTION=: 0
ISGUI=: 1
LASTMSG=: ''
LOGTXT=: ''
MSGX=: 0
SECTION=: ,<'All'
SELNDX=: 0 0
if. -. pmview_init'' do. destroy'' end.
)

NB. =========================================================
destroy=: 3 : 0
codestroy''
)
