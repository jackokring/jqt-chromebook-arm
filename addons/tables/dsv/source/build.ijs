NB. build
require 'project'
writesource_jp_ '~Addons/tables_dsv/source';'~Addons/tables_dsv/dsv.ijs'

NB. (jpath '~addons/tables/dsv/dsv.ijs') (fcopynew ::0:) jpath '~Addons/tables_dsv/dsv.ijs'

f=. 3 : 0
(jpath '~Addons/tables_dsv/',y) fcopynew jpath '~Addons/tables_dsv/source/',y
(jpath '~addons/tables/dsv/',y) (fcopynew ::0:) jpath '~Addons/tables_dsv/',y
)

mkdir_j_ jpath '~addons/tables/dsv/test'
f 'dsv.ijs'
f 'LICENSE'
f 'manifest.ijs'
f 'history.txt'
f 'test/test_dsv.ijs'
f 'test/test.tsv'
f 'test/mixed.tsv'
