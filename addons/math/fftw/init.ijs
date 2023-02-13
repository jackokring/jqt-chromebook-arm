NB. init

coclass 'jfftw'
NB. z definitions:

fftw_z_=: (_1 & fftwnd_jfftw_) :. (1 & fftwnd_jfftw_)
ifftw_z_=: (1 & fftwnd_jfftw_) :. (_1 & fftwnd_jfftw_)
