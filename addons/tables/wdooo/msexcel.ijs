NB. Excel using vtable oleautomation
NB. only works if ms office excel has been installed

require 'tables/wdooo'

cocurrent 'base'
coinsert 'excelh'

NB. MS Office Excel
test=: 3 : 0
(1!:1 <jpath '~addons/tables/wdooo/test1.xls',(y-.@-:'')#'x') 1!:2 <f1=. jpath '~temp/test1.xls',(y-.@-:'')#'x'
smoutput f1
acp=. 'kernel32 GetACP > i'&cd''
p=. '' conew 'wdooo'
try.
  'base temp'=. olecreate__p 'Excel.Application'
  if. 1252 950 936 -.@e.~ acp do.
    oleput__p base ; 'decimalseparator' ; ,'.'
    oleput__p base ; 'thousandsseparator' ; ,','
    VT_BOOL oleput__p base ; 'usesystemseparators' ; 0
  end.
  oleget__p base ; 'workbooks'
  wb=. oleid__p temp
  olemethod__p wb ; 'open' ; f1
  oleget__p base ; 'activeworkbook'
  awb=. oleid__p temp
  oleget__p awb ; 'worksheets' ; 1     NB. sheet 1-base
  aws=. oleid__p temp
NB. write string into a cell
  oleget__p aws ; 'range' ; xlcell 3 10
  range=. oleid__p temp
  oleput__p range ; 'numberformat' ; '@'
  oleput__p range ; 'value2' ; 'Ms Excel'
NB. read string
  oleget__p range ; 'value2'
  smoutput olevalue__p temp
  olerelease__p range
NB. write number into a cell
  oleget__p aws ; 'range' ; xlcell 4 10
  range=. oleid__p temp
  oleput__p range ; 'value2' ; 123
  oleput__p range ; 'HorizontalAlignment' ; xlHAlignRight
NB. read number
  oleget__p range ; 'value2'
  smoutput olevalue__p temp
  olerelease__p range
NB. write date into a cell
  oleget__p aws ; 'range' ; xlcell 5 10
  range=. oleid__p temp
  if. 1251 e.~ acp do.
    oleput__p range ; 'numberformat' ; ucp 'ДД.ММ.ГГГГ'
  else.
    oleput__p range ; 'numberformat' ; 'yyyy-mmm-dd'
  end.
  oleput__p range ; 'value2' ; (-&36522) 76533        NB. 2007-2-28
NB. read date
  oleget__p range ; 'value2'
  smoutput (+&36522) olevalue__p temp
  olerelease__p range
NB. write number using safearray
  oleget__p aws ; 'range' ; xlrange 2 12 5 14
  range=. oleid__p temp
  sa=. '' olesafearray__p i. 3 4
  oleput__p range ; 'value2' ; <<sa
  olevarfree__p sa
NB. read safearray
  oleget__p range ; 'value2'
  smoutput olevalue__p temp
  olerelease__p range
NB. write string using safearray
  oleget__p aws ; 'range' ; xlrange 2 22 5 24
  range=. oleid__p temp
  oleput__p range ; 'numberformat' ; '@'
  sa=. '' olesafearray__p 3 4$'cat';'dog  ';'123'   NB. trailing blanks
  oleput__p range ; 'value2' ; <<sa
  olevarfree__p sa
NB. read safearray
  oleget__p range ; 'value2'
  smoutput olevalue__p temp
  olerelease__p range
NB. write box using safearray of variant
  oleget__p aws ; 'range' ; xlrange 2 32 5 34
  range=. oleid__p temp
  sa=. '' olesafearray__p 3 4$'cat';123.45;'tiger'
  oleput__p range ; 'value2' ; <<sa
  olevarfree__p sa
NB. read safearray
  oleget__p range ; 'value2'
  smoutput olevalue__p temp
  olerelease__p range
NB. save and cleanup
  (olerelease__p ::0:) aws
  if. 1252 950 936 -.@e.~ acp do.
    VT_BOOL oleput__p base ; 'usesystemseparators' ; 1
  end.
  VT_BOOL (oleput__p ::0:) base ; 'DisplayAlerts' ; 0
  (olemethod__p ::0:) awb ; 'save'
  (olemethod__p ::0:) awb ; 'close'
  (olerelease__p ::0:) awb
  (olerelease__p ::0:) wb
  (olemethod__p ::0:) base ; 'quit'
  smoutput 'success'
catch.
  smoutput 'error'
  smoutput oleqer__p ''
  try.
    VT_BOOL (oleput__p ::0:) base ; 'DisplayAlerts' ; 0
    (olemethod__p ::0:) base ; 'quit'
  catch. end.
end.
destroy__p ''
)

NB. 0-base col row
xlcell=: 3 : 0
'c r'=. y
f=. 26&#.
efn=. 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' {~ }.@(1&, -&.f 1 #~ #)@(f inv)
(efn 1+c),":1+r
)

NB. 0-base col1 row1 col2 row2
xlrange=: 3 : 0
(xlcell 2{.y),':',xlcell _2{.y
)

NB. sample output
NB.    load'tables/wdooo'
NB.    load'~addons/tables/wdooo/msexcel.ijs'
NB.    test''
NB. h:\jusr\j602\user\temp\test1.xls
NB. Ms Excel
NB. 123
NB. 76533
NB. +-+-+--+--+
NB. |0|1|2 |3 |
NB. +-+-+--+--+
NB. |4|5|6 |7 |
NB. +-+-+--+--+
NB. |8|9|10|11|
NB. +-+-+--+--+
NB. +-----+-----+-----+-----+
NB. |cat  |dog  |123  |cat  |
NB. +-----+-----+-----+-----+
NB. |dog  |123  |cat  |dog  |
NB. +-----+-----+-----+-----+
NB. |123  |cat  |dog  |123  |
NB. +-----+-----+-----+-----+
NB. +------+------+------+------+
NB. |cat   |123.45|tiger |cat   |
NB. +------+------+------+------+
NB. |123.45|tiger |cat   |123.45|
NB. +------+------+------+------+
NB. |tiger |cat   |123.45|tiger |
NB. +------+------+------+------+
NB. success
NB. 1
