NB. run

load '~.Qt/release/help.ijs'

Text=: 'a+b',LF,'c +: d  '

f=. helpcontext_jqtide_
f=. helpcontext1_jqtide_

smoutput f '0 7 7 ',Text
f '0 12 12 ',Text
