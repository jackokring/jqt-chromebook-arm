NB. util

NB. =========================================================
NB. dict
dict=: 3 : 0
if. L. y do.
  s=. ; y ,each <LF
else.
  s=. y , (LF ~: {: y) # LF
end.
'<<',LF,s,'>>',LF
)

NB. =========================================================
view=: 3 : 0
viewpdf_j_ OutputFile
EMPTY
)

NB. =========================================================
write=: 3 : 0
while. _1 = y fwrite OutputFile do.
  msg=. 'Unable to write to file: ',OutputFile,LF,LF
  if. #d=. 1!:0 OutputFile do.
    msg=. msg, 'If the file is open in Adobe, close the file and try again.'
    if. 1 query msg do. return. end.
  else.
    info msg,'The file name is invalid.' return.
  end.
end.
EMPTY
)
