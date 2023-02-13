smoutput(jpathsep>(4!:4<'zx'){4!:3'');~zx=.'uu test1 -- rarer uu calls'
cocurrent 'base'
Q=: 3 : 'q1234__=: y'
A=: 3 : 'assert. y-:q1234__ [qqq__=: y;q1234__'

Q 'm m' uu '1 cm cm'
A '1.0E-4 m m'
Q 'm m' uu '1 cm^2'
A '1.0E-4 m m'
Q '/(m m)' uu '1 /(cm cm)'
A '10000 /(m m)'
Q '/(m m)' uu '1 /cm^2'
A '10000 /(m m)'
Q 'deg' uu '1 rad'
A '57.2958°'
Q 'dms' uu '1 rad'
A '57° 17′ 44″'
Q 'hms' uu '3700 s'
A '01:01:40 hms'
Q 'hms' uu '1.1 h'
A '01:06:00 hms'
Q '*' uu '1.1 h'
A '3960 *'
Q 'note' uu '440 Hz'
A 'A note'
Q '*' uu '440 Hz'
A '440 *'
Q '!' uu 2
A zz=.'YES'
Q '!' uu 1
A zz
Q '!' uu '1 /'
A zz
Q '!' uu '1 *'
A zz
Q '!' uu 0
A zz=.'NO'
Q '!' uu '0 /'
A zz
Q '!' uu '0 *'
A zz
