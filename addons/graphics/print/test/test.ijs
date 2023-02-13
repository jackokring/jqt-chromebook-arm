NB. test0

load 'print'

require 'general/misc/format'
F=: jpath '~temp/t1.txt'

a=: fread jpath '~Addons/graphics/print/test/jeltz.txt'
a=: a,LF
a=: a,flatten i.3 4 5
a=: toHOST a
a fwrites F
A=: fread jpath '~Addons/graphics/print/test/alice.txt'

'ascii;font "courier new" 14;port' print_jprint_ ;/i.3 4 5
print_jprint_ a
'ruler' print2_jprint_ A NB. ,LF,LF,A,LF,LF,A
'font arial 12;land;footer just testing' print_jprint_ i.3 4 5
'fontsize 7.5;land;ruler' printfile_jprint_ jpath '~Addons/graphics/print/test/orders.txt'
printfile2_jprint_ jpath '~addons/general/misc/pack.ijs'
~
