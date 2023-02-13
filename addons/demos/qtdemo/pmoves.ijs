NB. pmoves demo

coclass 'qtdemo'

Text=: topara 0 : 0
Move and resize this form as you like.

Then close and reopen it. The position and size should have been restored.

The position and size are saved in ~config/winpos.dat.
)

NB. =========================================================
pmovesdemo_run=: 3 : 0
wd 'pc pmovesdemo closeok escclose;pn "pmoves Demo"'
wd 'cc ted editm'
wd 'set ted stylesheet *color:#00007f;background-color:#ffefd5'
wd 'set ted text *',Text
wd 'bin zhs'
wd 'cc close button;cn Close'
wd 'pmoves 100 10 500 200'
wd 'pshow'
)

NB. =========================================================
pmovesdemo_close=: 3 : 0
wd 'pclose'
)

pmovesdemo_close_button=: pmovesdemo_close

NB. =========================================================
pmovesdemo_run''
