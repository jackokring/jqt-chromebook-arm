NB. scrollbar demo
NB.
NB. cc track scrollbar [v] [numeric options]
NB.
NB. numeric options are:
NB. minimum
NB. single step
NB. page step
NB. maximum
NB. position

NB.
NB. min,max,value should be integers

coclass 'qtdemo'

NB. =========================================================
SBdemo=: 0 : 0
pc scrollbardemo;
cc track scrollbar 2 1 5 20 7;
)

NB. =========================================================
scrollbardemo_close=: 3 : 0
wd 'pclose'
showevents_jqtide_ 0
)

NB. =========================================================
scrollbardemo_run=: 3 : 0
P=. jpath '~addons/ide/qt/images/'
wd SBdemo
wd 'pmove 700 10 400 200'
wd 'pshow'
)

NB. =========================================================
showevents_jqtide_ 2
scrollbardemo_run''
smoutput 0 : 0
Try:
  wd 'set track pos 11'
  wd 'set track max 30'
)
