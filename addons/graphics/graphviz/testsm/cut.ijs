coclass 'pcut'

require '~addons/graphics/graphviz/smgraph.ijs'

mc=: ' '=a.

sc=: sc=: 2 2 2$ 0 0  1 1   1 0  1 2

states=: 'iw'
inputs=: 'xs'

(states;inputs) smview sc

f=: (0;sc;mc)&;:
d=: (5;sc;mc)&;:

0 : 0
<"1 sc_pcut_
f_pcut_' fourscore and seven years ago, our fathers'
f_pcut_'junk@front zero two'
d_pcut_'junk@front zero two'
)
