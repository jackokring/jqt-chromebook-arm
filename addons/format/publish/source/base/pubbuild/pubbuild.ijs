NB. build

NB. =========================================================
NB. build
NB.  1 Info
NB.  2 Catalog
NB.  3+ Fonts
NB.  n Urls
NB.    Dictionary
NB.     +...
NB.  n XObjects
NB.    Dictionary
NB.    Data
NB.     +...
NB.  n Pages
NB.    Page
NB.    Content
NB.    Page
NB.    Content
NB.     +...
NB.  n Outlines
NB.     +...
NB.
NB. wrap adds:
NB.  Xref
NB.  Trailer

NB. =========================================================
build=: 3 : 0
log 'Make creator'
inf=. creator''
log 'Resolve urls'
uls=. urls''
log 'Resolve images'
xbs=. xobjects''
sec=. sections''
log 'Make page numbers'
sec=. y numbers sec
log 'Make fonts'
fnt=. fonts''
log 'Make PDF pages'
roots''
nds=. pages sec
out=. outlines''
cat=. catalog ''
wrapbody inf;cat;fnt,uls,xbs,nds,out
)

NB. =========================================================
NB. catalog
NB.
catalog=: 3 : 0
r=. '/Type /Catalog',LF
r=. r, '/Pages ',(":RootPages),' 0 R',LF
if. RootOutlines do.
  r=. r, '/Outlines ',(":RootOutlines),' 0 R',LF
end.
dict r
)

NB. =========================================================
NB. creator
creator=: 3 : 0
msk=. (0 < #TITLE),(0 < #AUTHOR), 1 1
t=. u2a '/Title (',TITLE,')'
a=. u2a '/Author (',AUTHOR,')'
p=. '/Producer (J Publish)'
d=. creationdate''
dict msk # t;a;p;d
)

NB. =========================================================
NB. creationdate
creationdate=: 3 : 0
t=. '20', ; _2 {.each '0' ,each ": each <. 6!:0''
'/CreationDate (D:',t,')'
)

NB. =========================================================
roots=: 3 : 0
RootUrls=: 3 + +/ PDFFontpages
RootXObjects=: RootUrls + #Urls
RootPages=: RootXObjects + #XObjects
RootOutlines=: 0
)
