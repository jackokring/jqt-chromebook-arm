NB. ---------------------------------------------------------
NB. read numeric and string data from excel files
NB. written by bill lam
NB. ---------------------------------------------------------

coclass 'biffread'
coinsert 'oleutlfcn'
NB. x 0 normal  1 debug
NB. y stream data
create=: 4 : 0
debug=: x
stream=: y
biffver=: 0        NB. biff5/7 16b500   biff8 16b600
NB. biff2 16b200 biff3 16b300  biff4 16b400  (there is in fact no biffver stored)
streamtype=: 16    NB. worksheet 16
filepos=: 0
worksheets=: 0 2$''
bkrecords=: 0 3$'' [ bkbytes=: ''   NB. dump workbook for debug mode
records=: 0 3$'' [ bytes=: ''       NB. dump worksheet for debug mode
sst=: ''
bnsst=: nsst=: 0  NB. number of strings
sstchar=: 0
sstrtffe=: 0
insst=. 0
type=. _1
newptr=. 0
while. (type~:10)*.filepos<#stream do.
  'type ptr len'=. nextrecord ''
NB. dump records of workbook global to [bkbytes] with index held in [bkrecords]
  if. debug do.
    bkbytes=: bkbytes, (ptr+i.len){stream
    newptr=. newptr+len [ bkrecords=: bkrecords, type, newptr, len
  end.
  if. 16b9=type do.        NB. BOF record biff2
    biffver=: 16b200 break.
  elseif. 16b209=type do.  NB. BOF record biff3
    biffver=: 16b300 break.
  elseif. 16b409=type do.  NB. BOF record biff4
    biffver=: 16b400 break.
  elseif. 16b809=type do.  NB. BOF record
    if. 0=biffver do.  NB. only read the 1st BOF record in workbook
      'biffver streamtype'=: fromWORD0 4{.data=. (ptr+i.len){stream
    end.
  elseif. 16b0085=type do.  NB. boundsheet record
    if. 0={.fromBYTE 5{data=. (ptr+i.len){stream do.
      if. 16b500=biffver do.
        worksheets=: worksheets, (0 decodestring8 6}.data) ,< {.(fromDWORD0 4{.data)
      else.
        worksheets=: worksheets, (0 decodeustring8 6}.data) ,< {.(fromDWORD0 4{.data)
      end.
    end.
  elseif. 16b00fc=type do.  NB. sst record
    'bnsst nsst'=: fromDWORD0 8{.data=. (ptr+i.len){stream
    readsst 8}.data
    insst=. 1
  elseif. insst *. 16b003c=type do. NB. continue record after sst
    readsst data=. (ptr+i.len){stream
  elseif. do.
    insst=. 0
  end.
end.
if. #sst do. sst=: <;._2 sst end.
NB. some worksheets failed this assertion
NB. assert. nsst=#~.sst
assert. 0~:biffver
)

destroy=: codestroy
NB. parse string from sst record
readsst=: 3 : 0
fp=. 0
while. fp<#y do.
  if. 0=sstchar+sstrtffe do.
    't t1'=. fp decodeustring16 y
    sst=: sst, t, {.a.
    fp=. fp + a [ 'a b c'=. t1
    sstchar=: b-#t
    sstrtffe=: c
  else.
    't t1'=. (fp, sstchar, sstrtffe) decodeustring16a y
    sst=: (}:sst), t, {.a.
    fp=. fp + a [ 'a b c'=. t1
    sstchar=: sstchar-#t
    sstrtffe=: c
  end.
end.
)

NB. return record type, pointer to data buffer, length of data buffer
nextrecord=: 3 : 0
'type len'=. fromWORD0 (filepos+i.4){stream
filepos=: +/data=. (4+filepos), len
type, data
)

NB. byte string used in biff2/3/4/5/7
NB. assume no continue record
decodestring8=: 4 : 0
len=. {.fromBYTE (x+0){y
< len (([ <. #@]) {. ]) (x+1)}.y
)

decodestring16=: 4 : 0
len=. {.fromWORD0 (x+i.2){y
< len (([ <. #@]) {. ]) (x+2)}.y
)

NB. assume no continue record
decodeustring8=: 4 : 0
len=. {.fromBYTE (x+0){y
uc=. 0~:1 bitand op=. {.fromBYTE (x+1){y
fe=. 0~:4 bitand op
rtf=. 0~:8 bitand op
if. uc do.
  < utf8 fromucode0 (2*len) (([ <. #@]) {. ]) (x+2+(fe*4)+(rtf*2))}.y
else.
  < len (([ <. #@]) {. ]) (x+2+(fe*4)+(rtf*2))}.y
end.
)

decodeustring16=: 4 : 0
NB. len number of (wchar) character in string
NB. z decoded string
NB. p point to rtf/fe block
NB. p1 byte length of decoded string segment
NB. p2 number of pending bytes to be read in next record
NB. lenrtf rtf size in byte (4 bytes per block)
NB. lenfe  fe size in byte
len=. {.fromWORD0 (x+i.2){y
uc=. 0~:1 bitand op=. {.fromBYTE (x+2){y    NB. uncompress wchar
fe=. 0~:4 bitand op                         NB. #far east phonetic (4 byte)
rtf=. 0~:8 bitand op                        NB. #rtf format run (2 byte)
lenrtffe=. 0
if. rtf do. lenrtffe=. 4* {.fromWORD0 ((x+3)+i.2){y end.
if. fe do. lenrtffe=. lenrtffe + {.fromDWORD0 ((x+3+(rtf*2))+i.4){y end.
NB. p point to position of fe/rtf block if read
NB. p2 #byte in character array not yet read
l=. (3+(fe*4)+(rtf*2)) + (len*uc{1 2) + lenrtffe  NB. expect length if no further continue record need
if. uc do.
  z=. fromucode0 z1=. (2*len) (([ <. #@]) {. ]) (x+3+(fe*4)+(rtf*2))}.y
  z2=. (2*len)-#z1  NB. byte length of remaining character array
else.
  z=. z1=. len (([ <. #@]) {. ]) (x+3+(fe*4)+(rtf*2))}.y
  if. 1 e. 127<a.i.z do. z=. u: z end.
  z2=. len-#z1  NB. byte length of remaining character array
end.
if. (#y)<x+l do.
  z ; (#y), len, (x+l)-z2+#y
else.
  z ; l, len, 0
end.
)

NB. the first splitted string in continue record
decodeustring16a=: 4 : 0
'x len lenrtffe'=. x
NB. there is no len for the first splitted string in continue record
NB. there is option byte the first splitted string in continue record
NB. but if length of remaining character array is zero, ie rtf/fe portion only
NB. then there will be no option byte
if. len do.
  uc=. 0~:1 bitand op=. {.fromBYTE (x+0){y
  l=. 1 + (len*uc{1 2) + lenrtffe  NB. expect length if no further continue record need
  if. uc do.
    z=. fromucode0 z1=. (2*len) (([ <. #@]) {. ]) (x+1)}.y
    z2=. (2*len)-#z1    NB. byte length of remaining character array
  else.
    z=. z1=. len (([ <. #@]) {. ]) (x+1)}.y
    if. 1 e. 127<a.i.z do. z=. u: z end.
    z2=. len-#z1  NB. byte length of remaining character array
  end.
else.
  l=. lenrtffe  NB. expect length if no further continue record need
  z=. ''
  z2=. 0
end.
if. (#y)<x+l do.
  z ; (#y), len, (x+l)-z2+#y
else.
  z ; l, len, 0
end.
)

NB. x 1 convert all number to string
readsheet=: 0&$: : (4 : 0)
if. 16b200 16b300 16b400 e.~ biffver do.  NB. biff2/3/4
  filepos=: 0
  scnt=. _1
  sheetfound=. 0
else.
  filepos=: y
  sheetfound=. 1
end.
rowcolss=. rowcol=. rowcol4=. rowcol8=. rowcolc=. 0 2$''
cellvalss=. cellval=. cellval4=. cellval8=. cellvalc=. ''
null=. {.a.
type=. _1
records=: 0 3$'' [ bytes=: ''       NB. dump worksheet for debug mode
newptr=. 0
lookstr=. 0
while. filepos<#stream do.
  'type ptr len'=. nextrecord ''
NB. dump records of worksheet to [bytes] with index held in [records]
  if. debug do.
    bytes=: bytes, (ptr+i.len){stream
    newptr=. newptr+len [ records=: records, type, newptr, len
  end.
  if. 0=sheetfound do.  NB. biff2/3/4
    if. 16b0009 16b0209 16b0409 e.~ type do.  NB. biff2/3/4  BOF
      if. 16b10= fromWORD0 (2+ptr+i.2){stream do.  NB. worksheet stream
        if. y = scnt=. >:scnt do.         NB. test worksheet index wanted
          sheetfound=. 1
        end.
      end.
    end.
    continue.
  end.
  select. type
  case. 16b000a do. NB. EOF
    break.
  case. 16b027e do. NB. rk
    if. 0=x do.
      if. 8=3!:0 a=. >getrk 4}.data=. (ptr+i.len){stream do.
        rowcol8=. rowcol8, fromWORD0 4{.data
        cellval8=. cellval8, a
      else.
        rowcol4=. rowcol4, fromWORD0 4{.data
        cellval4=. cellval4, a
      end.
    else.
      rowcol=. rowcol, fromWORD0 4{.data=. (ptr+i.len){stream
      cellval=. cellval, ; null&,@ (":(!.maxpp))&.> getrk 4}.data   NB. ieee double have at most 16 sig. digits
    end.
  case. 16b0002 do. NB. unsigned 16-bit integer biff2
    if. 0=x do.
      rowcol4=. rowcol4, fromWORD0 4{.data=. (ptr+i.len){stream
      cellval4=. cellval4, {.fromDWORD0 (2#{.a.),~ (7+i.2){data
    else.
      rowcol=. rowcol, fromWORD0 4{.data=. (ptr+i.len){stream
      cellval=. cellval, null&,@": {.fromDWORD0 (2#{.a.),~ (7+i.2){data
    end.
  case. 16b0003 do. NB. number biff2
    if. 0=x do.
      rowcol8=. rowcol8, fromWORD0 4{.data=. (ptr+i.len){stream
      cellval8=. cellval8, {.fromDouble0 (7+i.8){data
    else.
      rowcol=. rowcol, fromWORD0 4{.data=. (ptr+i.len){stream
      cellval=. cellval, null&,@ (":(!.maxpp)) {.fromDouble0 (7+i.8){data
    end.
  case. 16b0203 do. NB. number
    if. 0=x do.
      rowcol8=. rowcol8, fromWORD0 4{.data=. (ptr+i.len){stream
      cellval8=. cellval8, {.fromDouble0 (6+i.8){data
    else.
      rowcol=. rowcol, fromWORD0 4{.data=. (ptr+i.len){stream
      cellval=. cellval, null&,@ (":(!.maxpp)) {.fromDouble0 (6+i.8){data
    end.
  case. 16b00fd do. NB. labelss
    rowcolss=. rowcolss, fromWORD0 4{.data=. (ptr+i.len){stream
    cellvalss=. cellvalss, fromDWORD0 (6+i.4){data
  case. 16b0005 do. NB. boolerr biff2
    if. ({.a.)=(8+ptr){stream do. NB. error code ignored
      if. 0=x do.
        rowcol4=. rowcol4, fromWORD0 4{.data=. (ptr+i.len){stream
        cellval4=. cellval4, ({.a.)~:7{data
      else.
        rowcol=. rowcol, fromWORD0 4{.data=. (ptr+i.len){stream
        cellval=. cellval, null&,@": ({.a.)~:7{data
      end.
    end.
  case. 16b0205 do. NB. boolerr
    if. ({.a.)=(7+ptr){stream do. NB. error code ignored
      if. 0=x do.
        rowcol4=. rowcol4, fromWORD0 4{.data=. (ptr+i.len){stream
        cellval4=. cellval4, ({.a.)~:6{data
      else.
        rowcol=. rowcol, fromWORD0 4{.data=. (ptr+i.len){stream
        cellval=. cellval, null&,@": ({.a.)~:6{data
      end.
    end.
  case. 16b00bd do. NB. multrk
    rocol=. fromWORD0 4{.data=. (ptr+i.len){stream
    lc=. fromWORD0 _2{.data
    nc=. >:lc-{:rocol
    if. 0=x do.
      v=. getrk("1) _6]\ _2}.4}.data
      for_rcl. rocol +("1) 0 ,("0) i.nc do.
        if. 8=3!:0 a=. >rcl_index{v do.
          rowcol8=. rowcol8, rcl
          cellval8=. cellval8, a
        else.
          rowcol4=. rowcol4, rcl
          cellval4=. cellval4, a
        end.
      end.
    else.
      rowcol=. rowcol, rocol +("1) 0 ,("0) i.nc
      cellval=. cellval, ; null&,@ (":(!.maxpp))&.> getrk("1) _6]\ _2}.4}.data
    end.
  case. 16b0006 do. NB. formula, only cached result read
    data=. (ptr+i.len){stream
    if. 16b200 = biffver do. NB. biff2
      if. (255 255{a.)-:13 14{data do.
        if. (0{a.)=7{data do. NB. string result
          lookrowcol=. fromWORD0 4{.data
          lookstr=. 2
        elseif. (1{a.)=7{data do. NB. boolerr
          if. 0=x do.
            rowcol4=. rowcol4, fromWORD0 4{.data
            cellval4=. cellval4, ({.a.)~:9{data
          else.
            rowcol=. rowcol, fromWORD0 4{.data
            cellval=. cellval, null&,@": ({.a.)~:9{data
          end.
        end.
      else.  NB. double
        if. 0=x do.
          rowcol8=. rowcol8, fromWORD0 4{.data
          cellval8=. cellval8, {.fromDouble0 (7+i.8){data
        else.
          rowcol=. rowcol, fromWORD0 4{.data
          cellval=. cellval, null&,@ (":(!.maxpp)) {.fromDouble0 (7+i.8){data
        end.
      end.
    else.
      if. (255 255{a.)-:12 13{data do.
        if. (0{a.)=6{data do. NB. string result
          lookrowcol=. fromWORD0 4{.data
          lookstr=. 2
        elseif. (1{a.)=6{data do. NB. boolerr
          if. 0=x do.
            rowcol4=. rowcol4, fromWORD0 4{.data
            cellval4=. cellval4, ({.a.)~:8{data
          else.
            rowcol=. rowcol, fromWORD0 4{.data
            cellval=. cellval, null&,@": ({.a.)~:8{data
          end.
NB. blank and multblank records may be ignore
NB.       elseif. (3{a.)=6{data do.  NB. blank
NB.         if. 0=x do.
NB.           rowcolc=. rowcolc, fromWORD0 4{.data
NB.           cellvalc=. cellvalc, null
NB.         else.
NB.           rowcol=. rowcol, fromWORD0 4{.data
NB.           cellval=. cellval, null
NB.         end.
        end.
      else.  NB. double
        if. 0=x do.
          rowcol8=. rowcol8, fromWORD0 4{.data
          cellval8=. cellval8, {.fromDouble0 (6+i.8){data
        else.
          rowcol=. rowcol, fromWORD0 4{.data
          cellval=. cellval, null&,@ (":(!.maxpp)) {.fromDouble0 (6+i.8){data
        end.
      end.
    end.
NB. string for formula result, assume no continue record
  case. 16b0007 do. NB. biff2
    if. 1=lookstr do.
      if. 0=x do.
        rowcolc=. rowcolc, lookrowcol
        cellvalc=. cellvalc, null&,@> {.0 decodestring8 data=. (ptr+i.len){stream
      else.
        rowcol=. rowcol, lookrowcol
        cellval=. cellval, null&,@> {.0 decodestring8 data=. (ptr+i.len){stream
      end.
    end.
NB. string for formula result, assume no continue record
  case. 16b0207 do.
    if. 1=lookstr do.
      if. 16b300 16b400 16b500 e.~ biffver do.  NB. biff3/4/5/7
        if. 0=x do.
          rowcolc=. rowcolc, lookrowcol
          cellvalc=. cellvalc, null&,@> {.0 decodestring16 data=. (ptr+i.len){stream
        else.
          rowcol=. rowcol, lookrowcol
          cellval=. cellval, null&,@> {.0 decodestring16 data=. (ptr+i.len){stream
        end.
      else.
        if. 0=x do.
          rowcolc=. rowcolc, lookrowcol
          cellvalc=. cellvalc, null&,@> {.0 decodeustring16 data=. (ptr+i.len){stream
        else.
          rowcol=. rowcol, lookrowcol
          cellval=. cellval, null&,@> {.0 decodeustring16 data=. (ptr+i.len){stream
        end.
      end.
    end.
NB. blank and multblank records may be ignore
NB.   case. 16b0201 do. NB. blank
NB.     if. 0=x do.
NB.       rowcolc=. rowcolc, fromWORD0 4{.data=. (ptr+i.len){stream
NB.       cellvalc=. cellvalc, null
NB.     else.
NB.       rowcol=. rowcol, fromWORD0 4{.data=. (ptr+i.len){stream
NB.       cellval=. cellval, null
NB.     end.
NB.   case. 16b00be do. NB. multblank
NB.     rocol=. fromWORD0 4{.data=. (ptr+i.len){stream
NB.     lc=. fromWORD0 _2{.data
NB.     nc=. >:lc-{:rocol
NB.     if. 0=x do.
NB.       rowcolc=. rowcolc, rocol +("1) 0 ,("0) i.nc
NB.       cellvalc=. cellvalc, nc#null
NB.     else.
NB.       rowcol=. rowcol, rocol +("1) 0 ,("0) i.nc
NB.       cellval=. cellval, nc#null
NB.     end.
  case. 16b0004 do. NB. biff2 label, assume no continue record
    if. 0=x do.
      rowcolc=. rowcolc, fromWORD0 4{.data=. (ptr+i.len){stream
      cellvalc=. cellvalc, null&,@> {.0 decodestring8 7}.data
    else.
      rowcol=. rowcol, fromWORD0 4{.data=. (ptr+i.len){stream
      cellval=. cellval, null&,@> {.0 decodestring8 7}.data
    end.
NB. biff8 does not use label record, but excel will read it
  case. 16b0204 do. NB. label, assume no continue record
    if. 16b300 16b400 16b500 e.~ biffver do.  NB. biff3/4/5/7
      if. 0=x do.
        rowcolc=. rowcolc, fromWORD0 4{.data=. (ptr+i.len){stream
        cellvalc=. cellvalc, null&,@> {.0 decodestring16 6}.data
      else.
        rowcol=. rowcol, fromWORD0 4{.data=. (ptr+i.len){stream
        cellval=. cellval, null&,@> {.0 decodestring16 6}.data
      end.
    else.
      if. 0=x do.
        rowcolc=. rowcolc, fromWORD0 4{.data=. (ptr+i.len){stream
        cellvalc=. cellvalc, null&,@> {.0 decodeustring16 6}.data
      else.
        rowcol=. rowcol, fromWORD0 4{.data=. (ptr+i.len){stream
        cellval=. cellval, null&,@> {.0 decodeustring16 6}.data
      end.
    end.
NB. biff8 does not use rstring record, but excel will read it
  case. 16b00d6 do. NB. rstring, assume no continue record
    if. 16b300 16b400 16b500 e.~ biffver do.  NB. biff3/4/5/7
      if. 0=x do.
        rowcolc=. rowcolc, fromWORD0 4{.data=. (ptr+i.len){stream
        cellvalc=. cellvalc, null&,@> {.0 decodestring16 6}.data
      else.
        rowcol=. rowcol, fromWORD0 4{.data=. (ptr+i.len){stream
        cellval=. cellval, null&,@> {.0 decodestring16 6}.data
      end.
    else.
      if. 0=x do.
        rowcolc=. rowcolc, fromWORD0 4{.data=. (ptr+i.len){stream
        cellvalc=. cellvalc, null&,@> {.0 decodeustring16 6}.data
      else.
        rowcol=. rowcol, fromWORD0 4{.data=. (ptr+i.len){stream
        cellval=. cellval, null&,@> {.0 decodeustring16 6}.data
      end.
    end.
  end.
  lookstr=. 0>.<:lookstr
end.
if. 0=x do.
  (rowcol4, rowcol8, rowcolc, rowcolss) (;<) (<("0) cellval4), (<("0) cellval8), ( <;._1 cellvalc), utf8&.> sst{~cellvalss
else.
  (rowcol, rowcolss) (;<) ( <;._1 cellval), utf8&.> sst{~cellvalss
end.
)

bigendian=: ({.a.)={. 1&(3!:4) 1  NB. 0 little endian   1 big endian

NB. decode rk value
getrk=: 3 : 0
if. 0=2 bitand d=. fromDWORD0 2}.y do. NB. double
  if. 0=bigendian do.
    rk=. fromDouble0 toDWORD0 0, d bitand _4    NB. 0xfffffffc
  else.
    rk=. fromDouble0 toDWORD0 0,~ d bitand _4    NB. 0xfffffffc
  end.
else.  NB. integer
  rk=. _2 bitsha d bitand _4    NB. 0xfffffffc
end.
if. 1 bitand d do.  NB. scale factor
  rk=. rk%100
end.
<{.rk
)

NB. ---------------------------------------------------------
NB. Covers for reading sheet(s) from an Excel workbook
NB. redeveloped by Ric Sherlock from original by bill lam
NB. ---------------------------------------------------------

NB.*readxlsheets v Reads one or more sheets from an Excel file
NB. returns: 2-column matrix with a row for each sheet
NB.       0{"1 boxed list of sheet names
NB.       1{"1 boxed list of boxed matrices of sheet contents
NB. y is: 1 or 2-item boxed list:
NB.       0{ filename of Excel workbook
NB.       1{ [default 0] optional switch to return all cells contents as strings
NB. x is: one of [default is 0]:
NB.       * numeric list of indicies of sheets to return
NB.       * boxed list of sheet names to return
NB.       * '' - return all sheets
NB. EG:   0 readxlsheets 'test.xls'
NB. reads Excel Versions 5, 95, 97, 2000, XP, 2003
NB. biff5  excel 5  biff7 excel 97   biff8 excel 97, xp, 2003
readxlsheets=: 3 : 0
0 readxlsheets y
:
try.
  'fln strng'=. 2{.!.(<0) boxopen y
  x=. boxopen x
  locs=. '' NB. store locales created
  (msg=. 'file not found') assert fexist fln
  locs=. locs,ole=. fln conew 'olestorage'
  if. 0=#wks=. getppssearch__ole 'Workbook' ; 1 ; 1 do.              NB. biff8
    if. 0=#wks=. getppssearch__ole 'Book' ; 1 ; 1 do.                NB. biff5/7
      (msg=. 'unknown Excel file format') assert 16b40009 16b60209 16b60409 e.~ fromDWORD0 freadx fln;0 4  NB. biff2/3/4
    end.
  end.
  locs=. locs,wks
  locs=. locs,ex=. conew 'biffread'
  if. #wks do.
    wk=. {.wks
    0&create__ex data__wk
NB. get worksheet location
    if. x-:<'' do.
      x=. i.#worksheets__ex
    elseif. -. */ 1 4 8 e.~ 3!:0 every x do.
      x=. x i.&(tolower&.>"_)~ {."1 worksheets__ex   NB. case insensitive worksheet name
    elseif. do. x=. >x NB. unbox numeric list
    end.
    (msg=. 'worksheet not found') assert x<#worksheets__ex
    'name location'=. |: x{worksheets__ex
  else.
    0&create__ex fread fln
    location=. {.>x
  end.
  'ix cell'=. <"1 |: ,:^:(1:=#@:$) strng&readsheet__ex"0 location NB. read worksheets
  for_l. |.locs do. NB. housekeeping
    destroy__l ''
    locs=. locs -. l
  end.
  rcs=. 0&>.@(>./ >:@- <./) each ix   NB. transform cell records to matrix
  offset_biffread_=: >{: off=. <./ each ix   NB. store offset in static class variable if needed
  ix=. ix -"1 each off
  m=. 0$0
  for_sht. cell do.
    n=. (sht_index{::rcs)$a:
    n=. (>sht) (<"1^:(0:<#) sht_index{::ix)} n
    m=. m,<n
  end.
  dtb=. #~ ([: +./\. ' '&~:)
  (<@dtb"1 name) ,. m
NB. convert excel date
NB. todate (+&36522) 38335 --> 2004 12 14
catch.
  for_l. |.locs do. NB. housekeeping
    destroy__l ''
    locs=. locs -. l
  end.
  smoutput 'readxlsheets: ',msg
end.
)

NB. stringtype v Ensures string type returned by appending <1 filename
stringtype=:  (<1) ,~ [: {. boxopen  
NB. firstsheet v Returns the first reference to a worksheet in x, or in the worksheet if no x.
firstsheet=: 0: :({.^:(3!:0 -.@e. 2 131072 262144"_)@[) NB. 

NB.*readxlsheetsstring v Reads contents of one or more sheets from an Excel file as strings
NB. see readxlsheets
readxlsheetsstring=: 0&$: : ([ readxlsheets stringtype@])

NB.*readxlworkbook v Reads all sheets from an Excel file
NB. see readxlsheets
readxlworkbook=: ''&readxlsheets

NB.*readexcel v Reads contents of a sheet from an Excel file
NB. see readxlsheets
readexcel=: 0 _1 {:: firstsheet readxlsheets ]

NB.*readexcelstring v Reads contents of a sheet from an Excel file as strings
NB. see readxlsheets
readexcelstring=: 0 _1 {:: firstsheet readxlsheets stringtype@]

NB. ---------------------------------------------------------
NB.*readxlsheetnames v Reads sheet names from Excel workbook
NB. returns: boxed list of sheet names
NB. y is: Excel file name
NB. eg: readxlsheetnames 'test.xls'
NB. read Excel Versions 5, 95, 97, 2000, XP, 2003
NB. biff5  excel 5  biff7 excel 97   biff8 excel 97, xp, 2003
readxlsheetnames=: 3 : 0
try.
  fln=. >y
  locs=. '' NB. store locales created
  (msg=. 'file not found') assert fexist fln
  locs=. locs,ole=. fln conew 'olestorage'
  if. 0=#wks=. getppssearch__ole 'Workbook' ; 1 ; 1 do.              NB. biff8
    if. 0=#wks=. getppssearch__ole 'Book' ; 1 ; 1 do.                NB. biff5/7
      (msg=. 'unknown Excel file format') assert 16b40009 16b60209 16b60409 e.~ fromDWORD0 freadx fln;0 4  NB. biff2/3/4
    end.
  end.
  locs=. locs,wks
  locs=. locs,ex=. conew 'biffread'
  if. #wks do.
    wk=. {.wks
    0&create__ex data__wk
  else.
    0&create__ex fread y
  end.
NB. read worksheet
  nms=. {."1 worksheets__ex
  for_l. |.locs do. destroy__l '' end. NB. housekeeping
  nms
catch.
  for_l. |.locs do. destroy__l '' end.
  smoutput 'readxlsheetnames: ',msg
end.
)

NB. cover function to dump worksheet
NB. sst shared string
NB. (bk)records= type index length
NB. (bk)bytes= byte stream for records
NB. x sheet index or name
NB. y Excel file name
NB. 0 dumpexcel 'test.xls'
dumpexcel=: 0&$: : (4 : 0)
assert. fexist y
ole=. (>y) conew 'olestorage'
if. 0=#wks=. getppssearch__ole 'Workbook' ; 1 ; 1 do.              NB. biff8
  if. 0=#wks=. getppssearch__ole 'Book' ; 1 ; 1 do.                NB. biff5/7
    assert. 16b40009 16b60209 16b60409 e.~ fromDWORD0 freadx y;0 4  NB. biff2/3/4
  end.
end.
ex=. conew 'biffread'
if. #wks do.
  wk=. {.wks
  1&create__ex data__wk       NB. 1=debug mode
NB. get worksheet location
  if. 2 131072 262144 e.~ 3!:0 x do. x=. (<x) i.~ {.("1) worksheets__ex end.
  assert. x<#worksheets__ex
  'name location'=. x{worksheets__ex
else.
  1&create__ex fread y
  location=. x
end.
NB. get worksheet location
NB. read worksheet
'ix cell'=. 0&readsheet__ex location
NB. workbook global
sst__=: sst__ex
bkrecords__=: bkrecords__ex
bkbytes__=: bkbytes__ex
NB. worksheet
records__=: records__ex
bytes__=: bytes__ex
NB. housekeeping
destroy__ex ''
for_wk. wks do. destroy__wk '' end.
destroy__ole ''
''
)

NB.  populate z locale
readexcel_z_=: readexcel_biffread_
readexcelstring_z_=: readexcelstring_biffread_
dumpexcel_z_=: dumpexcel_biffread_
readxl_z_=: readexcel_biffread_
readxlstring_z_=: readexcelstring_biffread_
readxlsheetnames_z_=: readxlsheetnames_biffread_
readxlsheets_z_=: readxlsheets_biffread_
readxlsheetsstring_z_=: readxlsheetsstring_biffread_
readxlworkbook_z_=: readxlworkbook_biffread_
