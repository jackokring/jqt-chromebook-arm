NB. insert csv data
NB. sql server, native client.
NB. bigint mapping to long long seems does not works

require 'dates dll strings'
cocurrent 'base'

NB. may need to change the dsn in these line
require 'data/sqltable'
dsn=: 'dsn=testdata;uid=sa;pwd=secret'

reset_jsqltable_''

9!:11[15
ddconfig 'dayno';0

NB. utils from Inverted Tables essay
ifa=: <@(>"1)@|:  NB. inverted from atomic
afi=: |:@:(<"_1@>)  NB. atomic from inverted
ttally=: *@# * #@>@{.

abcs=: > <;._2 (0 : 0)
             1048576
         -1073741824
       1099511627776
    1125899906842624
-1152921504606846976
 4611686018427387904
)

NB. =========================================================
run=: 3 : 0

ch=. ddcheck ddcon dsn

abc=. 1 _1 1 1 _1 1 * <. 2^20 30 40 50 60 62

NMS=: ;: 'Anne Brenda Carol Denise Esther Fanny'

NB. ---------------------------------------------------------
cls=. 'bon,name,sal,rate,dob'
def=. 'bon bigint,name char(6),sal int,rate float,dob datetime'

('drop table mytab') ddsql ch
('create table mytab (',def,')') ddsql ch

NB. dddis ch

NB. ---------------------------------------------------------
a=: ('mytab';ch) conew 'jsqltable'

smoutput 'columns'
smoutput cols__a

smoutput 'colinfo'
smoutput colinfo__a

sqtbchk 'dob' setmeta__a 'Y2'

smoutput 'use bigint' 
ddconfig 'bigint';1

smoutput 'write' 
sqtbchk write__a (,.abc);(>NMS);(,.1000*>:i.6);(,.1000*?.6$0);(,.20130301+i.6)

smoutput 'read' 
smoutput sqtbchk read__a ''

smoutput 'delete all rows'
sqtbchk delete__a ''

smoutput 'writer' 
sqtbchk writer__a afi (,.abc);(>NMS);(,.1000*>:i.6);(,.1000*?.6$0);(,.20130301+i.6)

smoutput 'readr' 
smoutput sqtbchk readr__a ''

smoutput 'don''t use bigint' 
ddconfig 'bigint';0

smoutput 'delete all rows'
sqtbchk delete__a ''

smoutput 'write' 
sqtbchk write__a (,.abc);(>NMS);(,.1000*>:i.6);(,.1000*?.6$0);(,.20130301+i.6)

smoutput 'read' 
smoutput sqtbchk read__a ''

smoutput 'delete all rows'
sqtbchk delete__a ''

smoutput 'writer' 
sqtbchk writer__a afi (,.abc);(>NMS);(,.1000*>:i.6);(,.1000*?.6$0);(,.20130301+i.6)

smoutput 'readr' 
smoutput sqtbchk readr__a ''

smoutput 'don''t use bigint' 
smoutput 'bon setmeta ''N''' 

sqtbchk 'bon' setmeta__a 'N'

smoutput 'delete all rows'
sqtbchk delete__a ''

smoutput 'write' 
sqtbchk write__a (abcs);(>NMS);(,.1000*>:i.6);(,.1000*?.6$0);(,.20130301+i.6)

smoutput 'read' 
smoutput sqtbchk read__a ''

smoutput 'delete all rows'
sqtbchk delete__a ''

smoutput 'writer' 
sqtbchk writer__a afi (abcs);(>NMS);(,.1000*>:i.6);(,.1000*?.6$0);(,.20130301+i.6)

smoutput 'readr' 
smoutput sqtbchk readr__a ''

destroy__a''
smoutput 'that''s all'
reset_jsqltable_''
dddis ::0: ch
)

run ''

