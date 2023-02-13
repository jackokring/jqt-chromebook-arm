NB. build.ijs

writesource_jp_ '~Addons/tables/tara/source';'~Addons/tables/tara/tara.ijs'

cocurrent 'base'

NB. =========================================================

f=. 3 : 0
mkdir_j_ jpath '~addons/tables/tara/test/'
(jpath '~Addons/tables/tara/',y) fcopynew ::] jpath '~Addons/tables/tara/source/',y
(jpath '~addons/tables/tara/',y) (fcopynew ::0:) ::] jpath '~Addons/tables/tara/source/',y
)

f 'manifest.ijs'
f 'tara.ijt'
f 'history.txt'
f 'taradoc.txt'
f 'test/dora.png'
f 'test/taratest.ijs'
f 'test/taratest2.ijs'
f 'test/test.xls'
