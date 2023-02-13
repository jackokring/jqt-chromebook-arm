NB.

cocurrent IFQT{'jqtide';'z'

NB. =========================================================
wdreadimg=: ('"',libjqt,'" wdreadimg  ',(IFWIN#'+'),' x *c *i')&cd
wdgetimg=: ('"',libjqt,'" wdgetimg  ',(IFWIN#'+'),' x *c i *i')&cd
wdwriteimg=: ('"',libjqt,'" wdwriteimg  ',(IFWIN#'+'),' i *c *i *c *c i')&cd
wdputimg=: ('"',libjqt,'" wdputimg  ',(IFWIN#'+'),' x *c *i *i *c i')&cd

NB. =========================================================
NB. preserved for compatibility
getsha1=: 3 : 0
gethash 'sha1';y
)

NB. =========================================================
gethash=: 3 : 0
't m'=. y
t gethash m
:
m=. ,y
c=. '"',libjqt,'" gethash ',(IFWIN#'+'),' i *c *c i * *i'
'r t m w p n'=. c cd (tolower x);m;(#m);(,2);,0
res=. memr p,0,n
if. r do.
  res (13!:8) 3
end.
res
)
