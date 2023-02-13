NB. util

NB. =========================================================
addcontents=: 3 : 'Contents__locS=: Contents,y'

NB. =========================================================
newsectionnum=: 3 : 0
SectionNum__locS=: SectionNum+1
)

NB. =========================================================
newgroup=: 3 : 0
GroupNum__locS=: GroupNum+1
)

NB. =========================================================
newsection=: 3 : 0
cocurrent locS
y newinstance 'ppubsection'
)

NB. =========================================================
newurl=: 3 : 0
cocurrent locS
if. (<y) e. UrlIds do. return. end.
y newinstance 'ppuburl'
)

NB. =========================================================
newxobject=: 3 : 0
cocurrent locS
y newinstance 'ppubxobject'
)

NB. =========================================================
newplot=: 3 : 0
cocurrent locS
y newinstance 'ppubplot'
)

NB. =========================================================
setgroup=: 3 : 0
Groups__locS=: Groups,SNum,PNum,Sh,Locales i. coname''
)