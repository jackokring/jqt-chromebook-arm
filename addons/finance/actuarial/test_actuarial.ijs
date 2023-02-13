NB. test actuarial
NB.
NB. run actuarial tests

load 'finance/actuarial'
load 'finance/actuarial/actfnsm'

rnd=: 4 : 'a%~<.0.5+y*a=.10^x'
QB=: actable 'BGA83M'
QF=: actable 'GAM83F'
QM=: actable 'GAM83M'
QX=: actable '80CSOM'

NB. =========================================================
testagerate=: 3 : 0
tab1=. 0.1* i.6
A1=. 0.2 0.3 0.4 0.5
A2=. 0 0 0 0.1 0.2 0.3 0.4 0.5
A3=. 0.2 0.3 0.5
A4=. 0 0 0 0 0.1 0.2 0.3 0.4 0.5

B1=. 3 2$0.4 0.5 0.6 0.7 0.8 0.9
B2=. 7 2$0 0 0 0 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9
B3=. 2 2$0.4 0.5 0.6 0.9
B4=. 5 2$0 0.1 0 0.1 0 0.1 0 0.1 0.2 0.3
tab2=. 0.1*i.5 2

assert. A1 -: 2 agerated tab1
assert. A2 -: _2 agerated tab1
assert. A3 -: 2 2 3 agerated tab1
assert. A4 -: _2 _3 agerated tab1
assert. B1 -: 2 agerated tab2
assert. B2 -: _2 agerated tab2
assert. B3 -: 2 2 3 agerated tab2
assert. B4 -: _2 _3 agerated tab2
)

NB. =========================================================
testcomm=: 3 : 0
a=. ,:100000000 15155588 3 0
a=. a,1874669765 255200576 3 0
a=. a,0 12354 2 0
a=. a,2268401 1851292 2 0
a=. a,100000000 98720845 915 0

b=. ,:100000000 17477029 4 0
b=. b,1945084437 305425847 2 0
b=. b,0 14315 4 0
b=. b,3035971 2579230 4 0
b=. b,100000000 98720845 915 0

ndx=. 0 35 110 111
assert. a -: 0 rnd ndx&{&>commfns 0.055;QM
assert. b -: 0 rnd ndx&{&>1 commfns 0.055 5 0.05;QM

)

NB. =========================================================
NB. single life
testx=: 3 : 0
ages=. 35 36
qx=. QB
lx=. lfq qx
int=. 0.065 5 0.05
int9=. 100 stretch intrep 0.085 15 0.06
int60=. 40}.int9
vx9=. int9 vt 40
j9=. annx 60;0 0 0 5 12;int60;0;qx

assert. 15.79919 15.66722-:5 rnd annx ages;(1 0 0 0 1);int;0;qx
assert. 7.27166 7.267794-:6 rnd annx ages;(1 0 0 10 1);int;0;qx
assert. 16.25753 16.12555-:5 rnd annxm ages;(1 0 0 0 12);int;0;qx
assert. 10.96547 10.83474-:5 rnd annxm ages;(1 6 0 0 1);int;0;qx
assert. 11.2819 11.15099-:5 rnd annxm ages;(1 6 0 0 12);int;0;qx
assert. 15.81627 15.68554-:5 rnd annxm ages;(1 0 6 0 1);int;0;qx
assert. 11.06167 10.94125-:5 rnd annxm ages;(1 6 10 0 1);int;0;qx
assert. 11.37262 11.25147-:5 rnd annxm ages;(1 6 10 0 12);int;0;qx

assert. 16.79919 16.66722-:5 rnd annx ages;(0 0 0 0 1);int;0;qx
assert. 7.707786 7.704751-:6 rnd annx ages;(0 0 0 10 1);int;0;qx
assert. 16.34086 16.20889-:5 rnd annxm ages;(0 0 0 0 12);int;0;qx
assert. 11.65587 11.52475-:5 rnd annxm ages;(0 6 0 0 1);int;0;qx
assert. 11.33943 11.20849-:5 rnd annxm ages;(0 6 0 0 12);int;0;qx
assert. 16.81155 16.68043-:5 rnd annxm ages;(0 0 6 0 1);int;0;qx
assert. 11.74247 11.62046-:5 rnd annxm ages;(0 6 10 0 1);int;0;qx
assert. 11.42935 11.30807-:5 rnd annxm ages;(0 6 10 0 12);int;0;qx

assert. (5 rnd 12000*j9*vx9)-:5 rnd 12000*0 0 annx 20;0 40 0 5 12;int9;0;qx
assert. (5 rnd 12000*j9*vx9*%/60 20{lx)-:5 rnd 12000*0 1 annx 20;0 40 0 5 12;int9;0;qx
)

NB. =========================================================
NB. joint life
testxy=: 3 : 0
age=. 65
ages=. 65 62
int=. 0.065 5 0.05
QFM=. QM;QF
QJ=. <joint(_3 agerated QF);QM
assert. (5 rnd annxy ages;j,QFM)-:5 rnd annx age;j,QJ [j=. (1 0 0 0 1);int;0
assert. (5 rnd annxy ages;j,QFM)-:5 rnd annx age;j,QJ [j=. (1 0 0 10 1);int;0
assert. (5 rnd annxy ages;j,QFM)-:5 rnd annx age;j,QJ [j=. (1 0 0 0 12);int;0
assert. (5 rnd annxy ages;j,QFM)-:5 rnd annx age;j,QJ [j=. (1 6 0 0 1);int;0
assert. (5 rnd annxy ages;j,QFM)-:5 rnd annx age;j,QJ [j=. (1 6 0 0 12);int;0
assert. (5 rnd annxy ages;j,QFM)-:5 rnd annx age;j,QJ [j=. (1 0 6 0 1);int;0
assert. (5 rnd annxy ages;j,QFM)-:5 rnd annx age;j,QJ [j=. (1 6 10 0 1);int;0
assert. (5 rnd annxy ages;j,QFM)-:5 rnd annx age;j,QJ [j=. (0 0 0 0 1);int;0
assert. (5 rnd annxy ages;j,QFM)-:5 rnd annx age;j,QJ [j=. (0 0 0 10 1);int;0
assert. (5 rnd annxy ages;j,QFM)-:5 rnd annx age;j,QJ [j=. (0 0 0 0 12);int;0
assert. (5 rnd annxy ages;j,QFM)-:5 rnd annx age;j,QJ [j=. (0 6 0 0 1);int;0
assert. (5 rnd annxy ages;j,QFM)-:5 rnd annx age;j,QJ [j=. (0 6 0 0 12);int;0
assert. (5 rnd annxy ages;j,QFM)-:5 rnd annx age;j,QJ [j=. (0 0 6 0 1);int;0
assert. (5 rnd annxy ages;j,QFM)-:5 rnd annx age;j,QJ [j=. (0 6 10 0 1);int;0
)

NB. =========================================================
NB. joint & last survivor
testjls=: 3 : 0
qf=. QF
qm=. QM
lf=. lfq qf
lm=. lfq qm
tm=. %/65 20{lm
tf=. %/62 17{lf
vx=. 1.09^-45
match6=. -: & (6&rnd)

NB. no deferral
RES1=. 9.323077778
RES11=. 9 rnd annjls(65 62);(1 1 0.6 0 0 0 0 12);0.09;0;qm; qf
a0=. annxy(65 62);(0 0 0 0 12);0.09;0;qm;qf
a1=. annx 65;(0 0 0 0 12);0.09;0; qm
a2=. annx 62;(0 0 0 0 12);0.09;0; qf
RES12=. 9 rnd a1+0.6*a2-a0

RES2=. 9.239744444
RES21=. 9 rnd annjls(65 62);(1 1 0.6 1 0 0 0 12);0.09;0;qm;qf
a0=. annxy (65 62);(1 0 0 0 12);0.09;0;qm;qf
a1=. annx 65;(1 0 0 0 12);0.09;0; qm
a2=. annx 62;(1 0 0 0 12);0.09;0; qf
RES22=. 9 rnd a1+0.6*a2-a0

NB. deferal: interest only
RES3=. 0.192915401
RES31=. 9 rnd vx*annjls(65 62);(1 1 0.6 0 0 0 0 12);0.09;0;qm;qf
RES32=. 9 rnd 0 0 annjls(20 17);(1 1 0.6 0 45 0 0 12);0.09;0;qm;qf

RES4=. 0.1911910473
RES41=. 10 rnd vx*annjls(65 62);(1 1 0.6 1 0 0 0 12);0.09;0;qm;qf
RES42=. 10 rnd 0 0 annjls(20 17);(1 1 0.6 1 45 0 0 12);0.09;0;qm;qf

NB. deferal: interest and mortality
RES5=. 0.1805310209
a0=. vx*tf*tm*annjls(65 62);(1 1 0.6 0 0 0 0 12);0.09;0;qm;qf
a1=. vx*(1-tf)*tm*annx 65;(0 0 0 0 12);0.09;0;qm
a2=. vx*tf*(1-tm)*0.6*annx 62;(0 0 0 0 12);0.09;0;qf
RES51=. 10 rnd a0+a1+a2
RES52=. 10 rnd 0 1 annjls(20 17);(1 1 0.6 0 45 0 0 12);0.09;0;qm;qf

RES6=. 0.178911281
a0=. vx*tf*tm*annjls(65 62);(1 1 0.6 1 0 0 0 12);0.09;0;qm;qf
a1=. vx*(1-tf)*tm*annx 65;(1 0 0 0 12);0.09;0; qm
a2=. vx*tf*(1-tm)*0.6*annx 62;(1 0 0 0 12);0.09; 0 ;qf
RES61=. 9 rnd a0+a1+a2
RES62=. 9 rnd 0 1 annjls(20 17);(1 1 0.6 1 45 0 0 12);0.09;0;qm;qf

NB. deferal: interest and primary mortality
RES7=. 0.1657347295
RES71=. 10 rnd vx*tm*annjls(65 62);(1 1 0.6 0 0 0 0 12);0.09;0;qm;qf
RES72=. 10 rnd 0 2 annjls(20 17);(1 1 0.6 0 45 0 0 12);0.09;0;qm;qf

RES8=. 0.1642533274
RES81=. 10 rnd vx*tm*annjls(65 62);(1 1 0.6 1 0 0 0 12);0.09;0;qm;qf
RES82=. 10 rnd 0 2 annjls(20 17);(1 1 0.6 1 45 0 0 12);0.09;0;qm;qf

assert. RES1 match6 RES11
assert. RES1 match6 RES12
assert. RES2 match6 RES21
assert. RES2 match6 RES21
assert. RES3 match6 RES31
assert. RES3 match6 RES32
assert. RES4 match6 RES41
assert. RES4 match6 RES42
assert. RES5 match6 RES51
assert. RES5 match6 RES52
assert. RES6 match6 RES61
assert. RES6 match6 RES62
assert. RES7 match6 RES71
assert. RES7 match6 RES72
assert. RES8 match6 RES81
assert. RES8 match6 RES82

)

NB. =========================================================
testjoint=: 3 : 0
QX=. 0.1 0.2 0.3 0.6
QY=. 0.05 0.15 0.25 0.35 0.45 0.75 1
QXX=. 4 3$0.1 0.2 0.3,0.15 0.25 0.35,0.25 0.4 0.6,0.33 0.66 1
QYY=. 6 2$0.05 0.15,0.07 0.17,0.09 0.19,0.27 0.37,0.46 0.56,0.75 0.95
AA=. 0.145 0.32 0.475 0.74
BB=. 4 3$0.19 0.36 0.51 0.32 0.475 0.74 0.475 0.76 1 0.732 1 1
CC=. 6 2$0.0975 0.2775 0.2095 0.3775 0.3175 0.4735 0.5255 0.6535 0.703 0.89 0.9375 1
DD=. 4 3$0.145 0.32 0.419 0.2095 0.3775 0.4735 0.3175 0.514 0.748 0.5109 0.7858 1

assert. AA-:joint QX;QY
assert. BB-:joint QX;QXX
assert. CC-:joint QY;QYY
assert. DD-:joint QXX;QYY
assert. AA-:joint QY;QX
assert. BB-:joint QXX;QX
assert. CC-:joint QYY;QY
assert. DD-:joint QYY;QXX
)


NB. =========================================================
NB. test assx
testsx=: 3 : 0
INT=. 0.055
AGES=. 35 36
NB. F=. ":!.10
assert. 0.15781342 0.16471915 -: 8 rnd assx AGES;0 1 0 1;INT;QX
assert. 0.01946088 0.02101536 -: 8 rnd assx AGES;0 1 10 1;INT;QX
assert. 0.56965239 0.56838066 -: 8 rnd assx AGES;2 1 10 1;INT;QX
assert. 0.58911327 0.58939602 -: 8 rnd assx AGES;1 1 10 1;INT;QX
assert. 0.0097689 0.01028068 -: 8 rnd assx AGES;0 0 0 1;INT;QX
assert. 0.02002313 0.02091371 -: 8 rnd assx AGES;0 10 0 1;INT;QX
assert. 0.00377436 0.00408931 -: 8 rnd assx AGES;0 20 20 1;INT;QX
assert. 0.00589483 0.00637883 -: 8 rnd assx AGES;0 10 20 1;INT;QX
assert. 0.01946088 -: {.8 rnd assx 35;0 1 _45 1;INT;QX
assert. 0.56965239 -: {.8 rnd assx 35;2 1 _45 1;INT;QX
assert. 0.58911327 -: {.8 rnd assx 35;1 1 _45 1;INT;QX
assert. 0.00377436 -: {.8 rnd assx 35;0 20 _55 1;INT;QX
assert. 0.00377436 -: {.8 rnd assx 35;0 _55 _55 1;INT;QX
assert. 0.00589483 -: {.8 rnd assx 35;0 _45 _55 1;INT;QX
assert. 0.010058 0.010587 -: 6 rnd assx AGES;0 0 0 12;INT;QX
assert. 0.00604772 0.0065449 -: 8 rnd assx AGES;0 10 20 12;INT;QX
)

NB. =========================================================
test=: 3 : 0
testagerate''
testcomm''
testx''
testxy''
testjls''
testjoint''
testsx''
smoutput 'test actuarial done'
)

test''
