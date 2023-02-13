NB. build.ijs

writesourcex_jp_ '~Addons/tables/wdooo/source';'~Addons/tables/wdooo/wdooo.ijs'

(jpath '~addons/tables/wdooo/wdooo.ijs') (fcopynew ::0:) jpath '~Addons/tables/wdooo/wdooo.ijs'

f=. 3 : 0
(jpath '~Addons/tables/wdooo/',y) fcopynew jpath '~Addons/tables/wdooo/source/',y
(jpath '~addons/tables/wdooo/',y) (fcopynew ::0:) jpath '~Addons/tables/wdooo/source/',y
)

mkdir_j_ jpath '~addons/tables/wdooo'
f 'manifest.ijs'
f 'history.txt'
f 'jserver.ijs'
f 'msexcel.ijs'
f 'oocalc.ijs'
f 'test1.xls'
f 'test1.xlsx'
