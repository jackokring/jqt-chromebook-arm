NB. build.ijs

writesourcex_jp_ '~Addons/arc/lz4/source';'~Addons/arc/lz4/lz4.ijs'

f=. 3 : 0
(jpath '~addons/arc/lz4/',y) (fcopynew ::0:) jpath '~Addons/arc/lz4/',y
)

f 'lz4.ijs'

f=. 3 : 0
(jpath '~Addons/arc/lz4/',y) fcopynew jpath '~Addons/arc/lz4/source/',y
(jpath '~addons/arc/lz4/',y) (fcopynew ::0:) jpath '~Addons/arc/lz4/source/',y
)

f 'manifest.ijs'
f 'readme.txt'
f 'test1.ijs'
