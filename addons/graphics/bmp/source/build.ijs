NB. build.ijs

writesourcex_jp_ '~Addons/graphics/bmp/source';'~Addons/graphics/bmp/bmp.ijs'

f=. 3 : 0
(jpath '~addons/graphics/bmp/',y) (fcopynew ::0:) jpath '~Addons/graphics/bmp/',y
)

f 'bmp.ijs'

f=. 3 : 0
(jpath '~Addons/graphics/bmp/',y) fcopynew jpath '~Addons/graphics/bmp/source/',y
(jpath '~addons/graphics/bmp/',y) (fcopynew ::0:) jpath '~Addons/graphics/bmp/source/',y
)

f 'manifest.ijs'
f 'history.txt'
f 'jbox.bmp'
f 'toucan.bmp'
