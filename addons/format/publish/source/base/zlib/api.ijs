NB. publish zlib
NB.
NB. note - this needs to use the zip addon

z2chr=: 2 & ic
z2num=: _2 & ic

NB. =========================================================
NB. returns success flag
zlibinit=: 3 : 0
if. IFUNIX do.
  p=. unxlib 'z'
else.
  p=. 'zlib1.dll'
  p=. (fexist p) # p
end.
res=. 0 < #p
if. res do.
  zcompress2=: (p,' compress2 + i * *i * i i') & cd
  zuncompress=: (p,' uncompress + i * *i * i') & cd
end.
res
)
