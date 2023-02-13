NB. timer
NB.
NB. argument is milliseconds

coclass 'qtdemo'

timer=: 3 : 0
if. y do.
  sys_timer_z_=: 3 : 'smoutput ''systimer: '',":6!:0$0'
  wd 'timer ',":y
else.
  wd 'timer 0'
  sys_timer_z_=: ]
end.
EMPTY
)

NB. =========================================================
qtdemo_timer=: 3 : 0
smoutput 'qtdemo form timer: ',":6!:0$0
)

NB. =========================================================
smoutput 0 : 0
There are 2 timers - the system timer, and the form timer.

There is only one system timer, while any number of form may have timers.

Examples:

1. system timer, calls sys_timer_z_

start, e.g. every two seconds:
   timer_qtdemo_ 2000

stop:
   timer_qtdemo_ 0

2. qtdemo form timer, calls qtdemo_timer
(qtdemo form should be active)

start, e.g. every 2 1/2 seconds:
   wd 'ptimer 2500'

stop:
   wd 'ptimer 0'
)
