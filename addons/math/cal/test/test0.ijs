smoutput<>|.(jpathsep>(4!:4<'zx'){4!:3'');zx=.'cal test0 - expandedPath'
0 :0
Friday 23 August 2019  13:56:36
)
cocurrent 'cal'
Q=: 3 : 'q1234__=: y'
A=: 3 : 'assert. y-:q1234__ [q5678__=: y'
test=: 3 : 0
smoutput '>>> test: Q…'
smoutput q1234__
smoutput '>>> test: A…'
smoutput q5678__
)

start '$'          NB. start with factory SAMPLE
NB. start ''       NB. start with NO t-table


3 : 0 '' NB. THE FOLLOWING TESTS ARE ONLY VALID FOR LOADFORMAT=1 …
if. 1~:LOADFORMAT do.
Q=: ]
A=: ]
end.
i.0 0
)


Q expandedPath '$'
A '/users/ianclark/documents/github/math_cal/SAMPLE.tbx'
Q expandedPath ,'$'
A '/users/ianclark/documents/github/math_cal/SAMPLE.tbx'
NB. The next one will vary by whether there's a saved SAMPLE
NB. Q expandedPath '$$'
NB. A '/users/ianclark/tabula-user/SAMPLE.tbx'
Q expandedPath '$1'
A '/users/ianclark/documents/github/math_cal/SAMPLE1.tbx'
Q expandedPath '1'
A z=.'/users/ianclark/documents/github/math_cal/SAMPLE1.tbx'
Q expandedPath ,'1'
A z
Q expandedPath 1
A z
Q expandedPath 0
A '/users/ianclark/documents/github/math_cal/SAMPLE0.tbx'
Q expandedPath '~/tabula-user/SAMPLE9.ijs'
A '/users/ianclark/tabula-user/SAMPLE9.ijs'
Q expandedPath '~Gitrcal/SAMPLE1.tbx'
A z
Q expandedPath '~Gitrcal/SAMPLE1.ijs'
A '/users/ianclark/documents/github/math_cal/SAMPLE1.ijs'

