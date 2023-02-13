NB. jdb_lexwin

NB. =========================================================
jdb_lexwin=: 3 : 0

NB. exit if no-name definition (not initialized)
if. 0 e. #NAME do. '' return. end.
jdb_stopread''
STACK=: jdb_getstack''
jdb_lexwin1 ''
)

NB. =========================================================
jdb_lexwin1=: 3 : 0
j=. (MOVELINE ; ERRMSG) jdb_stackrep STACK

if. 0 = L. j do. return. end.

'lines stack values'=. j

mrg=. '>' CURRENTLINE} NUMLINES # ' '

if. MOVELINE ~: CURRENTLINE do.
  mrg=. ('-+' {~ MOVELINE > CURRENTLINE) MOVELINE} mrg
end.

stp=. jdb_stopget''
lines=. (<"1 stp,.mrg) ,&.> lines
lines=. jdb_dtb &.> lines

jdebug_run 1

SCROLL=: 0 >. (NUMLINES - 6) <. MOVELINE - 2

1 jdb_writelines lines
jdb_wd 'set stack text *',jdb_listboxed stack
jdb_wd 'set value text *',jdb_listboxed values
jdb_wd 'pactive'
)
