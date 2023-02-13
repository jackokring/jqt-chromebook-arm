NB. ---------------------------------------------------------
NB.  jolew script for reading and writing ole2 storage
NB.  portion based on ole::storage_lite by kawai takanori, kwitknr@cpan.org
NB. utility function for olew
coclass 'oleutlfcn'
NB. return datetime in j timestamp format
oledate2local=: 3 : 0
86400000* _72682+86400%~10000000%~(8#256)#. a.i.y
)

NB. y datetime in j timestamp format
localdate2ole=: 3 : 0
a.{~(8#256)#: 10000000*x:86400*(y%86400000)+72682
)

NB. not defined in stdlib pre-J6
Note=: 3 : '0 0 $ 0 : 0' : [

NB. followings also defined in z locale
NB. ---------------------------------------------------------
NB. followings bit op require j5
bitand=: 17 b.
bitxor=: 22 b.
bitor=: 23 b.
bitneg=: 26 b.
bitrot=: 32 b.
bitshl=: 33 b.
bitsha=: 34 b.
NB. binary strings
bigendian=: ({.a.)={. 1&(3!:4) 1  NB. 0 little endian   1 big endian
toBYTE=: {&a.@(256&|)
fromBYTE=: a.&i.
toWORDm=: 1&(3!:4)@:<.
toDWORDm=: 2&(3!:4)@:<.
toucodem=: ''&,@(1&(3!:4))@(3&u:)@u:
toDoublem=: 2&(3!:5)
fromWORDm=: _1&(3!:4)
fromDWORDm=: _2&(3!:4)
fromucodem=: 6&u:
fromDoublem=: _2&(3!:5)
toWORDr=: ,@:(|."1)@(_2: ]\ 1&(3!:4)@:<.)
toDWORDr=: ,@:(|."1)@(_4: ]\ 2&(3!:4)@:<.)
toucoder=: ''&,@:,@:(|."1@(_2: ]\ 1&(3!:4)))@(3&u:)@u:
toDoubler=: ,@:(|."1)@(_8: ]\ 2&(3!:5))
fromWORDr=: _1&(3!:4)@:,@:(|."1)@(_2&(]\))
fromDWORDr=: _2&(3!:4)@:,@:(|."1)@(_4&(]\))
fromucoder=: 6&u:@:,@:(|."1)@(_2&(]\))
fromDoubler=: _2&(3!:5)@:,@:(|."1)@(_8&(]\))
NB. always little endian conversion
toWORD0=: toWORDm`toWORDr@.bigendian f.
toDWORD0=: toDWORDm`toDWORDr@.bigendian f.
toucode0=: toucodem`toucoder@.bigendian f.
toDouble0=: toDoublem`toDoubler@.bigendian f.
fromWORD0=: fromWORDm`fromWORDr@.bigendian f.
fromDWORD0=: fromDWORDm`fromDWORDr@.bigendian f.
fromucode0=: fromucodem`fromucoder@.bigendian f.
fromDouble0=: fromDoublem`fromDoubler@.bigendian f.
NB. always big endian conversion
toWORD1=: toWORDm`toWORDr@.(-.bigendian) f.
toDWORD1=: toDWORDm`toDWORDr@.(-.bigendian) f.
toucode1=: toucodem`toucoder@.(-.bigendian) f.
toDouble1=: toDoublem`toDoubler@.(-.bigendian) f.
fromWORD1=: fromWORDm`fromWORDr@.(-.bigendian) f.
fromDWORD1=: fromDWORDm`fromDWORDr@.(-.bigendian) f.
fromucode1=: fromucodem`fromucoder@.(-.bigendian) f.
fromDouble1=: fromDoublem`fromDoubler@.(-.bigendian) f.

NB. for biff8 RGB values
RGB=: 3 : 0"1
(0{y) (23 b.) 8 (33 b.) (1{y) (23 b.) 8 (33 b.) (2{y)
)

RGBtuple=: 3 : 0"0
(16bff (17 b.) y), (_8 (33 b.) 16bff00 (17 b.) y), (_16 (33 b.) 16bff0000 (17 b.) y)
)

NB. utf8 filename in J601
3 : 0''
if. 504 < 0&". 'j'-.~4{.9!:14 '' do.
NB.  fboxname=: <@jpath_j_@(8 u: >) ::]`]@.(32 2 131072 262144 -.@e.~ 3!:0)
  fboxname=: <@jpath_j_@(8 u: >) ::]`<.@.(1 4 8 e.~ 3!:0)
else.
  fboxname=: ([: < [: (1&u: ::]) >) ::]
end.
empty ''
)

fread=: (1!:1 :: _1:) @ fboxname
fdir=: 1!:0@fboxname
freadx=: (1!:11 :: _1:)@(fboxname@{., }.)`(1!:11)@.(0: = L.)
fwritex=: ([ (1!:12) (fboxname@{., }.)@])`(1!:12)@.((0: = L.)@])
fopen=: (1!:21 :: _1:) @ (fboxname &>) @ boxopen
fclose=: (1!:22 :: _1:) @ (fboxname &>) @ boxopen
fwrite=: [ (1!:2) fboxname@]
fappend=: [ (1!:3) fboxname@]
fexist=: (1:@(1!:4) :: 0:) @ (fboxname &>) @ boxopen
ferase=: (1!:55 :: _1:) @ (fboxname &>) @ boxopen
maxpp=: 15 [ 16   NB. max print precision for ieee 8-byte double (52 + 1 implied mantissa)
NB. ---------------------------------------------------------

coclass 'oleheaderinfo'
coinsert 'olepps'
create=: 3 : 0
smallsize=: 16b1000
ppssize=: 16b80
bigblocksize=: 16b200
smallblocksize=: 16b0040
bdbcount=: 0
rootstart=: 0
sbdstart=: 0
sbdcount=: 0
extrabbdstart=: 0
extrabbdcount=: 0
bbdinfo=: 0 2$''
sbstart=: 0
sbsize=: 0
data=: ''
fileh=: ''
ppsfile=: ''
)

coclass 'olestorage'
coinsert 'oleutlfcn'
ppstyperoot=: 5
ppstypedir=: 1
ppstypefile=: 2
datasizesmall=: 16b1000
longintsize=: 4
ppssize=: 16b80
create=: 3 : 0
sfile=: y
openfilenum=: ''
headerinfo=: ''
)

destroy=: 3 : 0
if. '' -.@-: openfilenum do. fclose("0) openfilenum end.
if. '' -.@-: headerinfo do. destroy__headerinfo '' end.
codestroy ''
)

NB.  getppstree:
getppstree=: 3 : 0
bdata=. y
NB. 0.init
rhinfo=. initparse sfile
if. ''-:rhinfo do. '' return. end.
NB. 1. get data
1{:: ugetppstree 0 ; rhinfo ; bdata ;< 0$0
)

NB.  getsearch:
getppssearch=: 3 : 0
'raname bdata icase'=. y
NB. 0.init
rhinfo=. initparse sfile
if. ''-:rhinfo do. '' return. end.
NB. 1. get data
1{:: ugetppssearch 0 ; rhinfo ; raname ; bdata ; icase ;< 0$0
)

NB.  getnthpps:
getnthpps=: 3 : 0
'ino bdata'=. y
NB. 0.init
rhinfo=. initparse sfile
if. ''-:rhinfo do. '' return. end.
NB. 1. get data
1{:: ugetnthpps ino ; rhinfo ; <bdata
)

NB.  initparse:
initparse=: 3 : 0
if. '' -.@-: headerinfo do. headerinfo return. end.
NB. 1. sfile is a resource  hopefully a file resource
if. 1 4 e.~ 3!:0 y do.
  oio=. y
else.
NB. 2. sfile is a filename string
  openfilenum=: ~. openfilenum, oio=. fopen boxopen y   NB. ~. workaround J504's 1!:21 bug
end.
if. '' -.@-: p=. getheaderinfo oio do. headerinfo=: p end.
p
)

NB.  ugetppstree:
ugetppstree=: 3 : 0
'ino rhinfo bdata radone'=. y
if. #radone do.
  if. ino e. radone do. radone ; <'' return. end.
end.
irootblock=. rootstart__rhinfo
NB. 1. get information about itself
if. ''-: opps=. ugetnthpps ino ; rhinfo ; <bdata do. radone ; <'' return. end.
radone=. radone, ino
NB. 2. child
if. dirpps__opps ~: _1 do.
  'rad achild'=. ugetppstree dirpps__opps ; rhinfo ; bdata ; <radone
  radone=. radone, rad
  child__opps=: child__opps, achild
else.
  child__opps=: ''
end.
NB. 3. previous, next ppss
alist=. ''
if. prevpps__opps ~: _1 do.
  'rad achild'=. ugetppstree prevpps__opps ; rhinfo ; bdata ; <radone
  radone=. radone, rad
  alist=. alist, achild
end.
alist=. alist, opps
if. nextpps__opps ~: _1 do.
  'rad achild'=. ugetppstree nextpps__opps ; rhinfo ; bdata ; <radone
  radone=. radone, rad
  alist=. alist, achild
end.
radone ; <alist
)

NB.  ugetppssearch:
ugetppssearch=: 3 : 0
'ino rhinfo raname bdata icase radone'=. y
irootblock=. rootstart__rhinfo
NB. 1. check it self
if. #radone do.
  if. ino e. radone do. radone ; <'' return. end.
end.
alist=. ''
if. ''-: opps=. ugetnthpps ino ; rhinfo ; <0 do. radone ; <'' return. end.
found=. 0
if. ((icase *. name__opps -:&toupper raname) +. name__opps-:raname) do.
  if. 1=bdata do.
    if. ''-: opps1=. ugetnthpps ino ; rhinfo ; <bdata do.
      destroy__opps ''
      radone ; <'' return.
    else.
      destroy__opps ''
      alist=. opps=. opps1
      radone=. radone, ino
    end.
  else.
    alist=. opps
    radone=. radone, ino
  end.
  found=. 1
end.
NB. 2. check child, previous, next ppss
if. dirpps__opps ~: _1 do.
  'rad achild'=. ugetppssearch dirpps__opps ; rhinfo ; raname ; bdata ; icase ; <radone
  radone=. radone, rad
  alist=. alist, achild
end.
if. prevpps__opps ~: _1 do.
  'rad achild'=. ugetppssearch prevpps__opps ; rhinfo ; raname ; bdata ; icase ; <radone
  radone=. radone, rad
  alist=. alist, achild
end.
if. nextpps__opps ~: _1 do.
  'rad achild'=. ugetppssearch nextpps__opps ; rhinfo ; raname ; bdata ; icase ; <radone
  radone=. radone, rad
  alist=. alist, achild
end.
if. 0=found do. destroy__opps '' end.
radone ; <alist
)

NB.  get header info  base informain about that file
getheaderinfo=: 3 : 0
NB. 0. check id
fp=. 0
if. -. (freadx y, fp, 8)-:16bd0 16bcf 16b11 16be0 16ba1 16bb1 16b1a 16be1{a. do. '' return. end.
rhinfo=. '' conew 'oleheaderinfo'
fileh__rhinfo=: y
NB. big block size
if. ''-:iwk=. getinfofromfile fileh__rhinfo ; 16b1e ; 2 do. '' [ destroy__rhinfo '' return. end.
bigblocksize__rhinfo=: <. 2&^ iwk
NB. small block size
if. ''-:iwk=. getinfofromfile fileh__rhinfo ; 16b20 ; 2 do. '' [ destroy__rhinfo '' return. end.
smallblocksize__rhinfo=: <. 2&^ iwk
NB. bdb count
if. ''-:iwk=. getinfofromfile fileh__rhinfo ; 16b2c ; 4 do. '' [ destroy__rhinfo '' return. end.
bdbcount__rhinfo=: iwk
NB. start block
if. ''-:iwk=. getinfofromfile fileh__rhinfo ; 16b30 ; 4 do. '' [ destroy__rhinfo '' return. end.
rootstart__rhinfo=: iwk
if. ''-:iwk=. getinfofromfile fileh__rhinfo ; 16b3c ; 4 do. '' [ destroy__rhinfo '' return. end.
sbdstart__rhinfo=: iwk
NB. small bd count
if. ''-:iwk=. getinfofromfile fileh__rhinfo ; 16b40 ; 4 do. '' [ destroy__rhinfo '' return. end.
sbdcount__rhinfo=: iwk
NB. extra bbd start
if. ''-:iwk=. getinfofromfile fileh__rhinfo ; 16b44 ; 4 do. '' [ destroy__rhinfo '' return. end.
extrabbdstart__rhinfo=: iwk
NB. extra bd count
if. ''-:iwk=. getinfofromfile fileh__rhinfo ; 16b48 ; 4 do. '' [ destroy__rhinfo '' return. end.
extrabbdcount__rhinfo=: iwk
NB. get bbd info
bbdinfo__rhinfo=: getbbdinfo rhinfo
NB. get root pps
if. ''-: opps=. ugetnthpps 0 ; rhinfo ; <0 do. '' [ destroy__rhinfo '' return. end.
sbstart__rhinfo=: startblock__opps
sbsize__rhinfo=: size__opps
destroy__opps ''
rhinfo
)

NB.  getinfofromfile
getinfofromfile=: 3 : 0
'file ipos ilen'=. y
if. ''-:file do. '' return. end.
if. 2=ilen do.
  fromWORD0 freadx file, ipos, ilen
else.
  fromDWORD0 freadx file, ipos, ilen
end.
)

NB.  getbbdinfo
getbbdinfo=: 3 : 0
rhinfo=. y
abdlist=. ''
ibdbcnt=. bdbcount__rhinfo
i1stcnt=. <.(bigblocksize__rhinfo - 16b4c) % longintsize
ibdlcnt=. (<.bigblocksize__rhinfo % longintsize) - 1
NB. 1. 1st bdlist
fp=. 16b4c
igetcnt=. ibdbcnt <. i1stcnt
abdlist=. abdlist, fromDWORD0 freadx fileh__rhinfo, fp, longintsize*igetcnt
ibdbcnt=. ibdbcnt - igetcnt
NB. 2. extra bdlist
iblock=. extrabbdstart__rhinfo
while. ((ibdbcnt> 0) *. isnormalblock iblock) do.
  fp=. setfilepos iblock ; 0 ; <rhinfo
  igetcnt=. ibdbcnt <. ibdlcnt
  abdlist=. abdlist, fromDWORD0 freadx fileh__rhinfo, fp, longintsize*igetcnt
  ibdbcnt=. ibdbcnt - igetcnt
  iblock=. fromDWORD0 freadx fileh__rhinfo, (fp=. fp+longintsize*igetcnt), longintsize
end.
NB. 3.get bds
iblkno=. 0
ibdcnt=. <.bigblocksize__rhinfo % longintsize
hbd=. 0 2$''
for_ibdl. abdlist do.
  fp=. setfilepos ibdl ; 0 ; <rhinfo
  awk=. fromDWORD0 freadx fileh__rhinfo, fp, bigblocksize__rhinfo
  for_i. i.ibdcnt do.
    if. ((i{awk) ~: iblkno+1) do.
      hbd=. hbd, iblkno, i{awk
    end.
    iblkno=. >:iblkno
  end.
end.
hbd
)

NB.  ugetnthpps
ugetnthpps=: 3 : 0
'ipos rhinfo bdata'=. y
ippsstart=. rootstart__rhinfo
ibasecnt=. <.bigblocksize__rhinfo % ppssize
ippsblock=. <.ipos % ibasecnt
ippspos=. ipos |~ ibasecnt
iblock=. getnthblockno ippsstart ; ippsblock ; <rhinfo
if. ''-:iblock do. '' return. end.
fp=. setfilepos iblock ; (ppssize*ippspos) ; <rhinfo
inmsize=. fromWORD0 (16b40+i.2){swk=. freadx fileh__rhinfo, fp, ppssize
inmsize=. 0 >. inmsize - 2
snm=. inmsize{.swk
sname=. fromucode0 (i.inmsize){swk
itype=. 256|fromWORD0 (16b42+i.2){swk
'lppsprev lppsnext ldirpps'=. fromDWORD0 (16b44+i.12){swk
ratime1st=: ((itype = ppstyperoot) +. (itype = ppstypedir)) { 0, oledate2local (16b64+i.8){swk
ratime2nd=: ((itype = ppstyperoot) +. (itype = ppstypedir)) { 0, oledate2local (16b6c+i.8){swk
'istart isize'=. fromDWORD0 (16b74+i.8){swk
if. 1=bdata do.
  sdata=. getdata itype ; istart ; isize ; <rhinfo
  pps=. createpps ipos ; sname ; itype ; lppsprev ; lppsnext ; ldirpps ; ratime1st ; ratime2nd ; istart ; isize ; sdata
else.
  pps=. createpps ipos ; sname ; itype ; lppsprev ; lppsnext ; ldirpps ; ratime1st ; ratime2nd ; istart ; isize
end.
pps
)

NB.  setfilepos
setfilepos=: 3 : 0
'iblock ipos rhinfo'=. y
ipos + (iblock+1)*bigblocksize__rhinfo
)

NB.  getnthblockno
getnthblockno=: 3 : 0
'istblock inth rhinfo'=. y
inext=. istblock
for_i. i.inth do.
  isv=. inext
  inext=. getnextblockno isv ; <rhinfo
  if. 0= isnormalblock inext do. '' return. end.
end.
inext
)

NB.  getdata
getdata=: 3 : 0
'itype iblock isize rhinfo'=. y
if. itype = ppstypefile do.
  if. isize < datasizesmall do.
    getsmalldata iblock ; isize ; <rhinfo
  else.
    getbigdata iblock ; isize ; <rhinfo
  end.
elseif. itype = ppstyperoot do.  NB. root
  getbigdata iblock ; isize ; <rhinfo
elseif. itype = ppstypedir do.  NB.  directory
  0
end.
)

NB.  getbigdata
getbigdata=: 3 : 0
'iblock isize rhinfo'=. y
if. 0= isnormalblock iblock do. '' return. end.
irest=. isize
sres=. ''
akeys=. /:~ {.("1) bbdinfo__rhinfo
while. irest > 0 do.
  ares=. (akeys>:iblock)#akeys
  inkey=. {.ares
  i=. inkey - iblock
  inext=. ({:("1) bbdinfo__rhinfo){~({.("1) bbdinfo__rhinfo)i.inkey
  fp=. setfilepos iblock ; 0 ; <rhinfo
  igetsize=. irest <. bigblocksize__rhinfo * (i+1)
  sres=. sres, freadx fileh__rhinfo, fp, igetsize
  irest=. irest-igetsize
  iblock=. inext
end.
sres
)

NB.  getnextblockno
getnextblockno=: 3 : 0
'iblockno rhinfo'=. y
if. iblockno e. {.("1) bbdinfo__rhinfo do.
  ({:("1) bbdinfo__rhinfo){~({.("1) bbdinfo__rhinfo)i.iblockno
else.
  iblockno+1
end.
)

NB.  isnormalblock
NB. _4 : bdlist, _3 : bbd,
NB. _2: end of chain _1 : unused
isnormalblock=: 3 : 0
y -.@e. _4 _3 _2 _1
)

NB.  getsmalldata
getsmalldata=: 3 : 0
'ismblock isize rhinfo'=. y
irest=. isize
sres=. ''
while. irest > 0 do.
  fp=. setfilepossmall ismblock ; <rhinfo
  sres=. sres, freadx fileh__rhinfo, fp, irest <. smallblocksize__rhinfo
  irest=. irest - smallblocksize__rhinfo
  ismblock=. getnextsmallblockno ismblock ; <rhinfo
end.
sres
)

NB.  setfilepossmall
setfilepossmall=: 3 : 0
'ismblock rhinfo'=. y
ismstart=. sbstart__rhinfo
ibasecnt=. <.bigblocksize__rhinfo % smallblocksize__rhinfo
inth=. <.ismblock%ibasecnt
ipos=. ismblock |~ ibasecnt
iblk=. getnthblockno ismstart ; inth ; <rhinfo
setfilepos iblk ; (ipos * smallblocksize__rhinfo) ; <rhinfo
)

NB.  getnextsmallblockno
getnextsmallblockno=: 3 : 0
'ismblock rhinfo'=. y
ibasecnt=. <.bigblocksize__rhinfo % longintsize
inth=. <.ismblock%ibasecnt
ipos=. ismblock |~ ibasecnt
iblk=. getnthblockno sbdstart__rhinfo ; inth ; <rhinfo
fp=. setfilepos iblk ; (ipos * longintsize) ; <rhinfo
fromDWORD0 freadx fileh__rhinfo, fp, longintsize
)

createpps=: 3 : 0
'ipos sname itype lppsprev lppsnext ldirpps ratime1st ratime2nd istart isize sdata'=. 11{.y
select. {.itype
case. ppstyperoot do.
  p=. conew 'oleppsroot'
  create__p ratime1st ; ratime2nd ;< ''
case. ppstypedir do.
  p=. conew 'oleppsdir'
  create__p sname ; ratime1st ; ratime2nd ;< ''
case. ppstypefile do.
  p=. conew 'oleppsfile'
  create__p sname ; sdata ;< ''
case. do.
  assert. 0
end.
no__p=: ipos
name__p=: u: sname
type__p=: {.itype
prevpps__p=: lppsprev
nextpps__p=: lppsnext
dirpps__p=: ldirpps
time1st__p=: ratime1st
time2nd__p=: ratime2nd
startblock__p=: istart
size__p=: isize
data__p=: sdata
p
)

coclass 'olepps'
coinsert 'oleutlfcn'
ppstyperoot=: 5
ppstypedir=: 1
ppstypefile=: 2
datasizesmall=: 16b1000
longintsize=: 4
ppssize=: 16b80
child=: ''
adoptedchild=: ''
NB.  no
NB.  name
NB.  type
NB.  prevpps
NB.  nextpps
NB.  dirpps
NB.  time1st
NB.  time2nd
NB.  startblock
NB.  size
NB.  data
NB.  child
NB.  ppsfile

destroy=: 3 : 0
for_pps. child -. adoptedchild do. destroy__pps '' end.
codestroy ''
)

fputs=: 3 : 0
if. fileh-:'' do. data=: data, y else. fileh fappend~ y end.
)

NB. ---------------------------------------------------------
NB.  datalen
NB.  check for update
NB. ---------------------------------------------------------
datalen=: 3 : 0
if. '' -.@-: ppsfile do. fsize ppsfile return. end.
#data
)

NB. ---------------------------------------------------------
NB.  makesmalldata
NB. ---------------------------------------------------------
makesmalldata=: 3 : 0
'alist rhinfo'=. y
sres=. ''
ismblk=. 0
for_opps. alist do.
NB. 1. make sbd, small data string
  if. type__opps=ppstypefile do.
    if. size__opps <: 0 do. continue. end.
    if. size__opps < smallsize__rhinfo do.
      ismbcnt=. >. size__opps % smallblocksize__rhinfo
NB. 1.1 add to sbd
      for_i. i.ismbcnt-1 do.
        fputs__rhinfo toDWORD0 i+ismblk+1
      end.
      fputs__rhinfo toDWORD0 _2
NB. 1.2 add to data string  will be written for rootentry
NB. check for update
      if. '' -.@-: ppsfile__opps do.
        sres=. sres, ]`(''"_)@.(_1&-:)@:fread ppsfile__opps
      else.
        sres=. sres, data__opps
      end.
      if. size__opps |~ smallblocksize__rhinfo do.
        sres=. sres, ({.a.) #~ smallblocksize__rhinfo ([ - |) size__opps
      end.
NB. 1.3 set for pps
      startblock__opps=: ismblk
      ismblk=. ismblk + ismbcnt
    end.
  end.
end.
isbcnt=. <. bigblocksize__rhinfo % longintsize
if. ismblk |~ isbcnt do.
  fputs__rhinfo, (,:toDWORD0 _1) #~ isbcnt ([ - |) ismblk
end.
NB. 2. write sbd with adjusting length for block
sres
)

NB. ---------------------------------------------------------
NB.  saveppswk
NB. ---------------------------------------------------------
saveppswk=: 3 : 0
rhinfo=. y
NB. 1. write pps
z=. toucode0 name
z=. z, ({.a.)#~ 64-2*#name                         NB.   64
z=. z, toWORD0 2*1+#name                     NB.   66
z=. z, toBYTE type                                 NB.   67
z=. z, toBYTE 16b00 NB. uk                         NB.   68
z=. z, toDWORD0 prevpps NB. prev             NB.   72
z=. z, toDWORD0 nextpps NB. next             NB.   76
z=. z, toDWORD0 dirpps  NB. dir              NB.   80
z=. z, 0 9 2 0{a.                                  NB.   84
z=. z, 0 0 0 0{a.                                  NB.   88
z=. z, 16bc0 0 0 0{a.                              NB.   92
z=. z, 0 0 0 16b46{a.                              NB.   96
z=. z, 0 0 0 0{a.                                  NB.  100
z=. z, localdate2ole time1st                       NB.  108
z=. z, localdate2ole time2nd                       NB.  116
z=. z, toDWORD0 startblock                   NB.  120
z=. z, toDWORD0 size                         NB.  124
z=. z, toDWORD0 0                            NB.  128
fputs__rhinfo z
z
)

coclass 'oleppsdir'
coinsert 'olepps'
create=: 3 : 0
'sname ratime1st ratime2nd rachild'=. y
no=: 0
name=: u: sname
type=: ppstypedir
prevpps=: 0 ] _1
nextpps=: 0 ] _1
dirpps=: 0 ] _1
time1st=: ratime1st
time2nd=: ratime2nd
startblock=: 0
size=: 0
data=: ''
child=: rachild
adoptedchild=: rachild
fileh=: ''
ppsfile=: ''
)

coclass 'oleppsfile'
coinsert 'olepps'
create=: 3 : 0
'snm sdata sfile'=. y
no=: 0
name=: u: snm
type=: ppstypefile
prevpps=: 0 ] _1
nextpps=: 0 ] _1
dirpps=: 0 ] _1
time1st=: 0
time2nd=: 0
startblock=: 0
size=: 0
data=: >(''-:sfile) { sdata ; ''
child=: ''
fileh=: ''
ppsfile=: ''
if. '' -.@-: sfile do.
  if. 1 4 e.~ 3!:0 sfile do.
    ppsfile=: sfile
  elseif. do.
    fname=. sfile
    ferase <fname
    ppsfile=: fopen boxopen fname
  end.
  if. #sdata do.
    ppsfile fappend~ sdata
  end.
end.
)

append=: 3 : 0
if. '' -.@-: ppsfile do.
  ppsfile fappend~ y
else.
  data=: data, y
end.
)

coclass 'oleppsroot'
coinsert 'olepps'
create=: 3 : 0
'ratime1st ratime2nd rachild'=. y
no=: 0
name=: u: 'Root Entry'
type=: ppstyperoot
prevpps=: 0 ] _1
nextpps=: 0 ] _1
dirpps=: 0 ] _1
time1st=: ratime1st
time2nd=: ratime2nd
startblock=: 0
size=: 0
data=: ''
child=: rachild
adoptedchild=: rachild
fileh=: ''
ppsfile=: ''
)

NB.  save  ole:
save=: 3 : 0
'sfile bnoas rhinfo'=. y
if. ''-:rhinfo do.
  rhinfo=. '' conew 'oleheaderinfo'
end.
bigblocksize__rhinfo=: <. 2&^ (0= bigblocksize__rhinfo) { (adjust2 bigblocksize__rhinfo), 9
smallblocksize__rhinfo=: <. 2&^ (0= smallblocksize__rhinfo) { (adjust2 smallblocksize__rhinfo), 6
smallsize__rhinfo=: 16b1000
ppssize__rhinfo=: 16b80
NB. 1.open file
NB. 1.1 sfile is ref of scalar
if. ''-:sfile do.
  fileh__rhinfo=: ''
elseif. 1 4 e.~ 3!:0 sfile do.
  fileh__rhinfo=: sfile
NB. 1.2 sfile is a simple filename string
elseif. do.
  ferase <sfile
  fileh__rhinfo=: fopen boxopen sfile
end.
iblk=. 0
NB. 1. make an array of pps  for save
alist=. ''
list=. 18!:5 ''
if. bnoas do.
  alist=. 0{::saveppssetpnt2 list ; alist ; <rhinfo
else.
  alist=. 0{::saveppssetpnt list ; alist ; <rhinfo
end.
'isbdcnt ibbcnt ippscnt'=. calcsize alist ; <rhinfo
NB. 2.save header
saveheader rhinfo ; isbdcnt ; ibbcnt ; <ippscnt
NB. 3.make small data string  write sbd
ssmwk=. makesmalldata alist ; <rhinfo
data=: ssmwk  NB. small datas become rootentry data
NB. 4. write bb
ibblk=. isbdcnt
ibblk=. savebigdata ibblk ; alist ; <rhinfo
NB. 5. write pps
savepps alist ; <rhinfo
NB. 6. write bd and bdlist and adding header informations
savebbd isbdcnt ; ibbcnt ; ippscnt ; <rhinfo
NB. 7.close file
if. (''-.@-:sfile) *. -. 1 4 e.~ 3!:0 sfile do.
  fclose fileh__rhinfo
end.
if. ''-:sfile do.
  rc=. data__rhinfo
else.
  rc=. ''
end.
destroy__rhinfo ''
rc
)

NB.  calcsize
calcsize=: 3 : 0
'ralist rhinfo'=. y
NB. 0. calculate basic setting
isbdcnt=. 0
ibbcnt=. 0
ippscnt=. 0
ismalllen=. 0
isbcnt=. 0
for_opps. ralist do.
  if. type__opps=ppstypefile do.
    size__opps=: datalen__opps ''  NB. mod
    if. size__opps < smallsize__rhinfo do.
      isbcnt=. isbcnt + >.size__opps % smallblocksize__rhinfo
    else.
      ibbcnt=. ibbcnt + >.size__opps % bigblocksize__rhinfo
    end.
  end.
end.
ismalllen=. isbcnt * smallblocksize__rhinfo
islcnt=. <. bigblocksize__rhinfo % longintsize
isbdcnt=. >.isbcnt % islcnt
ibbcnt=. ibbcnt + >.ismalllen % bigblocksize__rhinfo
icnt=. #ralist
ibdcnt=. <.bigblocksize__rhinfo % ppssize
ippscnt=. >.icnt % ibdcnt
isbdcnt ; ibbcnt ; <ippscnt
)

NB.  adjust2
adjust2=: 3 : 0
>. 2^.y
)

NB.  saveheader
saveheader=: 3 : 0
'rhinfo isbdcnt ibbcnt ippscnt'=. y
NB. 0. calculate basic setting
iblcnt=. <.bigblocksize__rhinfo % longintsize
i1stbdl=. <.(bigblocksize__rhinfo - 16b4c) % longintsize
i1stbdmax=. (i1stbdl*iblcnt) - i1stbdl
ibdexl=. 0
iall=. ibbcnt + ippscnt + isbdcnt
iallw=. iall
ibdcntw=. >.iallw % iblcnt
ibdcnt=. >.(iall + ibdcntw) % iblcnt
NB. 0.1 calculate bd count
if. ibdcnt > 109 do.
  iblcnt=. <:iblcnt  NB. the blcnt is reduced in the count of the last sect is used for a pointer the next bl
  ibbleftover=. iall - i1stbdmax
  if. iall > i1stbdmax do.
    whilst. ibdcnt > >. ibbleftover % iblcnt do.
      ibdcnt=. >. ibbleftover % iblcnt
      ibdexl=. >. ibdcnt % iblcnt
      ibbleftover=. ibbleftover + ibdexl
    end.
  end.
  ibdcnt=. ibdcnt + i1stbdl
end.
NB. 1.save header
z=. 16bd0 16bcf 16b11 16be0 16ba1 16bb1 16b1a 16be1{a.
z=. z, 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0{a.
z=. z, toWORD0 16b3b
z=. z, toWORD0 16b03
z=. z, toWORD0 _2
z=. z, toWORD0 9
z=. z, toWORD0 6
z=. z, toWORD0 0
z=. z, 0 0 0 0 0 0 0 0 {a.
z=. z, toDWORD0 ibdcnt
z=. z, toDWORD0 ibbcnt+isbdcnt NB. root start
z=. z, toDWORD0 0
z=. z, toDWORD0 16b1000
z=. z, toDWORD0 (0=isbdcnt){0 _2    NB. small block depot
z=. z, toDWORD0 isbdcnt
NB. 2. extra bdlist start, count
if. ibdcnt < i1stbdl do.
  z=. z, toDWORD0 _2       NB. extra bdlist start
  z=. z, toDWORD0 0        NB. extra bdlist count
else.
  z=. z, toDWORD0 iall+ibdcnt
  z=. z, toDWORD0 ibdexl
end.
fputs__rhinfo z
NB. 3. bdlist
i=. 0
while. (i<i1stbdl) *. (i < ibdcnt) do.
  fputs__rhinfo toDWORD0 iall+i
  i=. >:i
end.
if. i<i1stbdl do.
  fputs__rhinfo, (,:toDWORD0 _1) #~ i1stbdl-i
end.
)

NB.  savebigdata
savebigdata=: 3 : 0
'istblk ralist rhinfo'=. y
ires=. 0
NB. 1.write big (ge 16b1000)  data into block
for_opps. ralist do.
  if. type__opps ~: ppstypedir do.
    size__opps=: datalen__opps ''   NB. mod
    if. ((size__opps >: smallsize__rhinfo) +. ((type__opps = ppstyperoot) *. 0~:#data__opps)) do.
NB. 1.1 write data
NB. check for update
      if. '' -.@-: ppsfile__opps do.
NB. check for update
        ilen=. #sbuff=. ]`(''"_)@.(_1&-:)@:fread ppsfile__opps
        fputs__rhinfo sbuff
      else.
        fputs__rhinfo data__opps
      end.
      if. size__opps |~ bigblocksize__rhinfo do.
NB.  todo: check, if strrepeat()  is binary safe
        fputs__rhinfo ({.a.) #~ bigblocksize__rhinfo ([ - |) size__opps
      end.
NB. 1.2 set for pps
      startblock__opps=: istblk
      istblk=. istblk + >.size__opps % bigblocksize__rhinfo
    end.
  end.
end.
istblk
)

NB.  savepps
savepps=: 3 : 0
'ralist rhinfo'=. y
NB. 0. initial
NB. 2. save pps
for_pps. ralist do. saveppswk__pps rhinfo end.
NB. 3. adjust for block
icnt=. #ralist
ibcnt=. <.bigblocksize__rhinfo % ppssize__rhinfo
if. (icnt |~ ibcnt) do.
  fputs__rhinfo ({.a.) #~ (ibcnt ([ - |) icnt) * ppssize__rhinfo
end.
>.icnt % ibcnt
)

NB.  saveppssetpnt2
NB.   for test
saveppssetpnt2=: 3 : 0
'athis ralist rhinfo'=. y
NB. 1. make array as children-relations
NB. 1.1 if no children
if. ''-:athis do. ralist ; _1 return.
elseif. 1=#athis do.
NB. 1.2 just only one
  ralist=. ralist, l=. 0{athis
  no__l=: (#ralist) -1
  prevpps__l=: _1
  nextpps__l=: _1
  ralist=. 0{::ra=. saveppssetpnt2 child__l ; ralist ; <rhinfo
  dirpps__l=: _1{::ra
  ralist ; no__l return.
elseif. do.
NB. 1.3 array
  icnt=. #athis
NB. 1.3.1 define center
  ipos=. 0 NB. int(icnt% 2)
  awk=. athis
  if. (#athis) > 2 do.
    aprev=. 1{awk
    anext=. 2}.awk
  else.
    aprev=. ''
    anext=. }.awk
  end.
  l=. ipos{athis
  ralist=. 0{::ra=. saveppssetpnt2 aprev ; ralist ; <rhinfo
  prevpps__l=: _1{::ra
  ralist= ralist, l
  no__l=: (#ralist) -1
NB. 1.3.2 devide a array into previous, next
  ralist=. 0{::ra=. saveppssetpnt2 anext ; ralist ; <rhinfo
  nextpps__l=: _1{::ra
  ralist=. 0{::ra=. saveppssetpnt2 child__l ; ralist ; <rhinfo
  dirpps__l=: _1{::ra
  ralist ; no__l return.
end.
)

NB.  saveppssetpnt2
NB.   for test
saveppssetpnt2s=: 3 : 0
'athis ralist rhinfo'=. y
NB. 1. make array as children-relations
NB. 1.1 if no children
if. (0:=#) athis do. ralist ; _1 return.
elseif. (#athis) =1 do.
NB. 1.2 just only one
  ralist=. ralist, l=. 0{athis
  no__l=: (#ralist) -1
  prevpps__l=: _1
  nextpps__l=: _1
  ralist=. 0{::ra=. saveppssetpnt2 child__l ; ralist ; <rhinfo
  dirpps__l=: _1{::ra
  ralist ; no__l return.
elseif. do.
NB. 1.3 array
  icnt=. #athis
NB. 1.3.1 define center
  ipos=. 0 NB. int(icnt% 2)
  ralist=. ralist, l=. ipos{athis
  no__l=: (#ralist) -1
  awk=. athis
NB. 1.3.2 devide a array into previous, next
  aprev=. ipos{.awk
  anext=. (1+ipos)}.awk
  ralist=. 0{::ra=. saveppssetpnt2 aprev ; ralist ; <rhinfo
  prevpps__l=: _1{::ra
  ralist=. 0{::ra=. saveppssetpnt2 anext ; ralist ; <rhinfo
  nextpps__l=: _1{::ra
  ralist=. 0{::ra=. saveppssetpnt2 child__l ; ralist ; <rhinfo
  dirpps__l=: _1{::ra
  ralist ; no__l return.
end.
)

NB.  saveppssetpnt
saveppssetpnt=: 3 : 0
'athis ralist rhinfo'=. y
NB. 1. make array as children-relations
NB. 1.1 if no children
if. (0:=#) athis do. ralist ; _1 return.
elseif. (#athis) =1 do.
NB. 1.2 just only one
  ralist=. ralist, l=. 0{athis
  no__l=: (#ralist) -1
  prevpps__l=: _1
  nextpps__l=: _1
  ralist=. 0{::ra=. saveppssetpnt child__l ; ralist ; <rhinfo
  dirpps__l=: _1{::ra
  ralist ; no__l return.
elseif. do.
NB. 1.3 array
  icnt=. #athis
NB. 1.3.1 define center
  ipos=. <.icnt % 2
  ralist=. ralist, l=. ipos{athis
  no__l=: (#ralist) -1
  awk=. athis
NB. 1.3.2 devide a array into previous, next
  aprev=. ipos{.awk
  anext=. (1+ipos)}.awk
  ralist=. 0{::ra=. saveppssetpnt aprev ; ralist ; <rhinfo
  prevpps__l=: _1{::ra
  ralist=. 0{::ra=. saveppssetpnt anext ; ralist ; <rhinfo
  nextpps__l=: _1{::ra
  ralist=. 0{::ra=. saveppssetpnt child__l ; ralist ; <rhinfo
  dirpps__l=: _1{::ra
  ralist ; no__l return.
end.
)

NB.  saveppssetpnt
saveppssetpnt1=: 3 : 0
'athis ralist rhinfo'=. y
NB. 1. make array as children-relations
NB. 1.1 if no children
if. (0:=#) athis do. ralist ; _1 return.
elseif. (#athis) =1 do.
NB. 1.2 just only one
  ralist=. ralist, l=. 0{athis
  no__l=: (#ralist) -1
  prevpps__l=: _1
  nextpps__l=: _1
  ralist=. 0{::ra=. saveppssetpnt child__l ; ralist ; <rhinfo
  dirpps__l=: _1{::ra
  ralist ; no__l return.
elseif. do.
NB. 1.3 array
  icnt=. #athis
NB. 1.3.1 define center
  ipos=. <.icnt % 2
  ralist=. ralist, l=. ipos{athis
  no__l=: (#ralist) -1
  awk=. athis
NB. 1.3.2 devide a array into previous, next
  aprev=. ipos{.awk
  anext=. (1+ipos)}.awk
  ralist=. 0{::ra=. saveppssetpnt aprev ; ralist ; <rhinfo
  prevpps__l=: _1{::ra
  ralist=. 0{::ra=. saveppssetpnt anext ; ralist ; <rhinfo
  nextpps__l=: _1{::ra
  ralist=. 0{::ra=. saveppssetpnt child__l ; ralist ; <rhinfo
  dirpps__l=: _1{::ra
  ralist ; no__l return.
end.
)

NB.  savebbd
savebbd=: 3 : 0
'isbdsize ibsize ippscnt rhinfo'=. y
NB. 0. calculate basic setting
ibbcnt=. <.bigblocksize__rhinfo % longintsize
i1stbdl=. <.(bigblocksize__rhinfo - 16b4c) % longintsize
ibdexl=. 0
iall=. ibsize + ippscnt + isbdsize
iallw=. iall
ibdcntw=. >.iallw % ibbcnt
ibdcnt=. >.(iall + ibdcntw) % ibbcnt
NB. 0.1 calculate bd count
if. ibdcnt >i1stbdl do.
NB.  todo: do-while correct here?
  whilst. ibdcnt > i1stbdl+ibdexl*ibbcnt do.
    ibdexl=. >:ibdexl
    iallw=. >:iallw
    ibdcntw=. >.iallw % ibbcnt
    ibdcnt=. >.(iallw + ibdcntw) % ibbcnt
  end.
end.
NB. 1. making bd
NB. 1.1 set for sbd
if. isbdsize > 0 do.
  for_i. i.(isbdsize-1) do.
    fputs__rhinfo toDWORD0 i+1
  end.
  fputs__rhinfo toDWORD0 _2
end.
NB. 1.2 set for b
for_i. i.(ibsize-1) do.
  fputs__rhinfo toDWORD0 i+isbdsize+1
end.
fputs__rhinfo toDWORD0 _2
NB. 1.3 set for pps
for_i. i.(ippscnt-1) do.
  fputs__rhinfo toDWORD0 i+isbdsize+ibsize+1
end.
fputs__rhinfo toDWORD0 _2
NB. 1.4 set for bbd itself  _3 : bbd
for_i. i.ibdcnt do.
  fputs__rhinfo toDWORD0 _3
end.
NB. 1.5 set for extrabdlist
for_i. i.ibdexl do.
  fputs__rhinfo toDWORD0 _4
end.
NB. 1.6 adjust for block
if. ((iallw + ibdcnt) |~ ibbcnt) do.
  fputs__rhinfo, (,:toDWORD0 _1) #~ ibbcnt ([ - |) (iallw + ibdcnt)
end.
NB. 2.extra bdlist
if. (ibdcnt > i1stbdl) do.
  in=. 0
  inb=. 0
  i=. i1stbdl
  while. i<ibdcnt do.
    if. (in>: (ibbcnt-1)) do.
      in=. 0
      inb=. >:inb
      fputs__rhinfo toDWORD0 iall+ibdcnt+inb
    end.
    fputs__rhinfo toDWORD0 ibsize+isbdsize+ippscnt+i
    i=. >:i
    in=. >:in
  end.
  if. ((ibdcnt-i1stbdl) |~ (ibbcnt-1)) do.
    fputs__rhinfo, (,:toDWORD0 _1) #~ (ibbcnt-1) ([ - |) (ibdcnt-i1stbdl)
  end.
  fputs__rhinfo toDWORD0 _2
end.
)

