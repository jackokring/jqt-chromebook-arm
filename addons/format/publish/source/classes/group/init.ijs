NB. init

coclass 'ppubgroup'
NB. init group
NB.
NB. Gstate is:
NB.   0  - initial state
NB.   1  - tested state, no new page
NB.   2  - tested state, new page
NB.
NB. GroupNum is assigned on create
NB.
NB. State is newpage state, used in draw proper, with
NB. same definition as State in the page class

Gstate=: 0
State=: 0

NB. =========================================================
create=: 3 : 0
coinsert locP=: COCREATOR
GroupNum=: newgroup''
)

NB. =========================================================
NB. return new page indicator depending on State
draw=: 3 : 0
select. Gstate
case. 0 do.
  setgroup ''
  0;''
case. 1 do.
  0;''
case. 2 do.
  State=: -. State
  State;''
end.
)