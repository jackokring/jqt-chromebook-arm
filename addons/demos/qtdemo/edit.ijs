NB. alignment, password, readonly
NB.

coclass 'qtdemo'

NB. =========================================================
edit=: 3 : 0
wd 'fontdef monospace 12'
wd 'pc edit'
wh=. ". wd 'getp extent ',10#'M'
wd 'bin v'
wd 'bin g;grid size 3'
wd 'minwh 150 20'
wd 'cc e0 edit;set _ maxwh ',":8 8 + wh
wd 'cc e4 edit password'
wd 'cc e5 edit readonly'
wd 'cc l1 static left'
wd 'cc l2 static center'
wd 'cc l3 static right'
wd 'cc e1 edit left'
wd 'cc e2 edit center'
wd 'cc e3 edit right'
if. 901<".3{.}.9!:14'' do.
wd 'cc e6 edit uppercase'
end.
wd 'bin z'
wd 'bin g;grid size 2'
wd 'bin h;cc l4 static;cn "integer 0 to 111";cc v1 edit right;set _ intvalidator 0 111;bin sz'
wd 'bin h;cc l5 static;cn "float _99.99 to 99.99";cc v2 edit right;set _ doublevalidator -99.99 99.99 2;set _ limit 6;bin sz'
wd 'bin h;cc l6 static;cn "regexp \d*\.\d+";cc v3 edit;set _ regexpvalidator "\d*\.\d+";bin sz'
wd 'bin h;cc l7 static;cn "input mask Mac address";cc v4 edit;set _ inputmask "HH:HH:HH:HH:HH:HH;_";bin sz'
wd 'bin z'
wd 'bin sz'
wd 'pshow'
wd 'fontdef'
wd 'set e0 limit 10'
wd 'set e0 text limit=10'
wd 'set e1 text left'
wd 'set e2 text center'
wd 'set e3 text right'
wd 'set e4 text password'
wd 'set e5 text readonly'
wd 'set e6 text uPpErCaSe'
wd 'set l1 text left'
wd 'set l2 text center'
wd 'set l3 text right'
wd 'setp stylesheet *QLineEdit{color:blue} QLabel{color:green;background-color:yellow}'
wd 'set e4 stylesheet color:red'
wd 'set e5 stylesheet background-color:#bbbbbb'
)

NB. =========================================================
edit_e0_button=: 3 : 0
smoutput 'e0 button event'
)

NB. =========================================================
edit_e0_char=: 3 : 0
if. 16bf800 <: 3 u: ucp sysdata do.
  smoutput 'e0 char event keycode: ', ": 3 u: ucp sysdata
else.
  smoutput 'e0 char event key: ', sysdata
end.
)

NB. =========================================================
edit_close=: 3 : 0
wd 'pclose'
)

NB. =========================================================
edit''
