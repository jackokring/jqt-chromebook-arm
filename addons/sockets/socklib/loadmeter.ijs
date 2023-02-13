NB. Load calculation
NB. This is in z locale so each locale can have its own load meter
coclass 'z'

NB. To display the load meter use
NB. loadmetercalc_locale_ ''
NB. result is avg,:peak for recent 1, 10, 60  seconds

NB. The locale using these functions is required to run this initialization under its own locale
loadmeterinit =: 3 : 0
loadmeterhistory =: 60 $ 0
loadmeterlatestsec =: 0
NILRET
NB.?lintsaveglobals
)

NB. y is starting seconds, ending seconds
NB. the time in between is added to the load list
loadmeteradd =: 3 : 0
NB. Get the list of idle seconds.  This is everything AFTER the previous end time, up to and including the
NB. new end time.  These are seconds that must be cleared to 0.  Wrap around 60
i =. loadmeterlatestsec (60 | [ + 60 i.@>:@| -~) {: <. y
loadmeterlatestsec =:  {: <. y
NB. Clear the time for the idle seconds
loadmeterhistory =: 0 (}.i)} loadmeterhistory
NB. Get the list of indices we must modify.  They are the indexes for the starting
NB. sec and the ending, and everything in between, wrapping around 60
m =. (60 | {. + 60 i.@>:@| -~/) <. y
NB. Add the load for the time just added. ending time - starting time, with middle elements filled with 1
loadmeterhistory =: ((m{loadmeterhistory) + (((-#m) {.!.1 ]) - (#m) {. [)/ 1 | y) m} loadmeterhistory
NILRETQUIET
)

NB. return the recent load.  y is durations to calculate (default 1 10 60)
NB. result is table of avg,:peak at the times requested
loadmetercalc =: 3 : 0
if. 0 = #times =. y do. times =. 1 10 60 end.
|: (-times) ((+/ % #) , >./)@{."0 _ loadmeterhistory |.~ <. {: tod NIL
)
