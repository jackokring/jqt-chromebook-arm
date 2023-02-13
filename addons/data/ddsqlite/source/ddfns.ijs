NB. ddfns

NB. =========================================================
NB. main ODBC verbs
NB. words marked with --> have an external interface all
NB. other words are confined to the ODBC utility locale.

NB. =========================================================
errret=: 3 : 0

NB. (errret) error return.  Sets the last error message(s).  Some
NB. errors are generated by the (jdd) verbs (ISInn errors) all others
NB. boil up from the depths of ODBC.
NB.
NB. monad:  errret ilTypeHandle  NB. handle type and handle with last error
NB.         errret clErrmsg      NB. ISI error message text
NB.
NB.  errret ISI03
NB.  errret ch

LERR=: ''
ALLDM=: i. 0 0
r=. SQL_ERROR
if. iscl y do.
  LERR=: y
else.
  assert. isiu y
  h=. (_1=y){y,0
  s=. sqlite3_errcode h
  if. 0~: p=. sqlite3_errmsg h do.
    LERR=: 'HY000 ',(5":s),' [SQLITE Driver] ',memr p, 0 _1
  else.
    LERR=: 'HY000 ',(5":s),' [SQLITE Driver] No error message'
  end.
end.
if. UseErrRet do.
  r;LERR
else.
  r
end.
)


NB. =========================================================
NB. (clr) clear errors
clr=: 3 : 0
LERR=: ''
ALLDM=: i. 0 0
)

NB. =========================================================
erasebind=: 3 : 0
if. 0= nc <('BIND',":y) do.
  assert. 0= nc <('BINDN',":y)
  n=. ('BINDN',":y)~
  4!:55 <'BINDN',":y
  bind=. ('BIND',":y)~
  4!:55 <'BIND',":y
  assert. 0= nc <('BINDIO',":y)
  io=. ('BINDIO',":y)~
  4!:55 <'BINDIO',":y
  for_i. i.n do.
    4!:55 <'BIND',(":y),'_',":i
    4!:55 <'BINDLN',(":y),'_',":i
  end.
end.
)


NB. =========================================================
freestmt=: 3 : 0

NB. (freestmt) frees allocated statement handles.
NB.
NB. monad:  freestmt iaSh

erasebind y
sqlite3_finalize y
)

NB. =========================================================
getcolinfo=: 3 : 0"1

NB. return  catalog database table org_table name org_name column-id(1-base) typename coltype length decimals nullable def nativetype nativeflags

'sh icol'=. y
ch=. sh_to_ch sh
assert. _1~:ch

cat=. ''

if. p=. sqlite3_column_database_name y do. database=. memr p, 0 _1 else. database=. '' end.
if. p=. sqlite3_column_table_name y do. table=. memr p, 0 _1 else. table=. '' end.
if. p=. sqlite3_column_name y do. column=. memr p, 0 _1 else. column=. '' end.
if. p=. sqlite3_column_origin_name y do. org_column=. memr p, 0 _1 else. org_column=. '' end.

org_table=. table
if. #org_column do.
  datatype=. ,_1 [ collate=. ,_1 [ notnull=. ,_1 [ primkey=. ,_1 [ autoinc=. ,_1
  if. SQLITE_OK= ec=. >@{. cdrc=. sqlite3_table_column_metadata ch;database;table;org_column;datatype;collate;notnull;primkey;autoinc do.
    'ch database table org_column datatype collate notnull primkey autoinc'=. }.cdrc
    typenamex=. memr datatype,0 _1 [ nullable=. -.{.notnull
    'datatype typename length'=. parse_sqlite_typename typenamex
    'buflen char_octlen radix sqlcoltype sub'=. guess_sqlite_buffer datatype; length
    z=. cat;database;table;org_table;column;org_column;(>:icol);typename;datatype;length;radix;nullable;'';datatype;0
  end.
else.
  if. p=. sqlite3_column_decltype y do.
    'datatype typename length'=. parse_sqlite_typename typenamex=. memr p, 0 _1
    'buflen char_octlen radix sqlcoltype sub'=. guess_sqlite_buffer datatype; length
    z=. cat;database;table;org_table;column;org_column;(>:icol);typename;datatype;length;0;0;'';datatype;0
  else.
    z=. cat;database;table;org_table;column;org_column;(>:icol);'';0;0;0;0;'';0;0
  end.
end.
,&.> z
)


NB. =========================================================
getallcolinfo=: 3 : 0

NB. (getallcolinfo) returns information about all the
NB. columns in a result set.
NB.
NB. monad:  bt =. getallcolinfo iaSh

if. n=. sqlite3_column_count y do.
  z=. getcolinfo y,.i.n
else.
  0 15$<''
end.
)

NB. =========================================================
ddconfig=: 3 : 0  NB.-->

NB. (ddconfig) set driver specific config
NB. returns 0
NB.
NB. monad: ddconfig key;value {;key;value...}
NB.

clr 0
key=. {.keynvalue=. |: _2]\ y
value=. {:keynvalue
for_i. i.#key do.
  select. tolower i{::key
  case. 'errret' do. UseErrRet=: -. 0-: {.i{::value
  case. 'dayno' do. UseDayNo=: -. 0-: {.i{::value
  case. 'unicode' do. UseUnicode=: -. 0-: {.i{::value
  end.
end.
0
)

NB. =========================================================
dddriver=: 3 : 0  NB.-->

NB. (dddriver) query driver of current jdd...
NB. returns 0
NB.
NB. monad: bt =. dddriver uuIgnore
NB.
NB.   dddriver ''  NB. current jdd... driver

clr 0
'SQLITE'
)

NB. =========================================================
dddrv=: 3 : 0  NB.-->

NB. (dddrv) lists all ODBC drivers.
NB. returns boxed table of driver names and driver types.
NB.
NB. monad: bt =. ddsrc uuIgnore
NB.
NB.   dddrv ''  NB. boxed table of drivers

clr 0
ret_DD_OK ,:'SQLite3';'SQLite3'
)

NB. =========================================================
ddsrc=: 3 : 0  NB.-->

NB. (ddsrc) lists all registered ODBC datasources. Result
NB. is a boxed table of dsn names and driver types.
NB.
NB. monad: bt =. ddsrc uuIgnore
NB.
NB.   ddsrc ''  NB. boxed table of data sources

clr 0
ret_DD_OK 0 2$<''
)


NB. =========================================================
ddtbl=: 3 : 0  NB.-->

NB. (ddtbl) lists all the tables in the data source with
NB. connection handle (y). The result is a statement handle.
NB.
NB. NIMP? maybe more useful to return the table list and behave
NB. like (ddsrc) and (ddcol) (see ddtblx)
NB.
NB. monad:  iaSh =. ddtbl iaCh
NB.
NB.  ch =. ddcon 'dsn=jaccess'
NB.  sh =. ddtbl ch
NB.  ddfet sh,_1      NB. boxed list of tables

NB. test argument
clr 0
if. -. isia y do. errret ISI08 return. end.
if. -. y e. CHALL do. errret ISI03 return. end.

db=. 'main'

if. SQLITE_OK = >@{. z=. ('select '''' as TABLE_CAT, ''',db,''' as TABLE_SCHEMA, name as TABLE_NAME, type as TABLE_TYPE, '''' as REMARKS from ',db,'.sqlite_master where type=''table'' order by name') preparestmt y do.
  sh=. 1{::z
NB. update connection/statement pairs & return statement handle
  CSPALL=: CSPALL,y,sh,0
  ret_DD_OK sh
else.
  r=. errret y
end.
)


NB. =========================================================
ddtblx=: 3 : 0  NB.-->

NB. (ddtblx) like (ddtbl) except table information is immediately
NB. returned in a more readable format.
NB.
NB. monad:  ddtblx iaCh

if. -.@sqlresok z=. ddtbl y do. z
elseif. -.@sqlresok dat=. ddfch sh,_1 [ sh=. sqlres z do. z
elseif.do. fmtfchres dat [ ddend^:UseErrRet sh
end.
)

NB. =========================================================
NB. ddcheck  NB.-->
ddcheck=: 3 : 0
if. _1=y do. empty smoutput dderr $0 else. y end.
)
NB. =========================================================
NB. COMPATIBLE (ddcol) simply returns a header with no
NB. error when given a column that doesn't exist in a valid table.
NB. This is also what the original 14!:4 does.  Returning
NB. an error would make more sense.

ddcol=: 4 : 0  NB. -->

NB. (ddcol) lists all the columns in table (x).
NB.
NB. dyad:  bt =. clTable ddcol iaCh
NB.
NB.  ch =. ddcon 'dsn=jaccess'
NB.  'tdata' ddcol ch

NB. test arguments
clr 0
w=. y
if. -. (iscl x) *. isia w=. fat w do. errret ISI08 return. end.
if. -. w e. CHALL do. errret ISI03 return. end.
x=. utf8 ,x

if. '.' e. x do.
  db=. }:({.~ i.&'.') x
  tb=. }.(}.~ i.&'.') x
else.
  db=. 'main' [ tb=. x
end.

tbcolname=. 0$<'' [ tbdflt=. 0$<''
NB. table_info: cid name type notnull dflt_value pk
if. sqlresok rc=. y ddsel~ 'PRAGMA table_info(',x,')' do.
  sh=. sqlres rc
  rc=. ddfet sh,_1
  if. UseErrRet do.
    ddend^:UseErrRet sh
    if. sqlresok rc do.
      if. #rc=. sqlres rc do.
        tbcolname=. 1{"1 rc [ tbdflt=. 4{"1 rc
      end.
    end.
  else.
    if. (0~:#rc) *. 32 = 3!:0 rc do.
      tbcolname=. 1{"1 rc [ tbdflt=. 4{"1 rc
    end.
  end.
end.

if. SQLITE_OK = >@{. z=. ('select * from ', x,' limit 0') preparestmt y do.
  sh=. 1{::z
  err=. 0 [ r=. 0 0$<'' [ cat=. ''

NB. TABLE_CAT
NB. TABLE_SCHEM  db
NB. TABLE_NAME   tb
NB. COLUMN_NAME  column
NB. DATA_TYPE
NB. TYPE_NAME     datatype
NB. COLUMN_SIZE
NB. BUFFER_LENGTH
NB. DECIMAL_DIGITS
NB. NUM_PREC_RADIX
NB. NULLABLE       -.notnull
NB. REMARKS
NB. COLUMN_DEF
NB. SQL_DATA_TYPE
NB. SQL_DATETIME_SUB
NB. CHAR_OCTET_LENGTH
NB. ORDINAL_POSITION
NB. IS_NULLABLE       notnull{::'YES';'NO'
  hdr=. <;._1 ' TABLE_CAT TABLE_SCHEM TABLE_NAME COLUMN_NAME DATA_TYPE TYPE_NAME COLUMN_SIZE BUFFER_LENGTH DECIMAL_DIGITS NUM_PREC_RADIX NULLABLE REMARKS COLUMN_DEF SQL_DATA_TYPE SQL_DATETIME_SUB CHAR_OCTET_LENGTH ORDINAL_POSITION IS_NULLABLE'

  for_i. i.n=. sqlite3_column_count sh do.
    if. p=. sqlite3_column_origin_name sh,i do.
      column=. memr p, 0 _1
      datatype=. ,_1 [ collate=. ,_1 [ notnull=. ,_1 [ primkey=. ,_1 [ autoinc=. ,_1
      if. SQLITE_OK= ec=. >@{. cdrc=. sqlite3_table_column_metadata w;db;tb;column;datatype;collate;notnull;primkey;autoinc do.
        'w db tb column datatype collate notnull primkey autoinc'=. }.cdrc
        typenamex=. memr datatype,0 _1 [ nullable=. -.{.notnull
        'data_type type_name col_size'=. parse_sqlite_typename typenamex
        'buflen char_octlen radix sql_data_type sub'=. guess_sqlite_buffer data_type; col_size
        if. (<column) e. tbcolname do.
          dflt=. ": >tbdflt{~ tbcolname i. <column
        else.
          dflt=. ''
        end.
        r=. r, cat;db;tb;column;data_type;type_name;col_size;buflen;0;radix;nullable;'';dflt;sql_data_type;sub;char_octlen;(>:i);(nullable{::'NO';'YES')
      else.
        errret ISI14 [ freestmt sh return.
      end.
    else.
      errret ISI14 [ freestmt sh return.
    end.
  end.
  if. 1=err do. errret w [ freestmt sh return. end.
  if. #r do.
    r=. hdr,r
  else.
    r=. ,:hdr
  end.
  ret_DD_OK r [ freestmt sh
else.
  errret w
end.
)

NB. =========================================================
ddcon=: 3 : 0  NB.-->

NB. (ddcon) connects to an ODBC data source and returns a connection handle.
NB. The (y) argument is an ODBC connection string.
NB.
NB. monad:  iaCh =. ddcon clCstr
NB.
NB.   ddcon 'dsn=jdata'

f=. (i.&';')({. ; }.@}.) ]

NB. test arguments:
clr 0
if. -.iscl y do. errret ISI08 return. end.
y=. utf8 ,y

NB. ddcon 'Database=C:/jtest.sqlite;NoCreate=0'
keypair=. <;._2 y,(';'~:{:y)#';'
keyname=. tolower@dltb@({.~ i.&'=')&.> keypair
keyvalue=. dltb@(}.~ >:@(i.&'='))&.> keypair
if. keyname -.@e.~ <'database' do.
  errret ISI08 return.
end.
dbq=. > keyvalue {~ keyname i. <'database'
nocreate=. 1
if. keyname e.~ <'nocreate' do.
  if. ((,'0');'no';'false') e.~ keyvalue {~ keyname i. <'nocreate' do. nocreate=. 0 end.
end.
if. nocreate *. -.fexist dbq do. errret ISI18 return. end.

timeout=. 60000  NB. default 60 sec timeout
if. keyname e.~ <'timeout' do.
  timeout=. <. timeout ". '0', >keyvalue {~ keyname i. <'timeout'
end.

handle=. ,_1
if. has_sqlite3_extversion do.
  nul=. SQLITE_NULL_INTEGER;SQLITE_NULL_FLOAT;SQLITE_NULL_TEXT
  cdrc=. sqlite3_extopen (iospath^:IFIOS dbq);handle;(SQLITE_OPEN_READWRITE+SQLITE_OPEN_FULLMUTEX+SQLITE_OPEN_SHAREDCACHE+(nocreate{SQLITE_OPEN_CREATE,0));nul,<<0
else.
  cdrc=. sqlite3_open_v2 (iospath^:IFIOS dbq);handle;(SQLITE_OPEN_READWRITE+SQLITE_OPEN_FULLMUTEX+SQLITE_OPEN_SHAREDCACHE+(nocreate{SQLITE_OPEN_CREATE,0));<<0
end.
if. SQLITE_OK~: >@{. cdrc do.
  errret ISI19 return.
end.
handle=. 2{::cdrc
sqlite3_extended_result_codes handle, 1
sqlite3_busy_timeout handle, timeout
HDBC=: {.handle

CHALL=: CHALL,HDBC
dddbms HDBC
ret_DD_OK HDBC
)


NB. =========================================================
dddis=: 3 : 0"0   NB.-->

NB. (dddis) disconnects data sources.
NB.
NB. monad:  dddis i[0,1]Ch
NB.
NB.  dddis ch      NB. one handle
NB.  dddis CHALL   NB. all handles

clr 0
w=. y
if. -.isia w=. fat w do. errret ISI08 return. end.
if. -. w e. CHALL do. errret ISI03 return. end.

if. #sh=. 1{"1 CSPALL#~w=0{"1 CSPALL do. ddend"0 sh end.
ch=. w NB. save in case dll call modifies value

NB. attempt to disconnect
if. sqlbad sqlite3_close w do. errret ch return. end.

NB. remove handles from globals
CHALL=: CHALL-.ch
CSPALL=: CSPALL#~ch~:0{"1 CSPALL
DBMSALL=: DBMSALL#~ch~:>0{("1) DBMSALL
ret_DD_OK DD_OK
)

NB. =========================================================
preparestmt=: 4 : 0
stmt=. ,_1 [ tail=. ,_1
if. SQLITE_OK = rc=. >@{. cdrc=. sqlite3_prepare_v2 ({.y);(bs x),stmt;tail do.
  'stmt tail'=. 4 5{cdrc
  if. ({.tail) e. 0 _1 do.
    rc;({.stmt);''
  else.
    rc;({.stmt);memr tail,0 _1
  end.
else.
  rc;_1;''
end.
)

NB. =========================================================
ddsel=: 4 : 0  NB.-->

NB. (ddsel) selects data. (y) argument is a connection handle and
NB. (x) is an SQL statement that generates a result set.
NB.
NB. dyad:  iaCh =. clSql ddsel iaCh
NB.
NB.   'select * from tdata' ddsel ch
NB.
NB.   NB. can be used to call stored procedures that
NB.   NB. take simple arguments and return result sets
NB.   NB. driver must support escape {}'s and stored procs
NB.   '{call procname(''chararg'')}' ddsel ch

NB. test arguments
clr 0
if. -.(isia w=. fat y) *. iscl x do. errret ISI08 return. end.
if. -.w e. CHALL do. errret ISI03 return. end.
x=. utf8 ,x

NB. attempt to execute and return statement handle
if. SQLITE_OK ~: >@{. z=. x preparestmt w do. errret w return. end.
'ec sh tail'=. z
CSPALL=: CSPALL,w,sh,0
ret_DD_OK sh
)

NB. =========================================================
NB. start or end transaction. CHTR not updated here
transact=: 4 : 0
assert. x e. SQL_COMMIT,SQL_ROLLBACK,SQL_BEGIN
COMRBK=. x{::'COMMIT';'ROLLBACK';'BEGIN'
st=. ,_1
if. SQLITE_OK= r=. >@{. cdrc=. sqlite3_prepare_v2 y;COMRBK;(#COMRBK);st;<<0 do.
  st=. 4{::cdrc
  r=. sqlite3_step {.st
  r1=. sqlite3_finalize {.st
  if. (SQLITE_OK,SQLITE_DONE) e.~ r do.
    DD_OK
  else.
    SQL_ERROR
  end.
else.
  SQL_ERROR
end.
)


NB. =========================================================
ddsql=: 4 : 0  NB.-->

NB. (ddsql) executes SQL statements (y) argument is a connection handle and
NB. (x) is any SQL statement.  Sets rows changed/modified for (ddcnt).
NB.
NB. dyad:  iaCh =. clSql ddsql iaCh
NB.
NB.   'delete from tdata' ddsel ch

NB. test arguments
clr DDROWCNT=: 0
if. -.(isia y) *. iscl x do. errret ISI08 return. end.
if. -.y e.CHALL do. errret ISI03 return. end.
x=. utf8 ,x

NB. attempt to get stmt handle and execute
if. SQLITE_OK ~: >@{. z=. x preparestmt y do. errret y return. end.
sh=. 1{::z
if. (SQLITE_OK,SQLITE_DONE) e.~ ec=. sqlite3_step sh do.

NB. set number of rows affected for (ddcnt)
  DDROWCNT=: sqlite3_changes y

NB. if connection is not on pending transactions commit
NB.   if. -. y e. CHTR do. SQL_COMMIT transact y end.
  ret_DD_OK DD_OK [ freestmt sh
else.
  r=. errret y
  r [ freestmt sh
end.
)


NB. =========================================================
ddfch=: 3 : 0  NB.-->

NB. ddfch
NB. The dyad is an extension of the original jodbc ddfch verb.
NB. if (x) is _2, data will be returned in raw format, otherwise
NB. data returned in jodbc compatible format.
NB. The original jodbc usage (COLUMNBUF) is ignored.
NB.
NB. monad:  blut =. ddfch ilShRows
NB.
NB.   sh=. 'select this,and,that from sometable' ddsel ch
NB.   ddfch sh     NB. one row
NB.   ddfch sh,10  NB. next 10 rows
NB.   ddfch sh,_1  NB. all remaining rows
NB.
NB. dyad:  blut =. iaBuffhint ddfch ilShRows
NB.
NB.   sh =. 'select these,here,integers from reallybigtable' ddsel ch
NB.
NB.   NB. get 1e5 rows with each fetch operation until all data is returned
NB.   100000 ddfch sh,_1

1 ddfch y
:
clr 0
if. -. isiu y do. errret ISI08 return. end.
'sh r'=. 2{.,y,1
if. -. sh e.1{"1 CSPALL do. errret ISI04 return. end.
if. 2{CSPALL{~ sh i.~ 1{"1 CSPALL do. errret ISI04 return. end.   NB. defunct
r=. (r<0){r,_1  NB. tolerate negs other than _1
if. 0=#ci=. getallcolinfo sh do.
  errret sh_to_ch sh
else.
  z=. ci getdata sh,r,1      NB. long data coerced to empty
  if. UseErrRet do.
    if. (<<<0)-:{.z do.
      r=. fmtfch&.>^:(_2~:x) }.z
      ret_DD_OK r
    else.
      z
    end.
  else.
    r=. fmtfch&.>^:(_2~:x) z
  end.
end.
)


NB. =========================================================
ddfet=: 3 : 0  NB.-->

NB. (ddfet) fetchs data by rows.  This verb must be used
NB. for long character and binary types.  For fixed length
NB. and short types (ddfch) is much faster.  The ODBC SQLGetData
NB. function is not well suited for J use because it forces you to loop.
NB. You must loop for each row and you must loop within each long
NB. column to collect large data objects.  When fetching data it's best
NB. to use (ddfch) on columns it can collect reserving (ddfet)
NB. only for those values that (ddfch) cannot fetch.
NB.
NB. monad:  ddfet ilShRows
NB.
NB.   ch=. ddcon 'dsn=mydatabase'
NB.   sh=. 'select bigbinary from mytable where myprimarykey = 666' ddsel ch
NB.   data =. ddfet sh

clr 0
if. -. isiu y do. errret ISI08 return. end.
'sh r'=. 2{.,y,1
if. -. sh e.1{"1 CSPALL do. errret ISI04 return. end.
if. 2{CSPALL{~ sh i.~ 1{"1 CSPALL do. errret ISI04 return. end.   NB. defunct
r=. (r<0){r,_1  NB. tolerate negs other than _1
if. 0=#ci=. getallcolinfo sh do.
  errret sh_to_ch sh
else.
  z=. ci getdata sh,r,0
  if. UseErrRet do.
    if. (<<<0)-:{.z do.
      r=. }.z
      if. #>{.r do.
        r=. |:@:(((<@,"_1)^:(0=L.))@>) r
      else.
        r=. (0,#r)$<''
      end.
      ret_DD_OK r
    else.
      z
    end.
  else.
    if. -. SQL_ERROR-: z do.
      r=. z
      if. #>{.r do.
        r=. |:@:(((<@,"_1)^:(0=L.))@>) r
      else.
        r=. (0,#r)$<''
      end.
    else.
      z
    end.
  end.
end.
)


NB. =========================================================
ddcnt=: 3 : 0  NB.-->

NB. (ddcnt) returns number of rows affected by last (ddsql) command.
NB.
NB. monad:  ddcnt uuIgnore

ret_DD_OK DDROWCNT
)


NB. =========================================================
ddend=: 0&$: : (4 : 0)"0  NB.-->

NB. (ddend) ends statements and frees statement handles.
NB. Bound nouns are also erased.
NB.
NB. monad:  ddend i[0,1]Sh
NB. dyad:   x ddend i[0,1]Sh
NB.       x=1 defunct only (to workaround sqlite3_step behaviour)

clr 0
w=. y
if. -.isia w=. fat w do. errret ISI08 return. end.
if. -.w e.1{"1 CSPALL do. errret ISI04 return. end.
if. x do.
  assert. 3={:$CSPALL
  k=. w i.~ 1{"1 CSPALL
  CSPALL=: 1 (<k,2)}CSPALL
  ret_DD_OK DD_OK return.
end.

sh=. w

NB. free and clean up regardless of sql errors
z=. freestmt w
CSPALL=: CSPALL#~sh~:1{"1 CSPALL

NB. now check for errors
if. sqlbad z do. errret sh_to_ch sh else. ret_DD_OK DD_OK end.
)

NB. =========================================================
dddata=: 3 : 0  NB.-->

NB. (dddata) gets data bound to single column for a stmt handle.
NB.
NB. monad:  dddata ilShCol

NB. check argument
clr 0
w=. >{.y
if. -. isia w=. fat w do. errret ISI08 return. end.
if. -.w e.1{"1 CSPALL do. errret ISI04 return. end.
if. 2{CSPALL{~ w i.~ 1{"1 CSPALL do. ISI04 return. end.   NB. defunct
c=. >{:y
if. -. isia c=. fat c do. errret ISI08 return. end.
if. (0>c) +. c>: ('BINDN',":w)~ do. errret ISI54 return. end.

ret_DD_OK ". ::(''"_) 'BIND',(":w),'_',":c
)

NB. =========================================================
dddataln=: 3 : 0

NB. (dddata) gets data length bound to single column for a stmt handle.
NB.
NB. monad:  dddata ilShCol
NB. internal use

NB. check argument
clr 0
w=. >{.y
if. -. isia w=. fat w do. errret ISI08 return. end.
if. -.w e.1{"1 CSPALL do. errret ISI04 return. end.
if. 2{CSPALL{~ w i.~ 1{"1 CSPALL do. ISI04 return. end.   NB. defunct
c=. >{:y
if. -. isia c=. fat c do. errret ISI08 return. end.
if. (0>c) +. c>: ('BINDN',":w)~ do. errret ISI54 return. end.

". ::(''"_) 'BINDLN',(":w),'_',":c
)


NB. =========================================================
dddcnt=: 3 : 0  NB.-->

NB. (dddcnt) actual number of rows in last fetch.
NB.
NB. monad:  dddcnt iaSh
NB. iaSh is ignored in this implementation

NB. check argument
clr 0
w=. y
if. -. isia w=. fat w do. errret ISI08 return. end.
if. -.w e.1{"1 CSPALL do. errret ISI04 return. end.
if. 2{CSPALL{~ w i.~ 1{"1 CSPALL do. ISI04 return. end.   NB. defunct

errret ISI14
)

NB. =========================================================
ddrow=: dddcnt NB. not sure which name to use...

initodbcenv=: 3 : 0

NB. (initodbcenv) first time initialization of ODBC environment.
NB.
NB. monad: initodbcenv uuIgnore

NB. intial values
CHTR=: CHALL=: i.0  NB. all connection handles (pending transactions)
CSPALL=: 0 3$0      NB. all statement handles (connection,statement,defunct triple)
DBMSALL=: 0 12$<''  NB. properties of connection handles
LERR=: ''           NB. last error message
ALLDM=: i. 0 3      NB. all last diagnostic messages
BADTYPES=: i. 0 0   NB. table of unbindable/ungetable columns
DDROWCNT=: 0        NB. number of rows affected by last (ddsql) command

DD_OK
)


NB. =========================================================
endodbcenv=: 3 : 0

NB.  (endodbcenv) frees all statement, connection and environment handles.
NB.
NB.  QUESTION? is all this necessary - you would think just freeing the
NB.  environment would automatically clean up.
NB.
NB.  monad:  iaRc =. endodbcenv uuIgnore

set=. 0&= @: (4!:0)
if. set <'CHTR' do. if. #CHTR do. ddrbk CHTR end. end.
if. set <'CSPALL' do. if. #CSPALL do. ddend {:"1 CSPALL end. end.
if. set <'CHALL' do. if. #CHALL do. dddis CHALL end. end.
erase ;:'CSPALL CHALL CHTR'
)


NB. =========================================================
ddcnm=: 3 : 0  NB.-->

NB. (ddcnm) returns a boxed list of column names in
NB. statement result sets.
NB.
NB. monad:  blcl =. ddcnm iaSh
NB.
NB.  sh=. 'select * from whatever' ddsel ch
NB.  ddcnm sh


NB. check argument
clr 0
w=. y
if. -. isia w=. fat w do. errret ISI08 return. end.
if. -.w e.1{"1 CSPALL do. errret ISI04 return. end.
if. 2{CSPALL{~ w i.~ 1{"1 CSPALL do. ISI04 return. end.   NB. defunct

NB. get column information and return names
if. 0=#ci=. getallcolinfo w do. errret sh_to_ch w return. end.
assert. 15= {:@$ ci
ret_DD_OK 4{"1 ci
)


NB. =========================================================
NB. COMPATIBLE? dderr accepts only empty arguments this verb
NB. accepts and ignores any argument.

dderr=: 3 : 0  NB.-->

NB. (dderr) returns the last error message (if any).  Optional
NB. (x) code displays additional error and diagnostic information.
NB.
NB. monad:  dderr uuIgnore
NB. dyad:   iaMore dderr uuIgnore

0 dderr y
:
LERR
)


NB. =========================================================
ddtrn=: 3 : 0  NB.-->

NB. (ddtrn) begins a transaction on connection handle (y)
NB.
NB. monad:  ddtrn iaCh

NB. test argument
clr 0
w=. fat y
if. -. isia w=. fat w do. errret ISI08 return. end.
if. -. w e. CHALL do. errret ISI03 return. end.
if. w e. CHTR do. errret ISI07 return. end.
NB. nested transaction not allowed in ODBC
if. 0~: sqlite3_get_autocommit w do.
  errret ISI07
end.
NB. set the handle to manual commit mode
if. sqlok SQL_BEGIN transact w do.
  CHTR=: ~.CHTR,y
  ret_DD_OK DD_OK
else.
  errret w
end.
)


NB. =========================================================
comrbk=: 4 : 0

NB. (comrbk) commits or rolls back transactions on connection handle (y)
NB.
NB. dyad:  iaType comrbk iaCh
NB.
NB.  SQL_COMMIT comrbk ch

NB. test argument
clr 0
w=. y
if. -. isia w=. fat w do. errret ISI08 return. end.
if. -. w e. CHALL do. errret ISI03 return. end.
if. -. w e. CHTR do. errret ISI07 return. end.

NB. commit transaction
if. sqlok x transact w do.
  CHTR=: CHTR-.y
  ret_DD_OK DD_OK
else.
  errret w
end.
)


NB. =========================================================
ddcom=: 3 : 0  NB.-->
SQL_COMMIT comrbk y
)


NB. =========================================================
ddrbk=: 3 : 0  NB.-->
SQL_ROLLBACK comrbk y
)

NB. =========================================================
ddttrn=: 3 : 0"0  NB.-->

NB. y is ch
NB. return 1 if inside transaction, otherwise (include  error conditions) return 0
NB. if y is _1, test for all ch
if. _1~: y do.
  if. y e. CHALL do.
    0= sqlite3_get_autocommit y
  else.
    0
  end.
else.
  for_y1. CHALL do.
    if. 0= sqlite3_get_autocommit y1 do. 1 return. end.
  end.
  0
end.
)

NB. =========================================================
dddbms=: 3 : 0  NB.-->

NB. dddbms ch
NB. return datadriver;dsn;uid;server;name;ver;drvname;drvver;charset;chardiv;bugflag

if. -. isia y=. fat y do. errret ISI08 return. end.
if. -.y e. CHALL do. errret ISI03 return. end.
ch=. y
clr 0
if. ch e. >0{("1) DBMSALL do.
  ret_DD_OK }.DBMSALL{~(>0{("1) DBMSALL)i.ch
  return.
end.
bugflag=. 0
chardiv=. 1  NB. some odbc driver need to divide column size to get the true column size in unicode characters
charset=. UTF8
dsn=. ''
uid=. ''
server=. ''
ver=. memr 0 _1,~ sqlite3_libversion''
drvname=. libsqlite
drvver=. ver
name=. 'SQLite'

DBMSALL=: DBMSALL, y; r=. 'SQLITE';dsn;uid;server;name;ver;drvname;drvver;charset;chardiv;bugflag
ret_DD_OK r
)

NB. =========================================================
NB. not implemented

ddbind=: ddfetch=: ddbtype=: errret bind ISI14
