
cocurrent 'base'

load '~Addons/math/fftw/fftw.ijs'

DATA=: j./ (i.64) ,: (i.64) + _5 + ?. 64$10

test0=: 3 : 0
DATA=: j./ (i.8) ,: 0 1 1 2 2 2 3 3
DATA matchclean_jfftw_ ifftw fftw DATA
)
