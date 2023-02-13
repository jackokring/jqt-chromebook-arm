NB. data selections

NB. =========================================================
NB. return mask of later versions
pkglater=: 3 : 0
if. 0=#PKGDATA do. $0 return. end.
loc=. fixvers > 2 {"1 PKGDATA
srv=. fixvers > 3 {"1 PKGDATA
{."1 /:"2 srv ,:"1 loc
)

NB. =========================================================
pkgnew=: 3 : 0
0 = # &> 2 {"1 PKGDATA
)
