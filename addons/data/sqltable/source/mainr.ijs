NB. mainr

NB. alternate verbs for ddfet format data because ddfch/ddins cannot handle long data

NB. all public verbs return 0 for success or box data,
NB. but return error message if fail.

NB. =========================================================
NB. public verbs
NB.
NB. deleter
NB. pkupdater
NB. readr
NB. replacer
NB. updater
NB. writer

NB. =========================================================
NB. deleter
NB.
NB. same as delete, just defined for convenience
NB.
deleter=: delete

NB. =========================================================
NB. pkupdater
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
NB.   pkupdater__a data
NB.   (<<'id1') pkupdater__a data            NB. if id1 alone is a pk candidate
NB.   (<'id1';'id2') pkupdater__a data       NB. if (id1,id2) is a pk candidate
NB.   ('id1';'foo';'id2';'bar') pkupdater__a data      NB. pk contained in columns 
NB.   ('';'id1';'foo';'id2';'bar') pkupdater__a data   NB. ditto.
NB.   (('id1';'id2');'id1';'foo';'id2';'bar') pkupdater__a data

pkupdater=: ''&$: : (4 : 0)
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
if. (#x)~:{:@$y do. ERR01 return. end.

if. 0=#y do. 0 return. end.  NB. no rows to update

b=. I. (<'') ~: ix_jtype{"1 ci{colinfo
for_i. b do.
  y=. ((3}.i{ci{colinfo) jtypetosql i{"1 y) (<a:;i)}y
end.
ty=. , > ix_coltype{"1 ci{colinfo

if. 0 e. col1 e. x do. ERR13 return. end.
if. 0=#col2 do. 0 return. end.
NB. rearrange order for sql update syntax
c1=. (x i. col2),(x i. col1)
y=. c1{"1 y
ty=. c1{ty
sql=. U2A 'update ',(}:delim), source, (}.delim),' set ', (}: ; (<}:delim) ,&.> col2 ,&.> (<(}.delim),'=?,')), ' where ', (_5}. ; (<}:delim) ,&.> col1 ,&.> (<(}.delim),'=? and '))

NB. start a transaction to rollback if update fails
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

NB. =========================================================
NB. readr
NB.
NB. read with optional where statement
NB.
NB. form: [columns] readr condition
NB. x = columns to be read. all columns if elided.
NB.
NB.  for example:
NB.  readr__ a 'city=''rome'' and year=2013'
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

NB. =========================================================
NB. writer
NB.
NB.write (i.e. append) new data
NB.
NB. form: [columns] writer data
NB. x = columns to be written. all columns if elided.
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
NB. if. 1 < #@~. #&> y do. ERR07 return. end.
if. 0=#y do. 0 return. end.
b=. I. (<'') ~: ix_jtype{"1 ci{colinfo
for_i. b do.
  y=. ((3}.i{ci{colinfo) jtypetosql i{"1 y) (<a:;i)}y
end.
ty=. , > ix_coltype{"1 ci{colinfo

NB. start a transaction to rollback if delete fails
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

NB. =========================================================
NB. replacer
NB.
NB. delete old values and write new
NB.
NB.  form: [columns] replacer data
NB. x = columns to be written. all columns if elided.
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
NB. if. 1 < #@~. #&> y do. ERR07 return. end.
sql=. U2A 'delete ', toprow, ' from ', (}:delim), source, (}.delim)
toprow=: ''

NB. start a transaction to rollback if delete fails
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

NB. =========================================================
NB. updater
NB.
NB. update with where statement
NB. this is a delete with conidtion then an insert data
NB.
NB.  form: (condition [;columns]) updater data
NB.  condition is mandatory
NB.  all columns if elided.
NB.
NB.  example:
NB.  'city=''rome''' update__a data
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
NB. if. 1 < #@~. #&> y do. ERR07 return. end.
if. (#x)~:{:@$y do. ERR01 return. end.
ci=. cols i. x
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
