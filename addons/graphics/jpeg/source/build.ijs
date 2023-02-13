NB. build.ijs

writesourcex_jp_ '~Addons/graphics/jpeg/source';'~Addons/graphics/jpeg/jpeg.ijs'

f=. 3 : 0
(jpath '~addons/graphics/jpeg/',y) (fcopynew ::0:) jpath '~Addons/graphics/jpeg/',y
)

f 'jpeg.ijs'

f=. 3 : 0
(jpath '~Addons/graphics/jpeg/',y) fcopynew jpath '~Addons/graphics/jpeg/source/',y
(jpath '~addons/graphics/jpeg/',y) (fcopynew ::0:) jpath '~Addons/graphics/jpeg/source/',y
)

f 'manifest.ijs'
f 'history.txt'
