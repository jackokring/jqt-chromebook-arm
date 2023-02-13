objective
=========

This document briefly describes how to use the jsqltable package.

dependency
==========

For J602, the following packages are also required,
strigs dates dll odbc

For J802, only the odbc addons (dd) is required.

Some of its features (retrieving indices and primary key)
only work for MS sql server.

odbc driver and dsn
===================

For sql server, both sql server 2000 odbc driver and
Native client drivers are supported but Native client drivers
are recommended.

Create an odbc dsn and set the default database, need separate
entry for 32 and 64 bit J.

files
=====

Only the file jsqlable.ijs is needed. Include it to the project manager.

sqltable object
===============

conew with an argument for table name and dsn or connection handle,

a new connection handle will be created if a dsn is provided,
   a=: ('kaikki';'dsn=testdata') conew 'jsqltable'

Credential if needed should be embedded into dsn, eg.
   'dsn=testdata;uid=sa;pwd=secret'

Alternatively, an existing connection handle can be used.
   a=: ('kaikki';ch) conew 'jsqltable'

If the name of table is unicode, it should be converted by u2a, eg
   u2a 'Käyttöpaikka'

These values are held in object's locale:

ch           connection handle
dsn          data source name (empty if connection handle is given when creating object)
source       base table (string)

Various information of the table will also be retrieved automatically.

colinfo      detail column information:
                name columnid typename coltype length decimals nullable jtype
cols         columns of the table
index        indices of the table: (only works for MS Sql server)
                name index_name name column_name key_ordinal is_descending_key is_included_column
pk           primary of the table (only works for MS Sql server)

data format
===========

data read and to be written are either:

inverted file format
--------------------
a rank-1 box array with each item contains all data of each column.  All items hold
rank-2 array, ie.  *./ 2 = #@$&> data
This is the preferred format becuase it has a much better performance. The main drawback
is that it cannot handle long datatype such as image or varbinary(max).

verbs for this format: delete read write replace update

Note that these verbs will ignore long datatype columns, this is true even in "update"
because "update" in sqltable is actually "delete" followed by "write".  Be careful!

boxed table format
------------------
a rank-2 box table with each each contains each field of each row .  All items hold
rank-1 array, ie.  *./ 1 = ; #@$&.> data
This format can handle long datatype but its performance can be orders of magnitude worse
than that of the inverted file format.

verbs for this format: deleter readr writer replacer updater

Note that "deleter" is identical to "delete", it is defined just for convenience.

raw types to jtypes conversion
==============================

Datetime fields are encoding by numbers internally which is similar to that used in the
verb "todayno" in J base library.  The J type of each column can be overrided using a
verb "setmata" which can convert between native sql type and J type.

  colnames setmeta__a jtypes

where colnames is a list of column name, and jtypes is a list of jtype.

Note that setmeta (if wanted) should be run before reading/writing to be effective.

Error management
================

all public verbs (except create and destroy) return 0 for success or box data,
but return error messages when fail.
A utility verb sqtbchk (exported to z-locale) can be used to check
the result and will raise a domain error if the result is a string (error). eg.

  data=. sqtbchk read__a ''

Manipulate an object
====================

After an object is created, operations on the base table can be
performed using the object, including reading and writing.

setmeta
-------
set meta data
form: colnums setmeta jtypes
  x = list of column name
  y = list of column jtype

For example we could say that we want everything in text to J, or some fields numeric and some datefields numeric/text.
In J this means we have three datatypes: text C, numeric N and date Y:
coltype              sql             J
C                    ‘Bill’          ‘Bill’
C                    123             ‘123’
C                    ‘2013-01-01’    ‘2013-01-01’
N                    123             123
Y1                   ‘2013-01-01’    ‘2013-01-01’
Y2                   ‘2013-01-01’    20130101
(empty) no mapping

read / readr
------------
read with an optional where statement
form: [columns] read condition
if the left argument is elided, it is default to cols

Assuming the object is "a", all records in the table can
be retrieved using,
  data=. read__a ''

or with an argument for searching condition
  data=. read__ a 'city=''rome'' and year=2013'

or with a left argument for selecting columns
  data=. ('city';'salary') read__ a 'city=''rome'' and year=2013'

condition strings starting with "where" or "order" are also accepted.

delete / deleter
----------------
delete rows form table
form: delete condition

  delete__a 'city=''rome'''

if the condition string is empty, all rows will be deleted.
condition strings starting with "where" are also accepted.

write / writer
--------------
write (i.e. append) new data
form: columns write data
if the left argument is elided, it is default to cols.
data must agree with columns, eg, if the columns are
city and year, then data should also have 2 items,
one for each column. The same applies to verbs
replace and update.

  write__a data

replace / replacer
------------------
delete all rows and write new data
form: [columns] replace data
if the left argument is elided, it is default to cols

  replace__a data

update / update
---------------
update with where statement
form: (condition [;columns]) update data
if columns in the left argument is elided, it is default to cols

this is a delete with condition then an insert of data,
it is an error if the condition is empty.

 'city=''rome''' update__a data

condition strings starting with "where" are also accepted.

to update selected columns
 ('city=''rome''';'city';'salary') update__a data

pkupdate
--------
pkupdate with primary key
this requires the table has a primary key or equivalent

form: [boxed index list;][column;column] pkupdate data
if boxed index list is absent or is an empty array, it will use the pk of table
otherwise the combination of boxed index list must constitute a pk
data must contains pk or column combination that is unique for each row.
If the above criteria is not satisfied, pkupdate can still execute without
raising any error but the result will not be what is being expected.

If the first item of left argument is a level-2 box, then it is a index list.

Depending on there is a primary key and columns contained in data,

1. columns of data are cols and the table has a pk

     pkupdate__a data

2. columns of data are cols and the table has no pk, but a combination of columns
   can provide a pk candidate.

     (<<'id1') pkupdate__a data            NB. if id1 alone is a pk candidate
     (<'id1';'id2') pkupdate__a data       NB. if (id1,id2) is a pk candidate

3. columns of data are not cols but they contain all columns of the pk of the table

     ('id1';'foo';'id2';'bar') pkupdate__a data      NB. pk contained in columns
     ('';'id1';'foo';'id2';'bar') pkupdate__a data   NB. ditto.

4. columns of data are not cols and the table has no pk,  but a combination of
   columns can provide a pk candidate.

     (('id1';'id2');'id1';'foo';'id2';'bar') pkupdate__a data

pkupdate / pkupdater
--------------------

static verbs
============

The following verbs do not require an object.

indexof
-------
return indices of one table in anthter table.
forms:  data1 indexof_jsqltable_ data2

For 2 tables, if a table has with columns which are the same as columns in
anther table, the verb indexof return the indices. For example, suppose both
table1 and table2 have the same column "city", the following will return the
indices.

('city' read__a'') indexof_jsqltable_ ('city' read__b'')

reset
-----

destroy all jsqltable objects and close their connection handles created.
form: reset_jsqltable_''

External connection handles used for creating objects will not be closed.

While it is not an error to load the locale jsqltable again before a reset,
there is a probability that some dangling objects which cannot be be erased by
reset.

acknowledgement
===============

This package is the result of a consultation work done for Anssi Seppälä.
Significant changes were also made in data/odbc addon to support this package.
This work is released to the public by the request and permission of Anssi Seppälä.
