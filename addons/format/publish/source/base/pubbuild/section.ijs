NB. section
NB.
NB. this runs top-level sections
NB.
NB. Each section is a 3 column table of:
NB.   level;newpage flag;text
NB.
NB. There may be several rows with the same level
NB.
NB. Short name is used for bookmarks, and long name for
NB. table of contents
NB.
NB. Groups are also processed here. Right now the drawing
NB. is done while checking groups, but this could be avoided

sections=: 3 : 0
log 'Build sections'
if. GroupNum >: 0 do.
  sectiongroups''
  sectionreset''
end.
sectionrun 1
)

NB. =========================================================
NB. evaluates groups
sectiongroups=: 3 : 0
sectionrun 1
while. #Groups do.
  bal=. i.0 0
  for_grp. ({."1 Groups) </. Groups do.
    dat=. >grp
    msk=. 2 # _2 =/\ 1 {"1 dat
    if. {. msk do.
      ndx=. msk # {:"1 dat
      for_loc. ndx{Locales do.
        Gstate__loc=: 1
      end.
    end.
    dat=. (-.msk)#dat
    if. #dat do.
      loc=. ((<0;_1){dat){Locales
      Gstate__loc=: 2
      loc=. ((<1;_1){dat){Locales
      Gstate__loc=: 1
      dat=. 2 }. dat
      bal=. bal,dat
    end.
  end.
  if. 0=#bal do. break. end.
  sectionrun (i.#Sections) e. {."1 bal
end.
)

NB. =========================================================
sectionreset=: 3 : 0
locs=. (Localex e. iPAGE,iGROUP)#Locales
for_loc. locs do.
  State__loc=: 0
end.
EMPTY
)

NB. =========================================================
NB. run sections, y is mask of sections to run
sectionrun=: 3 : 0
PNum=: 0
Groups=: i.0 0
ndx=. y # i.#Sections
r=. ''
for_s. ndx{Sections do.
  log 'Build section ',":s_index{ndx
  setnewpage ''
  r=. r,<draw__s 1
end.
r
)
