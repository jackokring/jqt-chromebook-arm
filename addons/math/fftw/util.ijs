NB. fftw utils
NB.
NB. cd            15!:0
NB. clean         clean numbers near 0
NB. info          cover for sminfo
NB. matchclean    if clean x-y is all 0

zzero=: 1j1-1j1

3 : 0''
if. UNAME-:'Linux' do.
  DLL=: 'libfftw3.so.3'
elseif. UNAME-:'Darwin' do.
  DLL=: '"',~'"',jpath '~addons/math/fftw/libfftw3.3.dylib'
  if. 0=fexist '"'-.~ DLL do. DLL=: 'libfftw3.3.dylib' end.
elseif. UNAME-:'Win' do.
  DLL=: '"',~'"',jpath '~addons/math/fftw/libfftw3-3', (IF64#'_64'), '.dll'
  if. 0=fexist '"'-.~ DLL do. DLL=: 'libfftw3-3', (IF64#'_64'), '.dll' end.
elseif. do.
  DLL=: ''
end.
)

FFTW_FORWARD=: _1
FFTW_BACKWARD=: 1
FFTW_ESTIMATE=: 6 (33 b.) 1
FFTW_MEASURE=: 0

FFTW_VERSION=: 3.2

cd=: 15!:0

info=: sminfo @ ('FFTW'&;)

matchclean=: 0: *./ . = clean @ , @: -

NB. =========================================================
NB.*clean v clean numbers to tolerance (default 1e_10)
NB. sets values less than tolerance to 0
clean=: (1e_10&$:) : (4 : 0)
if. L. y do.
  x clean each y
else.
  if. 16 ~: 3!:0 y do.
    y * x <: |y
  else.
    j./"1 y* x <: | y=. +.y
  end.
end.
)
