NB. test1

Target=: jpath '~temp/joxygen'
mkdir_j_ Target
ferase 1 dir Target

Source=: jpath '~Addons/docs/joxygen/source'

Files=: 0 : 0
tester.ijs
testempty.ijs
noscript.ijs
)

IndexHdr=: 'hello'

(Target,'/joxygen.css') fcopynew '~addons/docs/joxygen/joxygen.css'

makedocs''
smoutput dir Target
