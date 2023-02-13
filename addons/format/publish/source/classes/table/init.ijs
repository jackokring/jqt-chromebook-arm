NB. init
NB.
NB. A table object has tags for:
NB.   top
NB.   col
NB.   row
NB.   data
NB.   align
NB.   bold (maps to Font)
NB.   gridh
NB.   gridv
NB.   high
NB.
NB. Class is table type

coclass 'ppubtable'

Align=: ''
Bold=: ''
Col=: ''
Data=: ''
Font=: ''
High=: ''
Gridv=: ''
Gridh=: ''
Row=: ''
Top=: ''

NB. =========================================================
CLASS=: 'std'
SHAPE=: ''
NewPage=: 0           NB. 1 if new page requested initially

NB. =========================================================
NB. STATE gives the draw state of the table, and is used to
NB. fit a table horizontally
NB.   0 normal - if too small, try reduced margins
NB.   1 if too small, reduce fontsize
NB.   2 go ahead, even if too small
STATE=: 0

NB. =========================================================
NB. defaults:
Leading=: 1.4         NB. font leading
Leadingm=: 1          NB. font leading for multi-line cells
MinCellWid=: 50       NB. min data cell width
MinLabelWid=: 100     NB. min row label width
PadCell=: 15          NB. data cell horizontal padding
PadHeader=: 0         NB. header vertical pad
PadLabel=: 1          NB. row label horizontal padding on right
SepHdrCell=: 2        NB. separate header and cells

NB. =========================================================
create=: 3 : 0
coinsert locP=: COCREATOR
)
