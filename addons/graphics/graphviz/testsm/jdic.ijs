coclass 'pjsent'

require '~addons/graphics/graphviz/smgraph.ijs'

mj=: 256$0                     NB. X other
mj=: 1 (a.i.' ')}mj            NB. S space
mj=: 2 (,(a.i.'Aa')+/i.26)}mj   NB. A A-Z a-z excluding N B - modified for beta
mj=: 3 (a.i.'N')}mj            NB. N the letter N
mj=: 4 (a.i.'B')}mj            NB. B the letter B
mj=: 5 (a.i.'0123456789_')}mj  NB. 9 digits and _
mj=: 6 (a.i.'.')}mj            NB. D .
mj=: 7 (a.i.':')}mj            NB. C :
mj=: 8 (a.i.'''')}mj           NB. Q quote

sj=: _2]\"1 }.".;._2 (0 : 0) 
' X    S    A    N    B    9    D    C    Q ']0
 1 1  0 0  2 1  3 1  2 1  6 1  1 1  1 1  7 1  NB. 0 space
 1 2  0 3  2 2  3 2  2 2  6 2  1 0  1 0  7 2  NB. 1 other
 1 2  0 3  2 0  2 0  2 0  2 0  1 0  1 0  7 2  NB. 2 alp/num
 1 2  0 3  2 0  2 0  4 0  2 0  1 0  1 0  7 2  NB. 3 N
 1 2  0 3  2 0  2 0  2 0  2 0  5 0  1 0  7 2  NB. 4 NB
 9 0  9 0  9 0  9 0  9 0  9 0  1 0  1 0  9 0  NB. 5 NB.
 1 4  0 5  6 0  6 0  6 0  6 0  6 0  1 0  7 4  NB. 6 num
 7 0  7 0  7 0  7 0  7 0  7 0  7 0  7 0  8 0  NB. 7 '
 1 2  0 3  2 2  3 2  2 2  6 2  1 2  1 2  7 0  NB. 8 ''
 9 0  9 0  9 0  9 0  9 0  9 0  9 0  9 0  9 0  NB. 9 comment
)

states=: <;._2's x a N NB NB. 9 q Q c '
inputs=: <"0'xsaNB9dcq'

(states ,&< inputs) smview sj
