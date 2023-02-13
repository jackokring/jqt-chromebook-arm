NB. noun

NB. =========================================================
NB. public noun

allobj=: 0$<''      NB. jsqltable objects (box array)
ch=: _1             NB. connection handle
colinfo=: 0 8$<''   NB. table of column info: name columnid typename coltype length decimals nullable jtype
cols=: 0$<''        NB. columns (box array)
dsn=: ''            NB. data source name (empty if connection handle is given when creating object)
delim=: '[]'        NB. delimiters of enclosing names. default to '[]' for sql server
index=: 0 6$<''     NB. table of index: name index_name name column_name key_ordinal is_descending_key is_included_column
longcols=: 0$<''    NB. long datatype columns (box array)
pk=: ''             NB. primary index (string)
source=: ''         NB. base table (string)
toprow=: ''         NB. top rows (auto reset after used)

NB. =========================================================
NB. private

COLTYPE=: ;:'C N Y1 Y2'        NB. implemented jtype
DELBUG=: 1                     NB. some odbc driver (odbc ver. 2?) return error for delete zero rows
LONGCOLUMNSIZE=: 8000          NB. 8000 for sql server, other mdbs may vary

NB. fields in colfino
'ix_name ix_columnid ix_typename ix_coltype ix_length ix_decimals ix_nullable ix_jtype'=: i.8
