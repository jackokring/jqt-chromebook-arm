NB. build

mkdir_j_ jpath '~Addons/data/ddmysql/test'
mkdir_j_ jpath '~addons/data/ddmysql/test'

writesourcex_jp_ '~Addons/data/ddmysql/source';'~Addons/data/ddmysql/ddmysql.ijs'

(jpath '~addons/data/ddmysql/ddmysql.ijs') (fcopynew ::0:) jpath '~Addons/data/ddmysql/ddmysql.ijs'

f=. 3 : 0
(jpath '~Addons/data/ddmysql/',y) fcopynew jpath '~Addons/data/ddmysql/source/',y
(jpath '~addons/data/ddmysql/',y) (fcopynew ::0:) jpath '~Addons/data/ddmysql/source/',y
)

f 'manifest.ijs'
f 'history.txt'
f 'test/test1.ijs'
f 'test/test2.ijs'
