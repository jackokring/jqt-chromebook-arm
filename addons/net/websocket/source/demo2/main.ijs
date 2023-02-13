NB. main

NB. =========================================================
NB. show select result
showselect=: 3 : 0
try.
  tab2html dbread y
catcht.
  '<p>query failed: ',y,'</p>'
end.
)

NB. =========================================================
NB. show first 5 rows of each table
showtables=: 3 : 0
t=. dbtables''
s=. (,' - ' , ' records' ,~ ":@dbsize) each t
p=. ('<b>',,&'</b>') each s
r=. tab2html@dbread each t ,each <' limit 5'
; (p ,each r) ,each LF
)

NB. =========================================================
NB. for development
reloadJ_z_=: 3 : 0
dat=. freads '~addons/net/websocket/demo4/run.ijs'
0!:100 dat {.~ ('load ''net/websocket''' E. dat) i: 1
)
