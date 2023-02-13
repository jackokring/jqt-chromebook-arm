NB. build.ijs

mkdir_j_ jpath '~Addons/api/lapacke/test'
mkdir_j_ jpath '~Addons/api/lapacke/lib'
mkdir_j_ jpath '~addons/api/lapacke/test'
mkdir_j_ jpath '~addons/api/lapacke/lib'

writesourcex_jp_ '~Addons/api/lapacke/source';'~Addons/api/lapacke/lapacke.ijs'
('checklibrary$0',LF,'cocurrent ''base''',LF) fappend '~Addons/api/lapacke/lapacke.ijs'

(jpath '~addons/api/lapacke/lapacke.ijs') (fcopynew ::0:) jpath '~Addons/api/lapacke/lapacke.ijs'

f=. 3 : 0
(jpath '~Addons/api/lapacke/',y) fcopynew jpath '~Addons/api/lapacke/',y
(jpath '~addons/api/lapacke/',y) (fcopynew ::0:) jpath '~Addons/api/lapacke/',y
)

f 'manifest.ijs'
f 'test/test.ijs'
f 'lib/readme.txt'
