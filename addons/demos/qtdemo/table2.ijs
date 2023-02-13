NB. table with combolists

coclass 'qtdemo'

NB. =========================================================
fmt1=: 3 : 0
if. 2=3!:0 y do. ' "',y,'"' else. ' ',,8!:2 y end.
)

NB. =========================================================
Tab=: _2 [\ 11 8 6 9 23 6
Sel=: 0 0 1
DEL=: 127{a.
Types=: 0 100 200 0 0 300 0
NB. =========================================================
makedata=: 3 : 0
a=.  'Ford 0 ',DEL,'"First Item" "Second Item" "Third Item"',DEL,' 11 8 "0 Sedan Coupe Convertible" "USA"'
a=. a,'Toyota 0 "" 6 9 "1 Sedan Coupe Convertible" "Japan"'
a=. a,'"Mercedes Benz" 1 "1 First Second Third" 23 6 "2 Sedan Coupe Convertible" "Germany"'
)

NB. =========================================================
table=: 3 : 0
wd 'pc table'
wd 'cc pac table 3 7 selectrows sortable'
wd 'set pac hdr Manufacturer Select Options Hire Lease Type Origin'
wd 'set pac hdralign 0 1 1 1 1 1 0'
wd 'set pac type ',":Types
wd 'set pac align 0 1 0 2 2 0 0'
wd 'set pac protect 1 0 0 0 0 0 1'
wd 'set pac data *',makedata''
wd 'set pac cell 1 2 *3 First Second Third Fourth'
wd 'pmove 100 10 500 200'
wd 'pshow'
)

NB. =========================================================
table_pac_change=: 3 : 0
'row col'=. 0 ". pac_cell
smoutput (":row),' ',(":col),': ',pac_value

)


NB. =========================================================
table_close=: 3 : 0
wd 'pclose'
showevents_jqtide_ 0
)

NB. =========================================================
showevents_jqtide_ 2
table''
smoutput 0 : 0
Try:
  wd'set pac cell 0 1 1'
  wd'set pac cell 1 2 *2 "Item 1" "Item 2" "Item 3" "Item 4"'
  wd'get pac cell 0 5'
  <;._2 wd'get pac col 0'
  3 7$ <;._2 wd'get pac table'
  wd'set pac sort 6 descending'
)
