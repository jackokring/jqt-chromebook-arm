NB. quickwidget
NB.
NB. !!! this is experimental and *will* change...
NB.
NB. cover for the QQuickWidgets
NB. cmd so far:
NB.  set c source url
NB.  set c resizemode 0|1

coclass 'qtdemo'

NB. =========================================================
quickwidget=: 3 : 0
wd 'pc quickwidget'
wd 'cc e edit'
wd 'bin h'
wd 'cc run button;cn "run"'
wd 'cc view button;cn "View Source"'
wd 'bin sz'
wd 'minwh 300 300'
wd 'cc q quickwidget'
wd 'set e text *', e=. jpath '~addons/demos/qtdemo/quick2.qml'
wd 'pshow'
)

NB. =========================================================
quickwidget_e_button=: 3 : 0
wd 'set q source *',e
)

NB. =========================================================
quickwidget_run_button=: quickwidget_e_button

NB. =========================================================
quickwidget_view_button=: 3 : 0
textview e;1!:1 <e
)

NB. =========================================================
quickwidget_close=: 3 : 0
wd 'pclose'
)

NB. =========================================================
quickwidget''
