NB. quickview2
NB.
NB. !!! this is experimental and *will* change...
NB.
NB. cover for the QQuickView

coclass 'qtdemo'

NB. =========================================================
quickview2=: 3 : 0
wd 'pc quickview2'
wd 'cc e edit'
wd 'bin h'
wd 'cc run button;cn "run"'
wd 'cc view button;cn "View Source"'
wd 'bin sz'
wd 'set e text *', e=. jpath '~addons/demos/qtdemo/quick2.qml'
wd 'pshow'
)

NB. =========================================================
quickview2_e_button=: 3 : 0
wd 'quickview2 qv "', e ,'"'
)

NB. =========================================================
quickview2_run_button=: quickview2_e_button

NB. =========================================================
quickview2_view_button=: 3 : 0
textview e;1!:1 <e
)

NB. =========================================================
quickview2_close=: 3 : 0
wd 'pclose'
)

NB. =========================================================
quickview2''
