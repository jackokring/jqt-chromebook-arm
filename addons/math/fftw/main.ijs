NB. fftw

NB. =========================================================
NB.*createplan v create a plan
NB. y = shape ; p_in ; p_out ; direction; flag
NB.
NB.   p_in  = address of in
NB.   p_out = address of out
NB.   direction = FFTW_FORWARD | FFTW_BACKWARD
NB.   flag = FFTW_ESTIMATE | FFTW_MEASURE
createplan=: 3 : 0
'shape p_in p_out dir flag'=. y
assert dir e. FFTW_FORWARD,FFTW_BACKWARD
assert flag e. FFTW_ESTIMATE, FFTW_MEASURE
shape=. ,shape
cmd=. DLL,' fftw_plan_dft + x i *i x x i i'
0 pick cmd cd (#shape);shape;p_in;p_out;dir;flag
)

NB. =========================================================
NB.*destroyplan v destroy a plan
destroyplan=: 3 : 0
cmd=. DLL,' fftw_destroy_plan + n x'
1 [ cmd cd y
)

NB. =========================================================
NB.*fftwnd d n-dimensional FFT
NB. x =  _1 forward
NB.        1 backward
NB. y =  data
fftwnd=: 4 : 0
shp=. $y
if. 0 e. shp do. y return. end.
in=. zzero + , |: y
out=. in * 0
assert x e. _1 1
dir=. x
plan=. createplan shp;(15!:14<'in');(15!:14<'out');dir;FFTW_ESTIMATE
fftwexecute plan
destroyplan plan
res=. |: (|.shp) $ out
if. dir=1 do. res % */shp end.
)

NB. =========================================================
NB.*fftwexecute d one call to n-dimensional FFT
NB. y =  plan
fftwexecute=: 3 : 0
cmd=. DLL,' fftw_execute + n x'
1 [ cmd cd y
)

