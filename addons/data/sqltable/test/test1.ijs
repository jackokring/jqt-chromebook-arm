NB. insert csv data
NB. sql server, native client.

NB. results may need a2u for proper display in ide.

require 'dates dll strings'
cocurrent 'base'

NB. may need to change the dsn in these line
require 'data/sqltable'
kaikki=: jpath '~addons/data/sqltable/test/kaikki.csv'
asiak=: jpath '~addons/data/sqltable/test/asiak.csv'
dsn=: 'dsn=testdata;uid=sa;pwd=secret'

reset_jsqltable_''

9!:11[15

NB. utils from Inverted Tables essay
ifa=: <@(>"1)@|:  NB. inverted from atomic
afi=: |:@:(<"_1@>)  NB. atomic from inverted
ttally=: *@# * #@>@{.

NB. convert between utf8 and old 8-bit encoding
u2a=: 3 : '1&u: (u:128)(I.(7&u:y)=u:8364)}7&u:y'
a2u=: 3 : '8&u: (u:8364)(I.(u:y)=u:128)}u:y'

NB. =========================================================
run=: 3 : 0

NB. may need to set password in this line
ch=. ddcheck ddcon dsn

NB. ---------------------------------------------------------
cls=. '[Käyttöpaikka],[Asiakas],[Asiakastunnus],[Osoite],[Alkupvm],[Loppupvm],[photo]'
def=. '[Käyttöpaikka] int,[Asiakas] nvarchar(40),[Asiakastunnus] float,[Osoite] nvarchar(60),[Alkupvm] datetime,[Loppupvm] datetime,[photo] varbinary(max) constraint [pk_kaikki] primary key clustered ([Käyttöpaikka],[Asiakas])'

(u2a 'drop index [kaikki_idx_1] on [kaikki]') ddsql ch
(u2a 'drop table [kaikki]') ddsql ch
(u2a 'create table [kaikki] (',def,')') ddsql ch
(u2a 'create index [kaikki_idx_1] on [kaikki]([Asiakastunnus],[Asiakas])') ddsql ch

NB. smoutput (u2a' select * from [kaikki]') ddcoltype ch

NB. ---------------------------------------------------------
NB. without primary key
cls=. '[Käyttöpaikka],[Asiakas],[Asiakastunnus],[Osoite],[Postinro],[Postitmpk],[Hetu],[Laskuperuste],[Alkupvm],[Loppupvm],[photo]'
def=. '[Käyttöpaikka] int,[Asiakas] nvarchar(60),[Asiakastunnus] float,[Osoite] nvarchar(50),[Postinro] int,[Postitmpk] nvarchar(30),[Hetu] nvarchar(20),[Laskuperuste] smallint,[Alkupvm] datetime,[Loppupvm] datetime,[photo] varbinary(max)'

(u2a 'drop index [asiak_idx_1] on [asiak]') ddsql ch
(u2a 'drop table [asiak]') ddsql ch
(u2a 'create table [asiak] (',def,')') ddsql ch
(u2a 'create index [asiak_idx_1] on [asiak]([Asiakastunnus],[Asiakas])') ddsql ch

NB. smoutput (u2a' select * from asiak') ddcoltype ch

NB. dddis ch

NB. ---------------------------------------------------------
NB. first table
a=: ((u2a 'kaikki');ch) conew 'jsqltable'

smoutput 'columns'
smoutput cols__a
smoutput 'primary index'
smoutput pk__a
smoutput 'index'
smoutput index__a

smoutput 'colinfo'
smoutput colinfo__a

NB. kaikki.csv in latin-1
t1=. <;._1@:(';'&,)&.> }. <;._2 CR-.~ 1!:1 <kaikki
smoutput 'max width:', ": >./ #&> >t1
smoutput 'columns:', ": ~. #&>t1
assert. 1= # ~. #&>t1
t=. ifa <;._1@:(';'&,)&> }. <;._2 CR-.~ 1!:1 <kaikki
t=. (<((ttally t),10)$a.),~ (,.@(0&".)&.> 0 2 4 5{t) 0 2 4 5}t

sqtbchk ('Alkupvm';'Loppupvm') setmeta__a ('Y2';'Y2')
sqtbchk write__a t  NB. raise error if failed

smoutput 'first 10 rows'
toprow__a=: 'top(10)'
smoutput sqtbchk read__a ''
smoutput 'last 10 rows of 2 columns'
smoutput _10&{.&.> sqtbchk (u2a&.> 'Käyttöpaikka';'Asiakas') read__a ''

smoutput 'test pkupdate'
t2=. (< 100* 2{:: t) 2}t
sqtbchk pkupdate__a t2

smoutput 'first 10 rows after pkupdate'
toprow__a=: 'top(10)'
smoutput sqtbchk read__a ''

NB. ---------------------------------------------------------
NB. second table
b=: ((u2a 'asiak');ch) conew 'jsqltable'

smoutput 'columns'
smoutput cols__b
smoutput 'primary index'
smoutput pk__b
smoutput 'index'
smoutput index__b

smoutput 'colinfo'
smoutput colinfo__b

NB. asiak.csv in latin-1
t1=. <;._1@:(';'&,)&.> }. <;._2 CR-.~ 1!:1 <asiak
smoutput 'max width:', ": >./ #&> >t1
smoutput 'columns:', ": ~. #&>t1
assert. 1= # ~. #&>t1
t=. ifa <;._1@:(';'&,)&> }. <;._2 CR-.~ 1!:1 <asiak
t=. (<((ttally t),10)$a.),~ (,.@(0&".)&.> 0 2 4 7 8 9{t) 0 2 4 7 8 9}t

sqtbchk ('Alkupvm';'Loppupvm') setmeta__b ('Y2';'Y2')
sqtbchk write__b t  NB. raise error if failed

smoutput 'first 10 rows'
toprow__b=: 'top(10)'
smoutput sqtbchk read__b ''
smoutput 'last 10 rows of 2 columns'
smoutput _10&{.&.> sqtbchk (u2a&.> 'Käyttöpaikka';'Asiakas') read__b ''

NB. ---------------------------------------------------------
NB. test indexof
smoutput 'indexof'
r=. sqtbchk (b1=. sqtbchk ('Asiakas';'Osoite') read__b'') indexof_jsqltable_ a1=. sqtbchk ('Asiakas';'Osoite') read__a ''
i=. I. r < ttally b1
smoutput i&{&.> a1
smoutput (i{r)&{&.> b1

NB. ---------------------------------------------------------
smoutput 'test delete'
smoutput '# [Loppupvm] is null'
smoutput sqtbchk ttally read__b '[Loppupvm] is null'
smoutput '# [Loppupvm] is not null'
smoutput sqtbchk ttally read__b '[Loppupvm] is not null'
smoutput 'delete null rows'
sqtbchk delete__b '[Loppupvm] is null'
smoutput 'new # [Loppupvm] is null'
smoutput sqtbchk ttally read__b '[Loppupvm] is null'
smoutput 'new # all row'
smoutput sqtbchk ttally read__b ''
smoutput 'now delete all rows'
sqtbchk delete__b ''
smoutput 'new # all row'
smoutput sqtbchk ttally read__b ''

NB. ---------------------------------------------------------
smoutput 'test replace'
smoutput 'replace all rows again'
sqtbchk replace__b t
smoutput 'first 10 rows order by [Käyttöpaikka]'
toprow__b=: 'top(10)'
smoutput sqtbchk (5{.cols__b) read__b u2a 'order by [Käyttöpaikka]'

smoutput 'replace all rows again but fill only some columns'
sqtbchk (0 2 3 4{cols__b) replace__b 0 2 3 4{t
smoutput 'first 10 rows changed, note some null'
toprow__b=: 'top(10)'
smoutput sqtbchk (5{.cols__b) read__b u2a 'order by [Käyttöpaikka]'

NB. ---------------------------------------------------------
smoutput 'test update'
smoutput 'replace all rows again'
sqtbchk replace__b t

smoutput 'test pkupdate, expecting error'
smoutput pkupdate__b t
smoutput 'pkupdate using index list'
smoutput sqtbchk (< u2a&.> 'Käyttöpaikka';'Asiakas') pkupdate__b t

smoutput '# [Loppupvm] is null'
smoutput m=. ttally p=. sqtbchk read__b '[Loppupvm] is null'
p=. (<,.m#20140101) (cols__b i. <u2a 'Loppupvm')}p
smoutput 'update [Loppupvm] to change all null to 20140101'
sqtbchk '[Loppupvm] is null' update__b p
smoutput 'new # [Loppupvm] is null'
smoutput sqtbchk ttally read__b '[Loppupvm] is null'
smoutput 'new # [Loppupvm] is not null'
smoutput sqtbchk ttally read__b '[Loppupvm] is not null'

smoutput 'write selected columns'
sqtbchk (u2a&.> 'Käyttöpaikka';'Asiakas') write__b (,.8$_88);(8 4$'abc')
smoutput sqtbchk (5{.cols__b) read__b u2a '[Käyttöpaikka] = -88'

smoutput 'append using update'
sqtbchk (u2a&.> '1=0';'Käyttöpaikka';'Asiakas') update__b (,.9$_99);(9 4$'ABC')
smoutput sqtbchk (5{.cols__b) read__b u2a '[Käyttöpaikka] = -99'

destroy__a''
destroy__b''
smoutput 'that''s all'
reset_jsqltable_''
dddis ::0: ch
)

run ''

