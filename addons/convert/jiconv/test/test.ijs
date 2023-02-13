NB. part a - russian text
NB.      b - simplified chinese text
NB.      c - traditional chinese text

p=: jpath '~Addons/convert/jiconv/test/'
load '~Addons/convert/jiconv/jiconv.ijs'

bomucs2=: 255 254 { a.
bomutf8=: 239 187 191 { a.

test=: 3 : 0
NB. russian , simplified and traditional chinese in one file
NB. unicode and gbk ok
NB. cp1251 and big5 not supported 
utf8abc=. 1!:1 <p,'utf8.abc'
gbkabc=. 1!:1 <p,'gbk.abc'
assert. gbkabc -.@-: utf8abc
assert. 'GBK' -: 0{:: ('';'utf8') jiconv gbkabc
assert. utf8abc -: 1{:: ('';'utf8') jiconv gbkabc
assert. gbkabc -: 1{:: ('utf8';'gbk') jiconv utf8abc
smoutput 'success'

NB. russian text
utf8a=. 1!:1 <p,'utf8.a'
gbka=. 1!:1 <p,'gbk.a'
cp1251a=. 1!:1 <p,'cp1251.a'
assert. cp1251a -.@-: utf8a
assert. gbka -.@-: utf8a
assert. gbka -.@-: cp1251a
assert. utf8a -: 1{:: ('cp1251';'') jiconv cp1251a
assert. cp1251a -: 1{:: ('';'cp1251') jiconv utf8a
assert. cp1251a -: 1{:: ('';'cp1251') jiconv gbka
smoutput 'success'

NB. chinese text
utf8b=. 1!:1 <p,'utf8.b'
gbkb=. 1!:1 <p,'gbk.b'
assert. gbkb -.@-: utf8b
assert. gbkb -: 1{:: ('';'gbk') jiconv utf8b
assert. utf8b -: 1{:: ('';'') jiconv 1{:: ('';'gbk') jiconv utf8b
smoutput 'success'

NB. chinese text
big5c=. 1!:1 <p,'big5.c'
gbkc=. 1!:1 <p,'gbk.c'
utf8c=. 1!:1 <p,'utf8.c'
assert. utf8c -.@-: big5c
assert. gbkc -.@-: big5c
enc=. IFUNIX{::'big5';''
assert. utf8c -: 1{:: (enc;'') jiconv big5c
assert. gbkc -: 1{:: (enc;'gbk') jiconv big5c
assert. big5c -: 1{:: ('';'big5') jiconv 1{:: (enc;'gbk') jiconv big5c
smoutput 'success'

NB. test bom
assert. 'UTF-8' -: 0{:: ('';'UCS-2') jiconv bomutf8, utf8a
assert. 'UCS-2' -: 0{:: ('';'') jiconv bomucs2, 1 ic 3 u: ucp utf8a
assert. utf8a -: 1{:: ('';'') jiconv bomucs2, 1 ic 3 u: ucp utf8a
smoutput 'success'

NB. visual validation
smoutput ''
smoutput 'russian'
smoutput 60{. ucp 1{:: ('cp1251';'') jiconv cp1251a
smoutput ''
smoutput 'simplified chinese'
smoutput 60{. 6 u: 1{:: ('';'UCS-2') jiconv gbkb
smoutput ''
smoutput 'traditional chinese'
smoutput 60{. ucp 1{:: ('BIG5';'') jiconv big5c
''
)

test ''
