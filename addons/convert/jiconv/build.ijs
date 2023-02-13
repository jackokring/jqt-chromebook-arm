NB. build

T=: jpath '~addons/convert/jiconv/'
S=: jpath '~Addons/convert/jiconv/'
mkdir_j_ T

f=. 3 : '(T,y) fcopynew S,y'

f each cutopen 0 : 0
jiconv.ijs
history.txt
)
