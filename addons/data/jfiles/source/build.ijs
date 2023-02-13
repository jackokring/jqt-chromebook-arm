NB. build

writesourcex_jp_ '~Addons/data/jfiles/source';'~Addons/data/jfiles/jfiles.ijs'

(jpath '~addons/data/jfiles/jfiles.ijs') (fcopynew ::0:) jpath '~Addons/data/jfiles/jfiles.ijs'

f=. 3 : 0
(jpath '~Addons/data/jfiles/',y) fcopynew jpath '~Addons/data/jfiles/source/',y
(jpath '~addons/data/jfiles/',y) (fcopynew ::0:) jpath '~Addons/data/jfiles/source/',y
)

mkdir_j_ jpath '~addons/data/jfiles'
f 'manifest.ijs'
f 'history.txt'
f 'jfiles.txt'
f 'keyfiles.txt'
f 'test/test0.ijs'
f 'test/test1.ijs'
