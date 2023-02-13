NB. query

NB. =========================================================
NB. qprinter
NB.
NB. query printer and call verb y with result
qprinter=: 3 : 0
NB. wd 'pc qprinter;cc g isigraph;cc e edit;set e *',y
NB. glzprint ''
''
)

NB. =========================================================
NB. qprinter_g_print=: 3 : 0
NB. v=. > 1 { (({."1 wdq) i. <,'e') { wdq
NB. p=. glzqwh 2
NB. m=. 4{.glzqprintpaper''
NB. wd 'pclose'
NB. v~p;m
NB. )
