require 'dll'
coclass 'olecomerrorh'
DFH=: 3 : 0
if. '0x'-:2{.y=. }:^:('L'={:y) y do.
  d=. 0
  for_nib. ('0123456789abcdef'&i.) tolower 2}.y do.
    d=. nib (23 b.) 4 (33 b.) d
  end.
else.
  d=. 0&". y
end.
if. IF64 *. d > 2147483647 do.
  d=. d-2^32
end.
<. d
)

cheaderconst=: ''&$: : (4 : 0)
if. #x do.
  ({.x)=: {.("1) y
  ({:x)=: DFH&> {:("1) y
end.
,(>{.("1) y),("1) ' =: ',("1) (":@DFH&> {:("1) y) ,("1) LF
)

olecomerrmsg=: 3 : 0
if. y e. OLECOMERRVAL do. ; (,&' ')&.> OLECOMERRCODE #~ OLECOMERRVAL = y else. 'Other error: ', ":y end.
)

(0!:100) ('OLECOMERRCODE' ; 'OLECOMERRVAL') cheaderconst (<;._2)@(,&' ') ;._2 (0 : 0)
S_OK 0
CO_E_ALREADYINITIALIZED 0x800401F1
CO_E_APPDIDNTREG 0x800401FE
CO_E_APPNOTFOUND 0x800401F5
CO_E_APPSINGLEUSE 0x800401F6
CO_E_BAD_PATH 0x80080004
CO_E_CANTDETERMINECLASS 0x800401F2
CO_E_CLASSSTRING 0x800401F3
CO_E_CLASS_CREATE_FAILED 0x80080001
CO_E_DLLNOTFOUND 0x800401F8
CO_E_ERRORINAPP 0x800401F7
CO_E_ERRORINDLL 0x800401F9
CO_E_IIDSTRING 0x800401F4
CO_E_NOTINITIALIZED 0x800401F0
CO_E_OBJISREG 0x800401FC
CO_E_OBJNOTCONNECTED 0x800401FD
CO_E_OBJNOTREG 0x800401FB
CO_E_OBJSRV_RPC_FAILURE 0x80080006
CO_E_RELEASED 0x800401FF
CO_E_SERVER_EXEC_FAILURE 0x80080005
CO_E_SERVER_STOPPING 0x80080008
CO_E_WRONGOSFORAPP 0x800401FA
DISP_E_ARRAYISLOCKED 0x8002000D
DISP_E_BADCALLEE 0x80020010
DISP_E_BADINDEX 0x8002000B
DISP_E_BADPARAMCOUNT 0x8002000E
DISP_E_BADVARTYPE 0x80020008
DISP_E_DIVBYZERO 0x80020012
DISP_E_EXCEPTION 0x80020009
DISP_E_MEMBERNOTFOUND 0x80020003
DISP_E_NONAMEDARGS 0x80020007
DISP_E_NOTACOLLECTION 0x80020011
DISP_E_OVERFLOW 0x8002000A
DISP_E_PARAMNOTFOUND 0x80020004
DISP_E_PARAMNOTOPTIONAL 0x8002000F
DISP_E_TYPEMISMATCH 0x80020005
DISP_E_UNKNOWNINTERFACE 0x80020001
DISP_E_UNKNOWNLCID 0x8002000C
DISP_E_UNKNOWNNAME 0x80020006
E_ABORT 0x80004004
E_ACCESSDENIED 0x80070005
E_FAIL 0x80004005
E_HANDLE 0x80070006
E_INVALIDARG 0x80070057
E_NOINTERFACE 0x80004002
E_NOTIMPL 0x80004001
E_OUTOFMEMORY 0x8007000E
E_PENDING 0x8000000A
E_POINTER 0x80004003
E_UNEXPECTED 0x8000FFFF
TYPE_E_AMBIGUOUSNAME 0x8002802C
TYPE_E_BADMODULEKIND 0x800288BD
TYPE_E_BUFFERTOOSMALL 0x80028016
TYPE_E_CANTCREATETMPFILE 0x80028CA3
TYPE_E_CANTLOADLIBRARY 0x80029C4A
TYPE_E_CIRCULARTYPE 0x80029C84
TYPE_E_DLLFUNCTIONNOTFOUND 0x8002802F
TYPE_E_DUPLICATEID 0x800288C6
TYPE_E_ELEMENTNOTFOUND 0x8002802B
TYPE_E_INCONSISTENTPROPFUNCS 0x80029C83
TYPE_E_INVALIDID 0x800288CF
TYPE_E_INVALIDSTATE 0x80028029
TYPE_E_INVDATAREAD 0x80028018
TYPE_E_IOERROR 0x80028CA2
TYPE_E_LIBNOTREGISTERED 0x8002801D
TYPE_E_NAMECONFLICT 0x8002802D
TYPE_E_OUTOFBOUNDS 0x80028CA1
TYPE_E_QUALIFIEDNAMEDISALLOWED 0x80028028
TYPE_E_REGISTRYACCESS 0x8002801C
TYPE_E_SIZETOOBIG 0x800288C5
TYPE_E_TYPEMISMATCH 0x80028CA0
TYPE_E_UNDEFINEDTYPE 0x80028027
TYPE_E_UNKNOWNLCID 0x8002802E
TYPE_E_UNSUPFORMAT 0x80028019
TYPE_E_WRONGTYPEKIND 0x8002802A
)
cocurrent 'z'

VT_EMPTY=: 0
VT_NULL=: 1
VT_I2=: 2
VT_I4=: 3
VT_R4=: 4
VT_R8=: 5
VT_CY=: 6
VT_DATE=: 7
VT_BSTR=: 8
VT_DISPATCH=: 9
VT_ERROR=: 10
VT_BOOL=: 11
VT_VARIANT=: 12
VT_UNKNOWN=: 13
VT_DECIMAL=: 14
VT_I1=: 16
VT_UI1=: 17
VT_UI2=: 18
VT_UI4=: 19
VT_I8=: 20
VT_UI8=: 21
VT_INT=: 22
VT_UINT=: 23
VT_VOID=: 24
VT_HRESULT=: 25
VT_PTR=: 26
VT_SAFEARRAY=: 27
VT_CARRAY=: 28
VT_USERDEFINED=: 29
VT_LPSTR=: 30
VT_LPWSTR=: 31
VT_RECORD=: 36
VT_FILETIME=: 64
VT_BLOB=: 65
VT_STREAM=: 66
VT_STORAGE=: 67
VT_STREAMED_OBJECT=: 68
VT_STORED_OBJECT=: 69
VT_BLOB_OBJECT=: 70
VT_CF=: 71
VT_CLSID=: 72
VT_BSTR_BLOB=: 16bfff
VT_VECTOR=: 16b1000
VT_ARRAY=: 16b2000
VT_BYREF=: 16b4000
VT_RESERVED=: 16b8000
VT_ILLEGAL=: 16bffff
VT_ILLEGALMASKED=: 16bfff
VT_TYPEMASK=: 16bfff

CLSCTX_INPROC_SERVER=: 16b1
CLSCTX_INPROC_HANDLER=: 16b2
CLSCTX_LOCAL_SERVER=: 16b4
CLSCTX_REMOTE_SERVER=: 16b10
CLSCTX_NO_CODE_DOWNLOAD=: 16b400
CLSCTX_NO_CUSTOM_MARSHAL=: 16b1000
CLSCTX_ENABLE_CODE_DOWNLOAD=: 16b2000
CLSCTX_NO_FAILURE_LOG=: 16b4000
CLSCTX_DISABLE_AAA=: 16b8000
CLSCTX_ENABLE_AAA=: 16b10000
CLSCTX_FROM_DEFAULT_CONTEXT=: 16b20000
CLSCTX_ACTIVATE_32_BIT_SERVER=: 16b40000
CLSCTX_ACTIVATE_64_BIT_SERVER=: 16b80000
CLSCTX_ENABLE_CLOAKING=: 16b100000
CLSCTX_APPCONTAINER=: 16b400000
CLSCTX_ACTIVATE_AAA_AS_IU=: 16b800000
DISPID_PROPERTYPUT=: _3

coclass 'oleutil'
coinsert 'olecomerrorh'

szVARIANT=: IF64{16 24
CLSIDFromProgID=: 'ole32 CLSIDFromProgID i *w *c'&cd
CLSIDFromString=: 'ole32 CLSIDFromString i *w *c'&cd
CoCreateInstance=: 'ole32 CoCreateInstance   i *c i i *c *x'&cd
CoInitializeEx=: 'ole32 CoInitializeEx > i x i'&cd
SafeArrayAccessData=: 'oleaut32 SafeArrayAccessData   s x *x'&cd
SafeArrayCreate=: 'oleaut32 SafeArrayCreate > x s i *i'&cd
SafeArrayCreateVector=: 'oleaut32 SafeArrayCreateVector > x s i i'&cd
SafeArrayDestroy=: 'oleaut32 SafeArrayDestroy > s x'&cd
SafeArrayGetDim=: 'oleaut32 SafeArrayGetDim > i x'&cd
SafeArrayGetLBound=: 'oleaut32 SafeArrayGetLBound   i x i *i'&cd
SafeArrayGetUBound=: 'oleaut32 SafeArrayGetUBound   i x i *i'&cd
SafeArrayGetVartype=: 'oleaut32 SafeArrayGetVartype   i x *s'&cd
SafeArrayPutElement=: 'oleaut32 SafeArrayPutElement > i x *i *'&cd
SafeArrayUnaccessData=: 'oleaut32 SafeArrayUnaccessData > s x'&cd
SysAllocStringLen=: 'oleaut32 SysAllocStringLen > x *w i'&cd
SysFreeString=: 'oleaut32 SysFreeString > i x'&cd
VariantClear=: 'oleaut32 VariantClear > i x'&cd
VariantInit=: 'oleaut32 VariantInit n x'&cd

CoInitializeEx^:IFWIN 0;2
S_OK=: 0
SZI=: IF64{4 8

GUID_NULL=: 16#{.a.
iid_iunknown=: 0 0 0 0 0 0 0 0 192 0 0 0 0 0 0 70{a.
iid_idispatch=: 0 4 2 0 0 0 0 0 192 0 0 0 0 0 0 70{a.
DISPATCH_METHOD=: 1
DISPATCH_PROPERTYGET=: 2
DISPATCH_PROPERTYPUT=: 4
DISPATCH_PROPERTYPUTREF=: 8
lcid=: 1024

'QueryInterface AddRef Release GetTypeInfoCount GetTypeInfo GetIDsOfNames Invoke'=: i.7

vAddRef=: ('1 ', (":AddRef), ' > i x')&cd
vRelease=: ('1 ', (":Release), ' > i x')&cd
vInvoke=: ('1 ', (":Invoke), ' > i x x *c x s *x *x x x')&cd
vGetIDsOfNames=: ('1 ', (":GetIDsOfNames), ' i x *c *x i i *i')&cd

dispid=: 4 : 0
assert. x~:0
y=. uucp y,{.a.
nm=. ,15!:14 <,'y'
'hr r'=. 0 _1 { vGetIDsOfNames x;GUID_NULL;nm;1;0;r=. ,_1
hr, r
)

makevariant=: 4 : 0
assert. x =&# y
if. 0=#y do. 0 return. end.
vargs=. mema szVARIANT * #y
((szVARIANT * #y)#{.a.) memw vargs, 0, (szVARIANT * #y), 2
for_i. i.#y do.
  s=. >i{y [ vt=. >i{x
  if. 32 = 3!:0 s do.
    arr=. vargs + szVARIANT * i
    (memr (>s), 0, szVARIANT, 2) memw arr, 0, szVARIANT, 2
  else.
    cdrc=. VariantInit <arr=. vargs + szVARIANT * i
    arr=. {.>@{:cdrc
    (1 ic vt) memw arr, 0 2 2
    byref=. vt (17 b.) VT_BYREF
    if. byref do. s memw arr, 8 1 4 continue. end.
    select. 16bfff (17 b.) vt
    case. VT_BOOL do.
      (1 ic (s~:0){0 _1) memw arr, 8 2 2
    case. VT_BSTR do.
      bstr=. SysAllocStringLen (];#) uucp ,s
      bstr memw arr, 8 1 4
    case. VT_UI1;VT_I1 do.
      (s{a.) memw arr, 8 1 2
    case. VT_UI2;VT_I2 do.
      (1 ic s) memw arr, 8 2 2
    case. VT_UI4;VT_I4;VT_ERROR do.
      if. IF64 do.
        (2 ic s) memw arr, 8 4 2
      else.
        s memw arr, 8 1 4
      end.
    case. VT_UI8;VT_I8 do.
      if. IF64 do.
        s memw arr, 8 1 4
      else.
        s memw arr, 8 1 4
        ((s<0){0 _1) memw arr, 12 1 4
      end.
    case. VT_R4 do.
      (1 fc s) memw arr, 8 4 2
    case. VT_R8 do.
      s memw arr, 8 1 8
    case. VT_UNKNOWN;VT_DISPATCH do.
      if. 0=#s do.
        0 memw arr, 8 1 4
      else.
        s memw arr, 8 1 4
      end.
    case. VT_EMPTY do.
      0 memw arr, 8 1 4
    case. do.
      assert. 0
    end.
  end.
end.
vargs
)

makedispparms=: 4 : 0
'x named'=. 2{.boxopen x
dispparams=. mema SZI+SZI+4+4
((IF64{4 3)#0) memw dispparams, 0, (IF64{4 3), 4
(x makevariant&|. y) memw dispparams, 0 1 4
(2&ic #y) memw dispparams, (2*SZI), 4 2
if. #named do.
  pdispidNamed=. mema 4*#named
  (2&ic |.named) memw pdispidNamed, 0, (4*#named) ,2
  pdispidNamed memw dispparams, SZI, 1 4
  (2&ic #named) memw dispparams, (IF64{12 20), 4 2
end.
dispparams
)

freedispparms=: 4 : 0
msk=. |.x
if. IF64 do.
  'a b c1'=. memr y, 0 3 4
  c=. c1 (17 b.) 16bffffffff
else.
  'a b c d'=. memr y, 0 4 4
end.
if. a do.
  assert. c = #msk
  if. 1 e. msk do.
    VariantClear@<"0 a+msk# szVARIANT* i.-c
  end.
  memf a
end.
if. b do. memf b end.
memf y
)
olevaralloc=: 3 : 0
f=. mema szVARIANT
(szVARIANT#{.a.) memw f, 0, szVARIANT, 2
cdrc=. VariantInit <f
f=. {.>@{:cdrc
)
olevarfree=: 3 : 0
if. y do.
  memf y [ VariantClear <y
end.
)
coclass 'oleooo'
coinsert 'oleutil'
((<'OOoNumberFormat_') ,&.> ;:'DEFINED DATE TIME CURRENCY NUMBER SCIENTIFIC FRACTION PERCENT TEXT DATETIME LOGICAL UNDEFINED')=: <. 2^i.12
OOoNumberFormat_DATETIME=: OOoNumberFormat_DATE + OOoNumberFormat_TIME
OOoNumberFormat_ALL=: 0
((<'OOoCharWeight_') ,&.> ;:'DONTKNOW THIN ULTRALIGHT LIGHT SEMILIGHT NORMAL SEMIBOLD BOLD ULTRABOLD BLACK')=: 0 50 60 75 90 100 110 150 175 200
((<'OOoHoriJustify_') ,&.> ;:'STANDARD LEFT CENTER RIGHT BLOCK REPEAT')=: i.6
((<'OOoFontUnderline_') ,&.> ;:'NONE SINGLE DOUBLE DOTTED DONTKNOW DASH LONGDASH DASHDOT DASHDOTDOT SMALLWAVE WAVE DOUBLEWAVE BOLD BOLDDOTTED BOLDDASH BOLDLONGDASH BOLDDASHDOT BOLDDASHDOTDOT BOLDWAVE')=: i.19
((<'OOoCellFlags_') ,&.> ;:'VALUE DATETIME STRING ANNOTATION FORMULA HARDATTR STYLES OBJECTS EDITATTR FORMATTED')=: <.2^i.10
OOoinvoke=: 1 : 0
'' (m OOoinvoke) y
:
'disp name temp'=. 3{. y
args=. 3}.y
'x named'=. 2{. x=. boxopen x
oleerrno=: S_OK
if. 0=#x do. x=. (VT_BSTR, VT_BSTR, VT_BSTR, VT_I4, VT_I4, VT_R8, VT_UNKNOWN) {~ 2 131072 262144 1 4 8 i. (3!:0&> args) end.
if. (m e. DISPATCH_PROPERTYPUT, DISPATCH_PROPERTYPUTREF) > (DISPID_PROPERTYPUT e. named) do.
  named=. named, DISPID_PROPERTYPUT
end.
if. S_OK~: 0{:: 'hr id'=. disp dispid name do. hr return. end.
if. temp do. VariantClear <temp end.
msk=. -. (x (17 b.) VT_UNKNOWN) +. (x (17 b.) VT_DISPATCH) +. 32&=@(3!:0)&> args
dispparams=. (x;named) makedispparms args
hr=. vInvoke disp ; id ; GUID_NULL ; 0 ; m ; (<dispparams) ; (<temp) ; 0 ; 0
msk freedispparms dispparams
hr
)
OOoRGB=: 3 : 0
(2{y) (23 b.) 8 (33 b.) (1{y) (23 b.) 8 (33 b.) (0{y)
)
filetoURL=: 3 : 0
path=. y
if. (':' -.@e. path) *. ('/\'-.@e.~{.path) do. path=. (1!:43 ''), '/', path end.
path=. ('/'&,)^:('/'~:{.path) path=. '\/' charsub path
path=. 'file://', path stringreplace~ ' ' ; '%20' ; '#' ; '%23' ; '%' ; '%25' ; '&' ; '%26' ; ';' ; '%3B' ; '<' ; '%3C' ; '=' ; '%3D' ; '>' ; '%3E' ; '?' ; '%3F' ; '~' ; '%7E'
)
OOoCreateStruct=: 4 : 0
disp=. y
name=. x
ostru=. 0
cotmp=. olevaralloc ''
if. S_OK&= hr=. (DISPATCH_METHOD OOoinvoke) disp ; 'Bridge_GetStruct' ; cotmp ; name do.
  vAddRef ostru=. olevalue cotmp
end.
olevarfree cotmp
ostru
)
OOoPutStruct=: 4 : 0
disp=. y
'slot val vts'=. x
({.vts) (DISPATCH_PROPERTYPUT OOoinvoke) disp ; slot ; 0 ; val
)
OOoGetStruct=: 4 : 0
disp=. y
slot=. >x
cotmp=. olevaralloc ''
hr=. (DISPATCH_PROPERTYGET OOoinvoke) disp ; slot ; cotmp
hr ;< cotmp
)
OOoPropertyValue=: 4 : 0
disp=. y
'name value vts'=. 3{.x, a:
if. 0=#vts do.
  vts=. (VT_BSTR, VT_BSTR, VT_BSTR, VT_I4, VT_I4, VT_R8, VT_UNKNOWN) {~ 2 131072 262144 1 4 8 i. (3!:0&> value=. boxopen value)
end.
if. 0~: obj=. 'com.sun.star.beans.PropertyValue' OOoCreateStruct disp do.
  failure=. 1
  whilst. 0 do.
    if. S_OK&~: hr=. ('Name' ; name ; VT_BSTR) OOoPutStruct obj do. break. end.
    if. S_OK&~: hr=. ('Value' ; value ; vts) OOoPutStruct obj do. break. end.
    failure=. 0
  end.
  if. 0=failure do.
    obj
  else.
    0 [ vRelease obj
  end.
else.
  0
end.
)
OOoMakeCellBorderLine=: 4 : 0
disp=. y
'nColor WidthDistance'=. x
if. 0~: obj=. 'com.sun.star.table.BorderLine' OOoCreateStruct disp do.
  failure=. 1
  whilst. 0 do.
    if. S_OK&~: hr=. ('Color' ; nColor ; VT_I4) OOoPutStruct obj do. break. end.
    if. S_OK&~: hr=. ('InnerLineWidth' ; (0{WidthDistance) ; VT_I2) OOoPutStruct obj do. break. end.
    if. S_OK&~: hr=. ('OuterLineWidth' ; (1{WidthDistance) ; VT_I2) OOoPutStruct obj do. break. end.
    if. S_OK&~: hr=. ('LineDistance' ; (2{WidthDistance) ; VT_I2) OOoPutStruct obj do. break. end.
    failure=. 0
  end.
  if. 0=failure do.
    obj
  else.
    0 [ vRelease obj
  end.
else.
  0
end.
)
OOoGetNumberFormat=: 4 : 0
disp=. y
'fmt lang country'=. 3{.(boxopen x), '' ; ''
if. 0~: obj=. 'com.sun.star.lang.Locale' OOoCreateStruct disp do.
  failure=. 1
  cotmp=. olevaralloc ''
  whilst. 0 do.
    if. ''-.@-:lang do.
      if. S_OK&~: hr=. ('Language' ; lang ; VT_BSTR) OOoPutStruct obj do. break. end.
    end.
    if. ''-.@-:country do.
      if. S_OK&~: hr=. ('Country' ; country ; VT_BSTR) OOoPutStruct obj do. break. end.
    end.
    if. S_OK&~: hr=. '' (DISPATCH_METHOD OOoinvoke) disp ; 'getNumberFormats' ; cotmp do. break. end.
    coAddRef nf=. olevalue cotmp
    if. 1 4 e.~ 3!:0 fmt do.
      whilst. 0 do.
        if. S_OK&~: hr=. (VT_I4, VT_UNKNOWN) (DISPATCH_METHOD OOoinvoke) nf ; 'getStandardFormat' ; cotmp ; fmt ; obj do. break. end.
        fmtid=. olevalue cotmp
        failure=. 0
      end.
    else.
      whilst. 0 do.
        coAddRef obj
        if. S_OK&~: hr=. (VT_BSTR, VT_UNKNOWN, VT_BOOL) (DISPATCH_METHOD OOoinvoke) nf ; 'queryKey' ; cotmp ; fmt ; obj ; 1 do. break. end.
        fmtid=. olevalue cotmp
        if. _1=fmtid do.
          if. S_OK&~: hr=. (VT_BSTR, VT_UNKNOWN) (DISPATCH_METHOD OOoinvoke) nf ; 'addNew' ; cotmp ; fmt ; obj do. break. end.
          fmtid=. olevalue cotmp
          failure=. 0
        else.
          failure=. 0
        end.
      end.
    end.
    vRelease nf
  end.
  olevarfree cotmp
  vRelease obj
  if. 0=failure do.
    fmtid
  else.
    _1
  end.
else.
  _1
end.
)
coclass 'excelh'
ssCoerceBool=: 4
ssCoerceErr=: 16
ssCoerceFlow=: 32
ssCoerceFLStr=: 4096
ssCoerceFSRef=: 1024
ssCoerceInt=: 2048
ssCoerceMissing=: 128
ssCoerceMulti=: 64
ssCoerceNil=: 256
ssCoerceNum=: 1
ssCoerceParse=: 16384
ssCoerceRef=: 8
ssCoerceRef3d=: 512
ssCoerceSemiCalced=: 8192
ssCoerceStr=: 2
ssCoerceUncalced=: 32768
Delay=: 2
Normal=: 0
OM=: 1
chSurfaceBackWall=: 0
chSurfaceFloor=: 2
chSurfaceSideWall=: 1
chAxisCrossesAutomatic=: 0
chAxisCrossesCustom=: 3
chAxisGroupingAuto=: 1
chAxisGroupingManual=: 2
chAxisGroupingNone=: 0
chAxisPositionBottom=: _2
chAxisPositionCategory=: _7
chAxisPositionCircular=: _6
chAxisPositionLeft=: _3
chAxisPositionPrimary=: _10
chAxisPositionRadial=: _5
chAxisPositionRight=: _4
chAxisPositionSecondary=: _11
chAxisPositionSeries=: _9
chAxisPositionTimescale=: _7
chAxisPositionTop=: _1
chAxisPositionValue=: _8
chCategoryAxis=: 0
chSeriesAxis=: 3
chTimescaleAxis=: 2
chValueAxis=: 1
chAxisUnitDay=: 0
chAxisUnitMonth=: 2
chAxisUnitQuarter=: 3
chAxisUnitWeek=: 1
chAxisUnitYear=: 4
chBoundaryValueAbsolute=: 1
chBoundaryValuePercent=: 0
chChartLayoutAutomatic=: 0
chChartLayoutHorizontal=: 1
chChartLayoutVertical=: 2
chChartTypeArea=: 29
chChartTypeArea3D=: 60
chChartTypeAreaOverlapped3D=: 61
chChartTypeAreaStacked=: 30
chChartTypeAreaStacked100=: 31
chChartTypeAreaStacked1003D=: 63
chChartTypeAreaStacked3D=: 62
chChartTypeBar3D=: 50
chChartTypeBarClustered=: 3
chChartTypeBarClustered3D=: 51
chChartTypeBarStacked=: 4
chChartTypeBarStacked100=: 5
chChartTypeBarStacked1003D=: 53
chChartTypeBarStacked3D=: 52
chChartTypeBubble=: 27
chChartTypeBubbleLine=: 28
chChartTypeColumn3D=: 46
chChartTypeColumnClustered=: 0
chChartTypeColumnClustered3D=: 47
chChartTypeColumnStacked=: 1
chChartTypeColumnStacked100=: 2
chChartTypeColumnStacked1003D=: 49
chChartTypeColumnStacked3D=: 48
chChartTypeCombo=: _1
chChartTypeCombo3D=: _2
chChartTypeDoughnut=: 32
chChartTypeDoughnutExploded=: 33
chChartTypeLine=: 6
chChartTypeLine3D=: 54
chChartTypeLineMarkers=: 7
chChartTypeLineOverlapped3D=: 55
chChartTypeLineStacked=: 8
chChartTypeLineStacked100=: 10
chChartTypeLineStacked1003D=: 57
chChartTypeLineStacked100Markers=: 11
chChartTypeLineStacked3D=: 56
chChartTypeLineStackedMarkers=: 9
chChartTypePie=: 18
chChartTypePie3D=: 58
chChartTypePieExploded=: 19
chChartTypePieExploded3D=: 59
chChartTypePieStacked=: 20
chChartTypePolarLine=: 42
chChartTypePolarLineMarkers=: 43
chChartTypePolarMarkers=: 41
chChartTypePolarSmoothLine=: 44
chChartTypePolarSmoothLineMarkers=: 45
chChartTypeRadarLine=: 34
chChartTypeRadarLineFilled=: 36
chChartTypeRadarLineMarkers=: 35
chChartTypeRadarSmoothLine=: 37
chChartTypeRadarSmoothLineMarkers=: 38
chChartTypeScatterLine=: 25
chChartTypeScatterLineFilled=: 26
chChartTypeScatterLineMarkers=: 24
chChartTypeScatterMarkers=: 21
chChartTypeScatterSmoothLine=: 23
chChartTypeScatterSmoothLineMarkers=: 22
chChartTypeSmoothLine=: 12
chChartTypeSmoothLineMarkers=: 13
chChartTypeSmoothLineStacked=: 14
chChartTypeSmoothLineStacked100=: 16
chChartTypeSmoothLineStacked100Markers=: 17
chChartTypeSmoothLineStackedMarkers=: 15
chChartTypeStockHLC=: 39
chChartTypeStockOHLC=: 40
chColorAutomatic=: _1
chColorNone=: _2
chCommandAutoCalc=: 1016
chCommandAutoFilter=: 1017
chCommandAverage=: 6045
chCommandBold=: 1052
chCommandByRowCol=: 6032
chCommandChartType=: 6039
chCommandCollapse=: 1013
chCommandConditionalFilter=: 1125
chCommandCount=: 6042
chCommandCut=: 1001
chCommandDeleteSelection=: 1011
chCommandDrill=: 6034
chCommandDrillOut=: 6037
chCommandExpand=: 1012
chCommandFieldList=: 1010
chCommandFilterByMenu=: 1015
chCommandFontColor=: 1057
chCommandFontName=: 1050
chCommandFontSize=: 1051
chCommandInteriorColor=: 1056
chCommandItalic=: 1053
chCommandLaunchDataFinder=: 6027
chCommandLineColor=: 1055
chCommandMax=: 6044
chCommandMin=: 6043
chCommandMoveToCategoryArea=: 6056
chCommandMoveToChartArea=: 6057
chCommandMoveToFilterArea=: 6054
chCommandMoveToSeriesArea=: 6055
chCommandMultiChart=: 6050
chCommandPassiveAlert=: 6026
chCommandRefresh=: 1014
chCommandSelectNextMajor=: 6005
chCommandSelectNextMinor=: 6003
chCommandSelectPrevMajor=: 6004
chCommandSelectPrevMinor=: 6002
chCommandShowAbout=: 1007
chCommandShowAll=: 1121
chCommandShowBottom1=: 1110
chCommandShowBottom10=: 1113
chCommandShowBottom10Percent=: 1118
chCommandShowBottom1Percent=: 1115
chCommandShowBottom2=: 1111
chCommandShowBottom25=: 1114
chCommandShowBottom25Percent=: 1119
chCommandShowBottom2Percent=: 1116
chCommandShowBottom5=: 1112
chCommandShowBottom5Percent=: 1117
chCommandShowBottomNMenu=: 1124
chCommandShowContextMenu=: 6001
chCommandShowDropZones=: 6052
chCommandShowHelp=: 1006
chCommandShowLegend=: 6028
chCommandShowOther=: 1120
chCommandShowPropertyToolbox=: 1005
chCommandShowToolbar=: 6053
chCommandShowTop1=: 1100
chCommandShowTop10=: 1103
chCommandShowTop10Percent=: 1108
chCommandShowTop1Percent=: 1105
chCommandShowTop2=: 1101
chCommandShowTop25=: 1104
chCommandShowTop25Percent=: 1109
chCommandShowTop2Percent=: 1106
chCommandShowTop5=: 1102
chCommandShowTop5Percent=: 1107
chCommandShowTopNMenu=: 1123
chCommandShowWizard=: 6040
chCommandSortAscending=: 2000
chCommandSortAscendingByTotal=: 6035
chCommandSortDescending=: 2031
chCommandSortDescendingByTotal=: 6036
chCommandStdDev=: 6046
chCommandStdDevP=: 6048
chCommandSum=: 6041
chCommandTogglePropertiesInScreenTip=: 6038
chCommandUnderline=: 1054
chCommandUndo=: 1000
chCommandUnifiedScales=: 6051
chCommandVar=: 6047
chCommandVarP=: 6049
chDataGroupingFunctionAverage=: 3
chDataGroupingFunctionMaximum=: 1
chDataGroupingFunctionMinimum=: 0
chDataGroupingFunctionSum=: 2
chLabelPositionAutomatic=: 0
chLabelPositionBottom=: 9
chLabelPositionCenter=: 1
chLabelPositionInsideBase=: 3
chLabelPositionInsideEnd=: 2
chLabelPositionLeft=: 6
chLabelPositionOutsideBase=: 5
chLabelPositionOutsideEnd=: 4
chLabelPositionRight=: 7
chLabelPositionTop=: 8
chDataPointFirst=: 0
chDataPointLast=: 1
chDataSourceTypeDSC=: 5
chDataSourceTypePivotTable=: 3
chDataSourceTypeQuery=: 4
chDataSourceTypeSpreadsheet=: 1
chDataSourceTypeUnknown=: 0
chDimBubbleValues=: 9
chDimCategories=: 1
chDimCharts=: 15
chDimCloseValues=: 6
chDimFilter=: 14
chDimFormatValues=: 16
chDimHighValues=: 7
chDimLowValues=: 8
chDimOpenValues=: 5
chDimRValues=: 10
chDimSeriesNames=: 0
chDimThetaValues=: 11
chDimValues=: 2
chDimXValues=: 4
chDimYValues=: 3
chDrawModeHitTest=: 3
chDrawModePaint=: 1
chDrawModeScale=: 4
chDrawModeSelection=: 2
chDropZoneCategories=: 2
chDropZoneCharts=: 4
chDropZoneData=: 3
chDropZoneFilter=: 0
chDropZoneSeries=: 1
chEndStyleCap=: 2
chEndStyleNone=: 1
chErrorBarMinusValues=: 13
chErrorBarPlusValues=: 12
chErrorBarDirectionX=: 1
chErrorBarDirectionY=: 0
chErrorBarIncludeBoth=: 2
chErrorBarIncludeMinusValues=: 1
chErrorBarIncludePlusValues=: 0
chErrorBarTypeCustom=: 2
chErrorBarTypeFixedValue=: 0
chErrorBarTypePercent=: 1
chNone=: _1
chSolid=: 0
chFillGradientOneColor=: 3
chFillGradientPresetColors=: 5
chFillGradientTwoColors=: 4
chFillPatterned=: 2
chFillSolid=: 1
chFillTexturePreset=: 6
chFillTextureUserDefined=: 7
chGradientDiagonalDown=: 4
chGradientDiagonalUp=: 3
chGradientFromCenter=: 7
chGradientFromCorner=: 5
chGradientHorizontal=: 1
chGradientVertical=: 2
chGradientVariantCenter=: 3
chGradientVariantEdges=: 4
chGradientVariantEnd=: 2
chGradientVariantStart=: 1
chFunctionAvg=: 5
chFunctionCount=: 2
chFunctionDefault=: 6
chFunctionMax=: 4
chFunctionMin=: 3
chFunctionSum=: 1
chLabelOrientationAutomatic=: 1000
chLabelOrientationDownward=: _90
chLabelOrientationHorizontal=: 0
chLabelOrientationUpward=: 90
chLegendPositionAutomatic=: 0
chLegendPositionBottom=: 2
chLegendPositionLeft=: 3
chLegendPositionRight=: 4
chLegendPositionTop=: 1
chLineDash=: 0
chLineDashDot=: 1
chLineDashDotDot=: 2
chLineLongDash=: 4
chLineLongDashDot=: 5
chLineRoundDot=: 6
chLineSolid=: 7
chLineSquareDot=: 8
chLineMiterBevel=: 0
chLineMiterMiter=: 1
chLineMiterRound=: 2
chMarkerStyleCircle=: 8
chMarkerStyleDash=: 7
chMarkerStyleDiamond=: 2
chMarkerStyleDot=: 6
chMarkerStyleNone=: 0
chMarkerStylePlus=: 9
chMarkerStyleSquare=: 1
chMarkerStyleStar=: 5
chMarkerStyleTriangle=: 3
chMarkerStyleX=: 4
chPattern10Percent=: 2
chPattern20Percent=: 3
chPattern25Percent=: 4
chPattern30Percent=: 5
chPattern40Percent=: 6
chPattern50Percent=: 7
chPattern5Percent=: 1
chPattern60Percent=: 8
chPattern70Percent=: 9
chPattern75Percent=: 10
chPattern80Percent=: 11
chPattern90Percent=: 12
chPatternDarkDownwardDiagonal=: 15
chPatternDarkHorizontal=: 13
chPatternDarkUpwardDiagonal=: 16
chPatternDarkVertical=: 14
chPatternDashedDownwardDiagonal=: 28
chPatternDashedHorizontal=: 32
chPatternDashedUpwardDiagonal=: 27
chPatternDashedVertical=: 31
chPatternDiagonalBrick=: 40
chPatternDivot=: 46
chPatternDottedDiamond=: 24
chPatternDottedGrid=: 45
chPatternHorizontalBrick=: 35
chPatternLargeCheckerBoard=: 36
chPatternLargeConfetti=: 33
chPatternLargeGrid=: 34
chPatternLightDownwardDiagonal=: 21
chPatternLightHorizontal=: 19
chPatternLightUpwardDiagonal=: 22
chPatternLightVertical=: 20
chPatternNarrowHorizontal=: 30
chPatternNarrowVertical=: 29
chPatternOutlinedDiamond=: 41
chPatternPlaid=: 42
chPatternShingle=: 47
chPatternSmallCheckerBoard=: 17
chPatternSmallConfetti=: 37
chPatternSmallGrid=: 23
chPatternSolidDiamond=: 39
chPatternSphere=: 43
chPatternTrellis=: 18
chPatternWave=: 48
chPatternWeave=: 44
chPatternWideDownwardDiagonal=: 25
chPatternWideUpwardDiagonal=: 26
chPatternZigZag=: 38
chPivotColAggregates=: _3
chPivotColumns=: _1
chPivotRowAggregates=: _4
chPivotRows=: _2
chPlotAggregatesCategories=: 2
chPlotAggregatesCharts=: 3
chPlotAggregatesFromTotalOrientation=: 4
chPlotAggregatesNone=: 0
chPlotAggregatesSeries=: 1
chGradientBrass=: 20
chGradientCalmWater=: 8
chGradientChrome=: 21
chGradientChromeII=: 22
chGradientDaybreak=: 4
chGradientDesert=: 6
chGradientEarlySunset=: 1
chGradientFire=: 9
chGradientFog=: 10
chGradientGold=: 18
chGradientGoldII=: 19
chGradientHorizon=: 5
chGradientLateSunset=: 2
chGradientMahogany=: 15
chGradientMoss=: 11
chGradientNightfall=: 3
chGradientOcean=: 7
chGradientParchment=: 14
chGradientPeacock=: 12
chGradientRainbow=: 16
chGradientRainbowII=: 17
chGradientSapphire=: 24
chGradientSilver=: 23
chGradientWheat=: 13
chTextureBlueTissuePaper=: 17
chTextureBouquet=: 20
chTextureBrownMarble=: 11
chTextureCanvas=: 2
chTextureCork=: 21
chTextureDenim=: 3
chTextureFishFossil=: 7
chTextureGranite=: 12
chTextureGreenMarble=: 9
chTextureMediumWood=: 24
chTextureNewsprint=: 13
chTextureOak=: 23
chTexturePaperBag=: 6
chTexturePapyrus=: 1
chTextureParchment=: 15
chTexturePinkTissuePaper=: 18
chTexturePurpleMesh=: 19
chTextureRecycledPaper=: 14
chTextureSand=: 8
chTextureStationery=: 16
chTextureWalnut=: 22
chTextureWaterDroplets=: 5
chTextureWhiteMarble=: 10
chTextureWovenMat=: 4
chProjectionModeOrthographic=: 1
chProjectionModePerspective=: 0
chScaleOrientationMaxMin=: 1
chScaleOrientationMinMax=: 0
chScaleTypeLinear=: 0
chScaleTypeLogarithmic=: 1
chSelectionMarksAll=: 1
chSelectionMarksNone=: 0
chSelectionMarksPivot=: 2
chSelectionAxis=: 0
chSelectionCategoryLabel=: 16
chSelectionChart=: 1
chSelectionChartSpace=: 12
chSelectionDataLabel=: 18
chSelectionDataLabels=: 3
chSelectionDropZone=: 17
chSelectionErrorbars=: 4
chSelectionField=: 14
chSelectionGridlines=: 5
chSelectionLegend=: 6
chSelectionLegendEntry=: 7
chSelectionNone=: _1
chSelectionPlotArea=: 2
chSelectionPoint=: 8
chSelectionSeries=: 9
chSelectionSurface=: 13
chSelectionTitle=: 10
chSelectionTrendline=: 11
chSelectionUserDefined=: _2
chSelectModeAdd=: 1
chSelectModeRemove=: 2
chSelectModeReplace=: 0
chSelectModeToggle=: 3
chSeriesByColumns=: 1
chSeriesByRows=: 0
chSizeIsArea=: 1
chSizeIsWidth=: 0
chDataBound=: 0
chDataLinked=: _3
chDataLiteral=: _1
chDataNone=: _2
chStack=: 1
chStackScale=: 2
chStretch=: 3
chStretchPlot=: 5
chTile=: 4
chAllFaces=: 7
chEnd=: 2
chEndSides=: 6
chFront=: 1
chFrontEnd=: 3
chFrontSides=: 5
chProjectFront=: 8
chSides=: 4
chTickMarkAutomatic=: 0
chTickMarkCross=: 4
chTickMarkInside=: 2
chTickMarkNone=: 1
chTickMarkOutside=: 3
chTitlePositionAutomatic=: 0
chTitlePositionBottom=: 2
chTitlePositionLeft=: 3
chTitlePositionRight=: 4
chTitlePositionTop=: 1
chTrendlineTypeExponential=: 0
chTrendlineTypeLinear=: 1
chTrendlineTypeLogarithmic=: 2
chTrendlineTypeMovingAverage=: 5
chTrendlineTypePolynomial=: 3
chTrendlineTypePower=: 4
ctlTypeBoundSpan=: 1
ctlTypeTextBox=: 0
dscAdd=: 1
dscChange=: 5
dscDelete=: 2
dscDeleteComplete=: 6
dscLoad=: 4
dscMove=: 3
dscRename=: 7
dscDataAlertContinue=: 0
dscDataAlertDisplay=: 1
dscAbove=: 1
dscBelow=: 3
dscWithin=: 2
dscDefault=: 0
dscFields=: 2
dscGrid=: 1
dscEUCJ=: 4
dscUCS2=: 2
dscUCS4=: 3
dscUTF16=: 1
dscUTF8=: 0
dscWindows=: 5
dscFull=: 1
dscParameterized=: 2
dscCalculated=: 2
dscGrouping=: 3
dscOutput=: 1
dscParameter=: _1
dscDay=: 6
dscEachValue=: 0
dscHour=: 7
dscInterval=: 9
dscMinute=: 8
dscMonth=: 4
dscPrefix=: 1
dscQuarter=: 3
dscWeek=: 5
dscYear=: 2
dschlAddress=: 2
dschlDisplayedValue=: 0
dschlDisplayText=: 1
dschlFullAddress=: 5
dschlScreenTip=: 4
dschlSubAddress=: 3
dscInnerJoin=: 1
dscLeftOuterJoin=: 2
dscRightOuterJoin=: 3
dscClient=: 0
dscServer=: 1
dscSystem=: _1
dscobjDatamodel=: 512
dscobjGroupingDef=: 256
dscobjLookupRelationship=: 128
dscobjPageField=: 32
dscobjPageRelatedField=: 1024
dscobjPageRowsource=: 16
dscobjParameterValue=: 2048
dscobjRecordsetDef=: 8
dscobjSchemaField=: 2
dscobjSchemaParameter=: 8192
dscobjSchemaProperty=: 16384
dscobjSchemaRelatedField=: 4096
dscobjSchemaRelationship=: 4
dscobjSchemaRowsource=: 1
dscobjSublistRelationship=: 64
dscobjUnknown=: _1
dscOfflineMerge=: 1
dscOfflineNone=: 0
dscOfflineWorkflow=: 3
dscOfflineXMLDataFile=: 2
dscLookup=: 2
dscSublist=: 1
dscSnapshot=: 1
dscUpdatableSnapshot=: 2
dscCommandDSP=: 6
dscCommandFile=: 5
dscCommandText=: 3
dscFunction=: 5
dscInlineFunction=: 6
dscProcedure=: 4
dscTable=: 1
dscTableFunction=: 7
dscView=: 2
dscSaveAsEmbeddedXML=: 0
dscSaveAsXMLDataFile=: 1
dscDeleteCancel=: 1
dscDeleteOK=: 0
dscDeleteUserCancel=: 2
dscAny=: 6
dscAvg=: 2
dscCount=: 5
dscMax=: 4
dscMin=: 3
dscNone=: 0
dscStdev=: 7
dscSum=: 1
dscXMLDataFile=: 1
dscXMLEmbedded=: 0
ecBitmapOpenCloseFolder=: 2
ecBitmapPlusMinus=: 0
ecBitmapUpDownArrow=: 1
owcLineStyleAutomatic=: 1
owcLineStyleDash=: 3
owcLineStyleDashDot=: 5
owcLineStyleDashDotDot=: 6
owcLineStyleDot=: 4
owcLineStyleNone=: 0
owcLineStyleSolid=: 2
owcLineWeightHairline=: 0
owcLineWeightMedium=: 2
owcLineWeightThick=: 3
owcLineWeightThin=: 1
msoLanguageIDExeMode=: 4
msoLanguageIDHelp=: 3
msoLanguageIDInstall=: 1
msoLanguageIDUI=: 2
msoLanguageIDUIPrevious=: 5
msoLanguageIDAfrikaans=: 1078
msoLanguageIDAlbanian=: 1052
msoLanguageIDAmharic=: 1118
msoLanguageIDArabic=: 1025
msoLanguageIDArabicAlgeria=: 5121
msoLanguageIDArabicBahrain=: 15361
msoLanguageIDArabicEgypt=: 3073
msoLanguageIDArabicIraq=: 2049
msoLanguageIDArabicJordan=: 11265
msoLanguageIDArabicKuwait=: 13313
msoLanguageIDArabicLebanon=: 12289
msoLanguageIDArabicLibya=: 4097
msoLanguageIDArabicMorocco=: 6145
msoLanguageIDArabicOman=: 8193
msoLanguageIDArabicQatar=: 16385
msoLanguageIDArabicSyria=: 10241
msoLanguageIDArabicTunisia=: 7169
msoLanguageIDArabicUAE=: 14337
msoLanguageIDArabicYemen=: 9217
msoLanguageIDArmenian=: 1067
msoLanguageIDAssamese=: 1101
msoLanguageIDAzeriCyrillic=: 2092
msoLanguageIDAzeriLatin=: 1068
msoLanguageIDBasque=: 1069
msoLanguageIDBelgianDutch=: 2067
msoLanguageIDBelgianFrench=: 2060
msoLanguageIDBengali=: 1093
msoLanguageIDBosnian=: 4122
msoLanguageIDBrazilianPortuguese=: 1046
msoLanguageIDBulgarian=: 1026
msoLanguageIDBurmese=: 1109
msoLanguageIDByelorussian=: 1059
msoLanguageIDCatalan=: 1027
msoLanguageIDCherokee=: 1116
msoLanguageIDChineseHongKong=: 3076
msoLanguageIDChineseHongKongSAR=: 3076
msoLanguageIDChineseMacao=: 5124
msoLanguageIDChineseMacaoSAR=: 5124
msoLanguageIDChineseSingapore=: 4100
msoLanguageIDCroatian=: 1050
msoLanguageIDCzech=: 1029
msoLanguageIDDanish=: 1030
msoLanguageIDDivehi=: 1125
msoLanguageIDDutch=: 1043
msoLanguageIDDzongkhaBhutan=: 2129
msoLanguageIDEdo=: 1126
msoLanguageIDEnglishAUS=: 3081
msoLanguageIDEnglishBelize=: 10249
msoLanguageIDEnglishCanadian=: 4105
msoLanguageIDEnglishCaribbean=: 9225
msoLanguageIDEnglishIndonesia=: 14345
msoLanguageIDEnglishIreland=: 6153
msoLanguageIDEnglishJamaica=: 8201
msoLanguageIDEnglishNewZealand=: 5129
msoLanguageIDEnglishPhilippines=: 13321
msoLanguageIDEnglishSouthAfrica=: 7177
msoLanguageIDEnglishTrinidad=: 11273
msoLanguageIDEnglishTrinidadTobago=: 11273
msoLanguageIDEnglishUK=: 2057
msoLanguageIDEnglishUS=: 1033
msoLanguageIDEnglishZimbabwe=: 12297
msoLanguageIDEstonian=: 1061
msoLanguageIDFaeroese=: 1080
msoLanguageIDFarsi=: 1065
msoLanguageIDFilipino=: 1124
msoLanguageIDFinnish=: 1035
msoLanguageIDFrench=: 1036
msoLanguageIDFrenchCameroon=: 11276
msoLanguageIDFrenchCanadian=: 3084
msoLanguageIDFrenchCotedIvoire=: 12300
msoLanguageIDFrenchHaiti=: 15372
msoLanguageIDFrenchLuxembourg=: 5132
msoLanguageIDFrenchMali=: 13324
msoLanguageIDFrenchMonaco=: 6156
msoLanguageIDFrenchMorocco=: 14348
msoLanguageIDFrenchReunion=: 8204
msoLanguageIDFrenchSenegal=: 10252
msoLanguageIDFrenchWestIndies=: 7180
msoLanguageIDFrenchZaire=: 9228
msoLanguageIDFrisianNetherlands=: 1122
msoLanguageIDFulfulde=: 1127
msoLanguageIDGaelicIreland=: 2108
msoLanguageIDGaelicScotland=: 1084
msoLanguageIDGalician=: 1110
msoLanguageIDGeorgian=: 1079
msoLanguageIDGerman=: 1031
msoLanguageIDGermanAustria=: 3079
msoLanguageIDGermanLiechtenstein=: 5127
msoLanguageIDGermanLuxembourg=: 4103
msoLanguageIDGreek=: 1032
msoLanguageIDGuarani=: 1140
msoLanguageIDGujarati=: 1095
msoLanguageIDHausa=: 1128
msoLanguageIDHawaiian=: 1141
msoLanguageIDHebrew=: 1037
msoLanguageIDHindi=: 1081
msoLanguageIDHungarian=: 1038
msoLanguageIDIbibio=: 1129
msoLanguageIDIcelandic=: 1039
msoLanguageIDIgbo=: 1136
msoLanguageIDIndonesian=: 1057
msoLanguageIDInuktitut=: 1117
msoLanguageIDItalian=: 1040
msoLanguageIDJapanese=: 1041
msoLanguageIDKannada=: 1099
msoLanguageIDKanuri=: 1137
msoLanguageIDKashmiri=: 1120
msoLanguageIDKashmiriDevanagari=: 2144
msoLanguageIDKashmiriIndia=: 2144
msoLanguageIDKazakh=: 1087
msoLanguageIDKhmer=: 1107
msoLanguageIDKirghiz=: 1088
msoLanguageIDKonkani=: 1111
msoLanguageIDKorean=: 1042
msoLanguageIDKyrgyz=: 1088
msoLanguageIDLao=: 1108
msoLanguageIDLatin=: 1142
msoLanguageIDLatvian=: 1062
msoLanguageIDLithuanian=: 1063
msoLanguageIDMacedonian=: 1071
msoLanguageIDMalayalam=: 1100
msoLanguageIDMalayBruneiDarussalam=: 2110
msoLanguageIDMalaysian=: 1086
msoLanguageIDMaltese=: 1082
msoLanguageIDManipuri=: 1112
msoLanguageIDMaori=: 1153
msoLanguageIDMarathi=: 1102
msoLanguageIDMexicanSpanish=: 2058
msoLanguageIDMixed=: _2
msoLanguageIDMongolian=: 1104
msoLanguageIDNepali=: 1121
msoLanguageIDNone=: 0
msoLanguageIDNoProofing=: 1024
msoLanguageIDNorwegianBokmol=: 1044
msoLanguageIDNorwegianNynorsk=: 2068
msoLanguageIDOriya=: 1096
msoLanguageIDOromo=: 1138
msoLanguageIDPashto=: 1123
msoLanguageIDPolish=: 1045
msoLanguageIDPortuguese=: 2070
msoLanguageIDPunjabi=: 1094
msoLanguageIDRhaetoRomanic=: 1047
msoLanguageIDRomanian=: 1048
msoLanguageIDRomanianMoldova=: 2072
msoLanguageIDRussian=: 1049
msoLanguageIDRussianMoldova=: 2073
msoLanguageIDSamiLappish=: 1083
msoLanguageIDSanskrit=: 1103
msoLanguageIDSerbianCyrillic=: 3098
msoLanguageIDSerbianLatin=: 2074
msoLanguageIDSesotho=: 1072
msoLanguageIDSimplifiedChinese=: 2052
msoLanguageIDSindhi=: 1113
msoLanguageIDSindhiPakistan=: 2137
msoLanguageIDSinhalese=: 1115
msoLanguageIDSlovak=: 1051
msoLanguageIDSlovenian=: 1060
msoLanguageIDSomali=: 1143
msoLanguageIDSorbian=: 1070
msoLanguageIDSpanish=: 1034
msoLanguageIDSpanishArgentina=: 11274
msoLanguageIDSpanishBolivia=: 16394
msoLanguageIDSpanishChile=: 13322
msoLanguageIDSpanishColombia=: 9226
msoLanguageIDSpanishCostaRica=: 5130
msoLanguageIDSpanishDominicanRepublic=: 7178
msoLanguageIDSpanishEcuador=: 12298
msoLanguageIDSpanishElSalvador=: 17418
msoLanguageIDSpanishGuatemala=: 4106
msoLanguageIDSpanishHonduras=: 18442
msoLanguageIDSpanishModernSort=: 3082
msoLanguageIDSpanishNicaragua=: 19466
msoLanguageIDSpanishPanama=: 6154
msoLanguageIDSpanishParaguay=: 15370
msoLanguageIDSpanishPeru=: 10250
msoLanguageIDSpanishPuertoRico=: 20490
msoLanguageIDSpanishUruguay=: 14346
msoLanguageIDSpanishVenezuela=: 8202
msoLanguageIDSutu=: 1072
msoLanguageIDSwahili=: 1089
msoLanguageIDSwedish=: 1053
msoLanguageIDSwedishFinland=: 2077
msoLanguageIDSwissFrench=: 4108
msoLanguageIDSwissGerman=: 2055
msoLanguageIDSwissItalian=: 2064
msoLanguageIDSyriac=: 1114
msoLanguageIDTajik=: 1064
msoLanguageIDTamazight=: 1119
msoLanguageIDTamazightLatin=: 2143
msoLanguageIDTamil=: 1097
msoLanguageIDTatar=: 1092
msoLanguageIDTelugu=: 1098
msoLanguageIDThai=: 1054
msoLanguageIDTibetan=: 1105
msoLanguageIDTigrignaEritrea=: 2163
msoLanguageIDTigrignaEthiopic=: 1139
msoLanguageIDTraditionalChinese=: 1028
msoLanguageIDTsonga=: 1073
msoLanguageIDTswana=: 1074
msoLanguageIDTurkish=: 1055
msoLanguageIDTurkmen=: 1090
msoLanguageIDUkrainian=: 1058
msoLanguageIDUrdu=: 1056
msoLanguageIDUzbekCyrillic=: 2115
msoLanguageIDUzbekLatin=: 1091
msoLanguageIDVenda=: 1075
msoLanguageIDVietnamese=: 1066
msoLanguageIDWelsh=: 1106
msoLanguageIDXhosa=: 1076
msoLanguageIDYi=: 1144
msoLanguageIDYiddish=: 1085
msoLanguageIDYoruba=: 1130
msoLanguageIDZulu=: 1077
navbtnApplyFilter=: 10
navbtnDelete=: 5
navbtnHelp=: 12
navbtnMoveFirst=: 0
navbtnMoveLast=: 3
navbtnMoveNext=: 2
navbtnMovePrev=: 1
navbtnNew=: 4
navbtnSave=: 6
navbtnSortAscending=: 8
navbtnSortDescending=: 9
navbtnToggleFilter=: 11
navbtnUndo=: 7
dscConnectionReset=: 0
dscDataReset=: 1
ocCommandAbout=: 1007
ocCommandAutoCalc=: 1016
ocCommandAutoFilter=: 1017
ocCommandChooser=: 1010
ocCommandCollapse=: 1013
ocCommandCopy=: 1002
ocCommandCut=: 1001
ocCommandExpand=: 1012
ocCommandExport=: 1004
ocCommandHelp=: 1006
ocCommandPaste=: 1003
ocCommandProperties=: 1005
ocCommandRefresh=: 1014
ocCommandSortAsc=: 2000
ocCommandSortDesc=: 2031
ocCommandUndo=: 1000
plArrowModeAccept=: 0
plArrowModeEdit=: 1
plCaretPositionAtEnd=: 0
plCaretPositionAtMouse=: 1
plCommandAbout=: 1007
plCommandAutoAverage=: 12089
plCommandAutoCalc=: 1016
plCommandAutoCount=: 12006
plCommandAutoFilter=: 1017
plCommandAutoMax=: 12008
plCommandAutoMin=: 12007
plCommandAutoStdDev=: 12090
plCommandAutoStdDevP=: 12092
plCommandAutoSum=: 12005
plCommandAutoVar=: 12091
plCommandAutoVarP=: 12093
plCommandBottomRightEdge=: 12017
plCommandCalculated=: 12110
plCommandChooser=: 1010
plCommandClearCustomOrdering=: 12154
plCommandCollapse=: 1013
plCommandConditionalFilter=: 1125
plCommandContextMenu=: 12066
plCommandCopy=: 1002
plCommandCreateCalculatedTotal=: 12102
plCommandCut=: 12157
plCommandDelete=: 1011
plCommandDeleteRow=: 12101
plCommandDemote=: 12039
plCommandDown=: 12029
plCommandDropzones=: 12009
plCommandEndEdit=: 12100
plCommandEnterDetails=: 12024
plCommandExitDetails=: 12025
plCommandExpand=: 1012
plCommandExpandIndicator=: 12051
plCommandExport=: 1004
plCommandExtendBottomRightEdge=: 12108
plCommandExtendDown=: 12075
plCommandExtendLeft=: 12072
plCommandExtendPageDown=: 12079
plCommandExtendPageLeft=: 12076
plCommandExtendPageRight=: 12077
plCommandExtendPageUp=: 12078
plCommandExtendRight=: 12073
plCommandExtendTopLeftEdge=: 12107
plCommandExtendUp=: 12074
plCommandFilter=: 12037
plCommandFilterByMenu=: 12065
plCommandFilterBySel=: 12001
plCommandFormatAlignAutomatic=: 12158
plCommandFormatAlignCenter=: 12142
plCommandFormatAlignLeft=: 12141
plCommandFormatAlignRight=: 12143
plCommandFormatBackColor=: 12148
plCommandFormatBold=: 12062
plCommandFormatComma=: 12061
plCommandFormatCurrency=: 12056
plCommandFormatDate=: 12059
plCommandFormatExponent=: 12058
plCommandFormatForeColor=: 12147
plCommandFormatGeneral=: 12055
plCommandFormatItalic=: 12063
plCommandFormatName=: 12144
plCommandFormatPercent=: 12057
plCommandFormatSize=: 12145
plCommandFormatTime=: 12060
plCommandFormatUnderline=: 12064
plCommandFormatUnderline2=: 12146
plCommandGroupByColumn=: 12035
plCommandGroupByRow=: 12034
plCommandGroupMembers=: 12155
plCommandHelp=: 1006
plCommandHideAllPropertiesInReport=: 12150
plCommandHideAllPropertiesInScreenTip=: 12152
plCommandHideDetails=: 12096
plCommandHyperlink=: 12082
plCommandInsertField=: 12004
plCommandLastDown=: 12023
plCommandLastLeft=: 12020
plCommandLastRight=: 12021
plCommandLastUp=: 12022
plCommandLeft=: 12026
plCommandLeftEdge=: 12014
plCommandMoveMemDown=: 12086
plCommandMoveMemLeft=: 12087
plCommandMoveMemRight=: 12088
plCommandMoveMemUp=: 12085
plCommandNextHorz=: 12012
plCommandNextHorzCell=: 12018
plCommandNextVert=: 12013
plCommandNextVertCell=: 12069
plCommandOpenHyperlinkInPlace=: 12083
plCommandOpenHyperlinkInWindow=: 12084
plCommandPageDown=: 12031
plCommandPageLeft=: 12032
plCommandPageRight=: 12033
plCommandPageUp=: 12030
plCommandPaste=: 1003
plCommandPrevHorz=: 12067
plCommandPrevHorzCell=: 12019
plCommandPrevVert=: 12068
plCommandPrevVertCell=: 12070
plCommandProfile=: 12153
plCommandPromote=: 12038
plCommandProperties=: 1005
plCommandRefresh=: 1014
plCommandRemove=: 12010
plCommandRight=: 12027
plCommandRightEdge=: 12015
plCommandSelectAll=: 12054
plCommandSelectField=: 12052
plCommandSelectRow=: 12053
plCommandShowAll=: 1121
plCommandShowAllPropertiesInReport=: 12149
plCommandShowAllPropertiesInScreenTip=: 12151
plCommandShowAs=: 12134
plCommandShowAsNormal=: 12135
plCommandShowAsPercentOfColumnParent=: 12139
plCommandShowAsPercentOfColumnTotal=: 12137
plCommandShowAsPercentOfGrandTotal=: 12140
plCommandShowAsPercentOfRowParent=: 12138
plCommandShowAsPercentOfRowTotal=: 12136
plCommandShowBottom1=: 1110
plCommandShowBottom10=: 1113
plCommandShowBottom10Percent=: 1118
plCommandShowBottom1Percent=: 1115
plCommandShowBottom2=: 1111
plCommandShowBottom25=: 1114
plCommandShowBottom25Percent=: 1119
plCommandShowBottom2Percent=: 1116
plCommandShowBottom5=: 1112
plCommandShowBottom5Percent=: 1117
plCommandShowBottomNMenu=: 1124
plCommandShowDetails=: 12095
plCommandShowOther=: 1120
plCommandShowTop1=: 1100
plCommandShowTop10=: 1103
plCommandShowTop10Percent=: 1108
plCommandShowTop1Percent=: 1105
plCommandShowTop2=: 1101
plCommandShowTop25=: 1104
plCommandShowTop25Percent=: 1109
plCommandShowTop2Percent=: 1106
plCommandShowTop5=: 1102
plCommandShowTop5Percent=: 1107
plCommandShowTopNMenu=: 1123
plCommandSortAsc=: 2000
plCommandSortDesc=: 2031
plCommandStartEdit=: 12099
plCommandSubtotal=: 12042
plCommandTogglePropertiesInReport=: 12097
plCommandTogglePropertiesInScreenTip=: 12098
plCommandTogglePropertyInReport=: 12900
plCommandTogglePropertyInScreenTip=: 12950
plCommandToolbar=: 12044
plCommandTopLeftEdge=: 12016
plCommandUngroup=: 12036
plCommandUngroupMembers=: 12156
plCommandUp=: 12028
plDataReasonAdhocFieldAdded=: 43
plDataReasonAdhocFieldDeleted=: 44
plDataReasonAdhocMemberChanged=: 45
plDataReasonAllIncludeExcludeChange=: 42
plDataReasonAllowDetailsChange=: 4
plDataReasonAllowMultiFilterChange=: 41
plDataReasonAlwaysIncludeInCubeChange=: 46
plDataReasonCommandTextChange=: 31
plDataReasonConnectionStringChange=: 32
plDataReasonDataMemberChange=: 23
plDataReasonDataSourceChange=: 22
plDataReasonDisplayCalculatedMembersChange=: 10
plDataReasonDisplayCellColorChange=: 49
plDataReasonDisplayEmptyMembersChange=: 19
plDataReasonExcludedMembersChange=: 16
plDataReasonExpressionChange=: 47
plDataReasonFieldNameChange=: 53
plDataReasonFieldSetDeleted=: 39
plDataReasonFieldSetNameChange=: 52
plDataReasonFilterContextChange=: 9
plDataReasonFilterCrossJoinsChange=: 50
plDataReasonFilterFunctionChange=: 8
plDataReasonFilterFunctionValueChange=: 13
plDataReasonFilterOnChange=: 11
plDataReasonFilterOnScopeChange=: 12
plDataReasonGroupEndChange=: 30
plDataReasonGroupIntervalChange=: 27
plDataReasonGroupOnChange=: 24
plDataReasonGroupStartChange=: 26
plDataReasonIncludedMembersChange=: 15
plDataReasonInsertFieldSet=: 0
plDataReasonInsertTotal=: 2
plDataReasonIsFilteredChange=: 28
plDataReasonIsIncludedChange=: 17
plDataReasonMemberPropertyDisplayInChange=: 34
plDataReasonMemberPropertyIsIncludedChange=: 33
plDataReasonOrderedMembersChange=: 29
plDataReasonRecordChanged=: 40
plDataReasonRefreshDataSource=: 51
plDataReasonRemoveFieldSet=: 1
plDataReasonRemoveTotal=: 3
plDataReasonSortDirectionChange=: 5
plDataReasonSortOnChange=: 6
plDataReasonSortOnScopeChange=: 7
plDataReasonSubtotalsChange=: 35
plDataReasonTotalAllMembersChange=: 48
plDataReasonTotalDeleted=: 38
plDataReasonTotalExpressionChange=: 36
plDataReasonTotalFunctionChange=: 20
plDataReasonTotalNameChange=: 14
plDataReasonTotalSolveOrderChange=: 37
plDataReasonUnknown=: 25
plDataReasonUser=: 21
plEditInProgress=: 1
plEditNone=: 0
plExportActionNone=: 0
plExportActionOpenInExcel=: 1
plFilterFunctionBottomCount=: 4
plFilterFunctionBottomPercent=: 6
plFilterFunctionBottomSum=: 8
plFilterFunctionNone=: 0
plFilterFunctionTopCount=: 3
plFilterFunctionTopPercent=: 5
plFilterFunctionTopSum=: 7
plGroupOnDays=: 6
plGroupOnEachValue=: 0
plGroupOnHours=: 7
plGroupOnInterval=: 10
plGroupOnMinutes=: 8
plGroupOnMonths=: 4
plGroupOnPrefixChars=: 1
plGroupOnQtrs=: 3
plGroupOnSeconds=: 9
plGroupOnWeeks=: 5
plGroupOnYears=: 2
plAllDefault=: 0
plAllExclude=: 2
plAllInclude=: 1
plOrientationColumnAxis=: 1
plOrientationDataAxis=: 8
plOrientationFilterAxis=: 4
plOrientationNone=: 0
plOrientationPageAxis=: 16
plOrientationRowAxis=: 2
plFieldSetTypeOther=: 2
plFieldSetTypeTime=: 1
plFieldSetTypeUnknown=: 3
plFieldSetTypeUserDefined=: 4
plSortDirectionAscending=: 1
plSortDirectionCustom=: 4
plSortDirectionCustomAscending=: 5
plSortDirectionCustomDescending=: 6
plSortDirectionDefault=: 0
plSortDirectionDescending=: 2
plTypeCalculated=: 2
plTypeCustomGroup=: 17
plTypeRegular=: 1
plTypeTimeDays=: 9
plTypeTimeHalfYears=: 5
plTypeTimeHours=: 10
plTypeTimeMinutes=: 11
plTypeTimeMonths=: 7
plTypeTimeQuarters=: 6
plTypeTimeSeconds=: 12
plTypeTimeUndefined=: 13
plTypeTimeWeekdays=: 16
plTypeTimeWeeks=: 8
plTypeTimeYears=: 4
plTypeUnknown=: 14
plTypeUserDefined=: 15
plMemberStateChecked=: 2
plMemberStateClear=: 1
plMemberStateGray=: 3
plHAlignAutomatic=: 0
plHAlignCenter=: 2
plHAlignLeft=: 1
plHAlignRight=: 3
plGroupTypeCustomGroup=: 2
plGroupTypeDynamicOther=: 6
plGroupTypeFallThrough=: 3
plGroupTypePlaceHolder=: 4
plGroupTypeRegular=: 1
plGroupTypeStaticOther=: 5
plFindFormatMember=: 0
plFindFormatPathHex=: 3
plFindFormatPathInt=: 2
plFindFormatPathName=: 1
plDisplayPropertyInAll=: 3
plDisplayPropertyInReport=: 1
plDisplayPropertyInScreenTip=: 2
plDisplayPropertyNone=: 0
plMembersCompareByName=: 1
plMembersCompareByUniqueName=: 0
plScrollTypeAll=: 15
plScrollTypeBottom=: 4
plScrollTypeLeft=: 2
plScrollTypeNone=: 0
plScrollTypeRight=: 8
plScrollTypeTop=: 1
plShowAsNormal=: 0
plShowAsPercentOfColumnParent=: 4
plShowAsPercentOfColumnTotal=: 2
plShowAsPercentOfGrandTotal=: 5
plShowAsPercentOfRowParent=: 3
plShowAsPercentOfRowTotal=: 1
plExpandAlways=: 1
plExpandAutomatic=: 0
plExpandNever=: 2
plPivotTableReasonFieldAdded=: 3
plPivotTableReasonFieldSetAdded=: 2
plPivotTableReasonTotalAdded=: 0
plPivotTableReasonTotalDeleted=: 1
plFunctionAverage=: 5
plFunctionCalculated=: 127
plFunctionCount=: 2
plFunctionMax=: 4
plFunctionMin=: 3
plFunctionStdDev=: 6
plFunctionStdDevP=: 10
plFunctionSum=: 1
plFunctionUnknown=: 0
plFunctionVar=: 7
plFunctionVarP=: 11
plTotalTypeCalculated=: 3
plTotalTypeIntrinsic=: 1
plTotalTypeUserDefined=: 2
plViewReasonAlignmentChange=: 18
plViewReasonAllowAdditionsChange=: 64
plViewReasonAllowCustomOrderingChange=: 60
plViewReasonAllowDeletionsChange=: 65
plViewReasonAllowEditsChange=: 63
plViewReasonAllowFilteringChange=: 32
plViewReasonAllowGroupingChange=: 33
plViewReasonAllowPropertyToolbox=: 61
plViewReasonAutoFitChange=: 40
plViewReasonBackColorChange=: 17
plViewReasonCellExpandedChange=: 9
plViewReasonDataChange=: 2
plViewReasonDataMemberCaptionChange=: 72
plViewReasonDetailLeftChange=: 21
plViewReasonDetailLeftOffsetChange=: 48
plViewReasonDetailMaxHeightChange=: 44
plViewReasonDetailMaxWidthChange=: 43
plViewReasonDetailRowHeightChange=: 10
plViewReasonDetailTopChange=: 20
plViewReasonDetailTopOffsetChange=: 47
plViewReasonDisplayInFieldListChange=: 73
plViewReasonDisplayOutlineChange=: 26
plViewReasonDisplayScreenTipsChange=: 68
plViewReasonDisplayToolbarChange=: 37
plViewReasonExpandDetailsChange=: 42
plViewReasonExpandMembersChange=: 62
plViewReasonFieldCaptionChange=: 27
plViewReasonFieldDetailWidthChange=: 11
plViewReasonFieldExpandedChange=: 41
plViewReasonFieldGroupedHeightChange=: 53
plViewReasonFieldGroupedWidthChange=: 12
plViewReasonFieldSetCaptionChange=: 28
plViewReasonFieldSetWidthChange=: 14
plViewReasonFontBoldChange=: 5
plViewReasonFontItalicChange=: 6
plViewReasonFontNameChange=: 3
plViewReasonFontSizeChange=: 4
plViewReasonFontUnderlineChange=: 7
plViewReasonForeColorChange=: 16
plViewReasonHeightChange=: 35
plViewReasonHideDetails=: 59
plViewReasonIsHyperlinkChange=: 49
plViewReasonKillFocus=: 67
plViewReasonLabelCaptionChange=: 29
plViewReasonLabelVisibleChange=: 36
plViewReasonLeftChange=: 23
plViewReasonLeftOffsetChange=: 46
plViewReasonMaxHeightChange=: 38
plViewReasonMaxWidthChange=: 39
plViewReasonMemberCaptionChange=: 30
plViewReasonMemberCaptionsChange=: 70
plViewReasonMemberExpandedChange=: 8
plViewReasonMemberHeightChange=: 54
plViewReasonMemberPropertiesOrderChange=: 52
plViewReasonMemberPropertyCaptionChange=: 51
plViewReasonMemberPropertyDisplayInChange=: 50
plViewReasonMemberWidthChange=: 55
plViewReasonNumberFormatChange=: 19
plViewReasonPropertyCaptionWidthChange=: 71
plViewReasonPropertyHeightChange=: 57
plViewReasonPropertyValueWidthChange=: 56
plViewReasonRightToLeftChange=: 24
plViewReasonSelectionChange=: 0
plViewReasonSetFocus=: 66
plViewReasonShowAsChange=: 69
plViewReasonShowDetails=: 58
plViewReasonSystemColorChange=: 1
plViewReasonToolbarChange=: 74
plViewReasonTopChange=: 22
plViewReasonTopOffsetChange=: 45
plViewReasonTotalCaptionChange=: 31
plViewReasonTotalOrientationChange=: 25
plViewReasonTotalWidthChange=: 15
plViewReasonUseProviderFormattingChange=: 75
plViewReasonViewDetailWidthChange=: 13
plViewReasonWidthChange=: 34
plViewReasonXMLApplied=: 76
plTotalOrientationColumn=: 2
plTotalOrientationRow=: 1
providerTypeMultidimensional=: 3
providerTypeRelational=: 2
providerTypeUnknown=: 1
sectTypeCaption=: 1
sectTypeFooter=: 3
sectTypeHeader=: 2
sectTypeNone=: 0
sectTypeRecNav=: 4
ssAutoFilter=: 15
ssCalculate=: 0
ssClear=: 14
ssCopy=: 7
ssCut=: 6
ssDeleteColumns=: 5
ssDeleteRows=: 4
ssExport=: 9
ssFind=: 13
ssHelp=: 17
ssInsertColumns=: 3
ssInsertRows=: 2
ssPaste=: 8
ssProperties=: 16
ssSortAscending=: 11
ssSortDescending=: 12
ssUndo=: 10
ssExportActionNone=: 0
ssExportActionOpenInExcel=: 1
ssExportAsAppropriate=: 0
ssExportHTML=: 2
ssExportXMLSpreadsheet=: 1
ssFilterFunctionExclude=: 2
ssFilterFunctionInclude=: 1
ssCommandAbout=: 1007
ssCommandAutoFilter=: 10001
ssCommandAutosum=: 10000
ssCommandBold=: 1052
ssCommandClear=: 10002
ssCommandCopy=: 1002
ssCommandCut=: 1001
ssCommandDeleteCols=: 10007
ssCommandDeleteQuery=: 10071
ssCommandDeleteRows=: 10006
ssCommandEat=: 10054
ssCommandEditQuery=: 10070
ssCommandEnterEditMode=: 10038
ssCommandEscape=: 10041
ssCommandExpandDown=: 10033
ssCommandExpandLeft=: 10030
ssCommandExpandMenu=: 10053
ssCommandExpandPageDown=: 10046
ssCommandExpandPageLeft=: 10065
ssCommandExpandPageRight=: 10063
ssCommandExpandPageUp=: 10048
ssCommandExpandRight=: 10032
ssCommandExpandToEndDown=: 10037
ssCommandExpandToEndLeft=: 10034
ssCommandExpandToEndRight=: 10036
ssCommandExpandToEndUp=: 10035
ssCommandExpandToHome=: 10052
ssCommandExpandToLast=: 10043
ssCommandExpandToOrigin=: 10050
ssCommandExpandUp=: 10031
ssCommandExport=: 1004
ssCommandHelp=: 1006
ssCommandInsertCols=: 10009
ssCommandInsertRows=: 10008
ssCommandItalic=: 1053
ssCommandMakeActiveCellVisible=: 10066
ssCommandMoveDown=: 10017
ssCommandMoveLeft=: 10014
ssCommandMoveNext=: 10022
ssCommandMovePageDown=: 10045
ssCommandMovePageLeft=: 10064
ssCommandMovePageRight=: 10062
ssCommandMovePageUp=: 10047
ssCommandMovePrevious=: 10023
ssCommandMoveRight=: 10016
ssCommandMoveToEndDown=: 10029
ssCommandMoveToEndLeft=: 10026
ssCommandMoveToEndRight=: 10028
ssCommandMoveToEndUp=: 10027
ssCommandMoveToHome=: 10051
ssCommandMoveToLast=: 10042
ssCommandMoveToLastInRow=: 10044
ssCommandMoveToOrigin=: 10049
ssCommandMoveUp=: 10015
ssCommandNewSheet=: 10057
ssCommandNextSheet=: 10055
ssCommandOpenHyperlink=: 10073
ssCommandPaste=: 1003
ssCommandPrevSheet=: 10056
ssCommandProperties=: 1005
ssCommandRecalc=: 10059
ssCommandRecalcForce=: 10010
ssCommandRefresh=: 10060
ssCommandRefreshAll=: 10061
ssCommandRefreshData=: 10068
ssCommandSaveData=: 10069
ssCommandScrollDown=: 10021
ssCommandScrollLeft=: 10018
ssCommandScrollRight=: 10020
ssCommandScrollUp=: 10019
ssCommandSelectAll=: 10013
ssCommandSelectArray=: 10058
ssCommandSelectArraySilent=: 10067
ssCommandSelectCol=: 10012
ssCommandSelectRow=: 10011
ssCommandSetChartRange=: 10072
ssCommandShowContextMenu=: 10039
ssCommandSortAsc=: 2000
ssCommandSortAscLast=: 2030
ssCommandSortDesc=: 2031
ssCommandSortDescLast=: 2061
ssCommandTabNext=: 10024
ssCommandTabPrevious=: 10025
ssCommandToggleToolbar=: 10040
ssCommandUnderline=: 1054
ssCommandUndo=: 1000
dscSynchronizationDone=: 1
dscSynchronizing=: 0
eTipTypeAuto=: 2
eTipTypeHTML=: 1
eTipTypeNone=: _1
eTipTypeText=: 0
owcUnderlineStyleDouble=: 2
owcUnderlineStyleDoubleAccounting=: 4
owcUnderlineStyleNone=: 0
owcUnderlineStyleSingle=: 1
owcUnderlineStyleSingleAccounting=: 3
xl24HourClock=: 33
xl4DigitYears=: 43
xlAlternateArraySeparator=: 16
xlColumnSeparator=: 14
xlCountryCode=: 1
xlCountrySetting=: 2
xlCurrencyBefore=: 37
xlCurrencyCode=: 25
xlCurrencyDigits=: 27
xlCurrencyLeadingZeros=: 40
xlCurrencyMinusSign=: 38
xlCurrencyNegative=: 28
xlCurrencySpaceBefore=: 36
xlCurrencyTrailingZeros=: 39
xlDateOrder=: 32
xlDateSeparator=: 17
xlDayCode=: 21
xlDayLeadingZero=: 42
xlDecimalSeparator=: 3
xlGeneralFormatName=: 26
xlHourCode=: 22
xlLeftBrace=: 12
xlLeftBracket=: 10
xlListSeparator=: 5
xlLowerCaseColumnLetter=: 9
xlLowerCaseRowLetter=: 8
xlMDY=: 44
xlMetric=: 35
xlMinuteCode=: 23
xlMonthCode=: 20
xlMonthLeadingZero=: 41
xlMonthNameChars=: 30
xlNoncurrencyDigits=: 29
xlNonEnglishFunctions=: 34
xlRightBrace=: 13
xlRightBracket=: 11
xlRowSeparator=: 15
xlSecondCode=: 24
xlThousandsSeparator=: 4
xlTimeLeadingZero=: 45
xlTimeSeparator=: 18
xlUpperCaseColumnLetter=: 7
xlUpperCaseRowLetter=: 6
xlWeekdayNameChars=: 31
xlYearCode=: 19
xlDiagonalDown=: 5
xlDiagonalUp=: 6
xlEdgeBottom=: 9
xlEdgeLeft=: 7
xlEdgeRight=: 10
xlEdgeTop=: 8
xlInsideHorizontal=: 12
xlInsideVertical=: 11
xlHairline=: 1
xlMedium=: _4138
xlThick=: 4
xlThin=: 2
xlCalculationAutomatic=: _4105
xlCalculationManual=: _4135
xlCalculationSemiautomatic=: 2
xlColorIndexAutomatic=: _4105
xlColorIndexNone=: _4142
xlAutomatic=: _4105
xlNone=: _4142
xlShiftToLeft=: _4159
xlShiftUp=: _4162
xlDown=: _4121
xlToLeft=: _4159
xlToRight=: _4161
xlUp=: _4162
xlComments=: _4144
xlFormulas=: _4123
xlValues=: _4163
xlHAlignCenter=: _4108
xlHAlignCenterAcrossSelection=: 7
xlHAlignDistributed=: _4117
xlHAlignFill=: 5
xlHAlignGeneral=: 1
xlHAlignJustify=: _4130
xlHAlignLeft=: _4131
xlHAlignRight=: _4152
xlShiftDown=: _4121
xlShiftToRight=: _4161
xlContinuous=: 1
xlDash=: _4115
xlDashDot=: 4
xlDashDotDot=: 5
xlDot=: _4118
xlDouble=: _4119
xlLineStyleNone=: _4142
xlSlantDashDot=: 13
xlPart=: 2
xlWhole=: 1
xlDownward=: _4170
xlHorizontal=: _4128
xlUpward=: _4171
xlVertical=: _4166
xlRangeValueCSV=: 1001
xlRangeValueDefault=: 10
xlRangeValueHTML=: 1000
xlRangeValueXMLSpreadsheet=: 11
xlContext=: _5002
xlLTR=: _5003
xlRTL=: _5004
xlA1=: 1
xlR1C1=: _4150
xlNext=: 1
xlPrevious=: 2
xlByColumns=: 2
xlByRows=: 1
xlChart=: _4109
xlDialogSheet=: _4116
xlExcel4IntlMacroSheet=: 4
xlExcel4MacroSheet=: 3
xlWorksheet=: _4167
xlSheetHidden=: 0
xlSheetVeryHidden=: 2
xlSheetVisible=: _1
xlAscending=: 1
xlDescending=: 2
xlUnderlineStyleDouble=: _4119
xlUnderlineStyleDoubleAccounting=: 5
xlUnderlineStyleNone=: _4142
xlUnderlineStyleSingle=: 2
xlUnderlineStyleSingleAccounting=: 4
xlVAlignBottom=: _4107
xlVAlignCenter=: _4108
xlVAlignDistributed=: _4117
xlVAlignJustify=: _4130
xlVAlignTop=: _4160
xlChartAsWindow=: 5
xlChartInPlace=: 4
xlClipboard=: 3
xlInfo=: _4129
xlWorkbook=: 1
xlGuess=: 0
xlNo=: 2
xlYes=: 1
coclass 'wdooo'
coinsert 'oleutil'
coinsert 'oleooo'

oleerrno=: S_OK
init=: 0

create=: 3 : 0
assert. IFWIN
oleerrno=: S_OK
ids=: 0$0
init=: 0
)

destroy=: 3 : 0
if. init do.
  VariantClear <temp
  memf temp
  vRelease base
end.
if. 0~:#ids do.
  smoutput 'WARNING: oleid without olerelease ',":ids
end.
codestroy''
)
oleinvoke=: 1 : 0
'' (m oleinvoke) y
:
'disp name'=. 2{. y
args=. 2}.y
'x named'=. 2{. x=. boxopen x
oleerrno=: S_OK
if. 0=#x do. x=. (VT_BSTR, VT_BSTR, VT_BSTR, VT_I4, VT_I4, VT_R8, VT_UNKNOWN) {~ 2 131072 262144 1 4 8 i. (3!:0&> args) end.
if. (m e. DISPATCH_PROPERTYPUT, DISPATCH_PROPERTYPUTREF) > (DISPID_PROPERTYPUT e. named) do.
  named=. named, DISPID_PROPERTYPUT
end.
newdisp=. 0
if. disp=temp do.
  if. (VT_UNKNOWN, VT_DISPATCH) -.@e.~ {.oletype temp do. 13!:8[3 [ oleerrno=: DISP_E_TYPEMISMATCH end.
  newdisp=. 1
  vAddRef disp=. {. memr temp, 8 1 4
end.
if. S_OK~: 0{:: 'hr id'=. disp dispid name do. 13!:8[3 [ oleerrno=: hr end.
VariantClear <temp
msk=. -. (x (17 b.) VT_UNKNOWN) +. (x (17 b.) VT_DISPATCH) +. 32&=@(3!:0)&> args
dispparams=. (x;named) makedispparms args
if. S_OK~: hr=. vInvoke disp ; id ; GUID_NULL ; 0 ; m ; (<dispparams) ; (<temp) ; 0 ; 0 do. 13!:8[3 [ oleerrno=: hr end.
msk freedispparms dispparams
if. newdisp do. vRelease disp end.
temp
)
olecreate=: 0&$: : (4 : 0)
ctx=. (0=x){x,CLSCTX_INPROC_SERVER+CLSCTX_LOCAL_SERVER
oleerrno=: S_OK
if. S_OK= hr=. >@{. cdrc=. CLSIDFromProgID`CLSIDFromString@.('{'={.@>@{.) (y,{.a.) ; guid=. 16#{.a. do.
  guid=. >@{:cdrc
  if. S_OK= hr=. >@{. cdrc=. CoCreateInstance guid ; 0 ; ctx ; iid_idispatch ; p=. ,_2 do.
    p=. _1{::cdrc
    base=: {.p
    init=: 1
    temp=: olevaralloc ''
    rz=. base, temp
  end.
end.
if. S_OK~: hr do. 13!:8[3 [ oleerrno=: hr end.
rz
)
olemethod=: DISPATCH_METHOD oleinvoke
oleget=: DISPATCH_PROPERTYGET oleinvoke
oleput=: oleset=: DISPATCH_PROPERTYPUT oleinvoke
oleputref=: olesetref=: DISPATCH_PROPERTYPUTREF oleinvoke
oleid=: 3 : 0
oleerrno=: S_OK
if. (VT_UNKNOWN, VT_DISPATCH) -.@e.~ {.oletype y do. 13!:8[3 [ oleerrno=: DISP_E_TYPEMISMATCH end.
vAddRef d=. {. memr y, 8 1 4
ids=: ids,d
d
)
olerelease=: 3 : 0
ids=: ids-.y
vRelease y
)
oleqer=: 3 : 0
olecomerrmsg oleerrno
)
oletype=: 3 : 0
vt=. {. _1&ic memr y, 0 2 2
vt0=. vt ((17 b.) (26 b.)) VT_VECTOR (23 b.) VT_ARRAY (23 b.) VT_BYREF
vt0, 0~: vt (17 b.) VT_VECTOR, VT_ARRAY, VT_BYREF
)

olebstr=: 3 : 0
6 u: memr y, 0, (_2&ic memr y, _4 4 2), 2
)
olevalue=: 3 : 0
'vt vector array byref'=. oletype y
assert. 0=vector
if. byref do. y=. {. memr y, 8 1 4 end.
if. array do.
  shape=. 0$0
  sa=. {. memr y, 8 1 4
  if. 0= nd=. SafeArrayGetDim sa do. 0$0 return. end.
  for_i. >:i.nd do.
    u=. ,2-2
    b=. ,2-2
    if. S_OK ~: hr=. >@{. cdrc=. SafeArrayGetLBound sa ; i ; b do. shape=. 0 break. end.
    b=. _1{::cdrc
    if. S_OK ~: hr=. >@{. cdrc=. SafeArrayGetUBound sa ; i ; u do. shape=. 0 break. end.
    u=. _1{::cdrc
    shape=. shape, >:u-b
  end.
  if. (0=#shape) +. 0 e. shape do. shape $ 0 return. end.
  vt1=. ,2-2
  if. S_OK ~: hr=. >@{. cdrc=. SafeArrayGetVartype sa ; vt1 do. shape $ 0 return. end.
  vt1=. _1{::cdrc
  vt0=. ({.vt1) ((17 b.) (26 b.)) VT_VECTOR (23 b.) VT_ARRAY (23 b.) VT_BYREF
  assert. vt0=vt
  p=. ,2-2
  if. S_OK= hr=. >@{. cdrc=. SafeArrayAccessData sa ; p do.
    p=. _1{::cdrc
    select. vt0
    case. VT_EMPTY do. |: (|.shape) $ <''
    case. VT_UI1;VT_I1 do. |: (|.shape) $ a.i. memr p, 0, (*/shape), 2
    case. VT_BOOL do. |: (|.shape) $ 0 ~: _1&ic memr p, 0, (2**/shape), 2
    case. VT_UI2;VT_I2 do. |: (|.shape) $ _1&ic memr p, 0, (2**/shape), 2
    case. VT_UI4;VT_I4 do.
      if. IF64 do.
        |: (|.shape) $ _2&ic memr p, 0, (4**/shape), 2
      else.
        |: (|.shape) $ memr p, 0, (*/shape), 4
      end.
    case. VT_UI8;VT_I8 do.
      if. IF64 do.
        |: (|.shape) $ memr p, 0, (*/shape), 4
      else.
        |: (|.shape) $ , {.("1) _2\] _2&ic memr p, 0, (8**/shape), 2
      end.
    case. VT_R4 do. |: (|.shape) $ _1&fc memr p, 0, (4**/shape), 2
    case. VT_R8 do. |: (|.shape) $ memr p, 0, (*/shape), 8
    case. VT_BSTR do. |: (|.shape) $ <@olestr"0 memr p, 0, (*/shape), 4
    case. VT_VARIANT do. |: (|.shape) $ <@olevalue"0 ({.p)+szVARIANT*i.(*/shape)
    case. do. |: (|.shape) $ memr p, 0, (*/shape), 4
    end.
    if. S_OK~: hr=. SafeArrayUnaccessData sa do. end.
  else.
    shape $ 0
  end.
else.
  select. vt
  case. VT_EMPTY do. ''
  case. VT_UI1;VT_I1 do. {. a.i. memr y, 8 1 2
  case. VT_BOOL do. {. 0 ~: _1&ic memr y, 8 2 2
  case. VT_UI2;VT_I2 do. {. _1&ic memr y, 8 2 2
  case. VT_UI4;VT_I4 do.
    if. IF64 do.
      {. _2&ic memr y, 8 4 2
    else.
      {. memr y, 8 1 4
    end.
  case. VT_UI8;VT_I8 do.
    if. IF64 do.
      {. memr y, 8 1 4
    else.
      {. _2&ic memr y, 8 4 2
    end.
  case. VT_R4 do. {. _1&fc memr y, 8 4 2
  case. VT_R8 do. {. memr y, 8 1 8
  case. VT_BSTR do. olebstr {. memr y, 8 1 4
  case. VT_VARIANT do. olevalue {. memr y, 8 1 4
  case. do. {. memr y, 8 1 4
  end.
end.
)

olevector=: [ olesafearray ,@]
olesafearray=: 4 : 0
if. 0=#$y do. y=. ,y end.
if. 0=#x do. x=. (VT_BSTR, VT_BSTR, VT_BSTR, VT_I4, VT_I4, VT_R8, _1, VT_UNKNOWN) {~ 2 131072 262144 1 4 8 32 i. 3!:0 y end.
if. (0~:#,y) *. (VT_UNKNOWN=x) *. 1 4 -.@e.~ 3!:0 y do. 0 return. end.
if. _1=x do.
  if. *./ 2 131072 262144 e.~ t=. , 3!:0 &> y do. x=. VT_BSTR
  elseif. *./ 1 4 e.~ t do. x=. VT_I4 [ y=. ($y) $ ,>y
  elseif. *./ 1 4 8 e.~ t do. x=. VT_R8 [ y=. ($y) $ ,>y
  elseif. *./ 2 131072 262144 1 4 8 32 e.~ t do. x=. VT_VARIANT
  elseif. do. 0 return.
  end.
end.
if. VT_BSTR=x do.
  if. 32= 3!:0 y do.
    y=. SysAllocStringLen@:(];#)@:uucp&> y
  else.
    y=. SysAllocStringLen@:(];#)@:uucp("1) y
  end.
elseif. VT_VARIANT~:x do.
  if. 32= 3!:0 y do.
    try.
      y=. {.&> y
    catch.
      0 return.
    end.
    if. 32= 3!:0 y do. 0 return. end.
  end.
end.
if. 0=#$y do. y=. ,y end.
if. 0= sa=. SafeArrayCreate x ; (#$y) ; , ($y),.0 do.
  0 return.
end.
if. 0~: #,y do.
  p=. ,2-2
  if. S_OK~: hr=. >@{. cdrc=. SafeArrayAccessData sa ; p do.
    SafeArrayDestroy sa
    0 return.
  end.
  p=. _1{::cdrc
  if. (VT_UI1,VT_I1) e.~ x do.
    (a.{~ <. ,|:y) memw p, 0, (#,y), 2
  elseif. VT_BOOL = x do.
    (1 ic 0 _1{~ 0~: <. ,|:y) memw p, 0, (2*#,y), 2
  elseif. (VT_UI2,VT_I2) e.~ x do.
    (1 ic <. ,|:y) memw p, 0, (2*#,y), 2
  elseif. (VT_UI4,VT_I4,VT_EMPTY) e.~ x do.
    if. IF64 do.
      (2 ic <. ,|:y) memw p, 0, (4*#,y), 2
    else.
      ((2-2) + <. ,|:y) memw p, 0, (#,y), 4
    end.
  elseif. (VT_UI8,VT_I8) e.~ x do.
    if. IF64 do.
      ((2-2) + <. ,|:y) memw p, 0, (#,y), 4
    else.
      (2 ic , (] , (0 _1 {~ 0&>))"0 <. ,|:y) memw p, 0, (8*#,y), 2
    end.
  elseif. VT_R4 = x do.
    (1 fc ,|: _&<. y) memw p, 0, (4*#,y), 2
  elseif. VT_R8 = x do.
    (,|: _&<. y) memw p, 0, (#,y), 8
  elseif. VT_BSTR = x do.
    (,|:y) memw p, 0, (#,y), 4
  elseif. VT_VARIANT = x do.
    if. 2>#@$y do. y=. ,:y end.
    n1=. {.@$y
    for_i. i.{.@$ y do.
      for_j. i.{:@$ y do.
        if. 2 131072 262144 e.~ te=. 3!:0 elm=. (<i,j){::y do.
          (1 ic VT_BSTR) memw p, (szVARIANT*i+n1*j), 2 2
          (SysAllocStringLen@:(];#)@:uucp elm) memw p, (8+szVARIANT*i+n1*j), 1 4
        elseif. 1 4 e.~ te do.
          (1 ic VT_I4) memw p, (szVARIANT*i+n1*j), 2 2
          if. IF64 do.
            (2 ic (2-2)+ elm) memw p, (8+szVARIANT*i+n1*j), 4 2
          else.
            ((2-2)+ elm) memw p, (8+szVARIANT*i+n1*j), 1 4
          end.
        elseif. 32 = te do.
          if. 1 4 e.~ 3!:0 >elm do.
            (1 ic VT_UNKNOWN) memw p, (szVARIANT*i+n1*j), 2 2
            if. IF64 do.
              (2 ic (2-2)+ >elm) memw p, (8+szVARIANT*i+n1*j), 4 2
            else.
              ((2-2)+ >elm) memw p, (8+szVARIANT*i+n1*j), 1 4
            end.
          else.
            SafeArrayUnaccessData sa
            SafeArrayDestroy sa
            0 return.
          end.
        elseif. 8 = te do.
          (1 ic VT_R8) memw p, (szVARIANT*i+n1*j), 2 2
          elm memw p, (8+szVARIANT*i+n1*j), 1 8
        elseif. do.
          SafeArrayUnaccessData sa
          SafeArrayDestroy sa
          0 return.
        end.
      end.
    end.
  elseif. (VT_UNKNOWN, VT_DISPATCH) e.~ x do.
    (,|:y) memw p, 0, (#,y), 4
  elseif. do.
    assert. 0
  end.
  if. S_OK~: hr=. SafeArrayUnaccessData sa do.
    SafeArrayDestroy sa
    0 return.
  end.
end.
arr=. olevaralloc ''
(1 ic VT_ARRAY+x) memw arr, 0 2 2
sa memw arr, 8 1 4
arr
)

