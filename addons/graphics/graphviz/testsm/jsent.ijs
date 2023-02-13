coclass 'pjsent'

require '~addons/graphics/graphviz/smgraph.ijs'

mjx=: ' ';(a.{~,65 97+/i.26);'0123456789_';'.';':';''''
t=. 0 7 2$0
NB. S A 9 D C Q X
t=.t,_2]\ 0 0 2 1 3 1 1 1 1 1 4 1 1 1 NB. 0 space
t=.t,_2]\ 0 3 2 2 3 2 1 0 1 0 4 2 1 2 NB. 1 other
t=.t,_2]\ 0 3 2 0 2 0 1 0 1 0 4 2 1 2 NB. 2 alphanumeric
t=.t,_2]\ 0 5 3 0 3 0 3 0 1 0 4 4 1 4 NB. 3 numeric
t=.t,_2]\ 4 0 4 0 4 0 4 0 4 0 5 0 4 0 NB. 4 quote
t=.t,_2]\ 0 3 2 2 3 2 1 2 1 2 4 0 1 2 NB. 5 even quotes
sjx=: t

states=: 'sxa9qQ'
inputs=: 'sa9dcqx'

(states;inputs) smview sjx
