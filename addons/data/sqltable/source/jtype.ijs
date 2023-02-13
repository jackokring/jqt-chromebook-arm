NB. jtype

NB. =========================================================
NB. private verbs
NB.
NB. jtypetojtype
NB. sqltojtype
NB.
NB. jtypey2tojtype (internal)

NB. =========================================================
NB. sqltojtype
NB.
NB. convert sql data to jtype format data
NB.
NB. valide jtypes are:
NB. C  literal
NB. N  numeric
NB. Y1 datetime as string in the format 'yyyy-mm-dd hh:MM:ss[.nnn]'
NB.    fractional seconds optional
NB.    null as empty string
NB. Y2 datetime as number in the format yyyymmdd.hhMMss
NB.    fractional seconds ignored
NB.    null as _
NB.
NB. datetime in sql data are represented by a number with
NB. integer portion as the number of days from 1800-01-01
NB. fractional portion as the number of seconds from midnight divided by 24*60*60
NB. null as _
sqltojtype=: 4 : 0
'coltype length decimals nullable jtype'=. x
isr=. 32=3!:0 y
select. jtype
case. ,'C' do.
  if. coltype e. SQL_SMALLINT,SQL_INTEGER,(IF64*.UseBigInt_jdd_)#SQL_BIGINT do.
    z=. ":`(":&.>)@.isr y
  elseif. coltype e. SQL_REAL,SQL_FLOAT,SQL_DOUBLE do.
    z=. (0j16&":)`(0j16&":&.>)@.isr y
  elseif. coltype e. SQL_TYPE_TIMESTAMP do.
    z=. (isotimestampnull@:totimestampnull)`(isotimestampnull@:totimestampnull&.>)@.isr y
  elseif. coltype e. SQL_TYPE_DATE do.
    z=. (isodatenull@:todatenull)`(isodatenull@:todatenull&.>)@.isr y
  elseif. coltype e. SQL_TYPE_TIME,SQL_SS_TIME2 do.
    z=. (isotimenull@:totimenull)`(isotimenull@:totimenull&.>)@.isr y
  elseif. do.
    z=. y
  end.
case. ,'N' do.
  if. isr do.
    z=. (]`(,@:(_&"."1))@.(2=3!:0))&.> y
  else.
    z=. ]`(,.@:(_&"."1))@.(2=3!:0) y
  end.
case. 'Y1' do.
  if. coltype e. SQL_TYPE_TIMESTAMP do.
    z=. (isotimestampnull@:totimestampnull)`(isotimestampnull@:totimestampnull&.>)@.isr y
  elseif. coltype e. SQL_TYPE_DATE do.
    z=. (isodatenull@:todatenull)`(isodatenull@:todatenull&.>)@.isr y
  elseif. coltype e. SQL_TYPE_TIME,SQL_SS_TIME2 do.
    z=. (isotimenull@:totimenull)`(isotimenull@:totimenull&.>)@.isr y
  elseif. do.
    z=. y
  end.
case. 'Y2' do.
  if. coltype e. SQL_TYPE_TIMESTAMP do.
    z=. (,.@:(totimestampy2@:totimestampnull))`((totimestampy2@:totimestampnull)&.>)@.isr y
  elseif. coltype e. SQL_TYPE_DATE do.
    z=. (,.@:(todatey2@:todatenull))`((todatey2@:todatenull)&.>)@.isr y
  elseif. coltype e. SQL_TYPE_TIME,SQL_SS_TIME2 do.
    z=. (,.@:(totimey2@:totimenull))`((totimey2@:totimenull)&.>)@.isr y
  elseif. do.
    z=. y
  end.
end.
z
)

NB. =========================================================
NB. jtypetosql
NB.
NB. return sql data from jtype format data
NB.
NB. jtype same as that in sqltojtype
jtypetosql=: 4 : 0
'coltype length decimals nullable jtype'=. x
isr=. 32=3!:0 y
select. jtype
case. ,'C' do.
  if. coltype e. SQL_SMALLINT,SQL_INTEGER,SQL_REAL,SQL_FLOAT,SQL_DOUBLE do.
    if. isr do.
      z=. (]`(,@:(_&".))@.(2=3!:0))&.> y
    else.
      z=. ]`(,.@:(_&".))@.(2=3!:0) y
    end.
  else.
    z=. y
  end.
case. ,'N' do.
  if. coltype e. (-.IF64*.UseBigInt_jdd_)#SQL_BIGINT do.
    if. isr do.
      z=. (]`('_-'&charsub@:":@:{.)@.(1 4 e.~ 3!:0))&.> y
    else.
      z=. ]`('_-'&charsub@:":)@.(1 4 e.~ 3!:0) y
    end.
  else.
    z=. y
  end.
case. 'Y2' do.
  if. isr do.
    z=. (]`(,@:(coltype&jtypey2tosql))@.(2~:3!:0))&.> y
  else.
    z=. ]`(coltype&jtypey2tosql)@.(2~:3!:0) y
  end.
case. do.
  z=. y
end.
z
)

NB. =========================================================
NB. jtypey2tosql
NB.
NB. return sql data from jtype y2 format data
NB.
NB. called internally by jtypetosql
jtypey2tosql=: 4 : 0
coltype=. x
if. coltype e. SQL_TYPE_TIMESTAMP do.
  msk=. _ = ,y
  y=. 0 (I.msk)},y
  a=. todayno 10000 100 100 #: <. y
  b=. +/"1 (%24, (24*60), 24*60*60) *("1) 100 100 100 #: 1e6 * 1| y
  z=. ,. _ (I.msk)} a+b
elseif. coltype e. SQL_TYPE_DATE do.
  z=. ,. todayno 10000 100 100 #: <. ,y
elseif. coltype e. SQL_TYPE_TIME,SQL_SS_TIME2 do.
  z=. ,. +/"1 (%24, (24*60), 24*60*60) *("1) 100 100 100 #: 1e6 * 1| ,y
end.
z
)
