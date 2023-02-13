smoutput(jpathsep>(4!:4<'zx'){4!:3'');~zx=.'test reval(2)'
cocurrent 'base' [clear''
Q=: 3 : 'q1234__=: y'
A=: 3 : 'assert. y-:q1234__ [qqq__=: y;q1234__'
NB. A=: 3 : 'smoutput nb z ; TAB ; (crex y);(crex q1234__)'
xx=. BADRAT_uu_
trace_uu_ 0

Q reval_uu_ z=:  '3'
A 3x
Q reval_uu_ z=:  '34'
A 34x
Q reval_uu_ z=:  '3r5'
A 3r5
Q reval_uu_ z=:  '3r5x'
A xx
Q reval_uu_ z=:  '1 2 3'
A xx
Q reval_uu_ z=:  '123j456'
A 123x
Q reval_uu_ z=:  ''
A xx
Q reval_uu_ z=:  '@@'
A xx
Q reval_uu_ z=:  'a:'
A xx
Q reval_uu_ z=:  '1+a:'
A xx
Q reval_uu_ z=:  '3 bulstrode 5'
A xx
Q reval_uu_ z=:  'bulstrode 5'
A xx
Q reval_uu_ z=:  'bulstrode'
A xx
Q reval_uu_ z=:  'PI'
A PI
Q reval_uu_ z=:  'PIE'
A xx
Q reval_uu_ z=:  'PI/2'
A PI%2

Q reval_uu_ z=:  '10^_5'
A 1r100000
Q reval_uu_ z=:  '10^-5'
A 1r100000
Q reval_uu_ z=:  '_10^_5'
A _1r100000
Q reval_uu_ z=:  '-10^-5'
A _1r100000

Q reval_uu_ z=:  '10.1^-5'
A 100000r10510100501
Q reval_uu_ z=:  '1z0^-5'
A xx
Q reval_uu_ z=:  '1z0^-1z5'
A xx
Q reval_uu_ z=:  '10.1^-1z5'
A xx
