NB. stop manager
NB.
NB. SMNAMES     current names in stop manager (dynamically updated)
NB. STNAMES     current stack names
NB. SMNDX       selected index into SMNAMES
NB. SMLOCS      current names in locs (static once stopman loaded)
NB. SMLOC       selected locale

CX=: <'Current execution'

DEBUGNAMESUFFIX =: 'd4B7g0'
DISPNAMESUFFIX =: ' (header)'  NB. Added for display when a name is split

NB. =========================================================
jdbstop_dun=: ]

NB. =========================================================
NB. argument is a 0 or more names from current line
jdbstop_ini=: 3 : 0

if. jdb_inactive'' do.
  SMLOC=: <'base'
  0 jdebug_syslocs_button ''
  STNAMES=: i.0 2
  jdb_stoplocaleset SMLOC
else.
  SMLOC=: CX
  0 jdebug_syslocs_button ~. LOCALE, <'base'
  nms=. {."1 STACK
  nms=. ~. (jdb_boxxopen y), nms
  r=. ([:{.(_2&{.@I.@('_'=])))&.>nms
  p=. ;('_'={:)&.>nms
  nms1=. (r+&.>(-.p)*&.>#&.>nms){.&.>nms
  SMNAMES=: nms1 ,. LOCALE(I. -.;p)} ([:}.(}:))&.>r}.&.> nms
  STNAMES=: SMNAMES
  0 jdb_stopswritedef SMNAMES
end.
)

NB. =========================================================
NB. HANDLERS
NB. =========================================================

NB. =========================================================
jdbstop_stopall_button=: 3 : 0
jdb_lxsoff''
ndx=. {. _1,~ 0 ". name_select
if. _1=ndx do. jdb_lxson'' return. end.
nam=. {. ndx { SMNAMES
2 jdb_stoponall nam
jdb_stoprefresh {: 0 ". slines_select
jdb_lxson''
)

NB. =========================================================
jdbstop_stopline_button=: 3 : 0
jdb_lxsoff''
if. -. LF e. slines do.
  jdbstop_stopall_button''
else.
  'bgn end'=. 2{._1 _1,~ 0 ". slines_select
  num=. +/ LF = bgn {. slines
  val=. num > {. SMCOUNT
  line=. num - val * 1 + {.SMCOUNT
  nam=. {. SMNDX { SMNAMES
  NUMLINES=: val { SMCOUNT
  2 jdb_stopsetone nam,val;line
  jdb_stopwrite''
  jdb_stoprefresh end
end.
jdb_lxson''
)

NB. =========================================================
jdbstop_stopname_button=: 3 : 0
jdb_lxsoff''
if. 0 e. $j=. jdbstop_getnameat'' do. jdb_lxson'' return. end.
'pos name fullid'=. j

if. fullid -: jdbstop_getcurrentname'' do.
  jdbstop_stopall_button''
else.
  1 jdb_stoponall name
  jdb_wd 'set slines select ',":pos
  if. SMLOC-:CX do.
    SMNAMES=: ~. SMNAMES, fullid
    jdb_wd 'set name items ',jdb_listboxed {."1 jdebug_debugnametodisp SMNAMES
  end.
end.
jdb_lxson''
)

NB. =========================================================
jdbstop_stopwin_button=: 3 : 0
jdb_lxsoff''
if. 0 e. $j=. jdbstop_getnameat'' do. jdb_lxson'' return. end.

'pos name fullid'=. j

NB. no change:
if. fullid -: SMNDX { SMNAMES do. jdb_lxson'' return. end.

'rep both count'=. jdb_stoprep fullid
if. 0=#rep do.
  jdb_info 'No definition for name:',LF,LF,name
  jdb_lxson'' return.
end.

if. fullid e. SMNAMES do.
  nms=. SMNAMES
  ndx=. SMNAMES i. fullid
else.
  nms=. ~. fullid, SMNAMES
  ndx=. 0
end.

jdb_stopswritedefone rep;both;count;ndx;<nms
jdb_lxson''
)

NB. =========================================================
jdebug_name_select=: 3 : 0
jdb_lxsoff''
ndx=. {. _1,~ 0 ". name_select
if. _1=ndx do. jdb_lxson'' return. end.
NB. The user might have typed into the locale (without pressing ENTER) before he
NB. selected a name.  In that case the value in the 'loc' field does not match
NB. the locale we are going to use (SMLOC), so we reset the locs field to SMLOC
jdb_wd 'set locs select ',": SMLOCS i. SMLOC
if. ndx = #SMNAMES do.
  NB. The user typed in a new name.  Treat it as invalid (perhaps it
  NB. would be better to see if it exists and add the line to SMNAMES if so,
  NB. but we don't do that yet).  But Qt may have added it to the items in
  NB. the name control, so we rewrite the name and selection to expunge the
  NB. mistyped name.
  'dbgnames dispnames' =. jdebug_debugnametodisp SMNAMES
  jdb_wd 'set name items ',jdb_listboxed {."1 dispnames
  jdb_wd 'set name select ', ": SMNDX
  jdb_lxson''
  return.
end.
if. ndx ~: SMNDX do.
  NB. Get the selected name, and see if it has a detachable header.
  NB. If it does, the body will be detached and given a new name, which
  NB. we will use from here on
  if. (ndx { SMNAMES) -.@-: fullname =. jdebug_splitheader ndx { SMNAMES do.
    NB. The body was detached.  We will use it, but we must fix up
    NB. SMNAMES by adding the new name just after the header,
    NB. pointing ndx to it, and rewriting the control and selection
    SMNAMES =: (2 ndx} (#SMNAMES)$1) # SMNAMES
    'dbgnames dispnames' =. jdebug_debugnametodisp fullname (>:ndx)} SMNAMES
    SMNAMES =: dbgnames
    ndx =. SMNAMES i. fullname
    jdb_wd 'set name items ',jdb_listboxed {."1 dispnames
    jdb_wd 'set name select ', ": ndx
  end.
  'rep both count'=. jdb_stoprep fullname
  if. 0=#rep do.
    j=. 'Unable to get representation of:', LF, LF
    jdb_info j, 0 >@{ ndx { SMNAMES
    'dbgnames dispnames' =. jdebug_debugnametodisp (<<<ndx) { SMNAMES
    SMNAMES =: dbgnames
    SMNDX=: 0
    jdb_wd 'set name items ',jdb_listboxed {."1 dispnames
    jdb_wd 'set name select ', ": SMNDX
  else.
    if. DISPNAMESUFFIX ([ -: -@#@[ {. ]) name do.
      NB. The selected name was a header name (in display form).  Remove the
      NB. debug suffix from the (necessarily one-line) body
      rep =. DEBUGNAMESUFFIX&(taketo , takeafter)&.> rep
    end.
    jdb_wd 'set slines text *',jdb_listboxed rep
    SMNDX=: ndx
    NMC=: 4!:0 fullname
    SMBOTH=: both
    SMCOUNT=: count
  end.
end.
jdb_lxson''
)

NB. =========================================================
jdebug_locs_select=: 3 : 0
jdb_lxsoff''
if. SMLOCS -.@e.~ <locs do.
  NB. If the user typed a new locale, ignore it and reset
  NB. the previous value
  jdb_wd 'set locs items ',jdb_toDEL SMLOCS
  jdb_wd 'set locs select ' , ": SMLOCS i. SMLOC
else.
  jdb_stoplocaleset locs
end.
jdb_lxson''
)


NB. =========================================================
SYSTEMLOCALES =: ;: 'z'
SYSTEMPREFIXES =: ;: 'dissect lint j'
NB. If y is not empty, it is locales to move to the front of the list
NB. for initialization.  In any case, SMLOC is moved to the very front, ahead
NB. of locales in y.  All other locales follow, with system locales culled if
NB. syslocs is 0
jdebug_syslocs_button=: 3 : 0
(0 ". syslocs) jdebug_syslocs_button y
:
NB. Repopulate locale list, preserving the current selection.
NB. But if the current selection is not available, revert to base

NB. Get the list of all locales
lc=. (18!:1[0), 18!:1[1
NB. IF we are not to show system locales, remove them from the list.  Remove numbered locales too
if. 0 = x do.
  lc =. (#~   [: -. [: +./ SYSTEMPREFIXES ([ -: #@[ {. ])&>/ ]) lc -. SYSTEMLOCALES
  lc =. (#~   *@#@(-.&'0123456789')@>) lc
end.
NB. Put the privileged locales in y first, followed by the rest.  Save
NB. these as SMLOCS.   Note that the current selection always ends up as
NB. first item
jdb_wd 'set locs items ',jdb_toDEL SMLOCS =: (,   lc -. ]) SMLOC , y
jdb_wd 'set locs select 0'
0 0$0
)

NB. =========================================================
NB. utilities
NB. =========================================================

NB. =========================================================
NB. jdbstop_getcurrentname
NB. returns: name locale
jdbstop_getcurrentname=: 3 : 0
ndx=. 0 ". name_select
ndx { SMNAMES
)

NB. =========================================================
NB. jdbstop_getnameat
jdbstop_getnameat=: 3 : 0

'pos name'=. (0 ". slines_select) jdb_getnameat slines

if. 0 = #name do. '' return. end.
loc=. {: SMNDX { SMNAMES
fullid=. loc jdb_fullname name
pos;name;<fullid
)

NB. =========================================================
jdb_stoplocaleset=: 3 : 0
bloc=. jdb_boxopen y
ndx=. SMLOCS i. bloc
idx=. 0

if. bloc -: CX do.
  idx jdb_stopswritedef STNAMES
else.
  18!:4 bloc
  ids=. 4!:1 [ 1 2 3
  18!:4 <'jdebug'
  idx jdb_stopswritedef ids ,. bloc
end.

jdb_wd 'set locs select ',": ndx
SMLOC=: bloc
)

NB. =========================================================
NB. returns success flag
jdb_stopname=: 3 : 0
if. 0 = #y do. 0 return. end.
jdb_wd 'set locs items;setenable locs 0'
y=. jdb_fullname y
nms=. ~. y,SMNAMES,NAME;LOCALE
if. 0 jdb_stopswritedef nms do.
  STNAMES=: ~. y, SMNAMES
  1
else.
  0
end.
)

NB. =========================================================
NB. jdb_stoprefresh
NB. x is (name;loc) to use; if omitted, use the one selected by name_select
NB. If y is given, it is a line#: select the line and setfocus on stops
NB.   (the call was from a user click).  If y omitted, do no window action
jdb_stoprefresh=: 3 : 0
(jdbstop_getcurrentname'') jdb_stoprefresh y
:
'rep both count'=. jdb_stoprep x
if. #y do.
  srep=. jdb_listboxed rep
  jdb_wd 'set slines text *', srep
  sel=. 2 $ y
  jdb_wd 'set slines select ',":sel, 0
  jdb_wd 'setfocus slines'
end.
SMBOTH=: both
SMCOUNT=: count
)

NB. =========================================================
NB. jdb_stoprep - get representation for given name
NB. form: jdb_stoprep name
NB. returns: rep; both; countmonad, countdyad
NB.
NB. both is 1 if both monad and dyad reps are identical,
NB. in which case the display is as for monad, but both
NB. monad and dyad stops are updated.
NB.
NB. y is name;locale
jdb_stoprep=: 3 : 0

name=. jdb_boxopen y
rep=. jdb_getdrep name
lname=. ; name ,&.> '_'
both=. 0

if. 0=#rep do. '';0;0 0 return. end.

tac=. -. jdb_isexplicit lname
cls=. 4!:0 <lname
'cls rep0 rep1'=. (tac,cls) jdb_boxrep rep

if. rep0 -: rep1 do.
  if. cls=4 do.
    rep0=. ''
  else.
    both=. 1
    rep1=. ''
  end.
end.

cod0=. jdb_codelines rep0
cod1=. jdb_codelines rep1
num0=. #rep0
num1=. #rep1

if. num0 do.
  stp0=. jdb_stopgetone name,0;num0;cod0
  r=. stp0 ,&.> jdb_indexit rep0
else.
  r=. ''
end.

if. num1 do.
  stp1=. jdb_stopgetone name,1;num1;cod1
  r=. r, <' [:] ',40#'-'
  r=. r, stp1 ,&.> jdb_indexit rep1
end.

r; both ; num0, num1
)

NB. =========================================================
NB. index jdb_stopswritedef names
NB. returns success
jdb_stopswritedef=: 4 : 0
NB. empty if no objects in locale...
if. 0 e. #y do.
  jdb_stopswritedefone ''
else.
  'rep both count'=. jdb_stoprep x { y
  jdb_stopswritedefone rep;both;count;x;<y
end.
)

NB. =========================================================
jdb_stopswritedefone=: 3 : 0
if. 0 e. #y do.
  jdb_wd 'set name items;set slines text'
  SMNAMES=: i.0 2
  SMNDX=: 0
  SMCOUNT=: 0 0
  0
else.
  'rep both count ndx nms'=. y
  slines_select=: ''
  'dbgnames dispnames' =. jdebug_debugnametodisp nms
  name_select=: ": SMNDX =: dbgnames i. ndx { nms
  SMNAMES =: dbgnames
  jdb_wd 'set name items ',jdb_listboxed {."1 dispnames
  jdb_wd 'set name select ', ": SMNDX
  jdb_wd 'set name select ',name_select
  jdb_wd 'set slines text *', jdb_listboxed rep
  jdb_wd 'setenable name 1;setenable slines 1'
  SMBOTH=: both
  SMCOUNT=: count
  *#rep
end.
)

NB. =========================================================
NB. y is a fullname (i. e. name;loc) or a table of them
NB. If debug names are deleted, we delete them from the incoming name list
NB.
NB. If the name is a debug name, we change it back to the original name
NB. If the name is an original name and the corresponding debug name is
NB.  defined, we change the name to 'original (header)'
NB.
NB. The names are returned in accidental order.  Unused debugging names are deleted
NB.
NB. Result is (table of debugnames after deletions);(table of display names after deletion)
jdebug_debugnametodisp =: ,&.>/ @: ((3 : 0)/.~   1&{"1) @: (,:^:(1=#@$))
NB. Now y is a table of fullnames all in the same locale
dispnms =. nms =. 0 {"1 y
loc =. (<0 1) { y
NB. Get the debug names in the locale
cocurrent loc
ids=. 4!:1 [ 1 2 3
cocurrent <'jdebug'
if. #dids =. (#~   DEBUGNAMESUFFIX&([ -:"1 -@#@[ {.&> ])) ids do.
  NB. For each debug name, get the corresponding original name
  NB. and the header name
  oids =. (-#DEBUGNAMESUFFIX) }.&.> dids
  NB. If the original name is not a single line, it must have been reloaded
  NB. by the user.  Expunge the debug name in that case, and delete it
  if. #deadoids =. (#~  loc&jdebug_ismultiline) oids do.
    deaddids =. ,&DEBUGNAMESUFFIX&.> deadoids
    dids =. dids -. deaddids
    oids =. oids -. deadoids
    nms =. nms -. deaddids
    4!:55 ,&(,&'_')&.>/"1 deaddids ,. loc
  end.
  NB. Translate the headers - but only the ones that still have debug names
  hids =. ,&' (header)'&.> oids
  NB. Translate debug to original, and original to header
  dispnms =. (hids,oids,nms) {~ (oids,dids,nms) i. nms
end.
(nms,.loc) ,&< (dispnms,.loc)
)


NB. =========================================================
NB. Convert display name to debug name
NB. if name ends with (header), remove that
NB. otherwise, if there is a debugname, switch to it
NB. y is a fullname (name;locale), result is a single fullname
jdebug_dispnametodebug =: 3 : 0
nm =. 0 {:: y
if. DISPNAMESUFFIX ([ -: -@#@[ {. ]) nm do. nm =. (-#DISPNAMESUFFIX) }. nm
elseif.
cocurrent (1 { y)
ids =. ({.nm) 4!:1 [ 1 2 3
cocurrent <'jdebug'
(<nm,DEBUGNAMESUFFIX) e. ids
do.
  nm =. nm,DEBUGNAMESUFFIX
end.
nm ; 1 { y
)

NB. =========================================================
NB. Replace a definition with a header by two defs, for header & body
NB. y is a fullname (name;locale), result is new fullname
NB.  the name must be defined in the locale itself (not merely in the path)
NB.
NB. If the name is for an explicit definition with a header
NB. (example: hverb =: 3 : 0"0),
NB. create a new name for the explicit part and replace the
NB. original name with a reference to it, as in
NB. hverb =: d7B2g0hverb"0
NB. d7B2g0hverb =: 3 : 0
NB.    (body of hverb)
NB.
NB. If the name is in suspension, we can't modify it
NB.
NB. If we split the name, we return the name of the debug name
NB. If the name has already been split, we return the debug name
jdebug_splitheader =: 3 : 0
NB. To be a candidate for change, the verb must be a
NB. multiline definition, with the first line containing exactly one
NB. sequence of [1234] : 0 plus some other stuff.
NB. This definition implies that once we have split a definition,
NB. neither part will be split again
nm =. 0 {:: y
loc =. 1 { y
ld =. 5!:5 <nm,'__loc'  NB. Linear definition
if. (LF,')') -: _2 {. ld do.  NB. multiline definition
  'l1 ln' =. LF (taketo ; takeafter) ld
  if. 3 < # l1w =. ;: l1 do.  NB. More than just n : 0
    if. 1 = #cox =. I. 2 (;:':0')&-:\ l1w do.  NB. Positions of :0 - must be only one
      cox =. {. cox
      if. 4 > exptype =. ('1234' ;&,"0 '0') i. ((_1 1 + cox) { l1w,a:)  do.
        keepcom =. 9!:40''
        9!:41 'NB.' +./@:E. ln   NB. If definition contains comments, preserve them
        NB. Create the new name
        ((dnm =. nm,DEBUGNAMESUFFIX),'__loc') =: (>:exptype) : (}: ln)  NB. remove trailing )
        NB. Replace the pattern with the new name.  If the name is in suspension, this will fail
        try.
          ". (nm,'__loc =: ') , ;:^:_1 ('';dnm;'') (_1 0 1 + cox)} l1w
          NB. point user to the modifiable part
          nm =. dnm
        catch.
          NB. error replacing header; remove the debug name
          4!:55 <dnm,'__loc'
        end.
        NB. Restore comment status
        9!:41 keepcom
      end.
    end.
  end.
elseif. (dnm =. nm,DEBUGNAMESUFFIX) +./@:E. ld do. nm =. dnm
end.
nm ; loc
)

NB. =========================================================
NB. x is locale (boxed), y is name (boxed)
NB. Result is 1 if the name is a multiline definition (i. e. not tacit)
jdebug_ismultiline =: 4 : 0"0
(LF,')') -: _2 {. 5!:5 <(>y),'__x'
)

NB. =========================================================
jdebug_locs_button=: jdebug_locs_select
jdebug_name_button=: jdebug_name_select
jdebug_stopall_button=: jdbstop_stopall_button
jdebug_stopclose_button=: jdebug_mainwin
