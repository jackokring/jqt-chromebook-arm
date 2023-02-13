
dfoo=: 3 : 0
5 dfoo y
:
NB. dyad testing verb foo
a=. < x + y
b=. 10 + >a
'dfoo done: ',":b
)

mfoo=: 3 : 0
NB. monad testing verb foo
a=. y
b=. 10
c=. a * b
'mfoo done: ',":b
)

run=: 3 : 0
NB. this is verb run
x=. 5
y=. 7
5 dfoo 7
mfoo 7
'run'
)

NB. showevents 1
dbss''
dbstop 'run'
dbg 1
run 10
dbg 0