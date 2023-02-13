NB. init

require 'odbc'

coclass 'jsqltable'

NB. =========================================================
NB. public nouns and verbs
NB.
NB. data
NB. static:
NB.
NB. allobj       jsqltable objects
NB. delim        database specific optional delimiters for enclosing names
NB.
NB. object:
NB.
NB. ch           connection handle
NB. colinfo      detail column information
NB. cols         columns of the table
NB. dsn          data source name (empty if connection handle is given when creating object)
NB. index        indices of the table
NB. longcols     long datatype columns of the table
NB. pk           primary of the table
NB. source       base table
NB. toprow       top rows (auto reset after used)
NB.
NB. verb
NB. static:
NB.
NB. indexof     index of one table in another
NB. reset       destroy all object and clean up
NB.
NB. object:
NB.
NB. delete      delete rows
NB. read        read rows
NB. replace     delete all rows and then write data
NB. setmeta     set jtype for columns, mainly used in datetime
NB. update      delete rows with a condition, then write data
NB. write       append data
NB.
NB. alternate verbs for ddfet format data because ddfch/ddins cannot handle long data
NB.
NB. deleter     same as delete
NB. readr       read rows
NB. replacer    delete all rows and then write data
NB. updater     delete rows with a condition, then write data
NB. writer      append data
