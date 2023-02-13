
SHL=: 34 b.

FDCT=: (1&FDCT1"1)&.|:@:(0&FDCT1"1)

FDCT1=: 4 : 0
c1=. 1004   NB. cos(pi/16)<<10
s1=. 200    NB. sin(pi/16)<<10
c3=. 851    NB. cos(3pi/16)<<10
s3=. 569    NB. sin(3pi/16)<<10
r2c6=. 554  NB. sqrt(2)*cos(6pi/16)<<10
r2s6=. 1337
r2=. 181    NB. sqrt(2)<<7
'x0 x1 x2 x3 x4 x5 x6 x7'=. y
NB. Stage 1
x8=. x7+x0
x0=. x0-x7
x7=. x1+x6
x1=. x1-x6
x6=. x2+x5
x2=. x2-x5
x5=. x3+x4
x3=. x3-x4
NB. Stage 2
x4=. x8+x5
x8=. x8-x5
x5=. x7+x6
x7=. x7-x6
x6=. c1*(x1+x2)
x2=. x6+((-s1)-c1)*x2
x1=. x6+(s1-c1)*x1
x6=. c3*(x0+x3)
x3=. x6+((-s3)-c3)*x3
x0=. x6+(s3-c3)*x0
NB. Stage 3
x6=. x4+x5
x4=. x4-x5
x5=. r2c6*(x7+x8)
x7=. x5+((-r2s6)-r2c6)*x7
x8=. x5+(r2s6-r2c6)*x8
x5=. x0+x2
x0=. x0-x2
x2=. x3+x1
x3=. x3-x1
NB. Stage 4 round and output
(- 0 10 10 17 0 17 10 10 + 3*x) SHL"0 x6,(x2+x5+512),(x8+512),(65536+x3*r2),x4,(65536+x0*r2),(x7+512),((x2-x5)+512)
)

IDCT=: (1&IDCT1"1)&.|:@:(0&IDCT1"1)

IDCT1=: 4 : 0
c1=. 251   NB. cos(pi/16)<<8
s1=. 50    NB. sin(pi/16)<<8
c3=. 213   NB. cos(3pi/16)<<8
s3=. 142   NB. sin(3pi/16)<<8
r2c6=. 277 NB. cos(6pi/16)*sqrt(2)<<9
r2s6=. 669
r2=. 181   NB. sqrt(2)<<7
NB. Stage 4
x0=. (0{y) SHL~ 9
x1=. (1{y) SHL~ 7
x2=. (2{y)
x3=. (3{y) *r2
x4=. (4{y) SHL~ 9
x5=. (5{y)*r2
x6=. (6{y)
x7=. (7{y) SHL~ 7
x8=. x7+x1
x1=. x1-x7
NB. Stage 3
x7=. x0+x4
x0=. x0-x4
x4=. x1+x5
x1=. x1-x5
x5=. x3+x8
x8=. x8-x3
x3=. r2c6*(x2+x6)
x6=. x3+((-r2c6)-r2s6)*x6
x2=. x3+((-r2c6)+r2s6)*x2
NB. Stage 2
x3=. x7+x2
x7=. x7-x2
x2=. x0+x6
x0=. x0-x6
x6=. c3*(x4+x5)
x5=. (x6+((-c3)-s3)*x5) SHL~ _6
x4=. (x6+((-c3)+s3)*x4) SHL~ _6
x6=. c1*(x1+x8)
x1=. (x6+((-c1)-s1)*x1) SHL~ _6
x8=. (x6+((-c1)+s1)*x8) SHL~ _6
NB. Stage 1 rounding and output
x7=. x7+512
x2=. x2+512
x0=. x0+512
x3=. x3+512
(- 10 + x) SHL (x3+x4),(x2+x8),(x0+x1),(x7+x5),(x7-x5),(x0-x1),(x2-x8),(x3-x4)
)
