NB. CSV with Quotes
NB.
NB. Issues:
NB.   - strip quotes

coclass 'pcsv'

require '~addons/graphics/graphviz/smgraph.ijs'

mj=: 2-'",'i.a.  NB. X:0, C:1, Q:2

sj=: _2]\"1 }.".;._2 (0 : 0) 
' X    C    Q ']0
 3 1  1 1  4 1  NB. 0 Initial
 3 2  1 2  4 2  NB. 1 First comma
 3 1  2 2  4 1  NB. 2 Comma
 3 0  2 2  3 0  NB. 3 Other
 4 0  4 0  5 0  NB. 4 quote
 3 0  2 2  4 0  NB. 5 Quote in quote
)

states=: 'ifcxqQ'
inputs=: 'xcq'

(states;inputs) smview sj

f=: (0;sj;mj)&;:
d=: (5;sj;mj)&;:

0 : 0
f_pcsv_'abc'
f_pcsv_'a,bc,,,,cd,,'
f_pcsv_',a'
f_pcsv_',,a'
d_pcsv_',,a'
f_pcsv_'fld1,fld2,fd3'
f_pcsv_'1,2,3'
f_pcsv_'a,b,c'
f_pcsv_'aa,12,cc'
f_pcsv_'"one,two",three,four'
f_pcsv_'one,"two,three",four'
f_pcsv_'"""quote""",12,"quote""inside"'
f_pcsv_'"12,34","qq,zz","12 ""34"", 56"'
f_pcsv_'empty,,there'
f_pcsv_'1,2,3'
f_pcsv_'1,23"45,6'
f_pcsv_'1,23""45,6'
f_pcsv_'1,23""",6'
)
