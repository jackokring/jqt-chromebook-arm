NB. run test and check matches distribution

T=: jpath '~temp/joxygen'
ferase 1 dir T
load '~addons/docs/joxygen/joxygen.ijs'

Note''
load '~addons/docs/joxygen/test.ijs'
meld T;'~Addons/docs/joxygen/source/testdocs'
)

load '~Addons/docs/joxygen/source/test1.ijs'
