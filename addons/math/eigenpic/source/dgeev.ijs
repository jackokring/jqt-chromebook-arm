NB. dgeev

NB. =========================================================
NB. equivalent of lapack dgeev for 2x2 matrices
dgeev=: 3 : 0
'a b c d'=. ,y
'm n'=. 1 pick p. ((a*d)-b*c), (-a+d), 1
e0=. norm 1,~ -b % a - m
e1=. norm 1,~ -b % a - n
(|.e1,.e0);(m,n);e0,.e1
)

NB. =========================================================
NB. largest component real, euclidean norm 1
norm=: 3 : 0
n=. (i.>./) (*+) y
if. {: +. n{y do. y=. y * + n{y end.
y % %: +/ | *: y
)
