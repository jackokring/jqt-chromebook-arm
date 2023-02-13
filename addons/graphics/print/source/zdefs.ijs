NB. zdefs

NB. =========================================================
doprint=: 1 : 0
cocurrent conew 'jprint'
('';m) printit y
:
cocurrent conew 'jprint'
(x;m) printit y
)

NB. =========================================================
print=: 'print' doprint
print2=: 'print2' doprint
printfile=: 'printfile' doprint
printfile2=: 'printfile2' doprint

NB. =========================================================
NB. print_z_=: print_jprint_
NB. printfile_z_=: printfile_jprint_
NB. print2_z_=: print2_jprint_
NB. printfile2_z_=: printfile2_jprint_
NB. printn_z_=: printn_jprint_
