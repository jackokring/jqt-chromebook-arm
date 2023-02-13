

load 'fftw numeric plot trig'
load '~system/extras/labs/system/view2.ijs'
load '~system/packages/math/makemat.ijs'

sawtooth=: 3 : 0
X=: steps 0 5.999999 100
A=: _1 + 2 | X
hd=: 16
C=: real hd {. fftw A
CS=: - C % +/C
CS=:  (*C) * (% +/) C
pd 'reset'
pd A
NB. pd real +/ "1 C *"1 sin 1p1 * X */ 1+i.hd
pd +/ CS * sin (i.hd) */ X
pd 'show'
)

sawtooth''
