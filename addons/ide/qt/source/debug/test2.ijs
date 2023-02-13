NB. debug example
NB.
NB. run this script to step through verb foo

foo=: 3 : 0
NB. this is verb foo
a=. 2 * y
b=. 3 + a + y
)

showevents 1
dbstop ''              NB. remove any stop settings
dbg 1                  NB. enable debug window
dbstop 'foo'           NB. stop all lines in foo
foo 7                  NB. run foo
