NB. =========================================================
NB. ole utility

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

NB. prototype
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

NB. useful constants
S_OK=: 0
SZI=: IF64{4 8

GUID_NULL=: 16#{.a.
iid_iunknown=: 0 0 0 0 0 0 0 0 192 0 0 0 0 0 0 70{a.  NB. {00000000-0000-0000-C000-000000000046}
iid_idispatch=: 0 4 2 0 0 0 0 0 192 0 0 0 0 0 0 70{a.  NB. {00020400-0000-0000-c000-000000000046}

NB. Flags for IDispatch::Invoke
DISPATCH_METHOD=: 1
DISPATCH_PROPERTYGET=: 2
DISPATCH_PROPERTYPUT=: 4
DISPATCH_PROPERTYPUTREF=: 8

NB. lcid
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
        ((s<0){0 _1) memw arr, 12 1 4   NB. sign extension
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
(x makevariant&|. y) memw dispparams, 0 1 4        NB. arguments passed in reversed order
(2&ic #y) memw dispparams, (2*SZI), 4 2            NB. Number of arguments
if. #named do.
  pdispidNamed=. mema 4*#named
  (2&ic |.named) memw pdispidNamed, 0, (4*#named) ,2  NB. DISPID of named arguments
  pdispidNamed memw dispparams, SZI, 1 4
  (2&ic #named) memw dispparams, (IF64{12 20), 4 2    NB. Number of named arguments
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
    VariantClear@<"0 a+msk# szVARIANT* i.-c     NB. arguments passed in reversed order
  end.
  memf a
end.
if. b do. memf b end.
memf y
)

NB. alloc VARIANT
olevaralloc=: 3 : 0
f=. mema szVARIANT
(szVARIANT#{.a.) memw f, 0, szVARIANT, 2
cdrc=. VariantInit <f
f=. {.>@{:cdrc
)

NB. free VARIANT
olevarfree=: 3 : 0
if. y do.
  memf y [ VariantClear <y
end.
)
