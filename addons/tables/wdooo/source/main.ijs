NB. =========================================================
NB. wd syntax interface

coclass 'wdooo'
coinsert 'oleutil'
NB. for openoffice
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

NB. ---------------------------------------------------------
NB. private members
NB. named arguments always passed after positional arguments
NB. PROPERTYPUT, PROPERTYPUTREF:
NB.   assume the last argument to be DISPID_PROPERTYPUT
NB.   if no DISPID_PROPERTYPUT is provided in named

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
if. disp=temp do.  NB. pass prev temp for further invoke
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

NB. ---------------------------------------------------------
NB. public members

NB. 'base temp'=. [ctx] olecreate progid
olecreate=: 0&$: : (4 : 0)
ctx=. (0=x){x,CLSCTX_INPROC_SERVER+CLSCTX_LOCAL_SERVER
NB. create object and get idispatch, temp
oleerrno=: S_OK
if. S_OK= hr=. >@{. cdrc=. CLSIDFromProgID`CLSIDFromString@.('{'={.@>@{.) (y,{.a.) ; guid=. 16#{.a. do.
  guid=. >@{:cdrc
  if. S_OK= hr=. >@{. cdrc=. CoCreateInstance guid ; 0 ; ctx ; iid_idispatch ; p=. ,_2 do.
    p=. _1{::cdrc
    base=: {.p
    init=: 1
NB. temp result holder
    temp=: olevaralloc ''
    rz=. base, temp
  end.
end.
if. S_OK~: hr do. 13!:8[3 [ oleerrno=: hr end.
rz
)

NB. y: name ; args
NB. x: args type   (optional)
olemethod=: DISPATCH_METHOD oleinvoke
oleget=: DISPATCH_PROPERTYGET oleinvoke
oleput=: oleset=: DISPATCH_PROPERTYPUT oleinvoke
oleputref=: olesetref=: DISPATCH_PROPERTYPUTREF oleinvoke

NB. interface=. oleid temp
oleid=: 3 : 0
oleerrno=: S_OK
if. (VT_UNKNOWN, VT_DISPATCH) -.@e.~ {.oletype y do. 13!:8[3 [ oleerrno=: DISP_E_TYPEMISMATCH end.
vAddRef d=. {. memr y, 8 1 4
ids=: ids,d
d
)

NB. release interface created by oleid
olerelease=: 3 : 0
ids=: ids-.y
vRelease y
)

NB. equivalent of wd'qer'
oleqer=: 3 : 0
olecomerrmsg oleerrno
)

NB. retrieve type of variant
NB. return 4-element vector: basictype isvector isarray isbyref
oletype=: 3 : 0
vt=. {. _1&ic memr y, 0 2 2
vt0=. vt ((17 b.) (26 b.)) VT_VECTOR (23 b.) VT_ARRAY (23 b.) VT_BYREF
vt0, 0~: vt (17 b.) VT_VECTOR, VT_ARRAY, VT_BYREF
)

olebstr=: 3 : 0
6 u: memr y, 0, (_2&ic memr y, _4 4 2), 2
)

NB. retrieve value of variant
olevalue=: 3 : 0
'vt vector array byref'=. oletype y
assert. 0=vector                         NB. not yet implemented
if. byref do. y=. {. memr y, 8 1 4 end.
if. array do.
  shape=. 0$0
  sa=. {. memr y, 8 1 4
  if. 0= nd=. SafeArrayGetDim sa do. 0$0 return. end.
  for_i. >:i.nd do.    NB. axis is 1-base
    u=. ,2-2  NB. do not assign u and b in one sentence: alias
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
  p=. ,2-2    NB. pointer to rawdata
  if. S_OK= hr=. >@{. cdrc=. SafeArrayAccessData sa ; p do.
    p=. _1{::cdrc
NB. rawdata is column major
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

NB. make safearray
NB. x VT_...
NB. y elements (may be empty)
NB. return 0 if failed
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
  p=. ,2-2    NB. pointer to rawdata
  if. S_OK~: hr=. >@{. cdrc=. SafeArrayAccessData sa ; p do.
    SafeArrayDestroy sa
    0 return.
  end.
  p=. _1{::cdrc
NB. rawdata is column major
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
      (2 ic , (] , (0 _1 {~ 0&>))"0 <. ,|:y) memw p, 0, (8*#,y), 2   NB. sign extension
    end.
  elseif. VT_R4 = x do.
    (1 fc ,|: _&<. y) memw p, 0, (4*#,y), 2
  elseif. VT_R8 = x do.
    (,|: _&<. y) memw p, 0, (#,y), 8
  elseif. VT_BSTR = x do.
    (,|:y) memw p, 0, (#,y), 4
  elseif. VT_VARIANT = x do.
    if. 2>#@$y do. y=. ,:y end.
    n1=. {.@$y                       NB. column major
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
    assert. 0   NB. should not happen
  end.
  if. S_OK~: hr=. SafeArrayUnaccessData sa do.
    SafeArrayDestroy sa
    0 return.
  end.
end.
NB. wrap safearray inside a variant for oleautomation
NB. need to be freed using olevarfree
arr=. olevaralloc ''
(1 ic VT_ARRAY+x) memw arr, 0 2 2
sa memw arr, 8 1 4
arr
)

