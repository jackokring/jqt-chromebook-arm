NB. ide save

cocurrent 'jpsave'

pAddons=: jpath '~Addons/ide/ja'
paddons=: jpath '~addons/ide/ja'

mkdir_j_ jpath '~.Ja/release/'
mkdir_j_ jpath pAddons
mkdir_j_ jpath paddons

NB. =========================================================
f=. 3 : 0
load '~Ja/',y,'/build.ijs'
)

NB. =========================================================
Source=: <;._2 (0 : 0)
config
debug
demo
keys
pacman
main
help
xml/android
xml/drawable
xml/layout
xml/menu
xml/values
xml/resu
xml/mkview
xml/mkmenu
)

f each Source

NB. =========================================================
FTR=: 0 : 0
cocurrent 'base'
)

src=: <;._2[0 : 0
main
)

srcxml=: <;._2[0 : 0
android
drawable
layout
menu
values
resu
mkview
mkmenu
)

NB. =========================================================
NB. build ja.ijs:
run=: 3 : 0
f=. <jpath '~.Ja/release/'
dat=. ; freads each f ,each src ,each <'.ijs'
dat=. decomment_jp_ dat
hdr=. 'NB. JAndroid',LF2
dat=. hdr,dat
dat=. dat,LF,FTR
dat fwrites ::] pAddons,'/ja.ijs'
dat fwrites ::] paddons,'/ja.ijs'

NB. dat=. ; freads each f ,each srcxml ,each <'.ijs'
NB. dat=. decomment_jp_ dat
NB. hdr=. 'NB. JAndroid xml',LF2
NB. dat=. hdr,dat
NB. dat=. dat,LF,FTR
NB. dat fwrites ::] pAddons,'/jaxml.ijs'
NB. dat fwrites ::] paddons,'/jaxml.ijs'
)

NB. =========================================================
run''

NB. =========================================================
f=. 3 : 0
(pAddons,'/',y) fcopynew '~.Ja/release/',y
(paddons,'/',y) fcopynew '~.Ja/release/',y
)

NB. f 'debugs.ijs'
f 'gl2.ijs'
f 'keys.ijs'
f 'pacman.ijs'
f 'help.ijs'

f=. 3 : 0
(pAddons,'/',y) fcopynew jpath '~.Ja/',y
(paddons,'/',y) fcopynew jpath '~.Ja/',y
)

f 'manifest.ijs'
f 'history.txt'

NB. generate tag file baselibtags
NB. not used at the moment
NB. load '~Ja/baselibtag/save.ijs'
