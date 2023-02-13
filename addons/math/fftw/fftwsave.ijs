
FM=: jpath '~Addons/math/fftw/'
TO=: jpath '~addons/math/fftw/'

(TO,'libfftw3-3.dll') fcopynew FM,'libfftw3-3.dll'
(TO,'libfftw3-3_64.dll') fcopynew FM,'libfftw3-3_64.dll'
(TO,'libfftw3.3.dylib') fcopynew FM,'libfftw3.3.dylib'
(TO,'fftw.ijs') fcopynew FM,'fftw.ijs'
(TO,'fftw.ijt') fcopynew FM,'fftw.ijt'

load 'math/fftw'
