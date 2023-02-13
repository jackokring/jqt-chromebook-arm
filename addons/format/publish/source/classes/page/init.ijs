NB. init

coclass 'ppubpage'

State=: 0

NB. =========================================================
create=: 3 : 0
coinsert locP=: COCREATOR
)

NB. =========================================================
NB. return new page indicator depending on State
NB. needs to be restored after second call in case of redraw
draw=: 3 : 0
State=: -. State
State;''
)