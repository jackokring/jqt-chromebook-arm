NB. quickview1
NB.
NB. !!! this is experimental and *will* change...
NB.
NB. cover for the QDeclarativeView

coclass 'qtdemo'

NB. =========================================================
quickview1=: 3 : 0
wd 'pc quickview1'
wd 'cc e edit'
wd 'bin h'
wd 'cc run button;cn "run"'
wd 'cc view button;cn "View Source"'
wd 'bin sz'
wd 'set e text *', e=. jpath '~addons/demos/qtdemo/quick1.qml'
wd 'pshow'
)

NB. =========================================================
quickview1_e_button=: 3 : 0
wd 'quickview1 qv "', e ,'"'
)

NB. =========================================================
quickview1_run_button=: quickview1_e_button

NB. =========================================================
quickview1_view_button=: 3 : 0
textview e;1!:1 <e
)

NB. =========================================================
quickview1_close=: 3 : 0
wd 'pclose'
)

NB. =========================================================
quickview1''
