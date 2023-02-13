NB. util

NB. The odbc locale is designed to be independent of the contents of
NB. the (z) locale.  Hence there will be a few utilities that overlap
NB. the standard utilities that are loaded in the (z) locale.

SZI=: IF64{4 8     NB. sizeof integer - 4 for 32 bit and 8 for 64 bit
SFX=: >IF64{'32';'64'

iad=: 15!:14@boxopen   NB. integer address of real data of a J noun

NB. handy ddl argument utils
b0=: <"0
bs=: ];#

NB. bits to index #'s

NB. first atom - the dll interface likes pure atoms
fat=: ''&$@:,

NB. trim leading and trailing blanks
alltrim=: ] #~ [: -. [: (*./\. +. *./\) ' '&=

NB. tests of sql dll returns - small ints forced to standard form
src=: ]
sqlbad=: 13 : '(src >{. y) e. DD_ERROR'
sqlok=: 13 : '(src >{. y) e. DD_SUCCESS'

NB. returns 1 if argument is a character list or atom 0 otherwise
iscl=: e.&(2 131072 262144)@(3!:0) *. 1: >: [: # $

NB. returns 1 if argument is an atom 0 otheXrwise
isua=: 0: = [: # $

NB. returns 1 if argument is integer (booleans accepted) 0 otherwise
isiu=: 3!:0 e. 1 4"_

NB. returns 1 if argument is an integer atom 0 otherwise
isia=: isua *. isiu

NB. convert short integer columns to integer columns
ifs=: [: ,. [: _1&ic ,

NB. convert 4 bit integer columns to 8 bit integer columns (for 64bit)
i64fs=: [: ,. _2 ic 2 ic ,

NB. convert short float columns (real) to double float columns
ffs=: [: ,. [: _1&fc ,

NB. decode C datetime structures
dts=: 13 : '((#y),6) $ _1&ic , 12{."1 y'

NB. format (getlasterror) messages as char lists
fmterr=: [: ; ([: ":&.> ]) ,&.> ' '"_

NB. test all sqlgetdata return codes for a row
badrow=: 13 : '0 e. (src ;{.&> y) e. DD_SUCCESS'

NB. returns 1 if argument is a box 0 otherwise
isbx=: 3!:0 e. 32"_

NB. returns 1 if argument is a character 0 otherwise
isca=: 3!:0 e. 2 131072 262144"_

NB. convert integer to string
cvt2str=: 'a'&,@":

NB. return result assuming no error
sqlres=: 3 : 0
1&{::^:UseErrRet y
)

NB. test if result ok
sqlresok=: 3 : 0
([: -. SQL_ERROR&-:)`(MYSQL_OK = >@{.)@.UseErrRet y
)

NB. return success
ret_DD_OK=: 3 : 0
if. UseErrRet do. (<DD_OK), <y else. if. y do. y else. DD_OK end. end.
)

NB. translate sh to its ch
sh_to_ch=: 3 : 0
if. -.y e. shs=. 1{"1 CSPALL do. _1 return. end.
(shs i.y) { 0{"1 CSPALL
)

NB. translate sh to its meta resultset
sh_to_mres=: 3 : 0
if. -.y e. shs=. 0{"1 SMPALL do. _1 return. end.
(shs i.y) { 1{"1 SMPALL
)

NB. =========================================================
fmtfch=: >`(,.@:,)@.(1 4 8 e.~ 3!:0)

fmtfchres=: 3 : 0
if. UseErrRet do.
  if. sqlresok y do. y=. ({.y), fmtfch&.>&.>{:y end.
else.
  fmtfch&.> y
end.
)

NB. =========================================================
NB. convert date to dayno with fraction
todaynox=: 3 : 0
a=. todayno 3{."1 y
s=. 86400 %~ 3600 60 1 +/ .*"1 [ 3}."1 y
a+s
)

NB. =========================================================
NB. convert dayno with fraction to 6 element vector format
todatex=: 3 : 0
ymd=. todate d=. <. y
ymd,. 24 60 60#: 86400*y-d
)

