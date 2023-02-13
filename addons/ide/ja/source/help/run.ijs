NB. run

load '~.Ja/release/help.ijs'

Text=: 'a+b',LF,'c +: d  '

f=. helpcontext_ja_
f=. helpcontext1_ja_

smoutput f '0 7 7 ',Text
f '0 12 12 ',Text
