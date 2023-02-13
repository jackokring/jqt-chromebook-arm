NB. init
NB.
NB. File   filename
NB. Type   file type
NB. Shape  shape

coclass 'ppubxobject'

Shape=: ''

NB. =========================================================
create=: 3 : 0
coinsert locP=: COCREATOR
NAME=: 'Im',":#XObjects
XObjects__locS=: XObjects,coname''
)

NB. =========================================================
add=: 3 : 0
File=: filename y
Type=: tolower (1+File i: '.') }. File
if. Type -: 'jpeg' do. Type=: 'jpg' end.
if. -. (<Type) e. 'bmp';'jpg' do.
  throw '101 Image file not supported: ',FILE
end.
Shape=: readshape''
)

NB. =========================================================
read=: 3 : 0
('read',Type)~File
)

NB. =========================================================
readshape=: 3 : 0
dat=. read''
select. Type
case. 'bmp' do.
  $dat
case. 'jpg' do.
  readjpgshape dat
end.
)
