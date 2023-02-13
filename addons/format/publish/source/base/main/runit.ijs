NB. run

NB. =========================================================
publish=: 3 : 0
'file throw'=. 2 {. (boxxopen y),<FORCETHROW
file=. jpath file
locS=: conew 'ppublish'
FORCETHROW__locS=: throw
try.
  res=. publishrun__locS file
catcht.
  res=. throwtext__locS
  log res
end.
destroy__locS ''
res
)

NB. =========================================================
publishconfig=: 3 : 0
PDFCompress=: zlibinit_ppubzlib_''
)

NB. =========================================================
publishinit=: 3 : 0
loginit''
rxinit''
setdefaults ''
Counth1=: 0
Contents=: i.0 3
MasterFile=: jpathsep y
log 'master file: ',MasterFile
if. -. fexist MasterFile do.
  throw '101 Master file not found: ',MasterFile
end.
MasterPath=: getpath MasterFile
OutputFile=: ((i:&'.'{.])MasterFile),'.pdf'
log 'output file: ',OutputFile

NB. ---------------------------------------------------------
NB. load ijs in base:
dat=. pread MasterPath,'master.ijs'
if. -. dat -: _1 do. jcmd dat end.

NB. ---------------------------------------------------------
NB. load sty in current locale
dat=. pread MasterPath,'master.sty'
if. -. dat -: _1 do. 0!:100 dat end.

NB. ---------------------------------------------------------
1
)

NB. =========================================================
publishfini=: 3 : 0
rxfree Rxhnd
)

NB. =========================================================
publishrun=: 3 : 0
locB=: coname''
locT=: ''
if. 0=publishinit y do. '' return. end.
txt=. readtext MasterFile
if. 0=#txt do.
  throw '101 No text in file: ',MasterFile
end.
colorinit''
pageinit''
log 'First pass through source text'
txt=. fixedtext txt
if. 0=#txt do.
  throw '101 No source text for report'
end.
log 'Parse source text into sections'
'sec front'=. parsetext txt
FrontPage=: front
for_s. sec do.
  log 'Parse section ',":s_index
  parsesec >s
end.
b=. build front
write b
log 'Report created'
view ''
publishfini''
EMPTY
)
