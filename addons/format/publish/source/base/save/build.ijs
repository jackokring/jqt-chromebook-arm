NB. build
NB.
NB. builds each publish source file

Addir=: jpath '~Addons/format/publish/'
addir=: jpath '~addons/format/publish/'

mkdir_j_ Addir,'demo'
mkdir_j_ Addir,'findemo'
mkdir_j_ addir,'demo'

NB. =========================================================
f=. 3 : 0
readsourcex_jp_ '~Publish/',y
)

NB. =========================================================
dat=. ; f each cutopen 0 : 0
base/util
base/main
base/pubbuild
base/draw
base/font
base/read
base/zlib

classes/group
classes/image
classes/list
classes/page
classes/plot
classes/pre
classes/section
classes/skip
classes/table
classes/text
classes/url
classes/xobject

classes/header
classes/toc
)

dat=. dat,LF,0 : 0
cocurrent 'ppublish'
publishconfig''
cocurrent 'base'
)

dat fwritenew Addir,'publish.ijs'
dat fwritenew addir,'publish.ijs'

NB. =========================================================
f=. 3 : 0
(Addir,y) fcopynew '~.Publish/',y
(addir,y) fcopynew '~.Publish/',y
)

f 'history.txt'
f 'manifest.ijs'

NB. =========================================================
NB. demos
notdistrib=: 'build.ijs';'master.pdf'

names=. 3 : 0
notdistrib -.~ {."1 [ 2 dir '~Publish/',y
)

NB. =========================================================
NB. demo is distributed
f=. 3 : 0
(Addir,y) fcopynew '~Publish/',y
(addir,y) fcopynew '~Publish/',y
)

f each 'demo/'&, each names 'demo'

NB. =========================================================
NB. findemo is saved in Addons, not distributed
f=. 3 : 0
(Addir,y) fcopynew '~Publish/',y
)

f each 'findemo/'&, each names 'findemo'

ferase (Addir,'demo/')&, each notdistrib
ferase (Addir,'findemo/')&, each notdistrib
