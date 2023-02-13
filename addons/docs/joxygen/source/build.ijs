
mkdir_j_ jpath '~Addons/docs/joxygen/testdocs'
mkdir_j_ jpath '~Addons/docs/joxygen/testscripts'
mkdir_j_ jpath '~addons/docs/joxygen/testdocs'
mkdir_j_ jpath '~addons/docs/joxygen/testscripts'

writesourcex_jp_ '~Addons/docs/joxygen/source';'~Addons/docs/joxygen/joxygen.ijs'
writesourcex_jp_ '~Addons/docs/joxygen/source';'~addons/docs/joxygen/joxygen.ijs'

f=: 3 : 0
s=. '~Addons/docs/joxygen/source/',y
('~Addons/docs/joxygen/',y) fcopynew s
('~addons/docs/joxygen/',y) fcopynew s
)

f 'joxygen.css'
f 'manifest.ijs'
f 'test.ijs'
f each 'testdocs/'&, each {."1 [ 2 dir jpath '~Addons/docs/joxygen/source/testdocs'
f each 'testscripts/'&, each {."1 [ 2 dir jpath '~Addons/docs/joxygen/source/testscripts'
