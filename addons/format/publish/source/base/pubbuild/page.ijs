NB. page
NB.
NB. the pages are grouped by sections

NB. =========================================================
NB. pages
NB. returns header;pages
pages=: 3 : 0

Next=: 1 + RootPages NB. next free object
Contents=: Contents,.<0 NB. add pages column
PageNum=: 1 NB. used to set /Count parameter

NB. ---------------------------------------------------------
r=. pagesheader''
r=. r,'/Kids [',LF

NB. ---------------------------------------------------------
s=. ''
for_d. y do.
  r=. r, (":Next),' 0 R',LF
  s=. s, pageset > d
  PageBlk=: >: PageBlk
end.

NB. ---------------------------------------------------------
r=. r, ']',LF
r=. r, '/Count ',(":PageNum-1),LF
r=. dict r

r;s
)

NB. =========================================================
NB. pageset
NB.
NB. y is a section (=node. i.e. top level set of pages)
pageset=: 3 : 0
dat=. y
here=. Next
Next=: Next+1
pno=. PageNum
len=. #dat
r=. '/Type /Pages',LF
r=. r, '/Parent ',(":RootPages),' 0 R',LF
r=. r,'/Kids [',LF
s=. ''
levs=. ''
page=. ''

NB. ---------------------------------------------------------
for_d. dat do.
  'pos new txt'=. d
  if. new do.
    pagecontents levs
    levs=. <pos
    if. #page do.
      r=. r, (":Next),' 0 R',LF
      s=. s, here pageset1 page
    end.
    page=. txt
  else.
    levs=. levs,(<pos) -. levs
    page=. page,txt
  end.
end.

NB. ---------------------------------------------------------
if. #page do.
  pagecontents levs
  r=. r, (":Next),' 0 R',LF
  s=. s, here pageset1 page
end.

NB. ---------------------------------------------------------
r=. r, ']',LF
r=. r, '/Count ',(":PageNum-pno),LF
r=. dict r
r;s
)

NB. =========================================================
pageset1=: 4 : 0
r=. '/Type /Page',LF
r=. r,'/Parent ',(":x),' 0 R',LF
r=. r,'/Contents ',(":Next+1),' 0 R',LF
NB. if. ROT do.
NB.   r=. r,'/Rotate 90',LF
NB. end.
r=. dict r
Next=: Next + 2
PageNum=: PageNum+1
s=. y
if. ShowFrames do. s=. s, drawbox Dxywh end.
r;wrapstream s
)

NB. =========================================================
NB. pagesheader
pagesheader=: 3 : 0
r=. '/Type /Pages',LF
x=. ''

NB. ---------------------------------------------------------
if. #Urls do.
  o=. LF,' /Filespec <<',LF
  px=. i.#Urls
  t=. ,('  /Ul'&, &> ":each px),.' ',.(":,.px+RootUrls),"1 ' 0 R',LF
  t=. t,' >>'
  x=. o,t
end.

NB. ---------------------------------------------------------
if. #XObjects do.
  o=. LF,' /XObject <<',LF
  px=. i.#XObjects
  t=. ,('  /Im'&, &> ":each px),.' ',.(":,.px+RootXObjects),"1 ' 0 R',LF
  t=. t,' >>'
  x=. x,o,t
end.

NB. ---------------------------------------------------------
s=. '/Resources',LF,'<<',LF
s=. s,' /ProcSet [/PDF /Text /ImageC]',LF
s=. s,' /Font <<',LF
fx=. '  /F'&, &> ": each 1 + i.#PDFFonts
px=. ' ',. ": &> 2 + +/\ PDFFontpages
t=. ,fx ,"1 px ,"1 ' 0 R',LF
t=. t,' >>'
r=. r,s,t,x
r=. r,LF,'>>',LF

NB. ---------------------------------------------------------
r=. r, '/MediaBox [0 0 ',(":PAGESIZE),']',LF
)


NB. =========================================================
pagecontents=: 3 : 0
ndx=. I. ({."1 Contents) e. y
nxt=. < (":Next),' 0 R'
Contents=: nxt (<ndx;3) } Contents
EMPTY
)
