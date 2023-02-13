NB. build

T=: jpath '~addons/net/clientserver/'
S=: jpath '~Addons/net/clientserver/'
mkdir_j_ T

f=. 3 : '(T,y) fcopynew S,y'

f each cutopen 0 : 0
jssc.ijs
jsss.ijs
jsss_demo.ijs
)