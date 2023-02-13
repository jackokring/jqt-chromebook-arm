NB. build

writesourcex_jp_ '~Addons/data/sqltable/source';'~Addons/data/sqltable/sqltable.ijs'

(jpath '~addons/data/sqltable/sqltable.ijs') (fcopynew ::0:) jpath '~Addons/data/sqltable/sqltable.ijs'

f=. 3 : 0
(jpath '~Addons/data/sqltable/',y) fcopynew jpath '~Addons/data/sqltable/source/',y
(jpath '~addons/data/sqltable/',y) (fcopynew ::0:) jpath '~Addons/data/sqltable/source/',y
)

mkdir_j_ jpath '~addons/data/sqltable'
f 'manifest.ijs'
f 'history.txt'
f 'readme.txt'
f 'test/'
f 'test/asiak.csv'
f 'test/kaikki.csv'
f 'test/test-setup.txt'
f 'test/test1.ijs'
f 'test/test2.ijs'
f 'test/test3.ijs'
f 'test/test4.ijs'
f 'test/test5.ijs'
