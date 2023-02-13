NB. table4
NB.
NB. (not in demo)
NB.
NB. allow test program scroll/select with large number of cells

coclass 'qtdemo'

towords=: ;: inverse

NB. =========================================================
Rws=:100
Cls=:1000
Tab=: 10000+?(Rws,Cls)$90000
Tab=: <.(10?10000000) (<3;(Cls%10)*i.10)} Tab
Hdr=: (<'Hdr')(,":) each i.Cls
Lab=: (<'Lab')(,":) each i.Rws

NB. =========================================================
table=: 3 : 0
wd 'pc table'
wd 'cc pac table ',":Rws,Cls
wd 'set pac hdr ',towords Hdr
wd 'set pac hdralign 1'
wd 'set pac type 0'
wd 'set pac align 2'
wd 'set pac lab ',towords Lab
wd 'set pac data *',towords , 'c'8!:0 Tab
wd 'pmove 100 10 500 200'
wd 'pshow'
)

NB. =========================================================
table_close=: 3 : 0
wd 'pclose'
)

NB. =========================================================
wd :: ] 'psel table;pclose'
showevents_jqtide_ 0
table''

NB. =========================================================
smoutput 0 : 0
   wd 'set pac select 50 60'
   wd 'set pac select 50 52 60 63'
   wd 'set pac scroll 10 5'
   wd 'set pac scroll 0 0'
   wd 'set pac scroll 99 99'
)
