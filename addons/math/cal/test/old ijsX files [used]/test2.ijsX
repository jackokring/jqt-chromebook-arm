NB. CAL test2.ijs - expandedPath_cal_
0 :0
Wednesday 24 April 2019  01:02:31
-
open '~Gitcal/test/test.ijs'  NB. the top-level of the test suite
)

cocurrent 'base'

'PLS' default~ LF,~LF,60$'+'
smoutput PLS,'+++ CAL test2.ijs - entered',PLS

CALPATH=: jpath '~Gitrcal'  NB. /users/ianclark/documents/github/math_cal

]z=. expandedPath_cal_'$'
 assert z-: CALPATH,'/SAMPLE.ijs'
]z=. expandedPath_cal_,'$'
 assert z-: CALPATH,'/SAMPLE.ijs'
]z=. expandedPath_cal_'$0'
 assert z-: CALPATH,'/SAMPLE0.ijs'
]z=. expandedPath_cal_'$1'
 assert z-: CALPATH,'/SAMPLE1.ijs'
]z=. expandedPath_cal_'$9'
 assert z-: CALPATH,'/SAMPLE9.ijs'
]z=. expandedPath_cal_'able'
 assert z-: jpath '~home/tabula-user/able.ijs'


smoutput PLS,'--- CAL test2.ijs - completed',PLS
