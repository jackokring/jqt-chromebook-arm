NB. zlib compress

NB. =========================================================
NB. compress
NB.
NB. level compress data
compress=: 3 : 0
1 compress y
:
dat=. y
len=. >: >. 1.01 * 12 + #dat
'rc res wid j j j'=. zcompress2 ((len$' ');,len),dat;(#dat);x
if. rc do.
  dat
else.
  wid {. res
end.
)