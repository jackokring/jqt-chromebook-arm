load '~addons/math/fftw/fftw.ijs'

dfft=: 3 : '+/ y * ^ (#y) %~ (- o. 0j2 ) * */~ i.#y'
times=: 0.125 * i.32

freqs=: 3 : 0
'len size'=. 2 {. y,1
assert 0=2|len
s=. (len * size) %~ i.>:-:len
(}:s), - |. }.s

)

NB. h(t)=exp(-t) for t>0; h(t)=0 for t<0; h(0)=0.5
h=: 3 : 0
p=. y > 0
r=. (^ - p # y) (bx p)} y * 0
r + 0.5 * y=0
)

NB. ========

t0=: 3 : 0
(dfft -: fftw) i.8
)

NB. APL+WIN examples:

t1=: 3 : 0
s=. fftw h times
)
