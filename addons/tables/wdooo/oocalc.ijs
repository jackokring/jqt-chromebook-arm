NB. example on openoffice/libreoffice calc
NB. only works if openoffice/libreoffice has been installed

require 'tables/wdooo'

cocurrent 'base'

NB. OpenOffice.org/libreoffice calc
NB. some differences from VBA
NB. cell position is (col,row) and 0-base
NB. usually use olemethod instead of oleget/oleset
NB. file names use URL format eg. file:///C:/test.xls (always forward slash)
NB. might not coerce 1 to VT_BOOL TRUE so need to specify VT_... as left argument
NB. use array argument (discuss later)
test=: 3 : 0
(1!:1 <jpath '~addons/tables/wdooo/test1.xls',(y-.@-:'')#'x') 1!:2 <f=. jpath '~temp/test1.xls',(y-.@-:'')#'x'
smoutput f
p=. '' conew 'wdooo'
try.
  'base temp'=. olecreate__p 'com.sun.star.ServiceManager'
  olemethod__p base ; 'createInstance' ; 'com.sun.star.frame.Desktop'
  desktop=. oleid__p temp
  propVals=. VT_UNKNOWN olevector__p ('Hidden' ; 1 ; VT_BOOL) OOoPropertyValue__p base
  (VT_BSTR, VT_BSTR, VT_I4, VT_ARRAY+VT_UNKNOWN) olemethod__p desktop ; 'loadComponentFromURL' ; (file2url f) ; '_blank' ; 0 ; <<propVals
NB. no need to run "olevarfree__p propVals"
NB. propVals is passed with VT_BYREF so that the callee will free propVals
  doc=. oleid__p temp
  olemethod__p doc ; 'getSheets'
  olemethod__p temp ; 'getByIndex' ; 0
  sheet=. oleid__p temp
  olemethod__p sheet ; 'getCellByPosition' ; 3 ; 9
  olemethod__p temp ; 'SetString' ; 'OOo Calc'
  olemethod__p sheet ; 'getCellByPosition' ; 4 ; 9
  olemethod__p temp ; 'SetValue' ; 123
  olemethod__p sheet ; 'getCellByPosition' ; 5 ; 9
  olemethod__p temp ; 'SetFormula' ; '=DATE(2007;2;28)'
  olemethod__p doc ; 'store'
  VT_BOOL olemethod__p doc ; 'close' ; 1
  olemethod__p desktop ; 'terminate'
NB. clean up
  olerelease__p sheet
  olerelease__p doc
  olerelease__p desktop
  smoutput 'success'
catch.
  smoutput 'error'
  smoutput oleqer__p ''
  try. (olemethod__p ::0:) desktop ; 'terminate' catch. end.
end.
destroy__p ''
)

