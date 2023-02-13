
FM=: jpath '~Addons/graphics/gnuplot/'
TO=: jpath '~addons/graphics/gnuplot/'

f=. 3 : 0
(TO,y) fcopynew FM,y
)

f 'gnuplot.ijs'
f 'gpdemo.ijs'
f 'gnuplot.txt'

