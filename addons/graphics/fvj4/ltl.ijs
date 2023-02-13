NB. Larger than life automata in 1 and 2 dimensions
NB. Cliff Reiter March 2017

load '~addons/graphics/fvj4/automata.ijs'

NB. 1-d
LtL1d=: 1 : 0
'r a b c d'=.m
nl=.(a&<: *. <:&b)@:(+/)
rl=.(c&<: *. <:&d)@:(+/)
cen=.r&{
lltl=.(nl`rl@.cen)
(1+2*r)&(lltl;._3 f.)@:(r nperext)
)

NB. 1-d with most recent time to alive
LtL1dt=: 1 : 0
'r a b c d'=.m
nl=.(_1 * a&<: *. <:&b)@:(+/)
rl=.(c&<: *. <:&d)@:(+/)
cen=.r&{
lltl=.(nl`rl@.cen)
(((1+>./)@[*_1&=@])+(*1&=@])) (1+2*r)&(lltl;._3 f.)@:(r nperext)@:*
)

NB. 2-d
LtL=: 1 : 0
'r a b c d'=.m
nl=.(a&<: *. <:&b)@:(+/)
rl=.(c&<: *. <:&d)@:(+/)
cen=.(2*r*r+1)&{
lltl=.(nl`rl@.cen)@,
(2#1+2*r)&(lltl;._3 f.)@:(r nperext2)
)

NB. 2-d with most recent timme to alive
LtLt=: 1 : 0
'r a b c d'=.m
nl=.(_1 * a&<: *. <:&b)@:(+/)
rl=.(c&<: *. <:&d)@:(+/)
cen=.(2*r*r+1)&{
lltl=.(nl`rl@.cen)@,
(((1+>./@:,)@[*_1&=@])+(*1&=@])) (2#1+2*r)&(lltl;._3 f.)@:(r nperext2)@:*
)

try_some_examples=:0 : 0



)











