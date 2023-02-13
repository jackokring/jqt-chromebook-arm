
info=: sminfo @ ('Pousse'&;)
unwords=: ;: inverse

wdview=: 3 : 0
'a b'=. _2{. boxopen y
if. 2=#$b=. ":b do. b=. }.,LF,.b end.
f=. 8 u: DEL&, @ (,&DEL) @ -.&(0 127{a.)
wd 'pc wdvw owner escclose closeok;pn ',dquote a
wd 'cc ted editm'
wd 'set ted stylesheet *color:#00007f;background-color:#ffefd5'
wd 'set ted text *',b
wd 'bin zhs'
wd 'pmove 100 10 700 500'
wd 'pshow'
wd 'set ted readonly 1'
)
