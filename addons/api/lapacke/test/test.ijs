require 'api/lapacke'

cocurrent 'base'
coinsert 'jlapacke'
match=: matchclean;;

NB. =========================================================
NB. DSYEV computes the eigenvalues and, optionally, the left and/or right eigenvectors for SY matrices

tdsyev=: 3 : 0
a=. dzero + a0=. dzero + y
'm n'=. $a
assert. 0= 0{::cdrc=. dsyev LAPACK_ROW_MAJOR;'V';'U';m;a;(1>.n);V=. m$dzero
'R V'=. 5 7{cdrc
echo V;R
echo r=. (clean a0 mp R) match (clean V *"1 R)
0{::r
)

NB. =========================================================
NB. ZHEEV computes the eigenvalues and, optionally, the left and/or right eigenvectors for HE matrices
testdsyev=: 3 : 0
echo 'testdsyev'
m0=. 0 0$dzero
m1=. (+ |:) ?.6 6$10
m2=. 0 0$dzero
assert. tdsyev &> m0;m1;m2
)

tzheev=: 3 : 0
a=. zzero + a0=. zzero + y
'm n'=. $a
assert. 0= 0{::cdrc=. zheev LAPACK_ROW_MAJOR;'V';'U';m;a;(1>.n);V=. m$dzero
'R V'=. 5 7{cdrc
echo V;R
echo r=. (clean a0 mp R) match (clean V *"1 R)
0{::r
)

testzheev=: 3 : 0
echo 'testzheev'
m3=. (+ (+@|:)) j./ ?.2 6 6$10
assert. tzheev m3
)

NB. =========================================================
NB. DGELS ZGELS solves overdetermined or underdetermined systems for GE matrices
tgels=: 4 : 0
zero=. (2|x){::dzero;zzero
'ma mvb'=. y
ma=. zero + ma
'm n'=. $ma
mvb=. zero + ,.^:(2>#@$)mvb
nrhs=. {:@$mvb
NB. row major gave strange error, possibly memory corruption
assert. 0= 0{::cdrc=. dgels`zgels@.x LAPACK_COL_MAJOR;'N';m;n;nrhs;(|:ma);(1>.m);(|:ldb{. mvb);(ldb=. 1>.m>.n)
R=. n{. |: 8{::cdrc
echo R
echo r=. mvb match clean ma mp R
0{::r
)

testgels=: 3 : 0
echo 'testgels'
dma0=. 0 0$0
dmb0=. 0 0$0
dma1=. ?. 10 5$100          NB. match fails for this pair since solution is least squares
dmb1=. ?. 10 3$50
dma2=. ?. 5 10$100
dmb2=. ?. 5 3$50
dma3=. 0 0$0
dvb3=. 0$0
dma4=. ?. 10 5$100          NB. match fails for this pair since solution is least squares
dvb4=. ?. 10$50
dma5=. ?. 5 10$100
dvb5=. ?. 5$50
zma0=. 0 0$zzero
zmb0=. 0 0$zzero
zma1=. j./ ?. 2 10 5$100    NB. match fails for this pair since solution is least squares
zmb1=. j./ ?. 2 10 3$50
zma2=. j./ ?. 2 5 10$100
zmb2=. j./ ?. 2 5 3$50
zma3=. 0 0$zzero
zvb3=. 0$zzero
zma4=. j./ ?. 2 10 5$100    NB. match fails for this pair since solution is least squares
zvb4=. j./ ?. 2 10$50
zma5=. j./ ?. 2 5 10$100
zvb5=. j./ ?. 2 5$50
assert. 0 1 0 0 1 0 +. 0&tgels &> (< dma0;dmb0) , (< dma1;dmb1) , (< dma2;dmb2) , (< dma3;dvb3) , (< dma4;dvb4) , (< dma5;dvb5)
assert. 0 1 0 0 1 0 +. 1&tgels &> (< zma0;zmb0) , (< zma1;zmb1) , (< zma2;zmb2) , (< zma3;zvb3) , (< zma4;zvb4) , (< zma5;zvb5)
)

NB. =========================================================
NB. DGESV ZGESV computes the solution to system of linear equations A * X = B for GE matrices

tgesv=: 4 : 0
'a b'=. y
zero=. x{::dzero;zzero
a=. zero + a [ a0=. zero + a
b=. zero + ,.^:(2>#@$) b [ b0=. zero + ,.^:(2>#@$) b
'm n'=. $a
assert. m=n
assert. m={.$b
assert. 0= 0{::cdrc=. dgesv`zgesv@.x LAPACK_ROW_MAJOR;n;({:$b0);a;(1>.n);(ipv=. n$izero);b;(1>.{:$b)
x=. b=. 7{::cdrc
echo x
echo r=. b0 match clean a0 mp x
0{::r
)

testgesv=: 3 : 0
echo 'testgesv'
ma0=. 0 0$0
mb0=. 0 0$0
ma1=. ?. 10 10$100
mb1=. ?. 10 5$50
ma2=. 0 0$zzero
mb2=. 0 0$zzero
ma3=. j./ ?. 2 10 10$100
mb3=. j./ ?. 2 10 5$50
ma4=. 0 0$0
vb4=. 0$0
ma5=. ?. 10 10$100
vb5=. ?. 10$50
ma6=. 0 0$zzero
vb6=. 0$zzero
ma7=. j./ ?. 2 10 10$100
vb7=. j./ ?. 2 10$50
assert. 0&tgesv &> (< ma0;mb0) , (< ma1;mb1) , (< ma2;mb2)
assert. 1&tgesv &> (< ma3;mb3) , (< ma4;vb4) , (< ma5;vb5) , (< ma6;vb6) , (< ma7;vb7)
)

NB. =========================================================
NB. DGESVD ZGESVD computes the singular value decomposition (SVD) for GE matrices

tgesvd=: 4 : 0
zero=. x{::dzero;zzero
a=. zero + y [ a0=. zero + y
'm n'=. $a
mn=. m<.n
assert. 0= 0{::cdrc=. dgesvd`zgesvd@.x LAPACK_ROW_MAJOR;'A';'A';m;n;a;(1>.n);(S=. mn$dzero);(U=. (,~m)$zero);(1>.m);(VT=. (,~n)$zero);(1>.n);(superb=. mn$dzero)
'S U VT'=. 8 9 11{cdrc
S=. (m-n) diagmat S
echo U;S;VT
echo r=. a0 match clean U mp S mp VT
0{::r
)

testgesvd=: 3 : 0
echo 'testgesvd'
m0=. 0 0$0
m1=. ?.4 4$10
m2=. ?.4 6$10
m3=. ?.6 4$10
m4=. 0 0$zzero
m5=. j./ ?.2 4 4$10
m6=. j./ ?.2 4 6$10
m7=. j./ ?.2 6 4$10
assert. 0&tgesvd &> m0;m1;m2;m3;m4
assert. 1&tgesvd &> m5;m6;m7
)

NB. =========================================================
NB. DPOTRF computes the Cholesky factorization of a real symmetric positive definite matrix A.
NB. ZPOTRF computes the Cholesky factorization of a complex Hermitian positive definite matrix A.

tpotrf=: 4 : 0
zero=. x{::dzero;zzero
a=. zero + y [ a0=. zero + y
'm n'=. $a
assert. m=n
assert. 0= 0{::cdrc=. dpotrf`zpotrf@.x LAPACK_ROW_MAJOR;'L';n;a;(1>.n)
echo L=. ltri a=. 4{::cdrc
echo r=. a0 match L mp +|:L
0{::r
)

testpotrf=: 3 : 0
echo 'testpotrf'
m0=. 0 0$0
m1=. (mp |:) ?.4 4$10
m2=. (mp |:) _25 + ?.10 10$100
m3=. 0 0$zzero
m4=. (mp (+ @ |:)) j./ ?.2 4 4$10
m5=. (mp (+ @ |:)) _25 + j./ ?.2 10 10$100
assert. 0&tpotrf &> m0;m1;m2;m3
assert. 1&tpotrf &> m4;m5
)

NB. =========================================================
NB. DTRTRS ZTRTRS solves a triangular system of the form  A * X = B  or  A**T * X = B

ttrtrs=: 4 : 0
zero=. x{::dzero;zzero
'a b'=. y
a=. zero + a [ a0=. zero + a
b=. zero + ,.^:(2>#@$) b [ b0=. zero + ,.^:(2>#@$) b
'm n'=. $a
assert. m=n
assert. m={.$b
assert. 0= 0{::cdrc=. dtrtrs`ztrtrs@.x LAPACK_ROW_MAJOR;'U';'N';'N';n;({:$b0);a;(1>.n);b;(1>.{:$b)
x=. b=. 9{::cdrc
echo x
echo r=. b0 match clean a0 mp x
0{::r
)

testtrtrs=: 3 : 0
echo 'testtrtrs'
ma0=. 0 0$0
mb0=. 0 0$0
ma1=. utri ?. 10 10$100
mb1=. ?. 10 5$50
ma2=. 0 0$zzero
mb2=. 0 0$zzero
ma3=. utri j./ ?. 2 10 10$100
mb3=. j./ ?. 2 10 5$50
ma4=. 0 0$0
vb4=. 0$0
ma5=. utri 1 >. ?. 10 10$100
vb5=. ?. 10$50
ma6=. 0 0$zzero
vb6=. 0$zzero
ma7=. utri j./ ?. 2 10 10$100
vb7=. j./ ?. 2 10$50
assert. 0&ttrtrs &> (< ma0;mb0) , (< ma1;mb1) , (< ma2;mb2)
assert. 1&ttrtrs &> (< ma3;mb3) , (< ma4;vb4) , (< ma5;vb5) , (< ma6;vb6) , (< ma7;vb7)
)

NB. =========================================================
NB. DGEES ZGEES computes the eigenvalues, the Schur form, and, optionally, the matrix of Schur vectors for GE matrices

tgees=: 4 : 0
zero=. x{::dzero;zzero
a=. zero + y [ a0=. zero + y
'm n'=. $a
assert. m=n
if. 0=x do.
  assert. 0= 0{::cdrc=. dgees LAPACK_ROW_MAJOR;'V';'N';0;n;a;(1>.n);(,_1);(WR=. n$dzero);(WI=. n$dzero);(Z=. (,~n)$dzero);(1>.n)
  'a WR WI Z'=. 6 9 10 11{cdrc
  W=. WR j. WI
else.
  assert. 0= 0{::cdrc=. zgees LAPACK_ROW_MAJOR;'V';'N';0;n;a;(1>.n);(,_1);(W=. n$zzero);(Z=. (,~n)$zzero);(1>.n)
  'a W Z'=. 6 9 10{cdrc
end.
T=. a
echo Z;T;W
echo r=. a0 match clean Z mp T mp +|:Z
0{::r
)

testgees=: 3 : 0
echo 'testgees'
m0=. 0 0$0
m1=. ?.6 6$10
m2=. 0 0$zzero
m3=. j./ ?.2 6 6$10
assert. 0&tgees &> m0;m1;m2
assert. 1&tgees m3
)

NB. =========================================================
NB. DGETRF ZGETRF computes an LU factorization of a general M-by-N matrix A using partial pivoting with row interchanges.

tgetrf=: 4 : 0
zero=. x{::dzero;zzero
a=. zero + y [ a0=. zero + y
'm n'=. $a
mn=. m<.n
assert. 0= 0{::cdrc=. dgetrf`zgetrf@.x LAPACK_ROW_MAJOR;m;n;a;(1>.n);ipiv=. mn$izero

'a ipiv'=. 4 6{cdrc
u=. l=. izero
l=. (idmat m,n) + sltri a
if. m < n do.
  l=. (_,mn) {. l
end.
u=. utri a
if. m > n do.
  u=. (mn,_) {. u
end.

echo l;u;ipiv
echo r=. a0 match ipiv invperm~ l mp u
0{::r
)

testgetrf=: 3 : 0
echo 'testgetrf'
m0=. 0 0$0
m1=. ?.4 6$10
m2=. ?.6 4$10
m3=. ?.6 6$10
m4=. 0 0$zzero
m5=. j./ ?. 2 4 6$10
m6=. j./ ?.2 6 4$10
m7=. j./ ?.2 6 6$10
assert. 0&tgetrf &> m0;m1;m2;m3
assert. 1&tgetrf &> m4;m5;m6;m7
)

NB. =========================================================
NB. DGEQRF ZGEQRF computes a QR factorization of a real M-by-N matrix A: A = Q * R.

tgeqrf=: 4 : 0
zero=. x{::dzero;zzero
a=. zero + y [ a0=. zero + y
'm n'=. $a
k=. m<.n
assert. 0= 0{::cdrc=. dgeqrf`zgeqrf@.x LAPACK_ROW_MAJOR;m;n;a;(1>.n);tau=. (1>.k)$zero

q=. h=. r=. izero

val=. a=. 4{::cdrc
tau=. 6{::cdrc
h=. (m,k) {. (idmat m,n) + sltri val
r=. k {. utri val
q=. (m,k) {. mp/ (idmat m) -"2 tau * (* +)"0/~"1 |: h

echo q;r
echo r=. a0 match q mp r
0{::r
)

testgeqrf=: 3 : 0
echo 'testgeqrf'
m0=. 0 0$0
m1=. ?.4 6$10
m2=. ?.6 4$10
m3=. ?.6 6$10
m4=. 0 0$zzero
m5=. j./ ?. 2 4 6$10
m6=. j./ ?.2 6 4$10
m7=. j./ ?.2 6 6$10
assert. 0&tgeqrf &> m1;m2;m3
assert. 1&tgeqrf &> m5;m6;m7
)

testdsyev''
testzheev''
testgels''
testgesv''
testgesvd''
testpotrf''
testtrtrs''
testgees''
testgetrf''
testgeqrf''
