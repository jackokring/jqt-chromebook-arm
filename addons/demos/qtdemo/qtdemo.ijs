
18!:4 <'base'
18!:55 <'qtdemo'
coclass 'qtdemo'

sububar=: I. @(e.&'_')@]}
maketitle=: ' '&sububar each @ cutopen ;._2
fexist=: (1:@(1!:4) :: 0:) @ (fboxname &>) @ boxopen

ver=: ({.~i.&'(') wd 'version'
qtversion=: 100 #. 0&". ;. _1 '.', ({.~i.&'/') ver
qtmajor=: 0 ". ({.~ i.&'.') '/fs' -.~ (}.~ i.&'/') ver
qtslim=: 's' e. ver
qtfat=: 'f' e. ver
NB. pre 1.5.1
qtfat=: (qtfat,-.qtslim){~10500>(3#100)#. ".;._1 '.', '/fs' -.~ (}.~ i.&'/') ver

rundemo=: 1 : 0
load bind ('~addons/demos/qtdemo/','.ijs',~m)
)

SOH=: 1{a.
toSOH=: [:;(SOH,~":)each

win8x64=: 3 : 0''
if. IFWIN *: IF64 do. 0 return. end.
'w98 bld hi lo'=. 2 32768 256 256 #: 'kernel32 GetVersion > i' 15!:0 ''
(hi>1)*.(lo>5)
)

TITLES=: maketitle 0 : 0
browser dbrowser
controls dcontrols
datetime ddatetime
dial ddial
drag_and_drop ddragndrop
edit dedit
edith dedith
editm deditm
form_styles dpstyles
gl2 dgl2
grid_layout dgrid
ide dide
image dimage
isigrid disigrid
isigrid2 disigrid2
mbox dmbox
mbdialog dmbdialog
menu dmenu
msgs dmsgs
multimedia dmultimedia
pen_styles dpenstyles
plot dplot
pmoves dpmoves
printer dprinter
progressbar dprogressbar
scrollarea dscrollarea
scrollbar dscrollbar
shader dshader
slider dslider
spinbox dspinbox
split dsplit
statusbar dstatusbar
svg dsvg
table dtable
table2 dtable2
table3 dtable3
tabs dtabs
theme dtheme
timer dtimer
toolbar dtoolbar
toolbarv dtoolbarv
viewmat dviewmat
webd3 dwebd3
webgl dwebgl
websocket dwebsocket
websocket_client dwebsocketclient
webview dwebview
)

NB. =========================================================
QTDEMO=: 0 : 0
pc qtdemo closeok;pn "Demos Select";
bin v;
cc static1 static;cn "static1";
bin h;
minwh 200 400;cc listbox listbox;
bin v;
cc ok button;cn "OK";
cc cancel button;cn "Cancel";
cc view button;cn "View Source";
bin s;
cc addons button;cn "Install addons";
bin zzz;
rem form end;
)

NB. =========================================================
qtdemo_run=: 3 : 0
wd QTDEMO
t=. 'Select a Qt demo from the list below.',LF2
t=. t,'Click "install addons" to install the addons',LF
t=. t,'needed for the demos.'
wd 'set static1 text *',t
wd 'set listbox items ',;DEL,each ({."1 TITLES),each DEL
wd 'set listbox select 0'
wd 'setfocus listbox'
wd 'pshow;'
)

NB. =========================================================
qtdemo_close=: 3 : 0
wd 'pclose'
)

NB. =========================================================
qtdemo_listbox_button=: 3 : 0
fn=. > {: (".listbox_select) { TITLES
fn~0
)

NB. =========================================================
qtdemo_enter=: qtdemo_ok_button=: qtdemo_listbox_button
qtdemo_cancel_button=: qtdemo_close

NB. =========================================================
dbrowser=: 'browser' rundemo
dcontrols=: 'controls' rundemo
ddatetime=: 'datetime' rundemo
ddragndrop=: 'dragndrop' rundemo`notsupport@.(qtversion<10703)
ddial=: 'dial' rundemo
dedit=: 'edit' rundemo
dedith=: 'edith' rundemo
deditm=: 'editm' rundemo
dgl2=: 'gl2' rundemo
dgrid=: 'grid' rundemo
dide=: 'ide' rundemo
dimage=: 'image' rundemo
disigrid=: 'isigrid' rundemo
disigrid2=: 'isigrid2' rundemo
djdserver=: 'jdserver' rundemo`notsupport@.(-.IF64)
dmbox=: 'mbox' rundemo
dmbdialog=: 'mbdialog' rundemo
dmenu=: 'menu' rundemo
dmsgs=: 'msgs' rundemo
dmultimedia=: 'multimedia' rundemo`notsupport@.((qtmajor=4)+.qtslim)
dpenstyles=: 'penstyles' rundemo
dplot=: 'plot' rundemo
dpmoves=: 'pmoves' rundemo
dprinter=: 'printer' rundemo
dprogressbar=: 'progressbar' rundemo
dpstyles=: 'pstyles' rundemo
dquickview1=: 'quickview1' rundemo`notsupport@.((qtmajor=5)+.-.qtfat)
dquickview2=: 'quickview2' rundemo`notsupport@.((qtmajor=4)+.-.qtfat)
dquickwidget=: 'quickwidget' rundemo`notsupport@.((qtmajor=4)+.-.qtfat)
dscrollarea=: 'scrollarea' rundemo
dscrollbar=: 'scrollbar' rundemo
dshader=: 'shader' rundemo
dslider=: 'slider' rundemo
dspinbox=: 'spinbox' rundemo
dsplit=: 'split' rundemo
dstatusbar=: 'statusbar' rundemo
dsvg=: 'svg' rundemo
dtable=: 'table' rundemo
dtable2=: 'table2' rundemo
dtable3=: 'table3' rundemo
dtabs=: 'tabs' rundemo
dtheme=: 'theme' rundemo`notsupport@.(qtversion<10707)
dtimer=: 'timer' rundemo
dtoolbar=: 'toolbar' rundemo
dtoolbarv=: 'toolbarv' rundemo
dviewmat=: 'viewmat' rundemo
dwebd3=: 'webd3' rundemo`notsupport@.(qtslim)
dwebgl=: 'webgl' rundemo`notsupport@.(qtslim)
dwebsocket=: 'websocket' rundemo
dwebsocketclient=: 'websocketclient' rundemo
dwebview=: 'webview' rundemo`notsupport@.(qtslim)

NB. =========================================================
qtdemo_view_button=: 3 : 0
f=. }. > {: (".listbox_select) { TITLES
textview f;1!:1 <jpath '~addons/demos/qtdemo/',f,'.ijs'
)

NB. =========================================================
qtdemo_addons_button=: 3 : 0
require 'pacman'
'update' jpkg ''
'install' jpkg 'api/gles graphics/bmp graphics/plot graphics/viewmat'
smoutput 'All Qt demo addons installed.'
)

NB. =========================================================
checkrequire=: 3 : 0
'req install'=. y
if. ''-:getscripts_j_ req do. 1 return. end.
if. *./fexist getscripts_j_ req do. 1 return. end.
sminfo 'To run this demo, first install: ',install
0
)

NB. =========================================================
notsupport=: 3 : 0
sminfo 'This demo is not supported on ', UNAME, ' ', wd 'version'
)

NB. =========================================================
qtdemo_run''
