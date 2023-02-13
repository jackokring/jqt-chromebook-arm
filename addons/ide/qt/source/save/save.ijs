NB. ide save

cocurrent 'jpsave'

pAddons=: jpath '~Addons/ide/qt'
paddons=: jpath '~addons/ide/qt'

mkdir_j_ jpath '~.Qt/release/'
mkdir_j_ jpath pAddons
mkdir_j_ jpath paddons

NB. =========================================================
f=. 3 : 0
load '~Qt/',y,'/build.ijs'
)

NB. =========================================================
Source=: <;._2 (0 : 0)
config
debug
gl2
help
keys
main
opengl
pacman
printer
qtlib
)

f each Source

NB. =========================================================
FTR=: 0 : 0
cocurrent 'base'
)

src=: ;:'main'

NB. =========================================================
NB. build qt.ijs:
run=: 3 : 0
f=. <jpath '~.Qt/release/'
dat=. ; freads each f ,each src ,each <'.ijs'
dat=. dat, ; (<_1) -.~ freads '~Qt/save/finalize.ijs'
dat=. decomment_jp_ dat
hdr=. 'NB. J qtide',LF2
dat=. hdr,dat
dat=. dat,LF,FTR
dat fwrites ::] pAddons,'/qt.ijs'
dat fwrites ::] paddons,'/qt.ijs'
)

NB. =========================================================
run''

NB. =========================================================
f=. 3 : 0
(pAddons,'/',y) fcopynew '~.Qt/release/',y
(paddons,'/',y) fcopynew '~.Qt/release/',y
)

f 'debugs.ijs'
f 'gl2.ijs'
f 'help.ijs'
f 'keys.ijs'
f 'opengl.ijs'
f 'pacman.ijs'
f 'printer.ijs'
f 'qtlib.ijs'

f=. 3 : 0
(pAddons,'/',y) fcopynew jpath '~.Qt/',y
(paddons,'/',y) fcopynew jpath '~.Qt/',y
)

f 'manifest.ijs'
f 'history.txt'

NB. =========================================================
f=. 3 : 0
cf=. (jpath '~Qt/',y,'/') , ]
fl=. {."1[1!:0 cf'*'
ca=. (jpath '~addons/ide/qt/',y,'/') , ]
cA=. (jpath '~Addons/ide/qt/',y,'/') , ]
mkdir_j_ ca''
mkdir_j_ cA''
(ca fcopynew cf) each fl
(cA fcopynew cf) each fl
)

f 'images'

NB. generate tag file baselibtags
NB. not used at the moment
NB. load '~Qt/baselibtag/save.ijs'
