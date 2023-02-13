NB. init
NB.
NB. a section corresponds to a header. The headers themselves
NB. are created in header locales.
NB.
NB. sections are parsed and made - each making a list of object
NB. locales. at this stage, they are not drawn.
NB.
NB. sections are then drawn, creating a table of:
NB.    level;name;newpage flag;pdf commands
NB.
NB. entries for level;name may be duplicated in several rows.
NB.
NB. levels up to BMLEVEL are used for PDF bookmarks
NB. levels up to TOCLEVEL are used for Table of Contents
NB. by default, the same name applies to both, but a
NB. bookmark id can be supplied.
NB. pages are built from a list of sections
NB.
NB. level is an integer list, e.g.
NB.    1
NB.    1 2
NB.    2
NB.    2 1
NB.    2 1 1
NB.
NB. level starts from 0 if a front page, otherwise from 1
NB.
NB. The first "page" in any level follows immediately on from
NB. the previous level block. To make a new page, use an empty
NB. first page.
NB.
NB. locP      parent
NB. Locs      children locales
NB. Locx      children types
NB. Level     number
NB. Sections  subsections
NB. Name      shortname
NB. LName     longname
NB. SNum      section number (only for level 0 or 1)

coclass 'ppubsection'

Locs=: ''
Locx=: ''
Name=: ''
LName=: ''

NB. =========================================================
create=: 3 : 0
coinsert locP=: COCREATOR
NB. parent sections:
Sections__locP=: Sections,coname''
Level=: Level__locP,#Sections
if. FrontPage *. 1=#Level do. Level=: <:Level end.
if. 1 = #Level do. SNum=: newsectionnum'' end.
NB. own sections:
Sections=: ''
)

NB. =========================================================
new=: 3 : 0
a=. '' newinstance 'ppub',y
i=. ('i',toupper y)~
Locs=: Locs,a
Locx=: Locx,i
Locales__locS=: Locales,a
Localex__locS=: Localex,i
a
)
