NB. =========================================================
NB. Utility verbs

NB. escaped v process an escaped string
NB. eg: '\' escaped '\Date is: D\\MM\\YYYY'
NB. result: 2-item list of boxed mask & string:
NB.          0{:: boolean mask of non-escaped characters
NB.          1{:: string with escape character compressed out
NB. y: An escaped string
NB. x: character used to escape string
escaped=: 3 : 0
  '\' escaped y                         NB. default escape char
:
  mskesc=. y = x
  mskfo=. 2 < /\ 0&, mskesc             NB. 1st occurences of x
  mskesc=. mskesc ([ ~: *.) 0,}: mskfo  NB. unescaped 1st occurences of x
  mskunescaped=. -. 0,}: mskesc         NB. unescaped characters
  (-.mskesc)&# &.> mskunescaped;y       NB. compress out unescaped x
)

fmt=: 8!:0

NB. getDateFormats v returns boxed table of all formatted date components
NB. y: numeric array of [fractional] day numbers
NB. could have give desired components as optional left arg then
NB. for loop through each component using a select case to build
getDateFormats=: 3 : 0
  ymd=. |: todate (* * <.@:|),y    

  t=. 2{ymd                                  NB. Days
  values=. ('';'r<0>2.0') fmt"0 1 t
  t=. (7|3+<.,y){WKDAYS                      NB. Day names
  values=. values,(3&{.&.> ,: ]) t
  t=. 1{ymd                                  NB. Months
  values=. values, ('';'r<0>2.0') fmt"0 1 t
  t=. (0>.t){MONTHS                          NB. Month names
  values=. values, (3&{.&.> ,: ]) t
  t=. 0{ymd                                  NB. Years
  values=. values, (2&}.&.> ,: ]) fmt t
)

NB. getTimeFormats v returns boxed array of all formatted time components
NB. y: numeric array of fractional day numbers
getTimeFormats=: 3 : 0
  0 0 0 getTimeFormats y
:
  dcp=. x
  dhms=. 1e_3 round 86400 * 1|| , y
  NB.if. *./ , 0 = dhms do. '' return. end.      NB. No times given
  ccc=.  1 | dhms                                NB. fractions of seconds
  dhms=. |:(0,(24*0{dcp),60 60) #: dhms          NB. to lists of D,H,M,:S
  values=. ,:fmt 0{dhms                          NB. Days
  t=. (1{dhms) (] + 12&*@] | -) 2{dcp            NB. Hours, 12/24 hour formats
  values=. values,('';'r<0>2.0') fmt"0 1 t
  t=. 2{dhms                                     NB. Minutes
  values=. values,('';'r<0>2.0') fmt"0 1 t
  t=. 3{dhms                                     NB. Seconds
  values=. values,('';'r<0>2.0') fmt"0 1 t
  values=. values, 'r<0>6.3' fmt t+ccc               NB. sss
  t=. 100 10 1 round"0 1 ccc * 1000              NB. c, cc, ccc
  values=. values, 1 2 3 {.&.> 'r<0>3.0' fmt t
  t=. (12<:24|1{dhms){ ;:'am pm'                 NB. am/pm
  values=. values,(1&{.&.> ,: ]) t
)
