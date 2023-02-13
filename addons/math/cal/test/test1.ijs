smoutput<>|.(jpathsep>(4!:4<'zx'){4!:3'');zx=.'cal test1 - instruction set'
0 :0
Friday 23 August 2019  13:52:08
)
cocurrent 'cal'
Q=: 3 : 'q1234__=: y'
A=: 3 : 'assert. y-:q1234__ [q5678__=: y'
test=: 3 : 0
smoutput '>>> test',(brack $q1234__),': Q…'
smoutput q1234__
smoutput '>>> test',(brack $q5678__),': A…'
smoutput q5678__
)

NB. DISABLE…
NB. Q=: ]
NB. A=: ]

start_cal_ 1  NB. start CAL with SAMPLE1: Church Clock

zcc=. }: 0 : 0  NB. omit final LF
Church Clock
  ┌ {1}        75 ft    height of tower
  ├ {2}       800 kg    mass of weight
  ├ {3}     9.813 m/s²  acceleration; gravity=
┌ └>{4} @ 1.795E5 J     energy stored in hanging weight
│ ┌ {5}       3.1 A h   battery charge=
│ ├ {6}        17 V     battery potential=
├ └>{7}   1.897E5 J     energy stored in battery
└>  {8} @   0.946 /     {4}/{7}
)

znn=: }: 0 : 0  NB. omit final LF
CAPT: Church Clock
CAPU: Church_Clock
TITF: tf
TITL: Church Clock
TFIL: /users/ianclark/tabula-user/SAMPLE1.tbx
TFIT: ~/tabula-user/SAMPLE1.tbx
TNAM: SAMPLE1
TNMX: SAMPLE1.tbx
)

smoutput '+++ REACHES HERE'

NB. ---------------------------------------------------------

Q tt'QSAV'
A CAL_SAVED
Q tt'AABT'
A AABUILT
Q tt'ABOU'
A ABOUT
Q tt'ANCS 8'
A 1 2 3 5 6
Q $each tt'ARRO'
A 9 4 ; 7 3
Q tt'CAPT'
A 'Church Clock'
Q tt'CAPU'
A 'Church_Clock'
Q tt'CTAB'
A x4f ucp zcc
Q $each tt'CTBB'
A 9 1;9 1;(9 1x);9 12;9 5;9 12;9 31
Q tt'CTBN 3'
A tt'CTBB'
Q tt'CTBN _'  NB. default: y
A tt'CTAB'
Q tt'CTBU'
A zcc
Q tt'FMLA 4'
A 'a*b*c: a(ft),b(kg),c(grav)'
Q tt'FMLL 4'
A '{1}*{2}*{3}'
Q tt'INFO'
A ''
Q tt'INTD'
A 1
Q tt'ITMS'
A 1 2 3 4 5 6 7 8
Q tt'JXDO $VERSION'
A ,6
Q tt'NAME 4'
A 'energy stored in hanging weight'
Q tt'PARS 8'
A 4 7
Q tt'QCAL'
A CAL
Q tt'QSCI'
A 5
Q tt'QSIC'
A 1
Q tt'QSIG'
A 3
Q tt'QSIZ'
A __
Q tt'RETU'
A __
Q tt'TITF'
A 'tf'
Q tt'TITL'
A 'Church Clock'
Q tt'TITU'
A 'untitled'
Q tt'TFIL'
A file
Q tt'TFIT'
A shortpath file
Q tt'TFLU'
A 'untitled'
Q tt'TNAM'
A 'SAMPLE1'
Q tt'TNMS'
A znn
Q tt'TNMX'
A 'SAMPLE1.tbx'
Q tt'TPCA'
A TPCA_z_
Q tt'TPTT'
A TPTT_z_
Q tt'UCMU 6'
A ,<,'V'
Q tt'UCOM 6'
A ,<,'V'
Q tt'UNIF Ang'
A 'Å'
Q tt'UNIS 3'
A <'m/s^2'
Q tt'UNSU 3'
A 'm/s²'
Q tt'UNIT 3'
A <'m/s^2'
Q tt'UNTU 3'
A 'm/s²'
Q tt'UNIS 5'
A <'A s'
Q tt'UNSU 5'
A 'A s'
Q tt'UNIT 5'
A <'A h'
Q tt'UNTU 5'
A 'A h'
Q tt'VALF 3'
A '9.813'
Q ":float tt'VALU 3'
A '9.81287'
Q tt'VERS'
A VERSION
Q tt'XSIN'
A isExtendedSine''

NB. +++ MODIFY t-table to test: DIRT Undo Redo
smoutput '+++ COMPLETED: testing of all-caps (but not uuengine)'
