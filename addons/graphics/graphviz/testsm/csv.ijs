NB. CSV without Quotes
NB.
NB. Issues:
NB.   - empty values use ',', possibility to strip

coclass 'pcsv'

require '~addons/graphics/graphviz/smgraph.ijs'

mj=: a.e.',;|'

sj=: _2]\"1 }.".;._2 (0 : 0) 
' X    C ']0
 3 1  1 1  NB. 0 Initial
 3 2  1 2  NB. 1 First comma
 3 1  2 2  NB. 2 Comma
 3 0  2 2  NB. 3 Other
)

states=: 'ifcx'
inputs=: 'xc'

(states;inputs) smview sj

f=: (0;sj;mj)&;:
d=: (5;sj;mj)&;:

0 : 0
f_pcsv_'abc'
f_pcsv_'a,bc,,,,cd,,'
f_pcsv_',;|a'
d_pcsv_',;|a'
)
