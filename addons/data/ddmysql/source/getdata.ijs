NB. get and convert various datatypes ----------------------

NB. =========================================================
NB. bind read

NB. +--------------------+------------------+
NB. |        Type        |      Length      |
NB. +--------------------+------------------+
NB. |MYSQL_TYPE_TINY     |1                 |
NB. +--------------------+------------------+
NB. |MYSQL_TYPE_SHORT    |2                 |
NB. +--------------------+------------------+
NB. |MYSQL_TYPE_LONG     |4                 |
NB. +--------------------+------------------+
NB. |MYSQL_TYPE_LONGLONG |8                 |
NB. +--------------------+------------------+
NB. |MYSQL_TYPE_FLOAT    |4                 |
NB. +--------------------+------------------+
NB. |MYSQL_TYPE_DOUBLE   |8                 |
NB. +--------------------+------------------+
NB. |MYSQL_TYPE_TIME     |sizeof(MYSQL_TIME)|
NB. +--------------------+------------------+
NB. |MYSQL_TYPE_DATE     |sizeof(MYSQL_TIME)|
NB. +--------------------+------------------+
NB. |MYSQL_TYPE_DATETIME |sizeof(MYSQL_TIME)|
NB. +--------------------+------------------+
NB. |MYSQL_TYPE_STRING   |data length       |
NB. +--------------------+------------------+
NB. |MYSQL_TYPE_BLOB     |data_length       |
NB. +--------------------+------------------+

bindiorow=: 4 : 0
'bind i ty ln'=. y
p=. bind + i*SZ_MYSQL_BIND
(2&ic ty) memw p, MYSQL_BIND_buffer_type, 4 2
NB. do not allocate for input parameter
if. (0=x) *. 0<ln do.
  (mema ln) memw p, MYSQL_BIND_buffer, 1 4
  ln memw p, MYSQL_BIND_buffer_length, 1 4
else.
  0 memw p, MYSQL_BIND_buffer, 1 4
  0 memw p, MYSQL_BIND_buffer_length, 1 4
end.
(isnull=. mema 1) memw p, MYSQL_BIND_is_null, 1 4
(length=. mema SZI) memw p, MYSQL_BIND_length, 1 4
(error=. mema 1) memw p, MYSQL_BIND_error, 1 4
({.a.) memw isnull, 0 1
0 memw length, 0 1 4
({.a.) memw error, 0 1
)

NB. =========================================================
getbinddat=: 3 : 0
'sh bind i'=. y
p=. bind + i * SZ_MYSQL_BIND
ty=. {. _2&ic memr p,MYSQL_BIND_buffer_type,4 2
buf=. {. memr p,MYSQL_BIND_buffer,1 4
length=. {. memr 0 1 4,~ {.memr p,MYSQL_BIND_length,1 4
isnull=. ({.a.)~: {. memr 0 1,~ {. memr p,MYSQL_BIND_is_null,1 4
error=. ({.a.)~: {. memr 0 1,~ {. memr p,MYSQL_BIND_error,1 4
select. ty
case. MYSQL_TYPE_TINY do.
  if. isnull +: error do.
    z=. memr buf,0 1 2
    st=. 1
  else.
    z=. ,{.a.
    st=. error{(isnull{1,_2),_1
  end.
case. MYSQL_TYPE_SHORT do.
  if. isnull +: error do.
    z=. memr buf,0 2 2
    st=. 2
  else.
    z=. 2#{.a.
    st=. error{(isnull{1,_2),_1
  end.
case. MYSQL_TYPE_LONG do.
  if. isnull +: error do.
    if. IF64 do.
      z=. memr buf,0 4 2
    else.
      z=. memr buf,0 1 4
    end.
    st=. 4
  else.
    if. IF64 do.
      z=. 4#{.a.
    else.
      z=. ,0
    end.
    st=. error{(isnull{1,_2),_1
  end.
case. MYSQL_TYPE_LONGLONG do.
  if. isnull +: error do.
    if. IF64 do.
      z=. memr buf,0 1 4
    else.
      z=. memr buf,0 4 2      NB. TODO  assume little endian
    end.
    st=. 8
  else.
    if. IF64 do.
      z=. ,0
    else.
      z=. 4#{.a.
    end.
    st=. error{(isnull{1,_2),_1
  end.
case. MYSQL_TYPE_FLOAT do.
  if. isnull +: error do.
    z=. _1&fc memr buf,0 4 2
    st=. 4
  else.
    z=. 1&fc 1.1-1.1
    st=. error{(isnull{1,_2),_1
  end.
case. MYSQL_TYPE_DOUBLE;MYSQL_TYPE_DECIMAL;MYSQL_TYPE_NEWDECIMAL do.
  if. isnull +: error do.
    z=. memr buf,0 1 8
    st=. 8
  else.
    z=. 2&fc 1.1-1.1
    st=. error{(isnull{1,_2),_1
  end.
case. MYSQL_TYPE_TIME;MYSQL_TYPE_DATE;MYSQL_TYPE_DATETIME do.
  if. isnull +: error do.
    z=. memr buf,0, SZ_MYSQL_TIME
    st=. SZ_MYSQL_TIME
  else.
    z=. SZ_MYSQL_TIME#{.a.
    st=. error{(isnull{1,_2),_1
  end.
case. MYSQL_TYPE_STRING;MYSQL_TYPE_VAR_STRING do.
  if. -.isnull do.
    if. buf do.
      z=. memr buf, 0, length, 2
      st=. length
    else.
      if. error do.
        (tbuf=. mema length) memw p, MYSQL_BIND_buffer, 1 4
        length memw p, MYSQL_BIND_buffer_length, 1 4
        rc=. mysql_stmt_fetch_column sh, p, i, 0
        assert. 0=rc
        z=. memr tbuf, 0, length, 2
        memf tbuf
        0 memw p, MYSQL_BIND_buffer, 1 4
        0 memw p, MYSQL_BIND_buffer_length, 1 4
        st=. length
      else.
        z=. ''
        st=. 0
      end.
    end.
  else.
    z=. ''
    st=. error{(isnull{1,_2),_1
  end.
  z=. ,&({.a.) z
case. MYSQL_TYPE_BLOB do.
  if. -.isnull do.
    if. buf do.
      z=. memr buf, 0, length, 2
      st=. length
    else.
      if. error do.
        (tbuf=. mema length) memw p, MYSQL_BIND_buffer, 1 4
        length memw p, MYSQL_BIND_buffer_length, 1 4
        rc=. mysql_stmt_fetch_column sh, p, i, 0
        assert. 0=rc
        z=. memr tbuf, 0, length, 2
        memf tbuf
        0 memw p, MYSQL_BIND_buffer, 1 4
        0 memw p, MYSQL_BIND_buffer_length, 1 4
        st=. length
      else.
        z=. ''
        st=. 0
      end.
    end.
  else.
    z=. ''
    st=. error{(isnull{1,_2),_1
  end.
  z=. <z
case. do.
  smoutput 'getbinddat unsupported type: ',":ty
  assert. 0
end.
z;st
)

NB. =========================================================
getdata=: 4 : 0

NB. dyad:  btGetcolinfo getdata ilShRows
NB.
NB.  ci =. getcolinfo sh
NB.  ci getdata sh,10   NB. ten rows
NB.  ci getdata sh,_1   NB. all rows in stmt

'sh r'=. y
NB. catalog database table org_table name org_name column-id(1-base) typename coltype length decimals nullable def nativetype nativeflags
assert. 15={:$x
oty=. ; 8 {"1 x
ln=. ; 9 {"1 x
ty=. ; 13 {"1 x

dat=. 0$<''
if. r=0 do. dat return. end.

bindname=. 'BIND',(":sh)
if. 0= nc <bindname do.
  bind=. bindname~
else.
  if. MYSQL_OK~: mysql_stmt_execute sh do.
    er=. errret 1,sh
    er [ freestmt sh return.
  end.
  cnt=. 0 >. mysql_stmt_affected_rows sh

  bind=. mema sb=. SZ_MYSQL_BIND * #ty
  (sb#{.a.) memw bind,0,sb,2

  for_i. i.#ty do.
    select. t=. i{ty
    case. MYSQL_TYPE_TINY do. 0&bindiorow bind,i,t,1
    case. MYSQL_TYPE_SHORT do. 0&bindiorow bind,i,t,2
    case. MYSQL_TYPE_LONG do. 0&bindiorow bind,i,t,4
    case. MYSQL_TYPE_LONGLONG do. 0&bindiorow bind,i,t,8
    case. MYSQL_TYPE_FLOAT do. 0&bindiorow bind,i,t,4
    case. MYSQL_TYPE_DOUBLE;MYSQL_TYPE_DECIMAL;MYSQL_TYPE_NEWDECIMAL do. 0&bindiorow bind,i,MYSQL_TYPE_DOUBLE,8
    case. MYSQL_TYPE_TIME;MYSQL_TYPE_DATE;MYSQL_TYPE_DATETIME do. 0&bindiorow bind,i,t,SZ_MYSQL_TIME
    case. MYSQL_TYPE_STRING; MYSQL_TYPE_VAR_STRING do. 0&bindiorow bind,i,t,(30>:i{ln){0,i{ln
    case. MYSQL_TYPE_BLOB do. 0&bindiorow bind,i,t,0
    case. do.
      smoutput 'getdata unsupported type: ',":t
      assert. 0
    end.
  end.
  mysql_stmt_bind_result sh,bind
  (bindname)=: bind
  ('BINDN',":sh)=: #ty
  ('BINDIO',":sh)=: 1          NB. output parameter
  ('BINDRR',":sh)=: cnt
end.

pref=. 'BIND',(":sh),'_'
prefst=. 'BINDLN',(":sh),'_'
for_i. i.#ty do.
  (prefst,":i)=: 0$0
  select. t=. i{ty
  case. MYSQL_TYPE_TINY do. (pref,":i)=: 0$''
  case. MYSQL_TYPE_SHORT do. (pref,":i)=: 0$''
  case. MYSQL_TYPE_LONG do. (pref,":i)=: 0$ IF64{:: 0;''
  case. MYSQL_TYPE_LONGLONG do. (pref,":i)=: 0$ IF64{:: '';0
  case. MYSQL_TYPE_FLOAT do. (pref,":i)=: 0$''
  case. MYSQL_TYPE_DOUBLE;MYSQL_TYPE_DECIMAL;MYSQL_TYPE_NEWDECIMAL do. (pref,":i)=: 0$1.1-1.1
  case. MYSQL_TYPE_TIME;MYSQL_TYPE_DATE;MYSQL_TYPE_DATETIME do. (pref,":i)=: 0$''
  case. MYSQL_TYPE_STRING; MYSQL_TYPE_VAR_STRING do. (pref,":i)=: 0$''
  case. MYSQL_TYPE_BLOB do. (pref,":i)=: 0$<''
  case. do.
    smoutput 'getdata unsupported type: ',":t
    assert. 0
  end.
end.
eof=. 0
z=. mysql_stmt_fetch sh
while.do.

  if. MYSQL_NO_DATA= z do.
    eof=. 1
    break.
  elseif. MYSQL_DATA_TRUNCATED= z do.
NB. truncation is expected for zero-length buffer
NB.     er=. errret 1,sh
NB.     er [ freestmt sh return.
  elseif. 1= z do.
    er=. errret 1,sh
    er [ freestmt sh return.
  end.

  row=. 0$<i.0 0
  for_i. i.#ty do.
    'da lengthorstatus'=. getbinddat sh,bind,i
    (pref,":i)=: (pref,":i)~, da
    (prefst,":i)=: (prefst,":i)~, lengthorstatus
  end.

  if. 0=r=. <:r do. break. end.  NB. _1 case ends on SQL_NO_DATA
  z=. mysql_stmt_fetch sh
end.

if. 0=#(pref,":0)~ do.
  dat=. (#ty)$<i.0 0
else.
  dat=. 0$<i.0 0
  for_i. i.#ty do.
    select. t=. i{ty
    case. MYSQL_TYPE_TINY do. dat=. dat, < a.i.(pref,":i)~
    case. MYSQL_TYPE_SHORT do. dat=. dat, < _1&ic (pref,":i)~
    case. MYSQL_TYPE_LONG do. dat=. dat, < _2&ic^:IF64 (pref,":i)~
    case. MYSQL_TYPE_LONGLONG do. dat=. dat, < _2&ic^:(-.IF64) (pref,":i)~
    case. MYSQL_TYPE_FLOAT do. dat=. dat, < _1&fc (pref,":i)~
    case. MYSQL_TYPE_DOUBLE;MYSQL_TYPE_DECIMAL;MYSQL_TYPE_NEWDECIMAL do. dat=. dat, < (pref,":i)~
    case. MYSQL_TYPE_DATETIME do.
NB. optimized for performance, assume 4 bytes per field, need to check in each platform
      dat=. dat, < isotimestamp`todaynox@.UseDayNo "1[ _6]\ _2&ic , 24&{."1 (-SZ_MYSQL_TIME)]\ (pref,":i)~
    case. MYSQL_TYPE_DATE do.
      dat=. dat, < 10&{.@:isotimestamp`todaynox@.UseDayNo "1[ _6]\ _2&ic , 24&{."1 (-SZ_MYSQL_TIME)]\ (pref,":i)~
    case. MYSQL_TYPE_TIME do.
      dat=. dat, < 11&}.@:isotimestamp`todaynox@.UseDayNo "1[ _6]\ _2&ic , 24&{."1 (-SZ_MYSQL_TIME)]\ (pref,":i)~
    case. MYSQL_TYPE_STRING; MYSQL_TYPE_VAR_STRING do. dat=. dat, < <;._2 ucp^:UseUnicode (pref,":i)~
    case. MYSQL_TYPE_BLOB do. dat=. dat, < (pref,":i)~
    case. do.
      smoutput 'getidata unsupported type: ',":t
      assert. 0
    end.
  end.
end.
assert. 1= # ~. #&> dat
if. eof do. ddend^:(-.UseErrRet) sh end.
if. UseErrRet do.
  (<<<0),dat
else.
  dat
end.
)

