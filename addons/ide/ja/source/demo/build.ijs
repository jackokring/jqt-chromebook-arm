NB. build

fl=. cutopen 0 : 0
controls.ijs
datetime.ijs
edit.ijs
editm.ijs
gl2.ijs
image.ijs
mbox.ijs
menu.ijs
penstyles.ijs
plot.ijs
progressbar.ijs
jademo.ijs
shader.ijs
seekbar.ijs
tabs.ijs
timer.ijs
util.ijs
video.ijs
viewmat.ijs
webd3.ijs
webview.ijs
)

NB. =========================================================
cf=. (jpath '~Ja/demo/') , ]
ca=. (jpath '~addons/ide/ja/demo/') , ]
cA=. (jpath '~Addons/ide/ja/demo/') , ]
mkdir_j_ ca''
mkdir_j_ cA''
(ca fcopynew cf) each fl
(cA fcopynew cf) each fl

NB. =========================================================
f=: 3 : 0
cf=. (jpath '~Ja/',y,'/') , ]
fl=. {."1[1!:0 cf'*'
ca=. (jpath '~addons/ide/ja/',y,'/') , ]
cA=. (jpath '~Addons/ide/ja/',y,'/') , ]
mkdir_j_ ca''
mkdir_j_ cA''
(ca fcopynew cf) each fl
(cA fcopynew cf) each fl
)

f 'data'
f 'images'
f 'js'
