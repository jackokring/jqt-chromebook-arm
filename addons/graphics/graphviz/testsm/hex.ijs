NB. C-style Hex
NB.
NB. Issues:
NB.   - incomplete, need i=:_1

coclass 'phex'

require '~addons/graphics/graphviz/smgraph.ijs'

mj=: 256$0                              NB. Z other
mj=: 1 (a.i.'x')}mj                     NB. 'x'
mj=: 2 (a.i.'0')}mj                     NB. 0
mj=: 3 (a.i.'123456789ABCDEFabcdef')}mj NB. 1-9A-Fa-f = N


sj=: _2]\"1 }.".;._2 (0 : 0) 
' Z    x    0    N ']0
 0 0  0 0  1 1  0 0 NB. 0 Initial
 0 0  2 0  0 0  0 0 NB. 1 0
 0 3  0 3  2 0  2 0 NB. 2 0x[0-9A-Fa-f]
)

states=: 'Z0x'
inputs=: 'Zx0N'

(states;inputs) smview sj

f=: (0;sj;mj)&;:
d=: (5;sj;mj)&;:

0 : 0
f_phex_'qqq0x30x30x40x0xxxx'
f_phex_'qqq0x30x30x40x0xx0zxx'
f_phex_'qqq0x30x30x40x0xxx0zxxxx0zxx'
d_phex_'qqq0x30x30x40x0xx0zxx'
)
