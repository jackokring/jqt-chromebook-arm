NB. scrollarea demo
NB.
NB. a scrollarea provides a scrollable view into the
NB. last child control, typically a graphics control
NB.
NB. the last child control must have minwh set in order
NB. to trigger scrollbars when the visible area is smaller
NB.
NB. the scroll amounts are in pixels and depend on form size
NB.
NB. minimum position is 0, single step 1, page step 10
NB.
NB. the event shows horizontal position, maximum
NB. then vertical position, maximum
NB.
NB. wd 'set id pos h v' sets horizontal and vertical positions
NB. where -1 is ignored

coclass 'qtdemo'

NB. =========================================================
sademo=: 3 : 0
require 'gl2'
coinsert 'jgl2'
wd 'pc sademo'
wd 'cc g isigraph flush'
wd 'cc sa scrollarea'
wd 'set g minwh 400 250'
wd 'pmove 700 20 300 200'
wd 'pshow'
smoutput 'Try:',LF,'  wd ''set sa pos 10 100'''
showevents_jqtide_ 2
)

NB. =========================================================
sademo_close=: 3 : 0
wd 'pclose'
showevents_jqtide_ 0
)

NB. =========================================================
sademo_g_paint=: 3 : 0
glclear''
glbrush glrgb 255 0 0
glrect 50 50 200 200
gllines 30 30 300 300
)

NB. =========================================================
sademo''
