NB. stop management
NB.
NB. jdb_stopcut
NB. jdb_stoponall
NB. jdb_stopget
NB. jdb_stopgetone
NB. jdb_stopread
NB. jdb_stopset
NB. jdb_stopsetline
NB. jdb_stopsetone
NB. jdb_stopson
NB. jdb_stopwrite
NB. jdb_extstops

NB. =========================================================
a=. , ';'"_ -. {:
b=. i.&':' ({. ; }.@}.) ]
c=. i.&' ' ({. ; b @ }.@}.) ]
d=. c @ jdb_dlb
jdb_stopcut=: ([: d ;._2 a) f.

NB. =========================================================
NB. jdb_stopget
jdb_stopget=: 3 : 0
jdb_stopgetone NAME;'';VALENCE;NUMLINES;CODELINES
)

NB. =========================================================
jdb_stopgetone=: 3 : 0
'name dummy valence numlines codelines'=. y
'astop ustop'=. jdb_stopson name;valence;codelines
astop=. (astop < numlines) # astop
ustop=. (ustop < numlines) # ustop
'*' ustop} '|' astop} numlines # ' '
)

NB. =========================================================
NB. jdb_stoponall
NB. set stops on all lines in name
NB. 0 jdb_stoponall - remove
NB. 1 jdb_stoponall - add
NB. 2 jdb_stoponall - toggle
jdb_stoponall=: 4 : 0
nam=. {. jdb_boxxopen y
jdb_stopread ''
sel=. x
if. sel=2 do.
  sel=. -. (nam,1;1) e. 3 {."1 STOPS
end.
STOPS=: STOPS #~ nam ~: {."1 STOPS
if. sel do.
  STOPS=: STOPS, nam,1;1;'';''
end.
jdb_stopwrite ''
)

NB. =========================================================
NB.*jdb_stopread v read current stops into global STOPS
jdb_stopread=: 3 : 0
sq=. 13!:2 ''
if. sq -: STOPLAST do. STOPS return. end.
if. 0 = #sq do.
  STOPS=: 0#STOPS
  return.
end.
stp=. /:~ jdb_stopcut sq
nms=. ~. {."1 stp
res=. nms ,"0 1 }. STOPNONE
NB. ---------------------------------------------------------
for_i. 1 2 do.
  col=. i {"1 stp
  msk=. col = <,'*'
  if. 1 e. msk do.
    ndx=. ~. nms i. msk # nms
    res=. (<1) (<ndx;i) } res
  end.
  if. 0 e. msk do.
    mon=. 0 ". &.> (-.msk) # col
    bal=. (-.msk) # nms
    ndx=. nms i. ~.bal
    res=. (bal <@; /. mon) (<ndx;i+2) } res
  end.
end.
STOPS=: res
)

NB. =========================================================
NB. jdb_stopsetone
NB. left argument is setting: 0 off, 1 on, 2 toggled
NB. updates STOPS
jdb_stopsetone=: 4 : 0

'name val line'=. y

msk=. ({."1 STOPS) = <name
stp=. msk # STOPS
bal=. (-.msk) # STOPS

NB. check for stop both monad and dyad:
if. SMBOTH do. val=. 0 1 end.

if. 0 = #stp do.
  if. -. x -: 0 do.
    stp=. name;0;0;(0 1 e. val) {'';line
  end.
else.
  stp=. {. stp
  for_v. val do.
    'all sel'=. (v + 1 3) { stp
    select. x
    case. 0 do.
      if. all do.
        sel=. i.NUMLINES
        all=. 0
      end.
      sel=. sel -. line
    case. 1 do.
      if. -. all do.
        sel=. ~. line, sel
      end.
    case. do.
      if. all do.
        all=. 0
        sel=. (i.NUMLINES) -. line
      else.
        if. line e. sel do.
          sel=. sel -. line
        else.
          sel=. ~. line, sel
          if. 0=#(i.NUMLINES) -. sel do.
            all=. 1
            sel=. ''
          end.
        end.
      end.
    end.
    stp=. (all;/:~sel) (v + 1 3) } stp
  end.
end.

STOPS=: stp, bal
)

NB. =========================================================
NB. jdb_stopset
jdb_stopset=: 3 : '13!:3 STOPLAST=: y'

NB. =========================================================
NB. jdb_stopsetline
jdb_stopsetline=: 4 : 0
x jdb_stopsetone NAME;VALENCE;y
jdb_stopwrite ''
)

NB. =========================================================
NB. jdb_stopson name
NB. returns (all stops);(line stops)
jdb_stopson=: 3 : 0
'name valence codelines'=. y
val=. 2 | valence NB. for both >@{ monad
nms=. {."1 STOPS
x=. (nms i. <,name) { STOPS, STOPNONE
'all line'=. (val + 1 3) { x
as=. (1 e. all) # codelines
ls=. /:~ ~. line
as ; ls
)

NB. =========================================================
NB.*jdb_stopwrite v write STOPS
jdb_stopwrite=: 3 : 0
if. 0 e. #STOPS do. jdb_stopset '' return. end.
STOPS=: (-. (}.STOPNONE) (-:}.)"1 STOPS) # STOPS
if. 0 e. #STOPS do. jdb_stopset '' return. end.
STOPS=: /:~ ~. STOPS
nms=. {."1 STOPS
mon=. ": &.> 3 {"1 STOPS
mon=. (<'*') (I. ;1 {"1 STOPS) } mon
dyd=. ": &.> 4 {"1 STOPS
dyd=. (<'*') (I. ;2 {"1 STOPS) } dyd
jdb_stopset ; (nms,.mon,.dyd) ,&.> "1 ' :;'
)

NB. =========================================================
NB.*jdb_extstops v write STOPS and dissect parameters
NB. y is stop info[;autodissect setting[;dissect parms]]
NB. stop info is a table of
NB. action;functionname;locale;valence;lines
NB.   action is 0=off 1=on 2=toggle
NB.   functionname;locale (both single-boxed) identify the function
NB.   valence is 0 or 1 to indicate the valence to apply to
NB.   lines is the list of lines to apply to; if empty, uses all lines
NB. autodissect setting is 0 or 1
NB. dissect parms is a table of
NB. dissectinfo;functionname;locale;valence;lines
NB.   dissectinfo is a table to pass in as option 1 to dissect when the line is dissected
NB.     multiple options per line are allowed, and are applied in order
NB.     if table is empty, all options for that line(s) are cleared
NB.   others as for stop info
NB.
NB. sets stops, and creates the table DISSECTOPTIONS which looks just like
NB.  the dissect parms argument, but has the options for all verbs
jdb_extstops =: 3 : 0
'stopinfo autoinfo dissectinfo' =. 3 {. y
if. #stopinfo do.
  if. 1 = #$stopinfo do. stopinfo =. ,: stopinfo end.
  assert. (,5) -: }.$stopinfo
  NB. Collect the stops by name, and apply to each name
  (((<0;1 2)&{ jdb_installstops 0 3 4&{"1)/.~   1 2&{"1) stopinfo
end.

if. -. IFDISSECT do. return. end.

if. #autoinfo do.
  NB. Set the autodissect setting as specified
  assert. '' -: $autoinfo
  assert. autoinfo e. 0 1
  jdebug_dissecttoggleauto_run autoinfo
end.

if. #dissectinfo do.
  if. 1 = #$dissectinfo do. dissectinfo =. ,: dissectinfo end.
  assert. (,5) -: }.$dissectinfo
  NB. Collect the edits by name, and apply to the table
  (((<0;1 2)&{ jdb_installdissectopts 0 3 4&{"1)/.~   1 2&{"1) dissectinfo
end.
)


NB. =========================================================
NB.*jdb_installstops v edit STOPS table
NB. x is name;locale
NB. y is table of action;valence;lines
jdb_installstops =: 4 : 0
NB. If name has been reloaded and is no longer a header/body pair, remove the body
jdebug_debugnametodisp x
NB. The user interacts with us using the display name, i. e. 'v' to mean the
NB. body of v is v has a header.  So we convert the display name to the debug name,
NB. and then in case the selected name is a header, split it and look inside the body
x =. jdebug_splitheader jdebug_dispnametodebug x
NB. Refresh globals for the selected definition
x jdb_stoprefresh''
NB. Apply each action
x jdb_installstops1 y
NB. Install the stops into the J session
jdb_stopwrite''
NB. Do not bother to update the window, since we assume that we are installing the
NB. stops when the function is defined, before it has been put into the debug display;
NB. and there may be nothing to update
)

NB. =========================================================
NB.*jdb_installstops1 v edit STOPS table
NB. x is name;locale (name is debug name)
NB. y is action;valence;lines
jdb_installstops1 =: 4 : 0"1
'nam loc' =. x
'action val lines' =. y
assert. '' -: $val
assert. val e. 0 1
assert. '' -: $ action
assert. action e. 0 1 2
NUMLINES =: val { SMCOUNT
assert. 0 < NUMLINES [ 'selected valence is empty'
if. 0 = #lines do. lines =. i. NUMLINES end.
(action jdb_stopsetone (nam;val)&,)@<"0 lines
0 0$0
)

NB. =========================================================
NB.*jdb_installdissectopts v edit dissect info
NB. x is name;locale
NB. y is table of dissectinfo;valence;lines
jdb_installdissectopts =: 4 : 0
NB. If name has been reloaded and is no longer a header/body pair, remove the body
jdebug_debugnametodisp x
NB. The user interacts with us using the display name, i. e. 'v' to mean the
NB. body of v is v has a header.  So we convert the display name to the debug name,
NB. and then in case the selected name is a header, split it and look inside the body
x =. jdebug_splitheader jdebug_dispnametodebug x
NB. Refresh globals for the selected definition (needed only to get NUMLINES)
x jdb_stoprefresh''
NB. Apply each action
x jdb_installdissectopts1 y
)

NB. =========================================================
NB.*jdb_installdissectopts1 v edit STOPS table
NB. x is name;locale (debug name)
NB. y is table of dissectinfo;valence;lines
jdb_installdissectopts1 =: 4 : 0"1
'nam loc' =. x
'opttbl val lines' =. y
assert. '' -: $val
assert. val e. 0 1
NUMLINES =: val { SMCOUNT
assert. 0 < NUMLINES [ 'selected valence is empty'
if. 0 = #lines do. lines =. i. NUMLINES end.
if. #opttbl do.
  if. 1 = #$opttbl do. opttbl =. ,: opttbl end.
  assert. (,2) -: }.$opttbl
  NB. Options to add: just add the new line, keeping any old ones
  DISSECTOPTIONS =: DISSECTOPTIONS , opttbl;nam;loc;val;lines
else.
  NB. No options: clear all options for these lines
  NB. Get previous option lines for this name/valence
  nvmsk =. (nam;loc;val) -:"1 (1 2 3) {"1 DISSECTOPTIONS
  oldlines =. nvmsk # DISSECTOPTIONS
  NB. remove new lines from the old ones' domain
  oldlines =. (nlct =. -.&lines&.> 4 {"1 oldlines) (<a:;4)} oldlines
  NB. Delete options that now have no domain
  oldlines =. (a: ~: nlct) # oldlines
  NB. Append the surviving lines for this name, plus the new line (if not empty), to the others
  DISSECTOPTIONS =: ((-. nvmsk) # DISSECTOPTIONS) , oldlines
end.
0 0$0
)
