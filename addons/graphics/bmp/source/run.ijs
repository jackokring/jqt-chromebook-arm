NB. run.ijs

require 'rgb viewmat'
closeall_jviewmat_''

dbstops''
dbg 1

F=: jpath '~temp/t1.bmp'
G=: jpath '~temp/t2.bmp'

A=: 0 0 255
A=: 255 255 0
NB. A=: |."1 [ 256 256 256 #: 255 + i.1000

test=: 3 : 0
A=: readbmp jpath '~system/examples/data/stdtbar.bmp'
A writebmp jpath '~temp/t1.bmp'
assert. A -: readbmp jpath '~temp/t1.bmp'
assert. 3 = $readbmphdr jpath '~temp/t1.bmp'
)

f0=: 3 : 0
dat=: 200 300 $ 256 #. A
dat writebmp F
viewbmp F
viewrgb dat
smoutput dat -: readbmp F
)

f1=: 3 : 0
dat=: 200 300 3 $ ,A
dat writebmp G
viewbmp G
viewrgb 256 #. dat
smoutput (256 #. dat) -: readbmp G
)

NB. f0''
NB. f1''
