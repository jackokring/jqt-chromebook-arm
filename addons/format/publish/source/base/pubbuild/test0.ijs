NB. test0

cocurrent 'ppublish'
0!:0 <jpath '~Publish/base/main/pubdefs.ijs'
0!:0 <jpath '~Publish/base/build/plot.ijs'
ferase OutputFile

dbg 1
dbstops''

NB. =========================================================
testpages=: 3 : 0
a=. testpage1 each 1 + 0.1*1+i.3
a=. (1;1 1;1 2;1 3),.('Outline A '&, each ": each i.4),.'';a
b=. testpage1 each 2 + 0.1*1+i.2
b=. (2;2 1;2 2),.('Outline B '&, each ": each i.3),.'';b
c=. testpage1 each 3 + 0.1*1+i.4
c=. (3;3 1;3 2;3 3;3 4),.('Outline C '&, each ": each i.5),.'';c
NODES=: a;b;<c
)

NB. =========================================================
testpage1=: 3 : 0
txt=. 'hi there Page ',":y
font=. fontindex 'Arial 24'
align=. 0
pdftext txt;font;align;255 0 0;200 500
wrapstream pbufread''
)

draw_init''
testpages''
run''
fview OutputFile
PDFreader=: 'c:/program files/adobe/acrobat 7.0/reader/acrord32.exe'
view''
