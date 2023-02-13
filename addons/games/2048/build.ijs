NB. build

f=. 3 : 0
(jpath '~addons/games/2048/',y) (fcopynew ::0:) jpath '~Addons/games/2048/',y
)

mkdir_j_ jpath '~addons/games/2048'

f '2048.ijs'
f 'engine.ijs'
f 'ui_console.ijs'
f 'ui_wd.ijs'
f 'history.txt'
f 'manifest.ijs'
