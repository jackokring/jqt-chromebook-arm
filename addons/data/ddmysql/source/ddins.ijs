NB. ddins
NB.

NB.*ddcolinfo v get column type of result of a statement handle
NB. y sh
NB. return  catalog database table org_table name org_name column-id(1-base) typename coltype length decimals nullable def nativetype nativeflags
ddcolinfo=: 3 : 0
clr 0
if. -. isia y=. fat y do. errret ISI08 return. end.
if. -.y e. 1{("1) CSPALL do. errret ISI04 return. end.
sh=. y
if. 0= #ci=. getallcolinfo sh do.
  z=. errret 1,sh
else.
  assert. 15={:@$ci
  assert. 1= #@$&> ,ci
  z=. ret_DD_OK ci
end.
z
)

NB.ddcoltype v get column type of result of a select statement
NB. base table name appended
NB. x select statement
NB. return  catalog database table org_table name org_name column-id(1-base) typename coltype length decimals nullable def nativetype nativeflags
ddcoltype=: 4 : 0
if. -.y e.CHALL do. errret ISI03 return. end.
if. -. iscl sql=. x do. errret ISI08 return. end.
sql=. , utf8 x

if. _1= sh=. 0{:: rc=. sql preparesel y do. 1{::rc return. end.
if. #ci=. getallcolinfo sh do.
  freestmt sh
  assert. 15={:@$ci
  assert. 1= #@$&> ,ci
  ret_DD_OK ci
else.
  z=. errret 1,sh
  freestmt sh
  z
end.
)

NB. emulate sqlbulkoperation
NB. sql eg.  'select docnum,linenum,pcode,pqty from arinvl'
NB. (sql;data1;data2) ddins ch
ddins=: 4 : 0
clr DDROWCNT=: 0
if. -.(isia y) *. isbx x do. errret ISI08 return. end.
if. -.y e.CHALL do. errret ISI03 return. end.
if. 2>#x do. errret ISI08 return. end.
if. -. *./ 2>: #@$&> }.x do. errret ISI08 return. end.
if. 1<#rows=. ~. > {.@$&>}.x do. errret ISI08 return. end.
if. 0=rows=. fat rows do. SQL_NO_DATA; 0 return. end.
sql=. utf8 , 0{::x
if. SQL_ERROR-: z=. y ddcoltype~ sql do. z return. end.
if. (<SQL_ERROR)-: {.z do. z return. end.
'oty ty lns'=. |: _3]\;8 13 9{("1) z=. 1&{::^:UseErrRet z
flds=. 4{("1) z
tbl=. ~. 2{("1) z
NB. if table name can not be determined, try parsing the sql statement to get table name
if. (,a:)-:tbl do.
NB. discard "select"
  if. 'select'-.@-:tolower 6{.sql0=. deb sql do. errret ISI08 return. end.
  if. 'show'-.@-:tolower 4{.sql0=. deb sql do. errret ISI08 return. end.
  if. 'explain'-.@-:tolower 7{.sql0=. deb sql do. errret ISI08 return. end.
  sql0=. dlb 6}.sql0
NB. discard " where ..." clause
  if. 1 e. r=. ' where ' E. s=. tolower sql0 do. sql0=. sql0{.~ r i: 1
  elseif. 1 e. r=. ' where(' E. s do. sql0=. sql0{.~ r i: 1
  elseif. 1 e. r=. ')where ' E. s do. sql0=. sql0{.~ r i: 1
  elseif. 1 e. r=. ')where(' E. s do. sql0=. sql0{.~ r i: 1
  end.
NB. parse fields and table name
  if. 1 e. r=. ' from ' E. s=. tolower sql0 do.
    tbl=. dltb sql0}.~ a + #' from ' [[ a=. r i: 1
  elseif. 1 e. r=. ' from(' E. s do.
    tbl=. dltb sql0}.~ a + #' from(' [[ a=. r i: 1
  elseif. 1 e. r=. ')from ' E. s do.
    tbl=. dltb sql0}.~ a + #')from ' [[ a=. r i: 1
  elseif. 1 e. r=. ')from(' E. s do.
    tbl=. dltb sql0}.~ a + #')from(' [[ a=. r i: 1
  elseif. do. errret ISI08 return. end.
NB. filter extra invalid characters
  tbl=. < tbl -. '+/()*,-.:;=?@\^_`{|}'''
end.
if. (1~:#tbl) +. a: e. tbl do.  NB. more than one base table or column with base table
  errret ISI52 return.
end.
if. (<:#x)~:#ty do.
  errret ISI50 return.
end.
inssql=. 'insert into ', (>@{.tbl), '(', (}. ; (<',') ,("0) flds), ') values (', (}. ; (#flds)#<',?'), ')'
z=. (inssql ; (|: oty,.lns,.ty) ; (}.x)) ddparm y
)

NB. find base table and parameter in parameterised sql query like
NB. only applicable to single base table and one ? for each field
NB. return box array: table ; parm0 ; parm1 ; ...
NB. test
NB. 'update t set pa1=?,pa2=? where key=?'
NB. 'update t set a=12,b=b+?,c=(?),k=''abc'',p=right(t,3),q=trim(?,4),d=? where e1=foo(?) and e2=? or and e3<>4 and e4=?'
NB. 'insert into t (a,b,c,d,e,f) values (?,''?'',1,?,?,''aa'')'
parsesqlparm=: 3 : 0
fmt=. 0  NB. 1 (...) values (?,?,?)
if. ('insert into' ; 'select into') e.~ <tolower 11{.y=. dlb y do. ix=. 11 [ fmt=. 1
elseif. 'insert ' -: tolower 7{.y do. ix=. 6 [ fmt=. 1
elseif. 'delete from' -: tolower 11{.y do. ix=. 11
elseif. 'update' -: tolower 6{.y do. ix=. 6
elseif. do. ix=. _1
end.
if. _1~:ix do.
  table=. ({.~ i.&' ') dlb ix}. ' ' (I.y e.'()')}y
else.
  table=. ''
end.
if. 1=fmt do.
  if. 1 e. ivb=. ' values ' E. tolower ' ' (I.y e.'()')}y do. iv=. {.I.ivb else. fmt=. 0 end.
end.
if. 0=fmt do.
  y1=. y
  f1=. (0=(2&|)) +/\ ''''=y1  NB. outside quote but including trailing quote
  f2=. (> 0:,}:) f1           NB. firstones of f1
  f2=. 0,}.f2                 NB. no leading quote
  y1=. ' ' (I.-.f1)}y1        NB. replace string with blanks
  y1=. ' ' (I.f2)}y1          NB. replace trailing quote
  f1=. 0< (([: +/\ '('&=) - ([: +/\ ')'&=)) y1    NB. inside ()
  y1=. ' ' (I.f1 *. ','=y1)}y1    NB. replace , within () with blanks
  y1=. ' ' (I.y1 e.'()')}y1    NB. replace () with blanks
  y1=. (' where ';', where ';' WHERE ';', WHERE ';' and ';', and ';' AND ';', AND ';' or ';', or ';' OR ';', OR ') stringreplace (deb y1) , ','  NB. add delimiter for the last field
  a=. (',' = y1) <;._2 y1
  b=. (#~ ('='&e. *. '?'&e.)&>) a
  c=. ({.~ i:&'=')&.> b
  parm=. dtb&.> ({.~ i.&' ')&.|.&.> c
else.
  fld=. <@dltb;._1 ',', ' ' (I.a e.'()')} a=. (}.~ i.&'(') y{.~ iv

  y1=. y}.~ iv + #' values '
  f1=. (0=(2&|)) +/\ ''''=y1  NB. outside quote but including trailing quote
  f2=. (> 0:,}:) f1           NB. firstones of f1
  f2=. 0,}.f2                 NB. no leading quote
  y1=. ' ' (I.-.f1)}y1        NB. replace string with blanks
  y1=. ' ' (I.f2)}y1          NB. replace trailing quote
  y1=. }.}:dltb y1            NB. remove outermost ()
  f1=. 0< (([: +/\ '('&=) - ([: +/\ ')'&=)) y1    NB. inside ()
  y1=. ' ' (I.f1 *. ','=y1)}y1    NB. replace , within () with blanks
  y1=. ' ' (I.y1 e.'()')}y1    NB. replace () with blanks
  y1=. (deb y1),','   NB. add delimiter for the last field
  a=. <;._2 y1
  msk=. ('?'&e.)&> a
  parm=. ((#fld){.msk)#fld
end.
table;parm
)

NB.* ddsparm v
NB. parameterised query (no rows returned),  useful for insert/update blob
NB. will add column type and call ddparm, single base table only
NB.    ch ddsparm~ 'insert into blobs (jjname,jjbinary) values (?,?)';'abc';2345678$a.
ddsparm=: 4 : 0
clr 0
if. -.(isiu y) *. (isbx x) do. errret ISI08 return. end.
if. -.y e.CHALL do. errret ISI03 return. end.
if. 2>#x do. errret ISI08 return. end.
sql=. ,0{::x
if. -.(iscl sql) do. errret ISI08 return. end.
if. ''-:table=. 0{:: tp=. parsesqlparm sql do. errret ISI08 return. end.
if. tp ~:&# x do. errret ISI08 return. end.
sql2=. 'select ', (}. ; (<',') ,&.> (}.tp)), ' from ', table, ' where 1=0'
if. SQL_ERROR-: z=. y ddcoltype~ sql2 do. z return. end.
if. (<SQL_ERROR)-: {.z do. z return. end.
'oty ty lns'=. |: _3]\;8 13 9{("1) z=. 1&{::^:UseErrRet z
a=. (2 131072 262144 e.~ 3!:0)&> x1=. }.x
b=. (2>(#@$))&> x1
if. 1 e. r=. a *. b do.
  x=. (,:@:,&.> (1+I.r){x) (1+I.r)}x
end.
y ddparm~ (<|:oty,.lns,.ty) ,&.(1&|.) x
)

NB.* ddparm v
NB. parameterised query (no rows returned),  useful for insert/update blob
NB. (sql;((sqltype1, sqltype2, sqltype3) ., len1 , len2, len3);param1;param2;parm3) ddparm ch
NB. (sql;(sqltype1, sqltype2, sqltype3);param1;param2;parm3) ddparm ch
NB. create a longbinary field for testing because access memo field has max length about 64k
NB.    ch=: ddcon 'dsn=jblob'
NB.    ch ddsql~ 'alter table blobs add column jjbinary longbinary'
NB.    ch ddsql~ 'delete from blobs'
NB.    ch ddparm~ 'insert into blobs (jjname,jjbinary) values (?,?)';(SQL_VARCHAR_jdd_, SQL_LONGVARBINARY_jdd_);'abc';2345678$a.
NB.    sh=: ch ddsel~ 'select jjbinary from blobs where jjname=''abc'''
NB.    (2345678$a.) -: >{.{.ddfet sh, 1
NB.    dddis ch
ddparm=: 4 : 0
clr DDROWCNT=: 0
if. -.(isiu y) *. (isbx x) do. errret ISI08 return. end.
if. -.y e.CHALL do. errret ISI03 return. end.
if. 3>#x do. errret ISI08 return. end.
sql=. utf8 , >0{x
tyln=. >1{x
if. -.(iscl sql) *. (isiu tyln) do. errret ISI08 return. end.
if. 1 e. 2< #@$&> 2}.x do. errret ISI08 return. end.
if. 1 < #@:~. #&> 2}.x do. errret ISI08 return. end.
f=. >x{~ of=. 2
arraysize=. rows=. #f
ty=. ''
if. 2=$$tyln do.
  if. 2=#tyln do.
    'sqlty lns'=. tyln
  elseif. 3=#tyln do.
    'sqlty lns ty'=. tyln
  elseif. do.
    assert. 0
  end.
else.
  sqlty=. tyln [ lns=. (#tyln)#_2 NB. _2 mean undefined, _1 may be reserved for null in the future
end.
if. ''-:ty do.
  try.
    ty=. (odbc_type_table i. sqlty){native_type_table
  catch.
    errret ISI55 return.
  end.
end.

if. (#x) ~: of+#ty do. errret ISI50 return. end.
if. 0=rows do. ret_DD_OK SQL_NO_DATA return. end.

loctran=. 0
if. y -.@e. CHTR do.
  if. sqlok SQL_BEGIN transact y do.
    loctran=. 1
  else.
    errret 0,y return.
  end.
end.

if. _1= sh=. 0{:: rc=. sql preparesql y do.
  r=. 1{::rc
  if. loctran do. SQL_ROLLBACK transact y end.
  r return.
end.
if. (#ty) ~: mysql_stmt_param_count sh do.
  freestmt sh [ r=. errret ISI50
  if. loctran do. SQL_ROLLBACK transact y end.
  r return.
end.

NB. bind column, need erasebind in freestmt/ddend
ncol=. #ty
bytelen=. ''
boxs=. ncol#0

bindname=. 'BIND',(":sh)
assert. 0~: nc <bindname

bind=. mema sb=. SZ_MYSQL_BIND * #ty
(sb#{.a.) memw bind,0,sb,2
(bindname)=: bind
('BINDN',":sh)=: #ty
('BINDIO',":sh)=: 0        NB. input parametere

ec=. MYSQL_OK
for_i. i.ncol do.
  bname=. 'BIND',(":sh),'_',":i
  bnamel=. 'BINDLN',(":sh),'_',":i
  select. t=. i{ty
  case. MYSQL_TYPE_TINY do.
    try.
      nr=. #(bname)=: a.{~ <.,(i+of){::x
    catch.
NB. don't use continue inside switch which is inside a for loop. but that bug does not affect break
      ec=. SQL_ERROR break.
    end.
    (bnamel)=: nr$1
    1&bindiorow bind,i,t,1
  case. MYSQL_TYPE_SHORT do.
    try.
      nr=. 2%~ #(bname)=: 1&ic <.,(i+of){::x
    catch.
      ec=. SQL_ERROR break.
    end.
    (bnamel)=: nr$2
    1&bindiorow bind,i,t,2
  case. MYSQL_TYPE_LONG do.
    if. IF64 do.
      try.
        nr=. 4%~ #(bname)=: 2&ic <.,(i+of){::x
      catch.
        ec=. SQL_ERROR break.
      end.
    else.
      try.
        nr=. #(bname)=: <.,(i+of){::x
      catch.
        ec=. SQL_ERROR break.
      end.
    end.
    (bnamel)=: nr$4
    1&bindiorow bind,i,t,4
  case. MYSQL_TYPE_LONGLONG do.
    if. IF64 do.
      try.
        nr=. #(bname)=: <.,(i+of){::x
      catch.
        ec=. SQL_ERROR break.
      end.
    else.
      try.
        nr=. 4%~ #(bname)=: 2&ic <.,(i+of){::x
      catch.
        ec=. SQL_ERROR break.
      end.
    end.
    (bnamel)=: nr$8
    1&bindiorow bind,i,t,8
  case. MYSQL_TYPE_FLOAT do.
    try.
      nr=. 4%~ #(bname)=: 1&fc (1.1-1.1)+,(i+of){::x
    catch.
      ec=. SQL_ERROR break.
    end.
    (bnamel)=: nr$4
    1&bindiorow bind,i,t,4
  case. MYSQL_TYPE_DOUBLE;MYSQL_TYPE_DECIMAL;MYSQL_TYPE_NEWDECIMAL do.
    try.
      nr=. #(bname)=: (1.1-1.1)+,(i+of){::x
    catch.
      ec=. SQL_ERROR break.
    end.
    (bnamel)=: nr$8
    1&bindiorow bind,i,MYSQL_TYPE_DOUBLE,8
  case. MYSQL_TYPE_STRING; MYSQL_TYPE_VAR_STRING do.
    if. L. da=. (i+of){::x do.
      if. 0 e. (2 e.~ 3!:0)&> da do.
        ec=. SQL_ERROR break.
      end.
      nr=. #(bname)=: da=. ,da
      boxs=. 1 i}boxs
      (bnamel)=: #&> da
      1&bindiorow bind,i,MYSQL_TYPE_STRING, 0
    else.
      if. 2>#@$ da do. da=. ,: ,da end.
      nr=. #(bname)=: da
      lns=. (ls=. {:@$ da) i}lns
      (bnamel)=: nr$ls
      1&bindiorow bind,i,MYSQL_TYPE_STRING, ls
    end.
  case. MYSQL_TYPE_BLOB do.
    if. L. da=. (i+of){::x do.
      if. 0 e. (2 e.~ 3!:0)&> da do.
        ec=. SQL_ERROR break.
      end.
      nr=. #(bname)=: da=. ,da
      boxs=. 1 i}boxs
      (bnamel)=: #&> da
      1&bindiorow bind,i,t, 0
    else.
      if. 2>#@$ da do. da=. ,: ,da end.
      nr=. #(bname)=: da
      lns=. (ls=. {:@$ da) i}lns
      (bnamel)=: nr$ls
      1&bindiorow bind,i,t, ls
    end.
  case. MYSQL_TYPE_DATE;MYSQL_TYPE_TIME;MYSQL_TYPE_TIMESTAMP do.
    if. UseDayNo do.
      if. 1 4 8 -.@e.~ 3!:0 da=. (i+of){::x do.
        ec=. SQL_ERROR break.
      end.
    else.
      if. 2 131072 262144 -.@e.~ 3!:0 da=. (i+of){::x do.
        ec=. SQL_ERROR break.
      end.
      if. 2>#@$ da=. (i+of){::x do. da=. ,: ,da end.
      if. MYSQL_TYPE_TIMESTAMP= t do. da=. numdatetime@(23&{.)"1 da
      elseif. MYSQL_TYPE_DATE= t do. da=. numdate@(10&{.)"1 da
      elseif. MYSQL_TYPE_TIME= t do. da=. numtime@(11&}.)"1 da
      end.
    end.
    nr=. #da=. ,da
NB. optimized for performance, assume 4 bytes per field, need to check in each platform
    (bname)=: SZ_MYSQL_TIME{.!.({.a.)"1[ _24]\ 2&ic ,<. todatex da
    (bnamel)=: nr#SZ_MYSQL_TIME
    (bnamel)=: 0 (I. 0=da)}bnamel~
    1&bindiorow bind,i,t,SZ_MYSQL_TIME
  case. do.
    smoutput 'ddparm unsupported type: ',":t
    ec=. SQL_ERROR break.
  end.
  bnamep=. 'BINDP',(":sh),'_',":i
  (bnamep)=: iad bname
end.
if. (MYSQL_OK) -.@e.~ ec do.
  freestmt sh [ r=. errret ISI51
  if. loctran do. SQL_ROLLBACK transact y end.
  r return.
end.

rowcnt=. 0
k=. 0
ec=. MYSQL_OK
while. k<rows do.
  for_i. i.ncol do.
    (k,(i{ty),(i{lns),i{boxs) setbinddat sh,bind,i
  end.
  if. MYSQL_OK~: ec=. 1&(17 b.)^:IFWIN mysql_stmt_bind_param sh,bind do. break end.
  if. MYSQL_OK~: ec=. mysql_stmt_execute sh do. break end.
  rowcnt=. rowcnt + 0 >. mysql_stmt_affected_rows sh
  if. MYSQL_OK~: ec=. 1&(17 b.)^:IFWIN mysql_stmt_reset sh do. break. end.
  k=. >:k
end.
if. (MYSQL_OK) -.@e.~ ec do.
  freestmt sh [ r=. errret 1,sh
  if. loctran do. SQL_ROLLBACK transact y end.
  r return.
end.
assert. k=rows
DDROWCNT=: rowcnt
freestmt sh
if. loctran do. SQL_COMMIT transact y end.
ret_DD_OK DD_OK
)

NB. =========================================================
setbinddat=: 4 : 0
'sh bind i'=. y
'k ty ln boxs'=. x
bnamep=. 'BINDP',(":sh),'_',":i
pbuf=. bnamep~
p=. bind + i * SZ_MYSQL_BIND
select. ty
case. MYSQL_TYPE_TINY do.
  (pbuf+k) memw p,MYSQL_BIND_buffer,1 4
case. MYSQL_TYPE_SHORT do.
  (pbuf+k*2) memw p,MYSQL_BIND_buffer,1 4
case. MYSQL_TYPE_LONG do.
  (pbuf+k*4) memw p,MYSQL_BIND_buffer,1 4
case. MYSQL_TYPE_LONGLONG do.
  (pbuf+k*8) memw p,MYSQL_BIND_buffer,1 4
case. MYSQL_TYPE_FLOAT do.
  (pbuf+k*4) memw p,MYSQL_BIND_buffer,1 4
case. MYSQL_TYPE_DOUBLE;MYSQL_TYPE_DECIMAL;MYSQL_TYPE_NEWDECIMAL do.
  (pbuf+k*8) memw p,MYSQL_BIND_buffer,1 4
case. MYSQL_TYPE_DATETIME do.
  (pbuf+k*SZ_MYSQL_TIME) memw p,MYSQL_BIND_buffer,1 4
  bnamel=. 'BINDLN',(":sh),'_',":i
  if. 0=k{bnamel~ do.
    pisnull=. {.memr p,MYSQL_BIND_is_null,1 4
    1 memw pisnull, 0 1 1
  end.
case. MYSQL_TYPE_DATE do.
  (pbuf+k*SZ_MYSQL_TIME) memw p,MYSQL_BIND_buffer,1 4
  bnamel=. 'BINDLN',(":sh),'_',":i
  if. 0=k{bnamel~ do.
    pisnull=. {.memr p,MYSQL_BIND_is_null,1 4
    1 memw pisnull, 0 1 1
  end.
case. MYSQL_TYPE_TIME do.
  (pbuf+k*SZ_MYSQL_TIME) memw p,MYSQL_BIND_buffer,1 4
  bnamel=. 'BINDLN',(":sh),'_',":i
  if. 0=k{bnamel~ do.
    pisnull=. {.memr p,MYSQL_BIND_is_null,1 4
    1 memw pisnull, 0 1 1
  end.
case. MYSQL_TYPE_STRING; MYSQL_TYPE_VAR_STRING do.
  if. boxs do.
    bname=. 'BIND',(":sh),'_',":i
    dat=. k{::bname~
    (iad 'dat') memw p,MYSQL_BIND_buffer,1 4
    (#dat) memw p, MYSQL_BIND_buffer_length, 1 4
    plength=. {.memr p,MYSQL_BIND_length,1 4
    (#dat) memw plength, 0 1 4
  else.
    (pbuf+k*ln) memw p,MYSQL_BIND_buffer,1 4
    ln memw p, MYSQL_BIND_buffer_length, 1 4
    plength=. {.memr p,MYSQL_BIND_length,1 4
    ln memw plength, 0 1 4
  end.
case. MYSQL_TYPE_BLOB do.
  if. boxs do.
    bname=. 'BIND',(":sh),'_',":i
    dat=. k{::bname~
    (iad 'dat') memw p,MYSQL_BIND_buffer,1 4
    (#dat) memw p, MYSQL_BIND_buffer_length, 1 4
    plength=. {.memr p,MYSQL_BIND_length,1 4
    (#dat) memw plength, 0 1 4
  else.
    (pbuf+k*ln) memw p,MYSQL_BIND_buffer,1 4
    ln memw p, MYSQL_BIND_buffer_length, 1 4
    plength=. {.memr p,MYSQL_BIND_length,1 4
    ln memw plength, 0 1 4
  end.
  bnamel=. 'BINDLN',(":sh),'_',":i
  pisnull=. {.memr p,MYSQL_BIND_is_null,1 4
  (a.{~0=k{bnamel~) memw pisnull, 0 1 2
case. do.
  smoutput 'setbinddat unsupported type: ',":ty
  assert. 0
end.
)

NB. =========================================================
numdate=: 3 : 0
if. 0= #y=. dltb y do.
  0
else.
  NULL=. null=. 0
  86400000%~ tsrep 0 0 0,~ 3{. ". ' 0123456789' ([-.-.)~ ' ' (I. y e. '-:+TZ')}y
end.
)

numtime=: 3 : 0"1
if. 0= #y=. dltb y do.
  0
else.
  NULL=. null=. 0
  86400000%~ tsrep 0 (0 1 2)} 6{. ". ' 0123456789' ([-.-.)~ ' ' (I. y e. '-:+TZ')}y
end.
)

numdatetime=: 3 : 0"1
if. 0= #y=. dltb y do.
  0
else.
  NULL=. null=. 0
  86400000%~ tsrep 6{. ". ' 0123456789' ([-.-.)~ ' ' (I. y e. '-:+TZ')}y
end.
)

