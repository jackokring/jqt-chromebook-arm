NB. run

load '~Addons/graphics/afm/source/afmdev/build.ijs'
writesourcex_jp_ '~Addons/graphics/afm/source/afm';'~Addons/graphics/afm/source/release/afm.ijs'

f=. 3 : 0
(jpath '~Addons/graphics/afm/',y) fcopynew jpath '~Addons/graphics/afm/source/release/',y
(jpath '~addons/graphics/afm/',y) (fcopynew ::0:) jpath '~Addons/graphics/afm/source/release/',y
)

f 'afm.ijs'

f=. 3 : 0
(jpath '~Addons/graphics/afm/',y) fcopynew jpath '~Addons/graphics/afm/source/',y
(jpath '~addons/graphics/afm/',y) (fcopynew ::0:) jpath '~Addons/graphics/afm/source/',y
)

f 'manifest.ijs'
f 'history.txt'
