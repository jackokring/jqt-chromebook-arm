NB. html

NB. =========================================================
NB. format table from dbread as html
tab2html=: 3 : 0
'cls dat'=. y
th=. '<th>' , ,&'</th>'
tr=. '<tr>' , ,&'</tr>'
hdr=. tr ; th each cls
rws=. #0 pick dat
td0=. rws $ '<td>';'<td class="alt">'
td1=. '</td>'
td=. td0 (,td1,~":) each ]
ndx=. I. 0<L.&> dat
dat=. (td each ndx{dat) ndx} dat
td0=. rws $ '<td class="right">';'<td class="right alt">'
td=. td0 (,td1,~":) each ]
ndx=. I. 0=L.&> dat
dat=. (td each ndx{dat) ndx} dat
dat=. > ,.each/ dat
dat=. (<'<tr>'),.dat,.<'</tr>',LF
bdy=. ; <@;"1 dat
'<table>',hdr,bdy,'</table>'
)
