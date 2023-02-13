NB. build

S=: jpath '~Addons/math/lbfgs/source/'
PA=: jpath '~Addons/math/lbfgs/'
Pa=: jpath '~addons/math/lbfgs/'

mkdir_j_ Pa,'lib'

dat=. readsource_jp_ S,'base'
dat=. dat,'checklibrary$0',LF
dat=. dat,'cocurrent ''base''',LF
dat fwritenew PA,'lbfgs.ijs'

NB. =========================================================
f=. 3 : '(Pa,y) fcopynew PA,y'

f each cutopen 0 : 0
lbfgs.ijs
lbfgs-b.txt
lib/readme.txt
test/
)
