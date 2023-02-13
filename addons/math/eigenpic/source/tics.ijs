
NB. =========================================================
NB. gettics
NB. get tic positions for data
NB.
NB. form: gettics min;max
NB.
NB. returns minor;ticpositions

gettics=: 3 : 0

def=. 9

'min max'=. y

wid=. max-min

t=. 0.5 1 2 5 10 20 * pow10 <: <. log10 wid
ndx=. +/ def < wid%t

step=. ndx { t
min=. step rnddn min
pos=. min+step*i.>:>.(max-min)%step

max=. 3 + '5' e. ": step
minor=. (1,max) {~ max <: <. 40 % #pos

minor;pos
)
