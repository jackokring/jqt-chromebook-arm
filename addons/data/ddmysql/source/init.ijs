
coclass 'jddmysql'

InitDone=: 0
UseErrRet=: 0
UseDayNo=: 0
UseUnicode=: 0

create=: 3 : 0
if. 0=InitDone do.
  Init_jddmysql_=: 1
end.
initodbcenv 0
''
)

destroy=: 3 : 0
endodbcenv 0
codestroy''
)

NB. =========================================================
NB. replace z locale names defined by jdd/ODBC locale.

setzlocale=: 3 : 0
wrds=. 'ddsrc ddtbl ddtblx ddcol ddcon dddis ddfch ddend ddsel ddcnm dderr'
wrds=. wrds, ' dddrv ddsql ddcnt ddtrn ddcom ddrbk ddbind ddfetch'
wrds=. wrds ,' dddata ddfet ddbtype ddcheck ddrow ddins ddparm ddsparm dddbms ddcolinfo ddttrn'
wrds=. wrds ,' dddriver ddconfig ddcoltype'
wrds=. wrds ,' userfn sqlbad sqlok sqlres sqlresok'
wrds=. wrds , ' ', ;:^:_1 ('get'&,)&.> ;: ' DateTimeNull NumericNull UseErrRet UseDayNo UseUnicode CHALL'
wrds=. > ;: wrds

cl=. '_jddmysql_'
". (wrds ,"1 '_z_ =: ',"1 wrds ,"1 cl) -."1 ' '

if. 0=InitDone_jddmysql_ do.
  InitDone_jddmysql_=: 1
end.
endodbcenv_jddmysql_ 0
initodbcenv_jddmysql_ 0

EMPTY
)
