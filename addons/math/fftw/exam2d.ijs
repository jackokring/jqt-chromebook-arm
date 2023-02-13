

load 'fftw numeric plot trig'
load '~system/extras/labs/system/view2.ijs'
load '~system/packages/math/makemat.ijs'

0 : 0
B=: (utmat 101) * 101 101$102 {. 0 1
B=: (utmat 101) * 101 101$102 {. 0 1 0 0 0 0 1 0 0 0 0 1
B=: (utmat 101) * 101 101$202 {. 0 1 0 0 0 0 1 0 0 0 0 1

B=: 1 (50}) 101 101$0

s=. 20
B=: 1 (<;~(50-<.-:s)+i.s)} 101 101$0


)


sawtooth=: 3 : 0
X=: steps 0 5.9999 100
A=: _1 + 2 | X
hd=: 4
C=: real hd {. fftw A
C=: hd {. fftw A
pd 'reset'
pd A
NB. pd +/ "1 real C *"1 sin 1p1 * X */ 1+i.hd
pd real +/ "1 C *"1 sin 1p1 * X */ 1+i.hd
pd 'show'
)

sawtooth''
