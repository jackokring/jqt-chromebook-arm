NB. webgl

coclass 'qtdemo'

J3DI=: file2url jpath '~addons/demos/qtdemo/js/J3DI.js'
J3DIMath=: file2url jpath '~addons/demos/qtdemo/js/J3DIMath.js'
PICTURE=: file2url jpath '~addons/demos/qtdemo/image/lena.png'

NB. =========================================================
run_webgl=: 3 : 0
wd 'pc webgl;cc w webview;set _ sizepolicy expanding'
wd 'pmove 200 200 600 600'
h=. fread jpath '~addons/demos/qtdemo/webgl.html'
m=. ('J3DI_js';J3DI;'J3DIMath_js';J3DIMath;'PICTURE';PICTURE) stringreplace h
wd 'pshow'
wd 'set w baseurl *', file2url jpath '~addons'
wd 'set w html *',m
)

NB. =========================================================
webgl_close=: 3 : 0
wd 'pclose'
)

NB. =========================================================
run_webgl''
