require 'dd'

coclass 'jsqltable'
totimestampy2=: 3 : 0
+/@((10000 100 1, % 100 10000 1000000)&*) "1 y
)
todatey2=: 3 : 0
+/@((10000 100 1)&*@:(3&{.)) "1 <. y
)
totimey2=: 3 : 0
+/@((% 100 10000 1000000)&*@:(_3&{.)) "1 y
)
isotimestampnull=: 3 : 0
b=. y +./@e.("1) _ __
(23#' ') (I. b)}isotimestamp y
)
isodatenull=: 3 : 0
b=. y +./@e.("1) _ __
(10#' ') (I. b)}(10 {."1 isotimestamp) y
)
isotimenull=: 3 : 0
b=. y +./@e.("1) _ __
(12#' ') (I. b)}isotime y
)
isotime=: 3 : 0
d=. ($y)$ 0 (I.y1 e. _ __)}y1=. ,y
s=. $d=. (2 3 7j3) ": d
d=. , d
d=. s$'0'(I. ' '=d)}d
d=. ((#d)#,:'::') (<a:;2 5)} d
({:$d) {."0 1 d
)
totimestampnull=: 3 : 0
r=. $$y
d=. todatenull@:<. y
t=. totimenull@:(((1&|) ::])"0) y
if. 0=r do.
  d,t
else.
  d,.t
end.
)
todatenull=: 3 : 0
r=. $$y
b=. _ __ e.~ y=. <. ,y
z=. todate 0 (I.b)}y
if. 0=r do.
  (*+/b){z,:_ _ _
else.
  _ _ _ (I. b)}((#y),3)$,z
end.
)
totimenull=: 3 : 0
r=. $$y
b=. _ __ e.~ y=. ,y
z=. totime 0 (I.b)}y
if. 0=r do.
  (*+/b){z,:_ _ _
else.
  _ _ _ (I. b)}((#y),3)$,z
end.
)
totime=: 3 : 0
r=. $$y
h=. <. a=. 24*(1&|) y
m=. <. a=. 60*a-h
s=. 60*a-m
if. 0=r do.
  h,m,s
else.
  h,.m,.s
end.
)
ERR01=: 'incorrect number of arguments'
ERR02=: 'argument data type error'
ERR03=: 'unknown jtype'
ERR04=: 'unknown column'
ERR05=: 'condition not string type'
ERR06=: 'data not box type'
ERR07=: 'number of items in each column not match'
ERR08=: 'missing condition'
ERR09=: 'column not box type'
ERR10=: 'invalid connection handle'
ERR11=: 'table not found'
ERR12=: 'no short datatype column to insert'
ERR13=: 'pkupdate: no primary key'
ERR14=: 'pkupdate: key not in data'
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
create=: 3 : 0
if. 2~:#y=. boxopen y do. ERR01 13!:8[3 end.
if. 2~: 3!:0 >@{.y do. ERR02 13!:8[3 end.
if. 2 4 -.@e.~ 3!:0 >@{:y do. ERR02 13!:8[3 end.

'table dsnch'=. y
if. 2= 3!:0 dsnch do.
  if. _1= ch=: ddcon dsnch do. (dderr'') 13!:8[3 end.
  dsn=: dsnch
else.
  if. _1=dsnch=. {.,dsnch do. ERR10 13!:8[3 end.
  ch=: dsnch
end.

allobj_jsqltable_=: allobj_jsqltable_, coname''
source=: table -. delim
sql=. U2A 'select * from ',(}:delim),source,(}.delim)
z=. sql ddcoltype ch
if. _1-:z do. ERR11 13!:8[3 end.
tx=. ;:'ixcatalog ixdatabase ixtable ixorg_table ixname ixorg_name ixcolumnid ixtypename ixcoltype ixlength ixdecimals ixnullable ixdef ixnativetype ixnativeflags'
(tx)=. i.#tx
colinfo=: (<'') ,~"0 1 (ixname,ixcolumnid,ixtypename,ixcoltype,ixlength,ixdecimals,ixnullable){"1 z
colinfo=: (/:1{::"1 colinfo){colinfo
colinfo=: (A2U&.>{."1 colinfo) (<a:;0)}colinfo
cols=: ix_name{"1 colinfo
longcols=: ((LONGCOLUMNSIZE&< +. 0&>) ,>ix_length{"1 colinfo)#cols
sql=. sqlindex rplc LF;' ';'@1';source
sh=. ch ddsel~ sql
if. _1~:sh do.
  index=: }."1 ddfet sh,_1
  ddend sh
end.
sql=. sqlpk rplc LF;' ';'@1';source
sh=. ch ddsel~ sql
if. _1~:sh do.
  if. *# a=. ddfet sh,_1 do.
    pk=: (<0 0){::a
  end.
  ddend sh
end.

0
)
sqlindex=: 0 : 0
select object_name(c.object_id) object,i.name index_name,cl.name column_name,
c.key_ordinal,c.is_descending_key,c.is_included_column
from sys.index_columns c inner join sys.indexes
i on c.object_id = i.object_id and c.index_id = i.index_id
inner join sys.columns cl on c.object_id = cl.object_id and c.column_id = cl.column_id
where c.object_id = object_id ('@1')
)
sqlpk=: 0 : 0
select name from sysobjects where xtype='PK' and parent_obj
in (select id from sysobjects where name='@1')
)
destroy=: 3 : 0
if. *#dsn do. dddis ::0: ch end.
allobj_jsqltable_=: allobj_jsqltable_ -. coname''
0
)
setmeta=: 4 : 0
x=. ,&.> boxxopen x
y=. ,&.> boxxopen y
if. (#x)~:#y do. ERR01 return. end.
if. 0= *./ x e. cols do. ERR04 return. end.
if. 0= *./ y e. COLTYPE,<'' do. ERR03 return. end.
i=. cols i. x
colinfo=: y (<i;ix_jtype)}colinfo
0
)
delete=: 3 : 0
if. 2~: 3!:0 y do. ERR05 return. end.
if. 'where '-:tolower 6{. y=. dltb y do.
  cond=. y
elseif. do.
  cond=. (*#y)#' where ',y
end.
sql=. U2A 'delete ', toprow, ' from ', (}:delim), source, (}.delim),cond
toprow=: ''
er=. ch ddsql~ sql
if. _1=er do.
  if. DELBUG do.
    if. ''-:er=. dderr'' do.
      0
    else.
      er
    end.
  else.
    dderr''
  end.
else.
  0
end.
)
pkupdate=: ''&$: : (4 : 0)
x=. boxxopen x
if. 0=#x do. x=. (<''),cols end.
if. 32~: 3!:0 x do. ERR09 return. end.
col1=. 0$<''
if. 0=#>@{.x do.
  x=. }.x
elseif. 32 = 3!:0 >@{.x do.
  col1=. >@{.x
  x=. }.x
end.
if. 0=#x do. x=. cols end.
if. 0=#col1 do.
  if. (0~:#pk) *. 0~:#index do.
    if. (<pk) e. {."1 index do.
      col1=. ((<pk) = {."1 index) # 1{"1 index
    end.
  end.
end.
if. 0=#col1 do. ERR13 return. end.
if. 0= *./ col1 e. x do. ERR14 return. end.
col2=. x -. col1
ci=. cols i. x
if. 0= *./ (#cols)>ci do. ERR04 return. end.
if. (#x)~:#y do. ERR01 return. end.

if. 0=ttally y do. 0 return. end.

b=. I. (<'') ~: ix_jtype{"1 ci{colinfo
for_i. b do.
  y=. (< (3}.i{ci{colinfo) jtypetosql >i{y) i}y
end.
ty=. , > ix_coltype{"1 ci{colinfo

x1=. x -. longcols
if. 0 e. col1 e. x1 do. ERR13 return. end.
col2=. col2 -. longcols
if. 0=#col2 do. 0 return. end.
c1=. (x i. col2),(x i. col1)
y=. c1{y
ty=. c1{ty
sql=. U2A 'update ',(}:delim), source, (}.delim),' set ', (}: ; (<}:delim) ,&.> col2 ,&.> (<(}.delim),'=?,')), ' where ', (_5}. ; (<}:delim) ,&.> col1 ,&.> (<(}.delim),'=? and '))

er=. ch ddparm~ sql;ty;y
if. _1=er do. er=. dderr'' end.
er
)
read=: 3 : 0
cols read y
:
x=. boxxopen x
if. 32~: 3!:0 x do. ERR09 return. end.
if. 2~: 3!:0 y do. ERR05 return. end.
x1=. x -. longcols
ci=. cols i. x1
if. 0= *./ (#cols)>ci do. ERR04 return. end.
if. 'where '-:tolower 6{. y=. dltb y do.
  cond=. y
elseif. 'order '-:tolower 6{. y do.
  cond=. y
elseif. do.
  cond=. (*#y)#' where ',y
end.
if. 0=#x1 do.
  sql=. U2A 'select ', toprow, ' count(*) from ',(}:delim), source, (}.delim),cond
  toprow=: ''
  sh=. ch ddsel~ sql
  if. _1=sh do. dderr'' return. end.
  z=. ddfet sh,1
  er=. dderr''
  ddend sh
  if. _1-:z do. er return. end.
  assert. *#z
  nrows=. {. (<0 0){::z
  (#x)$<(nrows,0)$' '
else.
  sql=. U2A 'select ', toprow, ' ', (}. ; (<',',(}:delim)) ,&.> x1 ,&.> <(}.delim)), ' from ',(}:delim), source, (}.delim),cond
  toprow=: ''
  sh=. ch ddsel~ sql
  if. _1=sh do. dderr'' return. end.
  tdayno=. UseDayNo_jdd_
  ddconfig 'dayno';1
  z=. ddfch sh,_1
  ddconfig 'dayno';tdayno
  er=. dderr''
  ddend sh
  if. _1-:z do. er return. end.
  if. ttally z do.
    b=. I. (<'') ~: ix_jtype{"1 ci{colinfo
    for_i. b do.
      z=. (< (3}.i{ci{colinfo) sqltojtype >i{z) i}z
    end.
  end.
  z (I. x e. x1)}(#x)$<((ttally z),0)$' '
end.
)
write=: 3 : 0
cols write y
:
x=. boxxopen x
if. 32~: 3!:0 x do. ERR09 return. end.
if. 32~: 3!:0 y do. ERR06 return. end.
if. (#x)~:#y do. ERR01 return. end.
x1=. x -. longcols
if. 0=#x1 do. ERR12 return. end.
ci=. cols i. x1
y=. (x e. x1)#y
if. 0= *./ (#cols)>ci do. ERR04 return. end.
if. 1 < #@~. #&> y do. ERR07 return. end.
if. 0=ttally y do. 0 return. end.
b=. I. (<'') ~: ix_jtype{"1 ci{colinfo
for_i. b do.
  y=. (< (3}.i{ci{colinfo) jtypetosql >i{y) i}y
end.
sql=. U2A 'select ', (}. ; (<',',(}:delim)) ,&.> x1 ,&.> <(}.delim)), ' from ',(}:delim), source, (}.delim),' where 1=0'
er=. ch ddins~ sql;y
if. _1=er do. er=. dderr'' end.
er
)
replace=: 3 : 0
cols replace y
:
x=. boxxopen x
if. 32~: 3!:0 x do. ERR09 return. end.
if. 32~: 3!:0 y do. ERR06 return. end.
if. (#x)~:#y do. ERR01 return. end.
x1=. x -. longcols
if. 0=#x1 do. ERR12 return. end.
ci=. cols i. x1
y=. (x e. x1)#y
if. 0= *./ (#cols)>ci do. ERR04 return. end.
if. 1 < #@~. #&> y do. ERR07 return. end.
toprow=: ''
loctran=. 0
if. -. ddttrn ch do.
  er=. ddtrn ch
  if. _1=er do. dderr'' return. end.
  loctran=. 1
end.
sql=. U2A 'delete ', toprow, ' from ', (}:delim), source, (}.delim)
er=. ch ddsql~ sql
if. _1=er do.
  if. DELBUG do.
    if. ''-:er=. dderr'' do.
      0
    else.
      er [ ddrbk^:loctran ch return.
    end.
  else.
    er=. dderr''
    er [ ddrbk^:loctran ch return.
  end.
else.
  0
end.
if. 0=ttally y do.
  0[ddcom^:loctran ch return.
end.
b=. I. (<'') ~: ix_jtype{"1 ci{colinfo
for_i. b do.
  y=. (< (3}.i{ci{colinfo) jtypetosql >i{y) i}y
end.
sql=. U2A 'select ', (}. ; (<',',(}:delim)) ,&.> x1 ,&.> <(}.delim)), ' from ',(}:delim), source, (}.delim),' where 1=0'
er=. ch ddins~ sql;y
if. 0=er do.
  ddcom^:loctran ch
else.
  er=. dderr''
  ddrbk^:loctran ch
end.
er
)
update=: 4 : 0
x=. boxxopen x
if. 0=#x do. ERR08 return. end.
if. 32~: 3!:0 y do. ERR06 return. end.
co=. >@{.x
if. 2~: 3!:0 co do. ERR05 return. end.
if. 'where '-:tolower 6{. co=. dltb co do.
  cond=. co
elseif. do.
  cond=. (*#co)#' where ',co
end.
x=. }.x
if. 0= #x do. x=. cols end.
if. 32~: 3!:0 x do. ERR09 return. end.
if. 1 < #@~. #&> y do. ERR07 return. end.
if. (#x)~:#y do. ERR01 return. end.
x1=. x -. longcols
if. 0=#x1 do. ERR12 return. end.
ci=. cols i. x1
y=. (x e. x1)#y
if. 0= *./ (#cols)>ci do. ERR04 return. end.
toprow=: ''
loctran=. 0
if. -. ddttrn ch do.
  er=. ddtrn ch
  if. _1=er do. dderr'' return. end.
  loctran=. 1
end.
sql=. U2A 'delete ', toprow, ' from ', (}:delim), source, (}.delim),cond
er=. ch ddsql~ sql
if. _1=er do.
  if. DELBUG do.
    if. ''-:er=. dderr'' do.
      0
    else.
      er [ ddrbk^:loctran ch return.
    end.
  else.
    er=. dderr''
    er [ ddrbk^:loctran ch return.
  end.
else.
  0
end.
if. 0=ttally y do.
  0[ddcom^:loctran ch return.
end.
b=. I. (<'') ~: ix_jtype{"1 ci{colinfo
for_i. b do.
  y=. (< (3}.i{ci{colinfo) jtypetosql >i{y) i}y
end.
sql=. U2A 'select ', (}. ; (<',',(}:delim)) ,&.> x1 ,&.> <(}.delim)), ' from ',(}:delim), source, (}.delim),' where 1=0'
er=. ch ddins~ sql;y
if. 0=er do.
  ddcom^:loctran ch
else.
  er=. dderr''
  ddrbk^:loctran ch
end.
er
)
deleter=: delete
pkupdater=: ''&$: : (4 : 0)
x=. boxxopen x
if. 0=#x do. x=. (<''),cols end.
if. 32~: 3!:0 x do. ERR09 return. end.
col1=. 0$<''
if. 0=#>@{.x do.
  x=. }.x
elseif. 32 = 3!:0 >@{.x do.
  col1=. >@{.x
  x=. }.x
end.
if. 0=#x do. x=. cols end.
if. 0=#col1 do.
  if. (0~:#pk) *. 0~:#index do.
    if. (<pk) e. {."1 index do.
      col1=. ((<pk) = {."1 index) # 1{"1 index
    end.
  end.
end.
if. 0=#col1 do. ERR13 return. end.
if. 0= *./ col1 e. x do. ERR14 return. end.
col2=. x -. col1
ci=. cols i. x
if. 0= *./ (#cols)>ci do. ERR04 return. end.
if. (#x)~:{:@$y do. ERR01 return. end.

if. 0=#y do. 0 return. end.

b=. I. (<'') ~: ix_jtype{"1 ci{colinfo
for_i. b do.
  y=. ((3}.i{ci{colinfo) jtypetosql i{"1 y) (<a:;i)}y
end.
ty=. , > ix_coltype{"1 ci{colinfo

if. 0 e. col1 e. x do. ERR13 return. end.
if. 0=#col2 do. 0 return. end.
c1=. (x i. col2),(x i. col1)
y=. c1{"1 y
ty=. c1{ty
sql=. U2A 'update ',(}:delim), source, (}.delim),' set ', (}: ; (<}:delim) ,&.> col2 ,&.> (<(}.delim),'=?,')), ' where ', (_5}. ; (<}:delim) ,&.> col1 ,&.> (<(}.delim),'=? and '))
loctran=. 0
if. -. ddttrn ch do.
  er=. ddtrn ch
  if. _1=er do. dderr'' return. end.
  loctran=. 1
end.
for_r. y do.
  er=. ch ddparm~ sql;ty;,:&.> r
  if. _1=er do. break. end.
end.
if. 0=er do.
  ddcom^:loctran ch
else.
  er=. dderr''
  ddrbk^:loctran ch
end.
er
)
readr=: 3 : 0
cols readr y
:
x=. boxxopen x
if. 32~: 3!:0 x do. ERR09 return. end.
if. 2~: 3!:0 y do. ERR05 return. end.
ci=. cols i. x
if. 0= *./ (#cols)>ci do. ERR04 return. end.
if. 'where '-:tolower 6{. y=. dltb y do.
  cond=. y
elseif. 'order '-:tolower 6{. y do.
  cond=. y
elseif. do.
  cond=. (*#y)#' where ',y
end.
sql=. U2A 'select ', toprow, ' ', (}. ; (<',',(}:delim)) ,&.> x ,&.> <(}.delim)), ' from ',(}:delim), source, (}.delim),cond
toprow=: ''
sh=. ch ddsel~ sql
if. _1=sh do. dderr'' return. end.
tdayno=. UseDayNo_jdd_
ddconfig 'dayno';1
z=. ddfet sh,_1
ddconfig 'dayno';tdayno
er=. dderr''
ddend sh
if. _1-:z do. er return. end.
if. 0=#z do. z return. end.
b=. I. (<'') ~: ix_jtype{"1 ci{colinfo
for_i. b do.
  z=. ((3}.i{ci{colinfo) sqltojtype i{"1 z) (<a:;i)}z
end.
z
)
writer=: 3 : 0
cols writer y
:
x=. boxxopen x
if. 32~: 3!:0 x do. ERR09 return. end.
if. 32~: 3!:0 y do. ERR06 return. end.
y=. ,:@:(,&.>)^:(1=#@$) y
if. (#x)~:{:@$y do. ERR01 return. end.
ci=. cols i. x
if. 0= *./ (#cols)>ci do. ERR04 return. end.
if. 0=#y do. 0 return. end.
b=. I. (<'') ~: ix_jtype{"1 ci{colinfo
for_i. b do.
  y=. ((3}.i{ci{colinfo) jtypetosql i{"1 y) (<a:;i)}y
end.
ty=. , > ix_coltype{"1 ci{colinfo
loctran=. 0
if. -. ddttrn ch do.
  er=. ddtrn ch
  if. _1=er do. dderr'' return. end.
  loctran=. 1
end.
sql=. U2A 'insert into ',(}:delim), source, (}.delim), '(', (}. ; (<',',(}:delim)) ,&.> x ,&.> <(}.delim)), ') values (', (}.;(#x)#<',?'), ')'
for_r. y do.
  er=. ch ddparm~ sql;ty;,:&.> r
  if. _1=er do. break. end.
end.
if. 0=er do.
  ddcom^:loctran ch
else.
  er=. dderr''
  ddrbk^:loctran ch
end.
er
)
replacer=: 3 : 0
cols replacer y
:
x=. boxxopen x
if. 32~: 3!:0 x do. ERR09 return. end.
if. 32~: 3!:0 y do. ERR06 return. end.
y=. ,:@:(,&.>)^:(1=#@$) y
if. (#x)~:{:@$y do. ERR01 return. end.
ci=. cols i. x
if. 0= *./ (#cols)>ci do. ERR04 return. end.
sql=. U2A 'delete ', toprow, ' from ', (}:delim), source, (}.delim)
toprow=: ''
loctran=. 0
if. -. ddttrn ch do.
  er=. ddtrn ch
  if. _1=er do. dderr'' return. end.
  loctran=. 1
end.
er=. ch ddsql~ sql
if. _1=er do.
  if. DELBUG do.
    if. ''-:er=. dderr'' do.
      0
    else.
      er [ ddrbk^:loctran ch return.
    end.
  else.
    er=. dderr''
    er [ ddrbk^:loctran ch return.
  end.
else.
  0
end.
if. 0=#y do.
  0[ddcom^:loctran ch return.
end.
b=. I. (<'') ~: ix_jtype{"1 ci{colinfo
for_i. b do.
  y=. ((3}.i{ci{colinfo) jtypetosql i{"1 y) (<a:;i)}y
end.
ty=. , > ix_coltype{"1 ci{colinfo
sql=. U2A 'insert into ',(}:delim), source, (}.delim), '(', (}. ; (<',',(}:delim)) ,&.> x ,&.> <(}.delim)), ') values (', (}.;(#x)#<',?'), ')'
for_r. y do.
  er=. ch ddparm~ sql;ty;,:&.> r
  if. _1=er do. break. end.
end.
if. 0=er do.
  ddcom^:loctran ch
else.
  er=. dderr''
  ddrbk^:loctran ch
end.
er
)
updater=: 4 : 0
x=. boxxopen x
if. 0=#x do. ERR08 return. end.
if. 32~: 3!:0 y do. ERR06 return. end.
y=. ,:@:(,&.>)^:(1=#@$) y
co=. >@{.x
if. 2~: 3!:0 co do. ERR05 return. end.
if. 'where '-:tolower 6{. co=. dltb co do.
  cond=. co
elseif. do.
  cond=. (*#co)#' where ',co
end.
x=. }.x
if. 0= #x do. x=. cols end.
if. 32~: 3!:0 x do. ERR09 return. end.
if. (#x)~:{:@$y do. ERR01 return. end.
ci=. cols i. x
if. 0= *./ (#cols)>ci do. ERR04 return. end.
toprow=: ''
loctran=. 0
if. -. ddttrn ch do.
  er=. ddtrn ch
  if. _1=er do. dderr'' return. end.
  loctran=. 1
end.
sql=. U2A 'delete ', toprow, ' from ', (}:delim), source, (}.delim),cond
er=. ch ddsql~ sql
if. _1=er do.
  if. DELBUG do.
    if. ''-:er=. dderr'' do.
      0
    else.
      er [ ddrbk^:loctran ch return.
    end.
  else.
    er=. dderr''
    er [ ddrbk^:loctran ch return.
  end.
else.
  0
end.
if. 0=#y do.
  0[ddcom^:loctran ch return.
end.
b=. I. (<'') ~: ix_jtype{"1 ci{colinfo
for_i. b do.
  y=. ((3}.i{ci{colinfo) jtypetosql i{"1 y) (<a:;i)}y
end.
ty=. , > ix_coltype{"1 ci{colinfo
sql=. U2A 'insert into ',(}:delim), source, (}.delim), '(', (}. ; (<',',(}:delim)) ,&.> x ,&.> <(}.delim)), ') values (', (}.;(#x)#<',?'), ')'
for_r. y do.
  er=. ch ddparm~ sql;ty;(,:@,)&.> r
  if. _1=er do. break. end.
end.
if. 0=er do.
  ddcom^:loctran ch
else.
  er=. dderr''
  ddrbk^:loctran ch
end.
er
)
allobj=: 0$<''
ch=: _1
colinfo=: 0 8$<''
cols=: 0$<''
dsn=: ''
delim=: '[]'
index=: 0 6$<''
longcols=: 0$<''
pk=: ''
source=: ''
toprow=: ''
COLTYPE=: ;:'C N Y1 Y2'
DELBUG=: 1
LONGCOLUMNSIZE=: 8000
'ix_name ix_columnid ix_typename ix_coltype ix_length ix_decimals ix_nullable ix_jtype'=: i.8
indexof=: 4 : 0

if. ((1=#@$) x) *. (1=#@$) y do.
  if. (#x)~:#y do. ERR02 return. end.
  if. 0=ttally x do. (ttally y)$0 return. end.
  if. 0=ttally y do. 0$0 return. end.
  tx=. 2= 3!:0&>x
  ty=. 2= 3!:0&>y
  if. 0= *./ tx=ty do. ERR01 return. end.

  w=. ({:@$&>tx#x)>.({:@$&>ty#y)
  x=. (w ({."1)&.> tx#x) (I.tx)}x
  y=. (w ({."1)&.> ty#y) (I.ty)}y
  x (i.&>~@[ i.&|: i.&>) y

elseif. ((2=#@$) x) *. (2=#@$) y do.
  if. ({:@$ x)~:{:@$ y do. ERR02 return. end.
  if. 0=#x do. (#y)$0 return. end.
  if. 0=#y do. 0$0 return. end.
  tx=. 2= 3!:0&>{.x
  ty=. 2= 3!:0&>{.y
  if. 0= *./ tx=ty do. ERR01 return. end.

  x=. (dtb&.> (<a:;tx){x) (<a:;I.tx)}x
  y=. (dtb&.> (<a:;ty){y) (<a:;I.ty)}y
  x i. y

elseif. do.
  ERR02 return.
end.

)
reset=: 3 : 0
for_l. allobj_jsqltable_ do.
  if. l e. 18!:1[1 do.
    destroy__l ::0: ''
  end.
end.
allobj_jsqltable_=: 0$<''
0
)
U2A=: ]
A2U=: ]
ifa=: <@(>"1)@|:
afi=: |:@:(<"_1@>)
ttally=: *@# * #@>@{.
sqtbchk_z_=: ] ` (] 13!:8 3:) @. (2 = 3!:0)
