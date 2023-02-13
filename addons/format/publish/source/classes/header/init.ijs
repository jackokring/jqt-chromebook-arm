NB. init

coclass 'ppubheader'
NB. init header
NB.
NB. A header object has one or two lines
NB. The lines are formatted with FONTHx and FONTP
NB. No para spacing is applied between the lines.

NAME=: ''   NB. short name
Tag=: ''    NB. header tag used

NB. =========================================================
create=: 3 : 0
coinsert locP=: COCREATOR
coinsert 'ppubtext'
ALIGN=: iLEFT
ALIGNV=: iTOP
)