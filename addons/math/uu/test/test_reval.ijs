smoutput(jpathsep>(4!:4<'zx'){4!:3'');~zx=.'test reval'
cocurrent 'base' [clear''
Q=: 3 : 'q1234__=: y'
A=: 3 : 'assert. y-:q1234__ [qqq__=: y;q1234__'
reval=: reval_uu_
NB. trace_uu_ 1  NB. <<<<<<<<<<<<<<<<<<<<<<<<<<

NB. ┌─────────────────────────────────────────────┐
NB. │test reval - rational evaluation of a numeral│
NB. └─────────────────────────────────────────────┘

Q reval '6832167611683374095687762x'
A 6832167611683374095687762x
Q reval '6832167611r683374095687762'
A 6832167611r683374095687762
Q reval '1234567890'
A 1234567890x
Q reval '1234567890123456789'
A 1234567890123456789x
Q reval '12345678901234567890123456789'
A 12345678901234567890123456789x

Q reval '2/3'
A 2r3
Q reval '-2/3'
A _2r3
Q reval 'PI'
A PI
Q reval 'PI/2'
A PI%2
Q reval '-PI/2'
A PI%_2

Q reval '10^21'
A 1000000000000000000000x
Q reval '10^-21'
A 1r1000000000000000000000
Q reval '10^3'
A 1000x

Q reval '10^-5'
A 1r100000
Q reval '-10^-5'
A _1r100000
Q reval '_10^_5'
A _1r100000
Q -reval '10^-5'
A _1r100000
Q reval '10^_5'
A 1r100000

Q reval '10^1.0001'
A z=. 10997648288341r1099511627776
Q ":float z
A '10.0023'
Q reval '10^-5.0001'
A z=. 6832167611r683374095687762
Q ":float z
A '9.9977e_6'
Q reval '10^_5.0001'
A z

Q reval '_1.23e_5'
A z=. _123r10000000
Q reval '_1.23E_5'
A z
Q reval '_1.23E-5'
A z
Q reval '-1.23E-5'
A z
