NB. readd

NB. =========================================================
NB. read text from files, and resolve includes
readtext=: 3 : 0
txt=. pread y
txt=. trimWS delNB txt
inc=. ('<include>' E. txt) > premask txt
if. 0=#inc do. txt return. end.
ndx=. inc i. 1
res=. ndx {. txt
txt=. inc <;.1 txt
for_t. txt do.
  t=. >t
  ndx=. 1 i.~ '</include>' E. t
  if. ndx = #t do.
    throw '101 <include> tag has no closing </include>'
  end.
  f=. filename 9 }. ndx {. t
  t=. (ndx+10) }. t
  h=. ''
  select. tolower _4 {. f
  case. '.ijs' do.
    jcmd pread f
  case. '.sty' do.
    0!:100 pread f
  case. '.txt' do.
    h=. readtext f
  case. do.
    throw '101 Invalid <include> file type: ',f
  end.
  res=. res,h,t
end.
trimWS res
)
