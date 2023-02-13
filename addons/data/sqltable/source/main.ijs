NB. main

NB. all public verbs (except create and destroy) return 0 for success or box data,
NB. but return error message if fail.
NB. an utility verb sqtbchk can be use to check the result

NB. =========================================================
NB. public verbs
NB.
NB. create
NB. destroy
NB.
NB. delete
NB. pkupdate
NB. read
NB. replace
NB. setmeta
NB. update
NB. write

NB. =========================================================
NB. private nouns
NB.
NB. sqlindex
NB. sqlpk

NB. =========================================================
NB. create
NB.
NB. create jsqltable object for a table
NB.
NB. y = table ; dsn
NB.
NB. example:
NB. 'jsqltable' conew 'mytab' ; 'dsn=testdata;uid=sa;pwd=secret'
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

NB. column type
sql=. U2A 'select * from ',(}:delim),source,(}.delim)
z=. sql ddcoltype ch
if. _1-:z do. ERR11 13!:8[3 end.
NB. fields in ddcoltype
tx=. ;:'ixcatalog ixdatabase ixtable ixorg_table ixname ixorg_name ixcolumnid ixtypename ixcoltype ixlength ixdecimals ixnullable ixdef ixnativetype ixnativeflags'
(tx)=. i.#tx
colinfo=: (<'') ,~"0 1 (ixname,ixcolumnid,ixtypename,ixcoltype,ixlength,ixdecimals,ixnullable){"1 z
colinfo=: (/:1{::"1 colinfo){colinfo
colinfo=: (A2U&.>{."1 colinfo) (<a:;0)}colinfo
cols=: ix_name{"1 colinfo
longcols=: ((LONGCOLUMNSIZE&< +. 0&>) ,>ix_length{"1 colinfo)#cols     NB. 8000 for sql server, other mdbs may vary

NB. get index, only apply to sql server
sql=. sqlindex rplc LF;' ';'@1';source
sh=. ch ddsel~ sql
if. _1~:sh do.
  index=: }."1 ddfet sh,_1
  ddend sh
end.

NB. get primary key, only apply to sql server
sql=. sqlpk rplc LF;' ';'@1';source
sh=. ch ddsel~ sql
if. _1~:sh do.
  if. *# a=. ddfet sh,_1 do.
    pk=: (<0 0){::a
  end.
  ddend sh
end.

0 NB. success
)

NB. =========================================================
NB. sqlindex
NB.
NB. template for sql statement retrieving index from sql server
sqlindex=: 0 : 0
select object_name(c.object_id) object,i.name index_name,cl.name column_name,
c.key_ordinal,c.is_descending_key,c.is_included_column
from sys.index_columns c inner join sys.indexes
i on c.object_id = i.object_id and c.index_id = i.index_id
inner join sys.columns cl on c.object_id = cl.object_id and c.column_id = cl.column_id
where c.object_id = object_id ('@1')
)

NB. =========================================================
NB. sqlpk
NB.
NB. template for sql statement retrieving primary key from sql server
sqlpk=: 0 : 0
select name from sysobjects where xtype='PK' and parent_obj
in (select id from sysobjects where name='@1')
)

NB. =========================================================
NB. destroy
NB.
destroy=: 3 : 0
if. *#dsn do. dddis ::0: ch end.
allobj_jsqltable_=: allobj_jsqltable_ -. coname''
0 NB. success
)

NB. =========================================================
NB. setmeta
NB.
NB. set meta data
NB.
NB. form: columns setmeta jtypes
NB.  x = list of column name
NB.  y = list of column jtype
NB.
NB. For example we could say that we want everything in text to J, or some fields numeric and some datefields numeric/text.
NB. In J this means we have three datatypes: text C, numeric N and date Y:
NB. coltype              sql             J
NB. C                    ‘Bill’          ‘Bill’
NB. C                    123             ‘123’
NB. C                    ‘2013-01-01’    ‘2013-01-01’
NB. N                    123             123
NB. Y1                   ‘2013-01-01’    ‘2013-01-01’
NB. Y2                   ‘2013-01-01’    20130101
NB. (empty) no mapping
setmeta=: 4 : 0
x=. ,&.> boxxopen x
y=. ,&.> boxxopen y
if. (#x)~:#y do. ERR01 return. end.
if. 0= *./ x e. cols do. ERR04 return. end.
if. 0= *./ y e. COLTYPE,<'' do. ERR03 return. end.
i=. cols i. x
colinfo=: y (<i;ix_jtype)}colinfo  NB. need test
0
)

NB. =========================================================
NB. delete
NB.
NB. delete with optional where statement
NB. empty condition will delete all rows
NB.
NB. form: delete condition
NB.
NB.  for example:
NB.  delete__ a 'city=''rome'' and year=2013'
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

NB. =========================================================
NB. pkupdate
NB.
NB. pkupdate with primary key
NB. this requires the table has a primary key or equivalent
NB.
NB. form: [boxed index list;][column;column] pkupdate data
NB. if boxed index list is absent or is an empty array, it will use the pk of table
NB. otherwise the combination of boxed index list must constitute a pk
NB. data must contains pk or column combination that is unique for each row.
NB. If the above criteria is not satisfied, pkupdate can still execute without 
NB. raising any error but the result will not be what is being expected.
NB. 
NB. If the first item of left argument is a level-2 box, then it is a index list.
NB.
NB. example:
NB.   pkupdate__a data
NB.   (<<'id1') pkupdate__a data            NB. if id1 alone is a pk candidate
NB.   (<'id1';'id2') pkupdate__a data       NB. if (id1,id2) is a pk candidate
NB.   ('id1';'foo';'id2';'bar') pkupdate__a data      NB. pk contained in columns 
NB.   ('';'id1';'foo';'id2';'bar') pkupdate__a data   NB. ditto.
NB.   (('id1';'id2');'id1';'foo';'id2';'bar') pkupdate__a data

pkupdate=: ''&$: : (4 : 0)
x=. boxxopen x
if. 0=#x do. x=. (<''),cols end.
if. 32~: 3!:0 x do. ERR09 return. end.
col1=. 0$<''
NB. check if index list of pk is present
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

if. 0=ttally y do. 0 return. end.  NB. no rows to update

b=. I. (<'') ~: ix_jtype{"1 ci{colinfo
for_i. b do.
  y=. (< (3}.i{ci{colinfo) jtypetosql >i{y) i}y
end.
ty=. , > ix_coltype{"1 ci{colinfo

x1=. x -. longcols                          NB. cannot handle long datatype
if. 0 e. col1 e. x1 do. ERR13 return. end.  NB. unlikely, pk should be short columns
col2=. col2 -. longcols                     NB. cannot handle long datatype
if. 0=#col2 do. 0 return. end.
NB. rearrange order for sql update syntax
c1=. (x i. col2),(x i. col1)
y=. c1{y
ty=. c1{ty
sql=. U2A 'update ',(}:delim), source, (}.delim),' set ', (}: ; (<}:delim) ,&.> col2 ,&.> (<(}.delim),'=?,')), ' where ', (_5}. ; (<}:delim) ,&.> col1 ,&.> (<(}.delim),'=? and '))

er=. ch ddparm~ sql;ty;y
if. _1=er do. er=. dderr'' end.
er
)

NB. =========================================================
NB. read
NB.
NB. read with optional where statement
NB.
NB. form: [columns] read condition
NB. x = columns to be read. all columns if elided.
NB.
NB.  for example:
NB.  read__ a 'city=''rome'' and year=2013'
read=: 3 : 0
cols read y
:
x=. boxxopen x
if. 32~: 3!:0 x do. ERR09 return. end.
if. 2~: 3!:0 y do. ERR05 return. end.
x1=. x -. longcols           NB. ddfch cannot handle long datatype
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

NB. =========================================================
NB. write
NB.
NB.write (i.e. append) new data
NB.
NB. form: [columns] write data
NB. x = columns to be written. all columns if elided.
write=: 3 : 0
cols write y
:
x=. boxxopen x
if. 32~: 3!:0 x do. ERR09 return. end.
if. 32~: 3!:0 y do. ERR06 return. end.
if. (#x)~:#y do. ERR01 return. end.
x1=. x -. longcols                 NB. ddins cannot handle long datatype
if. 0=#x1 do. ERR12 return. end.   NB. no short column to insert, or what shall we do?
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

NB. =========================================================
NB. replace
NB.
NB. delete old values and write new
NB.
NB.  form: [columns] replace data
NB. x = columns to be written. all columns if elided.
replace=: 3 : 0
cols replace y
:
x=. boxxopen x
if. 32~: 3!:0 x do. ERR09 return. end.
if. 32~: 3!:0 y do. ERR06 return. end.
if. (#x)~:#y do. ERR01 return. end.
x1=. x -. longcols                 NB. ddins cannot handle long datatype
if. 0=#x1 do. ERR12 return. end.   NB. no short column to insert, or what shall we do?
ci=. cols i. x1
y=. (x e. x1)#y
if. 0= *./ (#cols)>ci do. ERR04 return. end.
if. 1 < #@~. #&> y do. ERR07 return. end.
toprow=: ''

NB. start a transaction to rollback if delete fails
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

NB. =========================================================
NB. update
NB.
NB. update with where statement
NB. this is a delete with conidtion then an insert data
NB.
NB.  form: (condition [;columns]) update data
NB.  condition is mandatory
NB.  all columns if elided.
NB.
NB.  example:
NB.  'city=''rome''' update__a data
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
x1=. x -. longcols                 NB. ddins cannot handle long datatype
if. 0=#x1 do. ERR12 return. end.   NB. no short column to insert, or what shall we do?
ci=. cols i. x1
y=. (x e. x1)#y
if. 0= *./ (#cols)>ci do. ERR04 return. end.
toprow=: ''

NB. start a transaction to rollback if delete fails
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
