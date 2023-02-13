NB. =========================================================
NB. OpenOffice.org specific code

coclass 'oleooo'
coinsert 'oleutil'

NB. new Document Type    Magical Text
NB. Writer text          private:factory/swriter
NB. Calc spreadsheet     private:factory/scalc
NB. Draw                 private:factory/sdraw
NB. Impress presentation private:factory/simpress
NB. Math formula         private:factory/smath

((<'OOoNumberFormat_') ,&.> ;:'DEFINED DATE TIME CURRENCY NUMBER SCIENTIFIC FRACTION PERCENT TEXT DATETIME LOGICAL UNDEFINED')=: <. 2^i.12
OOoNumberFormat_DATETIME=: OOoNumberFormat_DATE + OOoNumberFormat_TIME
OOoNumberFormat_ALL=: 0
NB. CharWeight : NORMAL is 100%
((<'OOoCharWeight_') ,&.> ;:'DONTKNOW THIN ULTRALIGHT LIGHT SEMILIGHT NORMAL SEMIBOLD BOLD ULTRABOLD BLACK')=: 0 50 60 75 90 100 110 150 175 200
((<'OOoHoriJustify_') ,&.> ;:'STANDARD LEFT CENTER RIGHT BLOCK REPEAT')=: i.6
((<'OOoFontUnderline_') ,&.> ;:'NONE SINGLE DOUBLE DOTTED DONTKNOW DASH LONGDASH DASHDOT DASHDOTDOT SMALLWAVE WAVE DOUBLEWAVE BOLD BOLDDOTTED BOLDDASH BOLDLONGDASH BOLDDASHDOT BOLDDASHDOTDOT BOLDWAVE')=: i.19
((<'OOoCellFlags_') ,&.> ;:'VALUE DATETIME STRING ANNOTATION FORMULA HARDATTR STYLES OBJECTS EDITATTR FORMATTED')=: <.2^i.10

NB. ---------------------------------------------------------
NB. private members

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

NB. ---------------------------------------------------------
NB. public members

NB. return integer
NB. y: R G B
NB. rz: integer in byte order of BGR0 (Excel use RGB0 order)
OOoRGB=: 3 : 0
(2{y) (23 b.) 8 (33 b.) (1{y) (23 b.) 8 (33 b.) (0{y)
)

NB. need strings.ijs
filetoURL=: 3 : 0
path=. y
NB. getAbsolutePath
if. (':' -.@e. path) *. ('/\'-.@e.~{.path) do. path=. (1!:43 ''), '/', path end.
NB. convert non-URL style file separators and make sure it starts at root
path=. ('/'&,)^:('/'~:{.path) path=. '\/' charsub path
NB. converting URL special characters
path=. 'file://', path stringreplace~ ' ' ; '%20' ; '#' ; '%23' ; '%' ; '%25' ; '&' ; '%26' ; ';' ; '%3B' ; '<' ; '%3C' ; '=' ; '%3D' ; '>' ; '%3E' ; '?' ; '%3F' ; '~' ; '%7E'
)

NB. return non-zero object if success
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

NB. return hresult
OOoPutStruct=: 4 : 0
disp=. y
'slot val vts'=. x
({.vts) (DISPATCH_PROPERTYPUT OOoinvoke) disp ; slot ; 0 ; val
)

NB. return hresult ;< cotmp
OOoGetStruct=: 4 : 0
disp=. y
slot=. >x
cotmp=. olevaralloc ''
hr=. (DISPATCH_PROPERTYGET OOoinvoke) disp ; slot ; cotmp
hr ;< cotmp
)

NB. y disp
NB. x name value vts
NB. return non-zero object if success
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

NB. Function MakeCellBorderLine( nColor, nInnerLineWidth, nOuterLineWidth, nLineDistance ) As
NB. com.sun.star.table.BorderLine
NB.    oBorderLine = createUnoStruct( "com.sun.star.table.BorderLine" )
NB.    With oBorderLine
NB.       .Color = nColor
NB.       .InnerLineWidth = nInnerLineWidth
NB.       .OuterLineWidth = nOuterLineWidth
NB.       .LineDistance = nLineDistance
NB.    End With
NB.    MakeCellBorderLine = oBorderLine
NB. End Function

NB.    oCells.LeftBorder   = MakeCellBorderLine( 0, 0, 75, 0 )
NB.    oCells.RightBorder  = MakeCellBorderLine( 0, 0, 75, 0 )
NB.    oCells.TopBorder    = MakeCellBorderLine( 0, 0, 75, 0 )
NB.    oCells.BottomBorder = MakeCellBorderLine( 0, 0, 75, 0 )

NB. return object
OOoMakeCellBorderLine=: 4 : 0
disp=. y
'nColor WidthDistance'=. x
NB. WidthDistance= nInnerLineWidth nOuterLineWidth nLineDistance
NB. (short: in 1/100 mm)
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

NB. fmt is format string or integer in OOoNumberFormat_ ...
NB. lang 'en' country 'gb'
NB. return _1 if fail
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
        coAddRef obj   NB. queryKey will Release oLocale ?
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

