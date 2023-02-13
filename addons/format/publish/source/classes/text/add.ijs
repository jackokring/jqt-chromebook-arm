NB. add
NB.
NB. formats:
NB.   plain text - cut into paras
NB.   single paras = 2 col L.1 table
NB.   several paras as boxed list of single paras

NB. =========================================================
add=: 3 : 0
dat=. y
dat=. fixbreak dat
select. L. dat
case. 0 do.
  if. 0=#Font do.
    Font=: fontindex FONTP
  end.
  if. 0=#Color do.
    Color=: iBLACK
  end.
  dat=. fixpara each cutparas dat
case. 1 do.
  dat=. <citemize dat
case. 2 do.
  dat=. citemize each dat
end.
Data=: Data,dat
)
