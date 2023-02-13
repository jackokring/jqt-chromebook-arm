NB. general/misc/lint
NB. check syntax of a script and load it
NB. main functions:
NB.  lint    check a file
NB.  exppatt regex pattern for finding explicit definitions

NB. TODO:
NB. bug: a__b__c will find local b, but only b in c should be found
NB. translate internal names back into primitives for postmortem
NB. check for side effect of inverse
NB. Label grid window in case multiple scripts
NB. handle multiple scripts, with chaining of globals?
NB. Run on all system scripts
NB. do better with gerunds
NB. do better with checking safety of explicit defns & 1-line modifiers
NB. need to keep track of which source words the stacked items come from

cocurrent 'lint'
require 'regex'
require 'strings'
3 : 0 ''  NB. IFGUI = 0 no GUI, return result, =1 use grid (J6 NOCONSOLE), =2 use QT
if. IFQT do. IFGUI=: 2   NB. J8 with QT
elseif. 0 > 4!:0 <'IFCONSOLE' do. IFGUI=: 0  NB. J8 without QT, i. e. JCONSOLE
elseif. do. IFGUI=: -. IFCONSOLE  NB. J6
end.
if. IFGUI = 1 do.
  require 'grid'
end.
''
)
LINT=: 0 : 0
pc lint;
minwh 10 10;cc text table;
pas 0 0;pcenter;
rem form end;
)

lintwindow =: 3 : 0  NB. Run lint on current window, used in J8 function keys
NB.?lintonly WinText_jqtide_ =. ''
if. (;: 'edit edit2') e.~ <wd 'sm get active' do.  NB. If user is in an edit window
  if. #fd =. wd :: (''"_) 'sm get edit' do.  NB. See which file is being edited
    if. \: 8 4 6 ,:~ _3 {. 0&".;._2 '.' ,~ LF taketo 'Library:' takeafter JVERSION do.
      wdinfo 'Upgrade required';'The lint function key requires J8.04 or later.'
    else.
      fn =. > (1&{"1 fd) {~ (0&{"1 fd) i. <'file'  NB. fetch filename
      wd 'sm save edit'
      smoutput '   lint ',5!:5 <'fn'
      lint <fn
    end.
  end.
end.
i. 0 0
)

NB. Maximum line length that we will try to display in a grid cell

MAXLINELEN=: 300

NB.*lint v check syntax of a script and load it
NB.-descrip: Load a J script and perform static analysis
NB.-
NB.- lint tries to find errors before a script is run.  The idea is for 'lint' to replace 'load'
NB.- during debugging.  The errors it looks for are:
NB.-  explicit definitions lacking trailing )
NB.-  undefined names, including names not defined in all paths
NB.-  verbs used with invalid valences
NB.-  non-noun results at the end of condition blocks and verbs
NB.-  syntax errors
NB.-  sentences with no effect on execution (eg verb verb)
NB.-
NB.- lint first loads the script, then extracts the explicit definitions and parses them one by one.
NB.- Each definition is executed in the locale it is loaded into.  Each line of the definition
NB.- is executed in "safe mode" where verbs that have side effects, such as file operations, are
NB.- not performed.  Global variables are used by the execution, but all assignments are
NB.- simulated without changing the global environment.  The execution has access to any globals
NB.- that are defined after the script is loaded (including definitions from other scripts)
NB.-
NB.- If a verb uses global variables defined in another verb, the dependent verb should follow the
NB.- defining verb in the script, and the NB.?lintsaveglobals directive should be used (see below).
NB.- Any verb named 'create' or whose name ends with '_run' will automatically its globals made
NB.- available to subsequent definition as if NB.?lintsaveglobals had been the last sentence of
NB.- the verb.
NB.-
NB.- Any changes to the locale must be made using the 'cocurrent' or 'coclass' verbs.  The
NB.- starting locale is 'base'.
NB.-
NB.- Coding Tip: conditions that are meant always to test true should be left empty.  This will
NB.- produce better flow analysis.  In other words, write
NB.- while. do.    rather than   while. 1 do.
NB.- and
NB.- elseif. do.   rather than   elseif. 1 do. in the last prong of a conditional
NB.-
NB.- Lint Directives
NB.- Lint Directives are comments beginning with NB.?lint .  These give additional control of the checking.
NB.-
NB.- NB.?lintmsgoff   suppresses display of messages starting with the next line
NB.- NB.?lintmsgon    resumes display of messages starting with the next line
NB.- NB.?lintonly ...    Executes ... (in safe mode) during checking.  This is useful to establish a
NB.-  valid value for a name during checking, to avoid a syntax error.
NB.- NB.?lintsaveglobals   Any global names that have been set by the current definition will be added
NB.-  to a list of such names that is passed in to later definitions.  Use this when one verb is
NB.-  known to be executed before others, and creates globals that the later verbs depend on.  Use
NB.-  in concert with NB.lintonly to solve other problems of initialization.  Note that the definitions are the
NB.-  ones in effect when the directive is scanned.
NB.- NB.?lintloopbodyalways  in the B block of for. or while., indicates that the loop body is always executed
NB.- NB.?lintformnames formname   the formname must be a form; all cc lines in the form create a variable of the controlname
NB.-  (and name_select for selection controls)
NB.-usage: [msglevel] lint filenames...
NB.-y: The names of the scripts to be checked.  For the nonce, only one script will be checked
NB.-result: Table of (line number);(error message) for each error.  If there is no error, a
NB.- congratulatory message is typed; if errors are found, a grid is launched to display the result
NB.- if msglevel=0 (default), the error messages are emptied if a grid is displayed; if msglevel=1, the errors
NB.- are always returned
NB.-author: Henry H. Rich, August 2012
NB.-eg: lint '~addons/math/misc/amoeba.ijs'
lint=: 3 : 0
0 lint y
:
msglevel=. x
fls=. getscripts_j_ y

NB. Read in the script, cut to lines with LF removed
lines=. <;._2 CR -.~ LF ,~^:(~: {:) 1!:1 sourcefn=. {. fls

NB. Find the starts of explicit definitions, using exppatt.
NB. Discard comment if any, and throw out quoted strings (because the assignment of Note contains quoted 00 : 0)
NB. Change exppatt to accommodate other patterns
NB. First find start of nouns
nstartx=. I. _1 ~: (<0 0)&{::@(exppattn&rxmatch)@> explines=. (#~   '''' ~: {.@>)@:(}:^:('NB.' -: 3 {. >@{:))&.;: :: (''"_)&.> lines
NB. Then everything else, and make sure nouns are included
estartx=. ~. /:~ nstartx , I. _1 ~: (<0 0)&{::@(exppatt&rxmatch)@> explines

NB. Find the ends of explicit definitions: ')' by itself
eendx=. I. ((,')') -: -.&' ')@> lines

NB. clear accumulating list of messages
emsgs=. 0 2$a:

NB. Find starts that share an end, or have no end.  If the first of a shared group of starts is a noun,
NB. we'll ignore it; otherwise flag all but the last as errors.  Install a bogus high start value to guarantee
NB. that the last box of results has the trailing unended.
sharedstarts=. (</.~   eendx&I.) estartx,_
if.  #missend=. ; ((#~  nstartx -.@:e.~ {.@>)@}: , {:) }:&.> sharedstarts do.
  emsgs=. emsgs , missend ;"0 <'definition is missing trailing )'
end.
NB. Remove all but the first start sharing an end from the list of starts.  This prevents us from going into
NB. a noun and putting in our collector there, where it will just become part of the noun
estartx=. estartx -. ; }.&.> sharedstarts

NB. Find ends that share a start or have no start.  Type the previous start.  You could make a case for
NB. not detecting these until after there has been an error on load, because
NB. sometimes a user will start two explicits on the same line, and we don't want to complain until there is trouble; but
NB. the argument the other way is that if the user left out a verb header, the contents of that verb
NB. are going to run during load, which is bad.  We will enforce matchup of parens.  If the user wants multiple
NB. starts on one line we'll have to check for it, or he can't use lint.
if.  #missstart=. I. estartx (I.  (= +. -.@:~:@[) 0:) eendx do.
  emsgs=. emsgs , (missstart{eendx) ;"0 < ') outside of explicit definition'
end.
if. 0 = #emsgs do.  NB. If no errors, continue checking
NB. Replace each explicit-defining line with our name-collector, and load the lines
NB. In our collector, we have to check the name for validity right away, because the same name may be
NB. reloaded later.  That makes this a rather long line
  expnames=: 0 2$a:
  nlines=. estartx ('expnames_lint_ =: expnames_lint_ , (<',(":@[),') ,.~ (#~   (1 2 3 e.~ 4!:0) *. ('' : '' +./@:E. 5!:5)"0) (4!:5@0: ] 1: 4!:5@[ (".@[ 4!:5@1:))' , '''' ([,[,~ ] #!.''''~ 1 j. =) ])&.> estartx { lines
  
  try.
    cocurrent 'base'   NB. In case no locale given, load into base
    3 : '0!:100 y' ; ,&LF&.> nlines estartx} lines  NB. Make an explicit verb to avoid corruption of locals here
    cocurrent 'lint'
  catch.
    cocurrent 'lint'
NB. try to analyze the error.  If we can get the line number, put the error into our format; else type and die
    syserr=. > (errnum=. <:13!:11'') { 9!:8''  NB. string form of emsg
    sysstg=. 13!:12''
    NB.?lintonly sysstg =. 4 # LF
    elineno =. ectllineno =. _100000
    if. LF = {: sysstg do.
      elineno=. _100000 ([: {. -@". , [) }. }: '\[.*?\]' rxfirst ; {: <;._1 sysstg
      ectllineno=. _100000 ([: {. ". , [) }. }: '\[.*?\]' rxfirst 1 {:: <;._1 sysstg,LF
    end.
    if. (errnum = 22) *. (elineno = _100000) do.  NB. control error
      smoutput 'Control error during load.  The message was:',LF,sysstg
      if. ectllineno ~: _100000 do.
        smoutput 'This means that line number ' , (":ectllineno),' of the indicated function contains a mismatched control word.'
      end.
      smoutput 'If the function is bivalent, you need to check both valences'
      emsgs return.
    elseif. elineno ~: _100000 do.
      estg =. syserr , ' encountered during loading the file'
      if. errnum = 15 do.  NB. spelling error
        if. 2 < #elines =. <;._2 sysstg , LF do.
          if. '|' = {. caretline =. 2 {:: elines do.
            eword =. '.' dropafter (caretline i. '^') }. 1 {:: elines
            if. (<eword) e. ,&'.'&.> ;: 'assert break continue for goto label if do else elseif end return select case fcase throw try catch catchd catcht while whilst' do.
              estg =. 'control word ' , eword , 'not allowed outside of a definition'
            end.
          end.
        end.
      end.
      emsgs=. emsgs , elineno ; estg
    elseif. do.
      smoutput 'Unexpected error during load.  The message was:',LF,sysstg
      emsgs return.
    end.
  end.
  if. 0 = #emsgs do.  NB. If no errors, continue checking
NB. Now we have the list of global names assigned when an explicit definition was created, and the line number.
NB. Discard any nouns, and then discard anything that doesn't have ' : ' in the first line of its definition.
NB. Then discard duplicates.  This should be enough of a name to identify the explicit definition, and we will
NB. use it to establish the locale of the definition
NB. obsolete     expnames =: (#~    1 2 3 e.~ 4!:0@:({."1)) expnames  NB. keep adv conj verb
NB. obsolete     expnames =: (#~    (' : ' +./@:E. 5!:5)@{."1) expnames  NB. keep explicit defn
    expnames=: (#~    ~:@:>@:({:"1)) expnames   NB. discard duplicates
    
NB. If no externals, quit... but it's suspicious
    if. 0 = #expnames do.
      smoutput 'No explicit definitions found.'
      emsgs return.
    end.
NB. Bring in the lines that are lint-only lines.  Remove the header, leaving the space.  We don't load
NB. the lint-only lines, because we want to be able to use lint as a replacement for load
    lines=. ((] {~ [: <@<@< (i. 12) + [)^:(<#)~&.>    'NB.?lintonly '&(i.&1@:E.)@>) lines
    
NB. Collect name;startline#;<lines for all the explicit definitions.  There may be surplus )s here.
    expdefs=. (,.    lines <@(];.0~ ,.)"_ 1 eendx (] ([ ,. -~) I. { [) [: >: 1&{::"1) expnames
    
NB. Create the table of all defined names (but not in objects)
    findglobalname=: e.&(listglobalnames '')
    
NB. Init the table of names that will be carried through the file
    persistentnames=: 0 3$a:
    
NB. Init no verbose typeout
    debuglevel=: 00
    
NB. Init the table of message-control commands.  Nonneg means messages on, negative means off.
NB. We start with messages enabled.  The setting applies to the number in the list, which
NB. is the line after the directive
    messageenable=: 0   NB. 0 = start on
    
NB. check each explicit name, creating list of errors
    emsgs=. emsgs , ; <@checkexplicitdefs expdefs
NB. Remove any error messages that were disabled by directive
    emsgs=. emsgs #~ 0 <: ((/: |) messageenable) (<:@(I.~ |)~ { [) >: > 0 {"1 emsgs
    
    4!:55 <'findglobalname'
NB.?lintsaveglobals
  end.
end.
NB. We have the list of errors
NB. display them in a grid, along with the source lines
if. #emsgs do.
NB. Sort emsgs on fraction, so the grouped messages come out in the right order
NB. Collect multiple errors per line into one big emsg, with LF in between
NB. Put messages for all parts of the same line into the line, by removing fractional part of line
  emsgs=. (<.&.>@{."1 (~.@[ ,. <@}:@;@:(,&LF&.>)/.) 1&{"1) /:~ emsgs
  if. IFGUI e. 1 2 do.
NB. If there is a long line, truncate it and make a note in the error messages
    ecount=. (":#emsgs),' errors found in'
    esfn=. >sourcefn
    if. MAXLINELEN < >./ #@> lines do.
      esfn=. esfn , LF , 'Lines displayed here are truncated to ' , (":MAXLINELEN) , ' characters'
      lines=. ({.~   MAXLINELEN <. #)&.> lines
    end.
    textlines=. (ecount;esfn) , ((1&{"1 emsgs) ((<:#lines) <. 0&{::"1 emsgs)} (#lines) # <'') ,. lines
    if. IFGUI = 1 do.
      gridopts=. ,: 'CELLCOLORS';0 0 0 240 240 240 ,: 255 0 0 240 240 240
      gridopts=. gridopts , 'CELLCOLOR';1 0
      gridopts=. gridopts , 'CELLFONTS';< '"Courier New" 10';'"Arial" 10'
      gridopts=. gridopts , 'CELLFONT';1 0
      gridopts=. gridopts , 'HDRROW';< ' ' ; <@":"0 i. # lines
      try.
        NB.?lintonly grid =: load
        gridopts grid textlines
NB. If messages have gone to grid, don't return them, unless asked for
        if. msglevel = 0 do. emsgs=. 0 2$a: end.
      catch.
        smoutput 'Error displaying grid'
      end.
    else.
      wd LINT
      textlines=. (,.~    (<'') 0} <@":"0@:i.@#) textlines
      wd 'set text shape *' , ": $ textlines
      wd 'set text data *' , ; (DEL ,~ DEL , ])&.> textlines
      wd 'set text block 0 _1 1 1'
      wd 'set text color "#ffffff" "#ff0000"'
      wd 'set text block 0 _1 0 _1'
      wd 'set text resizecol'
      wd 'set text resizerow'
      wd 'pshow'
      if. msglevel = 0 do. emsgs=. 0 2$a: end.
    end.
  end.
else.
  smoutput 'No errors found'
end.
emsgs
)
lint_cancel=: 3 : 0
wd 'pclose'
)
lint_close=: lint_cancel

NB.*exppatt n pattern to match the start of an explicit definition
NB.-descrip: regex pattern to detect start-of-explicit-definition
NB.-note: modify if you have novel ways of starting an explicit definition
exppattn=: rxcomp '(?:^\s*|[^a-zA-Z0-9_])(?:(?:0|noun)\s+define(?:\s|$)|(?:noun|0)\s+:\s*0|Note(?![a-zA-Z0-9_])\s*(?!\s)(?!=[:.]))'
exppatt=: rxcomp '(?:^\s*|[^a-zA-Z0-9_])(?:0|1|2|3|4|13|noun|verb|adverb|conjunction|monad|dyad)\s+(?:define(?:\s|$)|:\s*0)'

NB. nilad.  return list of all names globally defined anywhere
listglobalnames=: 3 : 0
akwnshcgtus4kgh_z_=. 4!:1
akwnshcgtus4kgh=. ''
for_y. (#~ [: -. '0123456789' e.~ {.@>) akwnshcgtus4kgh_z_ 6 do.
  akwnshcgtus4kgh=. akwnshcgtus4kgh , ,&('_',(>y),'_') &.> (;: 'akwnshcgtus4kgh y x') -.~ ('akwnshcgtus4kgh_',(>y),'_')~ 0 1 2 3
end.
4!:55 <'akwnshcgtus4kgh_z_'
akwnshcgtus4kgh
)

NB. Names that are used for form events, depending on which word they're in
formeventnames =: <;._2&.> ('close cancel ') ; (0 : 0)
button
select
changed
char
resize
paint
focus
focuslost
mwheel
initialize
mmove
mbldown
mbldbl
mblup
mbrdown
mbrdbl
mbrup
mbmdown
mbmdbl
mbmup
bufferstatus
duration
error
mediastatus
playstate
position
volume
curl
)

NB. Check an explicit definition.  Split it into monadic and dyadic parts, if any,
NB. and check each valence with the appropriate initial defined names
NB. y is name;starting line;lines of entity
NB. Result is table of (line number);error message
NB. Side effect: defined globals are saved for use in later verbs if this verb is flagged with ?lintsaveglobals
checkexplicitdefs=: 3 : 0"1 2 1
'name lineno lines'=. y
NB. Figure out what kind of explicit definition we are dealing with
exptype=. '1234' i. {: ' : ' taketo 5!:5 <name
NB. if noun or unknown type, give error
if. exptype > 3 do.  NB. 0123 = adv conj verb dyad
  ,: lineno ; 'Undecipherable explicit definition' return.
end.
NB. set the locale name to use for this verb, and initial values for noun-result and nugatory sentence, and the loopbodyalways stack
NB. The LBA stack is inited to nonempty so that a misplaced loopbodyalways will not cause index error
defnames=. persistentnames addnames ('$LOC';'$NNU';'$LBA') ,. (<$0) ,. ('_' taketo&.|. }: name) ; (2#<$0) ;< ,0

NB. split into valences
valences=. (<,':')&([ ((-: -.&' ')&> <;._1 ]) ,) lines
NB. Create the list of  starting variables
stvbls=. (defnames , {&startvbls)&.> (#valences) {. exptype { 4 2 $ 1 2 3 ;0 1 2 3;1 2 3 4 5;0 1 2 3 4 5;1;0 1;0 1;$0
NB. If the name looks like a form event, define the names associated with the form,
NB. if there are any
NB. Split the name on _; there should be 2 or 3 names
if. 3 4 e.~ #fmnm =. <;._2 name do.
  NB. See if the last name is a handler name in its position
  if. (_2 { fmnm) e. (_3 + #fmnm) {:: formeventnames do.
    NB. It might be a form event.  The last part of the name fits
    if. 1 < #$formvars =. (stvbls) createformnames (toupper&.> {. fmnm) , (<<<0 _1) { fmnm do.
      NB. No error looking up the form, so append the form vars
      stvbls =. addnames&formvars&.> stvbls
    end.
  end.
end.

NB. get vbls , emsgs for each valence
ve=. (((>: lineno + |.!.0 >:@#@> valences),.(exptype>:2)) ;"1 0 stvbls) checkvalence valences

NB. If the name of a verb is 'create' or '..._run', perform an automatic saveglobals function on both valences
NB. create produces globals used by its objects; _run, by its form
if. (exptype >: 2) *. ('create'&-: +. '_run' -: _4&{.) '_' takeafter&.|. }: name do.
  addpersistentnames 0 {"1 ve
end.

emsgs=. ; 1 {"1 ve
emsgs
)

NB.
NB. Convert text of a verb into a sequence of blocks.  A block is a single control word
NB. or a list of sentences.  Each block is associated with the starting line it came from.
NB. we remove comments here.
NB. y is (starting line number);(list of boxed lines)
NB. result is 0 if no error, 1 if error (empty definition)
initblockreader=: 3 : 0
'stline lines'=. y
NB. tokenize each line and remove comments - except for lint directives
try.
  lines=. }:^:(1 0 -: ('NB.';'NB.?lint') ([ -: #@[ {. ])&> {:)@;:&.> lines
catch.
  elines =. ''"_@;: :: ] &.> lines
  smoutput 'Syntax error in lintonly code:'
  smoutput ; ,&LF&.> elines
  1 return.
end.
NB. for each line, find control words; then recollect sentences between control words; then
NB. append the line number of the line. run all the blocks together.  This deletes empty sentences, too
NB. For multiple blocks on the same line (caused by control words), give them fractional parts to
NB. distinguish them
iscw=. ('NB.' -: 3&{.)@> +. e.&controlwords@(('_'&taketo)@}:&.>) *. ('.'={:)@>  NB. verb, applied to boxed word.  Any remaining comment must be a lint directive
if. #nl=. ; (stline + i. # lines) ( ( (+   (%~ i.)@#)~  ;"0   [ )~  (<@(;:^:_1);.1~ (+. |.!.1)@iscw))&.> lines do.
NB. assert. is funny: it takes one sentence, which may be in the current line or the next line.
NB. We will discard assert. blocks, since they may not be executed depending on global settings; so we
NB. delete assert. and the sentence following.
  nl=. ((*. |.!.1) ({:"1 nl) ~: <'assert.') # nl
NB. The blocks are blocks of line;sentence.  If the block is a list, it's a control word.  If it's a table,
NB. it's a table of executable sentences, each with its line number
NB. Prepend a dummy control word to handle the leading sentences
  readblocks=: (<0 2$a:) -.~ }. , (({. ,&< }.);.1~   iscw@({:"1)) (0;'assert.') , nl
NB. set the read pointer to the first block
  readblockx=: 0
  0
NB.?lintsaveglobals
else.
NB. The code above fails if there are no lines; but it turns out (J6.02 bug) that an empty
NB. explicit definition gives a domain error anyway; so we report the case as an error
  1
end.
)

NB. Check a single valence.
NB. x is (linenumber,isverb);initial variables
NB. y is <(the boxed lines)
NB. result is ending variables inline;<error messages
NB. We look at $NNU to find the lines that make it to the result.
NB. Remove them from the nugatory list, and then complain about all that are left
checkvalence=: 4 : 0"1 0
'lv startvbls'=. x
'lineno isverb'=. lv
lines=. >y
NB. Initialize the block reader for the lines.  If there are no lines, fail
if. initblockreader lineno;<lines do.
NB. Don't give message.  empty cases are legal, and missing valences will be detected on use, mostly
NB.  emsgs =. ,: lineno ; 'empty definition is not allowed'
  emsgs=. 0 2$a:
else.
  
NB. clear the list of nugatory lines that have not been accepted
  nugatories=: $0
  
NB. Parse the controls by recursive descent.  When we get a block of lines, parse them using
NB. our emulative parser.  Keep track of variable definitions.
  if. (readblockx < # readblocks) +. (1 >: #r=. cparse_statement startvbls;(0 3$a:);<(0 3$a:)) do.
NB. It's an error if the parser recognized failure, or if it failed to consume some lines
    emsgs=. ,: lineno ; 'Control error'  NB. should not occur
  else.
    'startvbls bvars rvars emsgs'=. r
NB. Account for all the ways we can make it to the result of the entity
    rvars=. startvbls namesintersectu rvars
NB. remove any lines that create a result from the nugatories, and then give messages for what remains
NB. Remove any nugatories from the error list.  They are OK, since they contributed to this T block
    nugatories=: nugatories -. 1 {:: r=. 1 {:: ('';<rvars) lookupname <'$NNU'
    emsgs=. emsgs , nugatories ;"0 <'Sentence has no effect'
NB. If the explicit definition is a verb, make sure it returns a noun
    if. isverb do.
      emsgs=. emsgs ,~ (0{::r) ;"0 <'non-noun value may become result of verb'
    end.
  end.
NB.?lintsaveglobals
end.
NB. We return the inline variable, which we may add to the persistent names
startvbls;<emsgs
)

NB. anything beginning with one of these words and ending with . is a control word
controlwords=: ;: 'assert break continue for goto label if do else elseif end return select case fcase throw try catch catchd catcht while whilst'
NB. these control words begin structures
controlwordsstart=: ;: 'break continue for goto label if return select throw try while whilst block NB'
NB. these control words end blocks - statement stops before one
controlwordsend=: ;: 'do else elseif end case fcase catch catchd catcht'

NB. Nilad.  look at next block, and return its control word (or eof for end-of-file, or
NB. block for an executable block of statements)
peekblock=: 3 : 0
if. readblockx >: #readblocks do. <'eof'
elseif. 2 = # $ cw=. readblockx {:: readblocks do. <'block'
elseif. 'NB.' -: 3 {. cw=. 1 {:: cw do. <'NB'
elseif. do.  < '_' taketo }: cw
end.
)

NB. Nilad. return next block, (line number);(sentences) or eof if none
NB. A control word is a single boxed string; a block of sentences is a boxed list of sentences
NB. readblocks is the blocks to return, readblockx is the index of the next block to read
NB. We remove the trailing . from a control word
readblock=: 3 : 0
if. readblockx >: #readblocks do.
  '';'eof'
else.
  r=. readblockx {:: readblocks
  if. 1 = #$ r do. r=. ({. , }:^:('.'={:)&.>@{:) r end.
  readblockx=: >: readblockx
  r
end.
)

NB. Each routine in the recursive-descent parser is called with
NB. y: (variables defined so far, inline);(variables for break);(variables for return)
NB.  the names $LOC, $NNU indicate block status
NB. result is
NB. (variables defined so far, inline);(variables for break);(variables for return);errors
NB. If there is an error (which shouldn't happen, since this has already been verified
NB. during load), just return empty, which will fail up the line
cparse_statement=: 3 : 0
'ivars bvars rvars'=. y
emsgs=. 0 2$a:
NB. Keep parsing until we hit eof.  When we hit eof, we're done
while. do.
NB. peek at the next block.  See if it is the
NB. start of a new control structure.  If it is, go execute that structure.
NB. (statement blocks are the block. type which just does one block)
NB. If not, it must part of the open control structure - return
  if. (p=. peekblock'') e. controlwordsstart do.
    if. 1 >: #'ivars bvars rvars nemsgs'=. ('cparse_control_',>p)~ ivars;bvars;<rvars do. a: return. end.
    emsgs=. emsgs , nemsgs
  else. break.
  end.
end.
ivars;bvars;rvars;<emsgs
)

NB. y is a boxed table of defined names.  The globals therein are added to the
NB. list of persistent names, for use by all subsequent definitions.  If the name is already
NB. defined, OR the types and check for differing value
addpersistentnames=: 3 : 0@>
NB. Remove non-global names; add the rest to the global
comnames=. persistentnames (e. # [)&:(0&{"1) y
newrcds=. persistentnames (comnames ,. 23 b.&.>&:(1&{"1) ,. (<'')"_^:~:"0&:(2&{"1))&({~   comnames i.~ 0&{"1) y
persistentnames=: (#~ ('_' = {:)@>@:({."1)) persistentnames addnames  y,newrcds
i. 0 0
)

NB. x and y are tables of defined names.  Result is table with their intersection.
NB. variables which appear in both lists appear in the result.  If the
NB. type differs, we OR the types together, which will let it parse either way.
NB. We will give a message during parsing.
NB. if the value differs, it is set to unknown ('')
NB. There are 3 special values, $LOC, $NNU, and $LBA.  $LOC is manadatory, giving the locale.  If
NB. it is omitted, it means that the path has no inline validity, i. e. it is dead code.  In this
NB. case, $LBA will still be defined.
NB. The special value $NNU is different - it contains potential errors, and it is
NB. unioned rather than intersected.
NB. $LBA is used as a poor-man's-stack for loops, and will always be the same in all branches
NB. in which it is combined.
NB. $NNU is always unioned between the two operands.  If $LOC is omitted in one path, all the
NB. other variables (except $NNU) are taken from the other path
NB. On top of that, there is one other possibility for coding ease: a list can be
NB. entirely empty, which just means that it wasn't created.  In that case, the other table
NB. is used
namesintersect=: namesintersectu&.>
namesintersectu=: 4 : 0
NB. If either list empty, use the other
if. 0 e. x ,&# y do. x,y return. end.
NB. If $LOC omitted in either list, take everything but $NNU from the other list.
NB. $LBA should still be defined and identical between the lists, so we delete duplicates
if. x +.&((<'$LOC')&(-.@e.))&:({."1) y do.
  newrcds=. (#~ (<'$NNU') ~: {."1) ~. x,y
else.
NB. get names in common
  comnames=. (x (e. # [)&:(0&{"1) y) -. <'$NNU'
  newrcds=. x (comnames ,. 23 b.&.>&:(1&{"1) ,. (<'')"_^:~:"0&:(2&{"1))&({~   comnames i.~ 0&{"1) y
end.
NB. Get the value for $NNU, which is known to be defined always
newrcds , x (2&{.@[ , ~.@,L:0&(2&{))&({~   (<'$NNU') i.~ 0&{"1) y
)

NB. Handle a block of J statements
NB. If the last sentence of the block had no side-effect, add it to the list of possibles
cparse_control_block=: 3 : 0
'ivars bvars rvars'=. y
NB. If $LOC is not defined, it means that the current block cannot be reached.  In that case,
NB. give an error message for the block, and don't try to parse anything
if. ivars isnamedefined '$LOC' do.
  'ivars emsgs'=. ivars parseblock readblock''
  nugatories=: nugatories , (1;1) {:: ('';<ivars) lookupname <'$NNU'
else.
NB. If there are no inline variables, it means that the current block cannot be reached.  In that case,
NB. give an error message for the block, and don't try to parse anything
  emsgs=. ,: ((<0 0) {:: y=. readblock'') ; 'Sentence cannot be reached'
end.
ivars;bvars;rvars;<emsgs
)

NB. if
cparse_control_if=: 3 : 0
'ivars bvars rvars'=. y
NB. discard the control word, which must be if
readblock''
NB. Save the NRE value from before the T block
startnnu=. 1 {:: ('';<ivars) lookupname <'$NNU'
NB. Read the T block.  Create new inline status, which will give the inline status if we go through
NB. a B block.
NB. We handle empty T-blocks specially, because (1) they don't properly generate the noun result
NB. (2) we want to be able to handle elseif. do. as a guaranteed true
emptytblock=. (<'do') -: peekblock''
NB. Before we start looking at the T block, clear the setting of inline variables
tivars=. ivars addnames '$NNU' ; ($0) ;< 2#<$0
if. 1 >: #'tivars tbvars trvars emsgs'=. cparse_statement tivars;bvars;<rvars do. a: return. end.
NB. We'd better be at a do.
if. 'do' -.@-: 1 {:: r=. readblock'' do. a: return. end.
NB. The block must have ended with a noun, or be empty
if. 0 ~: # 0 {:: r=. 1 {:: ('';<tivars) lookupname <'$NNU' do.
  emsgs=. emsgs , (0{::r) ;"0 < 'the test block must produce a noun value'
end.
NB. Remove any nugatories from the error list.  They are OK, since they contributed to this T block
nugatories=: nugatories -. 1 {:: r
NB. read the first B block.  Use the variables established by the T block, EXCEPT that we use inline info
NB. from before the T.  This is to handle the case of  non-NRE/if. x do. else. 1 end. which leaves
NB. a path for the non-NRE to slip through.  So we must reinit NRE for each B block.  But we keep
NB. any names that were assigned in the T block
tivars=. tivars addnames '$NNU' ; ($0) ;< startnnu
if. 1 >: #'b1ivars b1bvars b1rvars nemsgs'=. cparse_statement tivars;tbvars;<trvars do. a: return. end.
emsgs=. emsgs , nemsgs
NB. Now we split depending on the form of the if statement.
select. 1 {:: r=. readblock''   NB. consume the block-end
case. 'end' do.
  NB. if. do. end. - intersect the (modified) T block and the B block.  The only reason not to just take
  NB. the T block is that the NUG and NRE status needs to be combined, even if values cannot be.
  NB. Also, some known names may become unknown.  If the T block was empty, just keep the B block; except
  NB. when the b1ivars are empty: that means the block ended with break/return.  We shouldn't be doing anything
  NB. after that, but in case we do, we need to put something valid in the uivars
  if. (-. emptytblock) +. (0 = #b1ivars) do. 'b1ivars b1bvars b1rvars'=. (tivars;tbvars;<trvars) namesintersect (b1ivars;b1bvars;<b1rvars) end.
case. 'else' do.
  NB. if. do. else. end. - intersect the two B blocks (we know we have to take one path or the other,
  NB.  and NNUs from the start of the if are included in each leg, so we don't need to bring them in.
  NB. but if empty T block, just use the b1 variables
  NB. process the else. block, keeping names defined in the T block
  if. 1 >: #'b2ivars b2bvars b2rvars nemsgs'=. cparse_statement tivars;tbvars;<trvars do. a: return. end.
  emsgs=. emsgs , nemsgs
  if. -. emptytblock do. 'b1ivars b1bvars b1rvars'=. (b2ivars;b2bvars;<b2rvars) namesintersect (b1ivars;b1bvars;<b1rvars) end.
  NB. We'd better be at en end - consume it
  if. 'end' -.@-: 1 {:: r=. readblock'' do. a: return. end.
case. 'elseif' do.
  NB. if. do. elseif do. ... process all the elseifs, incrementally growing the table of T-block-defined
  NB. variables.  Before processing each T, clear the NNU; before processing each B, reset the NNU to the
  NB. values before the T-block started.  Combine the B blocks as we go along.  At the end, if the last T-block
  NB. was empty, we can use the final B block.  If not, we have to intersect it with the final T value, which
  NB. must include restoring the initial NNU value, to account for the possibility that no B block was executed.
  while. do.
    NB. if the previous T-block was empty, this is dead code.  Give a warning
    if. emptytblock do.
      emsgs=. emsgs , (0{r) , < 'the rest of this if-statement will not be executed'
    end.
    NB. T-block processing, as above
    emptytblock=. (<'do') -: peekblock''
    tivars=. tivars addnames '$NNU' ; ($0) ;< 2#<$0
    if. 1 >: #'tivars tbvars trvars nemsgs'=. cparse_statement tivars;bvars;<rvars do. a: return. end.
    emsgs=. emsgs , nemsgs
    if. 'do' -.@-: 1 {:: r=. readblock'' do. a: return. end.
    if. 0 ~: # 0 {:: r=. 1{:: ('';<tivars) lookupname <'$NNU' do.
      emsgs=. emsgs , (0{::r) ;"0 < 'the test block must produce a noun value'
    end.
    nugatories=: nugatories -. 1 {:: r
    NB. now the B block, as above.  We have added to the T block, but we must reset the NNU
    tivars=. tivars addnames '$NNU' ; ($0) ;< startnnu
    if. 1 >: #'b2ivars b2bvars b2rvars nemsgs'=. cparse_statement tivars;tbvars;<trvars do. a: return. end.
    emsgs=. emsgs , nemsgs
  NB. Accumulate variables into the B1 blocks
    'b1ivars b1bvars b1rvars'=. (b2ivars;b2bvars;<b2rvars) namesintersect (b1ivars;b1bvars;<b1rvars)
    NB. consume the next word, and remember it in case we loop back.  If it's end, we're done.  If it's
    NB. elseif, loop around.
    NB. otherwise abort with control error
    select. 1 {:: r=. readblock''
    fcase. 'else' do.
      NB. else. following elseif. - treat just like if. do. else.   Must be followed by end (we fall through to end processing)
      if. 1 >: #'b2ivars b2bvars b2rvars nemsgs'=. cparse_statement tivars;tbvars;<trvars do. a: return. end.
      emsgs=. emsgs , nemsgs
      if. -. emptytblock do. 'b1ivars b1bvars b1rvars'=. (b2ivars;b2bvars;<b2rvars) namesintersect (b1ivars;b1bvars;<b1rvars) end.
      if. 'end' -.@-: 1 {:: r=. readblock'' do. a: return. end.
    case. 'end' do. break.
    case. 'elseif' do.
    case. do. a: return.
    end.
  end.
NB. We have processed up to the end statement.  Now, if there is a possible path through just the
NB. T blocks, account for it
  if. -. emptytblock do. 'b1ivars b1bvars b1rvars'=. (tivars;tbvars;<trvars) namesintersect (b1ivars;b1bvars;<b1rvars) end.
case. do. a: return.  NB. control error, should not occur
end.
b1ivars;b1bvars;b1rvars;<emsgs
)

NB. while do end
NB. Looks just like if do end, but at the end we fold in the break values
cparse_control_while=: 3 : 0
'ivars bvars rvars'=. y
readblock''
startnnu=. 1 {:: ('';<ivars) lookupname <'$NNU'
emptytblock=. (<'do') -: peekblock''
tivars=. ivars addnames '$NNU' ; ($0) ;< 2#<$0
NB. Now we are in recursion on the break vars.  The old ones in bvars will be restored when we finish
NB. This control structure.  We are uncertain about how to handle break in a T block.  Start this structure
NB. with a fresh set of break vars
if. 1 >: #'tivars tbvars trvars emsgs'=. cparse_statement tivars;(0 3$a:);<rvars do. a: return. end.
if. 'do' -.@-: 1 {:: r=. readblock'' do. a: return. end.
if. 0 ~: # 0 {:: r=. 1{:: ('';<tivars) lookupname <'$NNU' do.
  emsgs=. emsgs , (0{::r) ;"0 < 'the test block must produce a noun value'
end.
nugatories=: nugatories -. 1 {:: r
tivars=. tivars addnames '$NNU' ; ($0) ;< startnnu
NB. Push onto the LBA stack
tivars=. tivars addnames '$LBA' ; ($0) ;< 0 ,~ startlba=. 1 {:: ('';<ivars) lookupname <'$LBA'
if. 1 >: #'b1ivars b1bvars b1rvars nemsgs'=. cparse_statement tivars;tbvars;<trvars do. a: return. end.
emsgs=. emsgs , nemsgs
if. 'end' -.@-: 1 {:: readblock'' do. a: return. end.  NB. consume the block-end
NB. Now that we are exiting the block, we need to combine the break and fallthrough paths.  We do this first,
NB. because if the loop ends with break, we will have cleared the fallthrough variables in expectation of their being intersected.  so do it.
b1ivars=. b1ivars namesintersectu b1bvars
NB. If empty T block, we don't need to worry about that path through.  Treat loopbodyalways like empty T-block
if. -. emptytblock +. {: 1 {:: ('';<b1ivars) lookupname <'$LBA' do.
  tivars=. tivars namesintersectu tbvars
  'b1ivars b1rvars'=. (tivars;<trvars) namesintersect (b1ivars;<b1rvars)
end.
NB. Treat loopbodyalways like empty T-block
if. -. emptytblock +. {: 1 {:: ('';<b1ivars) lookupname <'$LBA' do. 'b1ivars b1bvars b1rvars'=. (tivars;tbvars;<trvars) namesintersect (b1ivars;b1bvars;<b1rvars) end.
NB. The break info contains all the other ways to get to end-of-loop; include them and reset
NB. Pop the LBA stack, too
(b1ivars addnames '$LBA' ; ($0) ;< startlba);bvars;b1rvars;<emsgs
)

NB. whilst do end
NB. This really sucks, because we have to apply the globals in the order B T.
NB. Since it's not used much, we implement the following kludge:
NB. Remember where we are in the parse.  Parse the T block and ignore the results. (Save the globals
NB. and the nugatories and restore at end).  Remember where the B block starts.
NB. Parse the B block; reset the pointer and parse the T block.  Then skip to the end of the B block.
cparse_control_whilst=: 3 : 0
'ivars bvars rvars'=. y
readblock''  NB. discard whilst. control
NB. Save status before starting T block
'Tstart Tpnames Tdebug Tmsg'=. readblockx;persistentnames;debuglevel;<messageenable
NB. parse the T block to find its end.  Ignore what it produces
if. 1 >: #cparse_statement ivars;bvars;<rvars do. a: return. end.
NB. Restore the globals; keep the read pointer
'persistentnames debuglevel messageenable'=:  Tpnames;Tdebug;<Tmsg
NB. We'd better be at a do.
if. 'do' -.@-: 1 {:: r=. readblock'' do. a: return. end.
NB. parse the B block.  Keep all its variables, since the T always follows the B
NB. Now we are in recursion on the break vars.  The old ones in bvars will be restored when we finish
NB. This control structure.  We are uncertain about how to handle break in a T block.  Start this structure
NB. with a fresh set of break vars
if. 1 >: #'b1ivars b1bvars b1rvars emsgs'=. cparse_statement ivars;(0 3$a:);<rvars do. a: return. end.
NB. We'd better be at end.
if. 'end' -.@-: 1 {:: readblock'' do. a: return. end.  NB. consume the block-end
NB. Remember where to resume after the end
Bend=. readblockx
NB. reset the read pointer.  Reprocess the T block, remembering its results this time
readblockx=: Tstart
if. 1 >: #'b1ivars b1bvars b1rvars nemsgs'=. cparse_statement b1ivars;b1bvars;<b1rvars do. a: return. end.
emsgs=. emsgs , nemsgs
NB. Audit the results for valid T-block end
if. 0 ~: # 0 {:: r=. 1{:: ('';<b1ivars) lookupname <'$NNU' do.
  emsgs=. emsgs , (0{::r) ;"0 < 'the test block must produce a noun value'
end.
nugatories=: nugatories -. 1 {:: r
NB. Reset the read pointer to after the end
readblockx=: Bend
NB. The break info contains all the other ways to get to end-of-loop; include them and reset
(b1ivars namesintersectu b1bvars);bvars;rvars;<emsgs
)

NB. for[_...] do end
NB. like while, except that in the for_x form we define local x and x_index as nouns, and delete them
NB. after the end statement
cparse_control_for=: 3 : 0
'ivars bvars rvars'=. y
emsgs=. 0 2 $ a:
NB. Save the name if any
'lineno vname'=. readblock''
vname=. '_' takeafter vname
startnnu=. 1 {:: ('';<ivars) lookupname <'$NNU'
if. (<'do') -: peekblock'' do.
  emsgs=. emsgs , lineno ; 'for. must not have an empty selector'
end.
tivars=. ivars addnames '$NNU' ; ($0) ;< 2#<$0
NB. Now we are in recursion on the break vars.  The old ones in bvars will be restored when we finish
NB. this control structure.  We are uncertain about how to handle break in a T block.  Start this structure
NB. with a fresh set of break vars
if. 1 >: #'tivars tbvars trvars nemsgs'=. cparse_statement tivars;(0 3$a:);<rvars do. a: return. end.
emsgs=. emsgs , nemsgs
if. 'do' -.@-: 1 {:: r=. readblock'' do. a: return. end.
if. 0 ~: # 0 {:: r=. 1{:: ('';<tivars) lookupname <'$NNU' do.
  emsgs=. emsgs , (0{::r) ;"0 < 'the test block must produce a noun value'
end.
nugatories=: nugatories -. 1 {:: r
NB. add the names, if they are called for
tivars=. tivars addnames ('$NNU' ; ($0) ;< startnnu) , (*#vname) # (vnames=. vname&,&.>'';'_index') ,"0 1 noun ; ''
NB. Push onto the LBA stack
tivars=. tivars addnames '$LBA' ; ($0) ;< 0 ,~ startlba=. 1 {:: ('';<ivars) lookupname <'$LBA'
if. 1 >: #'b1ivars b1bvars b1rvars nemsgs'=. cparse_statement tivars;tbvars;<trvars do. a: return. end.
emsgs=. emsgs , nemsgs
if. 'end' -.@-: 1 {:: readblock'' do. a: return. end.  NB. consume the block-end
NB. Now that we are exiting the block, we need to combine the break and fallthrough paths.  We do this first,
NB. because if the loop ends with break, we will have cleared the fallthrough variables in expectation of their being intersected.  so do it.
b1ivars=. b1ivars namesintersectu b1bvars
NB. If we're not sure that we execute the loop body, another path is through the inital tblock and then bypassing the loop
if. -. {: 1 {:: ('';<b1ivars) lookupname <'$LBA' do.
  tivars=. tivars namesintersectu tbvars
  'b1ivars b1rvars'=. (tivars;<trvars) namesintersect (b1ivars;<b1rvars)
end.
NB. If the temp names were defined, remove them from the inline vbls.  This will also remove them from the intersection.
NB. They may remain in the return vbls, which doesn't matter since they are locals and will be deleted at the end
if. #vname do. b1ivars=. b1ivars delnames vnames end.
NB. Pop the LBA stack, too
(b1ivars addnames '$LBA' ; ($0) ;< startlba);bvars;b1rvars;<emsgs
)

NB. select T [f]case T do. B ...
NB. this resembles if elseif do except that there is no B block following the first T
NB. if we hit fcase, we intersect its result with the next T block
cparse_control_select=: 3 : 0
'ivars bvars rvars'=. y
emsgs=. 0 2 $ a:
NB. discard the control word, which must be select
lineno=. 0 {:: readblock''
startnnu=. 1 {:: ('';<ivars) lookupname <'$NNU'
if. (<'case') -: peekblock'' do.
  emsgs=. emsgs , lineno ; 'select. must not have an empty selector'
end.
NB. Before we start looking at the T block, clear the setting of inline variables
tivars=. ivars addnames '$NNU' ; ($0) ;< 2#<$0
if. 1 >: #'tivars tbvars trvars nemsgs'=. cparse_statement tivars;bvars;<rvars do. a: return. end.
emsgs=. emsgs , nemsgs
NB. The block must have ended with a noun
if. 0 ~: # 0 {:: r=. 1{:: ('';<tivars) lookupname <'$NNU' do.
  emsgs=. emsgs , (0{::r) ;"0 < 'the test block must produce a noun value'
end.
NB. Remove any nugatories from the error list.  They are OK, since they contributed to this T block
nugatories=: nugatories -. 1 {:: r

NB. Init the block where we accumulate variables for this structure.  Initialize to
NB. the values set in the first T block, which is always executed
'b1ivars b1bvars b1rvars'=. 3$<0 3$a:
NB.?lintonly 'b2ivars b2bvars b2rvars' =. 3$<0 3$a:

emptytblock=. 0  NB. to begin with, previous T was not empty
prevfcase=. 0  NB. first time, no previous fcase
NB. Process all the cases, accumulating t blocks as we go along
while. do.
  select. 1 {:: r=. readblock''
    case. 'end' do. break.
    case. 'case' do. fcase=. 0
    case. 'fcase' do. fcase=. 1
    case. do. a: return.
  end.
NB. if the previous T-block was empty, this is dead code.  Give a warning
  if. emptytblock do.
    emsgs=. emsgs , (0{r) , < 'the rest of this select statement will not be executed'
  end.
NB. T-block processing, as above, but keeping names defined in the T-blocks as they are encounterd
  emptytblock=. (<'do') -: peekblock''
  tivars=. tivars addnames '$NNU' ; ($0) ;< 2#<$0
  if. 1 >: #'tivars tbvars trvars nemsgs'=. cparse_statement tivars;tbvars;<trvars do. a: return. end.
  emsgs=. emsgs , nemsgs
  if. 'do' -.@-: 1 {:: r=. readblock'' do. a: return. end.
  if. 0 ~: # 0 {:: r=. 1{:: ('';<tivars) lookupname <'$NNU' do.
    emsgs=. emsgs , (0{::r) ;"0 < 'the test block must produce a noun value'
  end.
  nugatories=: nugatories -. 1 {:: r
NB. now the B block, as above.  We have added to the T block, but we must reset the NNU.
NB. If the PREVIOUS block was an fcase, we need to chain this block to the previous block's b2,
NB. but only after intersecting with the current T.  This block could have been entered
NB. 2 ways: from the B above or the T, and we account for that
  tivars=. tivars addnames '$NNU' ; ($0) ;< startnnu
  if. prevfcase do.
    if. 1 >: #'b2ivars b2bvars b2rvars nemsgs'=. cparse_statement (tivars;tbvars;<trvars) namesintersect b2ivars;b2bvars;<b2rvars do. a: return. end.
  else.
    if. 1 >: #'b2ivars b2bvars b2rvars nemsgs'=. cparse_statement tivars;tbvars;<trvars do. a: return. end.
  end.
  emsgs=. emsgs , nemsgs
NB. Accumulate variables into the B1 blocks.
NB. If this is an fcase, don't accumulate - wait for the case to come up.  Leave the b2vars accumulating for next time
  if. -. prevfcase=. fcase do.
    'b1ivars b1bvars b1rvars'=. (b2ivars;b2bvars;<b2rvars) namesintersect (b1ivars;b1bvars;<b1rvars)
  end.
end.
NB. If the last case turns out to be an fcase, go back and treat it like a case
if. prevfcase do.
  'b1ivars b1bvars b1rvars'=. (b2ivars;b2bvars;<b2rvars) namesintersect (b1ivars;b1bvars;<b1rvars)
end.
NB. We have processed up to the end statement.  Now, if there is a possible path through just the
NB. T blocks, account for it
if. -. emptytblock do. 'b1ivars b1bvars b1rvars'=. (tivars;tbvars;<trvars) namesintersect (b1ivars;b1bvars;<b1rvars) end.
b1ivars;b1bvars;b1rvars;<emsgs
)

NB. try catch end
NB. The try might be interrupted at any point, so we simply run all the blocks and
NB. intersect their results.  We start each block from the initial variables
cparse_control_try=: 3 : 0
'ivars bvars rvars'=. y
NB. discard the control word, which must be try
readblock''
NB. Init the accumulation variables
'b1ivars b1bvars b1rvars emsgs'=. (3#<0 3$a:),<0 2$a:
while. do.
  if. 1 >: #'b2ivars b2bvars b2rvars nemsgs'=. cparse_statement ivars;bvars;<rvars do. a: return. end.
  emsgs=. emsgs , nemsgs
NB. Accumulate variables into the B1 blocks
  'b1ivars b1bvars b1rvars'=. (b2ivars;b2bvars;<b2rvars) namesintersect (b1ivars;b1bvars;<b1rvars)
  select. 1 {:: r=. readblock''
    case. 'end' do. break.
    case. 'catch';'catchd';'catcht' do.
    case. do. a: return.
  end.
end.
b1ivars;b1bvars;b1rvars;<emsgs
)

NB. break, continue, return
NB. We intersect the current inline vbls as break variables, and clear the inline variables
NB. which will cause a message for dead code.
NB. We use the x parameter to indicate which secondary status should be updated (1 for break/continue, 2 for return)
cparse_control_bcr=: 4 : 0
ibr=. y
NB. read the control word
'lineno cw'=. readblock''
emsgs=. 0 2$a:
NB. take the new checkpoint of variables, and apply that to the indicated status
ibr=. (x namesintersect&({&ibr) 0) x} ibr
NB. clear the inline history, escept for $LBA and $NNU, to indicate that there is no inline
ibr=. (keepnames&('$NNU';'$LBA')&.> 0 { ibr) 0} ibr
ibr , <emsgs
)
cparse_control_break=: 1&cparse_control_bcr
cparse_control_continue=: cparse_control_break
cparse_control_return=: 2&cparse_control_bcr

NB. unsupported items: goto label, and throw which may have no effect
NB. ignore them
NB. 
cparse_control_goto=: 3 : 0
NB. consume the control word and continue
readblock ''
y , <0 2$a:
)
cparse_control_label=: cparse_control_goto
cparse_control_throw=: cparse_control_goto

NB. handle the NB.?lint... lines
NB. Each of these is a one-off
cparse_control_NB=: 3 : 0
ibr=. y
NB. read the control word
'lineno cw'=. readblock''
emsgs=. 0 2$a:
NB. The control word ends with a space.  dispatch on it
select. ' ' taketo cw
  case. 'NB.?lintsaveglobals' do.
  NB. make all global variables defined on the main line available to later verbs
    addpersistentnames 0 { ibr
  case. 'NB.?lintmsgsoff' do.
  NB. disable message reporting.  We have to save the requests for later disabling, because
  NB. nonnoun and nugatory errors may be detected long after the line itself is scanned
    messageenable=: messageenable , ->:lineno
  case. 'NB.?lintmsgson' do.
    messageenable=: messageenable , >:lineno
  case. 'NB.?lintdebug0' do.
    debuglevel=: 0
  case. 'NB.?lintdebug1' do.
    debuglevel=: 1
  case. 'NB.?lintdebug2' do.
    debuglevel=: 2
  case. 'NB.?lintloopbodyalways' do.
    ivars=. 0 {:: ibr
    ivars=. ivars addnames '$LBA' ; ($0) ;< 1 (_1)} 1 {:: ('';<ivars) lookupname <'$LBA'
    ibr=. (<ivars) 0} ibr
  case. 'NB.?lintformnames' do.
  NB. the operand of the directive is the name of a form.  Extract the name and look it up
    formname=. ' ' -.~ ' ' takeafter cw
    if. 1 >: #$formvars =. ibr createformnames <formname do.
      emsgs=. emsgs , lineno ;"0 formvars
    else.
      ibr=. (<(0 {:: ibr) addnames formvars) 0} ibr
    end.
  case. do.
    emsgs=. emsgs , lineno ; 'Unrecognized lint directive'
end.
NB. Return with line status unchanged
ibr , <emsgs
)

NB. Table of events for each type of control
NB. format is  controlname suffix
NB. where suffix is the value to append to the controlname to get the name of the defined variable
eventctlvariables =: 3&({.!.(<''))@(<;._2)@(,&'-');._2 (0 : 0)
checkbox--0
combobox
combolist
combodrop
combobox-_select-_1
combolist-_select-_1
combodrop _select _1
dial--0
dateedit--20150101
dspinbox--0
edit-- 
edit-_select-0 0
edith-- 
edith-_select-0 0
edith-_scroll-0
editm-- 
editm-_select-0 0
editm-_scroll-0
listbox
listbox-_select-_1
radiobutton--0
scrollbar--0
slider--0
spinbox--0
tab
tab-_select-_1
timeedit--81520.23
richedit
richeditm
scrollbarv
spin
spinv
trackbar
trackbarv
)
NB. These are the controls that create names that do not include the childcontrolname
NB. They use childclass and event rather than controlname
NB. lines are childclass;event;vblname;value
eventvariables =: ;:;._2 (0 : 0)
isidraw char sysdata a
isidraw char sysmodifiers 0 0
isidraw mwheel sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isidraw mwheel sysmodifiers 0 0
isidraw mmove sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isidraw mmove sysmodifiers 0 0
isidraw mbldown sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isidraw mbldown sysmodifiers 0 0
isidraw mbldbl sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isidraw mbldbl sysmodifiers 0 0
isidraw mblup sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isidraw mblup sysmodifiers 0 0
isidraw mbmdown sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isidraw mbmdown sysmodifiers 0 0
isidraw mbmdbl sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isidraw mbmdbl sysmodifiers 0 0
isidraw mbmup sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isidraw mbmup sysmodifiers 0 0
isidraw mbrdown sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isidraw mbrdown sysmodifiers 0 0
isidraw mbrdbl sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isidraw mbrdbl sysmodifiers 0 0
isidraw mbrup sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isidraw mbrup sysmodifiers 0 0
isigraph char sysdata a
isigraph char sysmodifiers 0 0
isigraph mwheel sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isigraph mwheel sysmodifiers 0 0
isigraph mmove sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isigraph mmove sysmodifiers 0 0
isigraph mbldown sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isigraph mbldown sysmodifiers 0 0
isigraph mbldbl sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isigraph mbldbl sysmodifiers 0 0
isigraph mblup sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isigraph mblup sysmodifiers 0 0
isigraph mbmdown sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isigraph mbmdown sysmodifiers 0 0
isigraph mbmdbl sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isigraph mbmdbl sysmodifiers 0 0
isigraph mbmup sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isigraph mbmup sysmodifiers 0 0
isigraph mbrdown sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isigraph mbrdown sysmodifiers 0 0
isigraph mbrdbl sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isigraph mbrdbl sysmodifiers 0 0
isigraph mbrup sysdata 0 0 0 0 0 0 0 0 0 0 0 0
isigraph mbrup sysmodifiers 0 0
multimedia bufferstatus sysdata 50
multimedia duration sysdata 10000
multimedia error sysdata error
multimedia mediastatus sysdata status
multimedia playstate sysdata stopped
multimedia position sysdata 0
multimedia volume sysdata 50
opengl char sysdata a
opengl char sysmodifiers 0 0
opengl mwheel sysdata 0 0 0 0 0 0 0 0 0 0 0 0
opengl mwheel sysmodifiers 0 0
opengl mmove sysdata 0 0 0 0 0 0 0 0 0 0 0 0
opengl mmove sysmodifiers 0 0
opengl mbldown sysdata 0 0 0 0 0 0 0 0 0 0 0 0
opengl mbldown sysmodifiers 0 0
opengl mbldbl sysdata 0 0 0 0 0 0 0 0 0 0 0 0
opengl mbldbl sysmodifiers 0 0
opengl mblup sysdata 0 0 0 0 0 0 0 0 0 0 0 0
opengl mblup sysmodifiers 0 0
opengl mbmdown sysdata 0 0 0 0 0 0 0 0 0 0 0 0
opengl mbmdown sysmodifiers 0 0
opengl mbmdbl sysdata 0 0 0 0 0 0 0 0 0 0 0 0
opengl mbmdbl sysmodifiers 0 0
opengl mbmup sysdata 0 0 0 0 0 0 0 0 0 0 0 0
opengl mbmup sysmodifiers 0 0
opengl mbrdown sysdata 0 0 0 0 0 0 0 0 0 0 0 0
opengl mbrdown sysmodifiers 0 0
opengl mbrdbl sysdata 0 0 0 0 0 0 0 0 0 0 0 0
opengl mbrdbl sysmodifiers 0 0
opengl mbrup sysdata 0 0 0 0 0 0 0 0 0 0 0 0
opengl mbrup sysmodifiers 0 0
webview char sysdata a
webview char sysmodifiers 0 0
webview mwheel sysdata 0 0 0 0 0 0 0 0 0 0 0 0
webview mwheel sysmodifiers 0 0
webview mmove sysdata 0 0 0 0 0 0 0 0 0 0 0 0
webview mmove sysmodifiers 0 0
webview mbldown sysdata 0 0 0 0 0 0 0 0 0 0 0 0
webview mbldown sysmodifiers 0 0
webview mbldbl sysdata 0 0 0 0 0 0 0 0 0 0 0 0
webview mbldbl sysmodifiers 0 0
webview mblup sysdata 0 0 0 0 0 0 0 0 0 0 0 0
webview mblup sysmodifiers 0 0
webview mbmdown sysdata 0 0 0 0 0 0 0 0 0 0 0 0
webview mbmdown sysmodifiers 0 0
webview mbmdbl sysdata 0 0 0 0 0 0 0 0 0 0 0 0
webview mbmdbl sysmodifiers 0 0
webview mbmup sysdata 0 0 0 0 0 0 0 0 0 0 0 0
webview mbmup sysmodifiers 0 0
webview mbrdown sysdata 0 0 0 0 0 0 0 0 0 0 0 0
webview mbrdown sysmodifiers 0 0
webview mbrdbl sysdata 0 0 0 0 0 0 0 0 0 0 0 0
webview mbrdbl sysmodifiers 0 0
webview mbrup sysdata 0 0 0 0 0 0 0 0 0 0 0 0
webview mbrup sysmodifiers 0 0
)


NB. Create list of form names to be defined for the current verb
NB. x is internal variables
NB. y is formname[;controlname[;eventname]]
NB. If the form is not defined as a noun, return a boxed emsg
NB. Otherwise return a table of the names to be defined, suitable for addnames
createformnames =: 4 : 0
ibr =. x
formname =. y
if. 1 = #formvalue=. ((loc=. 1 { ('';{.ibr) lookupname <'$LOC'),{.ibr) lookupname {. formname do.
  <'Form name is undefined' return.
elseif. noun ~: 0 {:: formvalue do.
  <'Form is not a noun' return.
elseif. do.
  formvalue=. (1 { formvalue) 5!:0
  NB.?lintonly formvalue =. '' 
  NB. Extract the child controls and their type.  This is rough and ready.
  NB. cut to words
  formlines=. (3 {. ;: :: (a:"_));._1 ';' , CRLF -.~ formvalue
  NB. keep only 'cc' lines
  formlines=. (#~ (<'cc') = {."1) formlines
  NB. For the lines that define variables including childname, create the variable including childname
    NB. and, wdq is always defined - in wdhandler
  NB. producing name1;name2;value (if empty value, use undefined)
  defnameval =.  ('wdq';'';'') , ; <@(,.   (}."1 eventctlvariables) #~ ({."1 eventctlvariables)&=)/"1 (1 2) {"1 formlines
  NB. Assign the value, or undefined if no value
  varnames =. (('_' ([,],[)&.> loc) ,~&.> ,&.>/"1 (2) {. "1 defnameval)
  varvalues =. (3 : '0 typeval <''y'''@>)`(noun&;)@.(a:&=)"0 (2) {"1 defnameval
  formvars =. varnames ,. varvalues
  if. 2 < #formname do.
    NB. Similarly, but for the names that do not include childname - for the current control-type only
    NB. Translate the controlname to its childclass
    childcc =. (a: ,~ 2 {"1 formlines) {~ (1 {"1 formlines) i. 1 { formname
    NB. Look up childclass;event producing name;value
    defnameval =. (2 3 {"1 eventvariables) #~ (0 1 {"1 eventvariables) -:"1 childcc , 2 { formname
    varnames =. (('_' ([,],[)&.> loc) ,~&.> {."1 defnameval)
    NB. Convert empty values to undefined
    varvalues =. (3 : '0 typeval <''y'''@>)`(noun&;)@.(a:&=)"0 {:"1 defnameval
    formvars =. formvars , varnames ,. varvalues
  end.
NB. obsolete   NB. keep only the controls that define variables
NB. obsolete   varctls=. ;: 'checkbox combobox combodrop combolist edit editm listbox radiobutton scrollbar scrollbarv richedit richeditm spin spinv tab trackbar trackbarv'
NB. obsolete   formlines=. (#~ varctls e.~ 2&{"1) formlines
NB. obsolete   NB. for the variables that create a _select name, create that name
NB. obsolete   selectctls=.  ;: 'combobox combodrop combolist edit editm listbox richedit richeditm'
NB. obsolete   formlines=. (,   [: ,&'_select'&.> (#~ selectctls e.~ 2&{"1)) formlines
NB. obsolete   NB. Now give the names a value of an empty string in the selected locale, and define the names
NB. obsolete   formval=. ''   NB. should be undefined
NB. obsolete   formvars=. (('_' ([,],[)&.> loc) ,~&.> 1 {"1 formlines) ,"0 1 (0) typeval <'formval'
NB. obsolete   formvars=. (('_' ([,],[)&.> loc) ,~&.> defnames) ,"0 1 (0) typeval <'formval'
end.
formvars
)

NB. ********************** from here on is devoted to parsing J sentences ***************
NB.
NB. Parsing stuff, copied from trace.ijs
NB. sideeff means that that valence of
NB. the verb must not be executed because of a side-effect (and therefore a sentence it is in should not
NB. be marked as nugatory).  setlocale means that the result of the verb should be assigned to loc
NB. parseerror indicates an error in forming the result.  A name is marked unparsed if it has been
NB. reconstructed from global variables.  In this case its sideeeff flags will be invalid and it must
NB. be moved to the queue for parsing.  Verbs with invalid parts, monad or dyad, are tagged thus and
NB. fail if executed in the wrong valence
NB. sideeffm, sideeffd must be adjacent
NB. invmonad invdyad  must be in that order
(x)=: 2^i.#x=. ;:'sideeffm sideeffd noun verb adv conj lpar rpar asgn name mark setlocale parseerror unparsed invmonad invdyad'
any=: _1
avn=: adv + verb + noun
cavn=: conj + adv + verb + noun
edge=: mark + asgn + lpar
invvalences=: invmonad+invdyad

x=. ,: (edge,       verb,       noun, any      ); 0 1 1 0; '0 Monad'
x=. x, ((edge+avn), verb,       verb, noun     ); 0 0 1 1; '1 Monad'
x=. x, ((edge+avn), noun,       verb, noun     ); 0 1 1 1; '2 Dyad'
x=. x, ((edge+avn), (verb+noun),adv,  any      ); 0 1 1 0; '3 Adverb'
x=. x, ((edge+avn), (verb+noun),conj, verb+noun); 0 1 1 1; '4 Conj'
x=. x, ((edge+avn), (verb+noun),verb, verb     ); 0 1 1 1; '5 Trident'
x=. x, (edge,       cavn,       cavn, any      ); 0 1 1 0; '6 Bident'
x=. x, ((name+noun),asgn,       cavn, any      ); 1 1 1 0; '7 Is'
x=. x, (lpar,       cavn,       rpar, any      ); 1 1 1 0; '8 Paren'

PTpatterns=: >0{"1 x  NB. parse table - patterns
PTsubj=: >1{"1 x  NB. "subject to" masks
PTactions=:  2{"1 x  NB. actions

bwand=: 17 b.    NB. bitwise and
bwor=: 23 b.    NB. bitwise or
bwlsl=: 33 b.  NB. logical left shift

prespace=: ,~ e.&'.:'@{. $ ' '"_
NB. preface a space to a word beginning with . or :

isname=: ({: e. '.:'"_) < {. e. (a.{~,(i.26)+/65 97)"_
NB. 1 iff a string y from the result of ;: is is a name

class=: 3 : 0         NB. the class of the word represented by string y
if. y-:mark do. mark return. end.
if. isname y do. name return. end.
if. 10>i=. (;:'=: =. ( ) m n u v x y')i.<y do.
  i{asgn,asgn,lpar,rpar,6#name return.
end.
(4!:0 <'x' [ ".'x=. ',y){noun,adv,conj,verb
)
NB. *** end of copied stuff

sideeff=: sideeffm+sideeffd
sideefferr=: sideeffm+sideeffd+parseerror
sideefferrloc=: sideeffm+sideeffd+parseerror+setlocale
sideeffderrloc=: sideeffd+parseerror+setlocale
sideeffmerrloc=: sideeffm+parseerror+setlocale
NB. The following fields are used when we want to work on valences at the same time as side effects, and in the same way
sideeffvm=: sideeffm+invmonad
sideeffvd=: sideeffd+invdyad
sideeffv=: sideeffvm+sideeffvd
sideeffverr=: sideeffvm+sideeffvd+parseerror
sideeffverrloc=: sideeffvm+sideeffvd+parseerror+setlocale
sideeffvderrloc=: sideeffvd+parseerror+setlocale
sideeffvmerrloc=: sideeffvm+parseerror+setlocale

NB. possible starting variables, in name;type;value form
startvbls=: 'xymunv' (,@[ ; '' ;~ ])"0 noun,noun,noun,(verb+sideeff),noun,(verb+sideeff)

enparen=: '( ' , ,&') '
NB. create type ; value for a name y.  x is additional flags to add
typeval=: (+  (noun,adv,conj,verb) {~ 4!:0) ; (5!:1)@]
NB. Same, but search definition of name for unsafe sequences; set unsafe flags as called for
typevalsafe=: 3 : 0
select. t=. 4!:0 y
  NB. If the name is a noun, keep it.  If we fail reading the name (memory error?), use 'unknown'
  case. 0 do. noun ; 5!:1 :: (<''"_) y
  NB. if the name is a verb, first fix the verb to resolve names as much as possible
  fcase. 3 do.
  NB. Before we fix the name, we need to switch to its locale (which must be present).  And, it is
  NB. possible for the fix to fail, if the name is malformed (e. g. pun in type)
    try.
  NB.?lintmsgsoff
      cocurrent ({.~ i:&'_') }: > y
  NB.?lintmsgson
      x=. (>y)~ f.
      cocurrent 'lint'
    catch.
      cocurrent 'lint'
      (sideeff+verb);'' return.
    end.
    y=. <'x'
  case. do.
  NB. for verb/adverb/conj, create linear form; if multiple lines, it's unsafe (explicit defn)
    try.
      l=. 5!:5 y  NB. linear form
  NB. Look at the first line.  If it contains any names, somehow f. couldn't figure out what
  NB. is happening, and neither can we.  Make the result unsafe
      if. +./ isname@> bl=. ;: LF taketo l do. (sideeff + t { (noun,adv,conj,verb)) ; ''
  NB. if multiple lines, it's unsafe (must be explicit defn), but we can still try to figure out its valences
      elseif. LF e. l do.
  NB. Find the occurrences of : 0 in the first line
        loc0=. >: I. 2 (;:':0')&-:\ bl
  NB. Remove empty lines; classify each line as : ) neither
        lc=. (,.':)')&(]@i.);._2 (#~   -.@(*. _1&|.)@(LF&=)) LF ,~ LF takeafter l  NB. ]@i. J602 bug
  NB. Now, looking at the sections ending in 1=), there is a monad (1) if the first line is not 0=:,
  NB. and a dyad (2) if any line other than the last is 0=:.  Calculate that.
        valences=. (((0 ~: {.) + 2 * 0 e. }:);._2~ (1&=)) lc
  NB. sections are in each :0: 1 (monad only), 2 (dyad only), 3 (both)
  NB. Now figure out, for each definition, whether it contains a reference to x or y.  Set a flag (4) if so,
  NB. to indicate that if this is used in a modifier, it will create an explicit verb
  NB. Must remove comments from the definition, in case they were not suppressed
        modexplicit=. (2&((;:LF,')')&-:\)   (4 * (;:'x y')&(+./@:e.));._2    }:) ;: ; (<@(,&LF)@(}:^:('NB.' -: 3 {. >@{:)&.;:));._2 LF ,~ LF takeafter l
  NB. Replace each :0 with : #sections.  That is our private valence tag
  NB. Make the first line (only) the unparsed value.  When it is parsed, we will
  NB. execute the :1 :2 :3 to set the missing-valence bits.  The result of that parse will be
  NB. an unknown verb, but it will have known valences.  We add 8 to say that we have set the bits,
  NB. even if no valences were valid
        if. loc0 =&# valences do. bl=. (<@":"0 valences+modexplicit+8) loc0} bl end.
        unparsed ;< bl
  NB. If it's all symbols, we can put it on the stack for parsing.  Mark the entity as 'unparsed'
  NB. and return the boxed words as the value
      elseif. do. unparsed ;< bl
      end.
    catch.
  NB. If there was an error accessing the name (preobably out of memory converting a huge name to string form), make it
  NB. a side-effectful unknown of the correct type
      (sideeff + t { (noun,adv,conj,verb)) ; ''
    end.
end.
)

NB. x is current locale;(table of defined names;type;value)
NB. y is boxed name, possibly with object references
NB. We go through the object references and resolve to a single name, with locale added in the case of object ref
NB. Result is boxed name, or boxed empty if error in locale resolution
analyzename=: 4 : 0"1 0
NB. Split the name on __.  If there aren't any, or if the string ended with __, there is no object locale:
NB. keep the original name, except replace final __ with _base_
if. 0 = # > {: }. qname=. (<@(2&}.);.1~ '__'&E.) '__' , > y do.
  if. 0 = # > {: qname do. ('_base_' ,~ _2&}.)&.> y 
  else. y
  end.
  return.
end.
NB. process the names starting from the end.  Each name except the last must result in a boxed string, which becomes the new locale
NB. start off by using the current locale as if it had come from a typeval
'loc defnames'=. x
for_l. |. }. qname do.
  assert. 0 = L. loc [ 'analyzename'
  if. 1 = #'type loc'=. (loc;<defnames) lookupname l do.  <'' return. end.
NB. verify the new locale is a single non-empty boxed string with rank <: 1
  if. noun ~: type do. <'' return. end.   NB. If not a noun, that's alocale error
  if. loc -: '' do. <'' return. end.   NB. if undefined, that's a locale error too
  loc=. (<loc) 5!:0   NB.?lintonly loc =. 0 NB. Convert string form of value to real form
  if. 1 ~: */ $ loc do.  <'' return. end.
  loc=. >loc   NB. our form is unboxed
  if. 2 ~: 3!:0 > loc do.  <'' return. end.
  if. 1 < $ $ > loc do.  <'' return. end.
NB. If the locale is numbered, don't use it, since it should have been handled by conew - we must be
NB. getting a run-time value
  if. ' 0123456789' e.~ {. > loc do. <'' return. end.
NB. The new loc is legit.  Proceed, starting in it
end.
NB. Return the locale we resolved to
< (> {. qname) , '_' , (loc) , '_'
)

NB. x is current locale;table of defined names;type;value
NB. y is single boxed name
NB. Result is type;value of name, or scalar empty box if undefined name
NB. If the name has no locale, we look for it in the defined-names table; if not found, we append the current locale
NB. Then we go through the path for the locale of the name: until found, we look first in the table, then in the system
lookupname=: 4 : 0"1 0
'loc defnames'=. x
assert. 0 = L. loc
nmx=. ({."1 defnames)&i.
NB. If the name is in the defined list, it's easy
if. (#defnames) > i=. nmx y do.
  (<i;1 2) { defnames return.
end.
NB. Split the name into name and locale.  If we were looking for a local name, use the default locale
if. '_' = {: > y do.
  nm=. ({.~ i:&'_') }: > y
  loc=. (>:#nm) }. }: > y
else.
  nm=. >y  NB. keep loc
end.
NB. If the locale for some reason does not exist, return undefined
if. 0 = # loc do. a: return. end.

NB. now nm and loc are strings

NB. Get the search path for this locale, including the locale itself
NB. Create all the names for the path, and look up each one in each name table.  Pick the first one found.
NB. Give the name table priority over defined names
allnames=. (nm , '_' , ,&'_')&.> loc ; 18!:2 <loc
dictp=. 1 i.~ (#defnames) > dictx=. nmx allnames
globp=. 1 i.~ findglobalname allnames
if. dictp <: globp do.   NB. found first in local dict, or nowhere
  if. dictp < #allnames do.
    (<(dictp{dictx);1 2) { defnames
  else.  NB. not found
    a:
  end.
else.   NB. found first as a global name
  typevalsafe globp { allnames
end.
)

NB. add name;type;value to list, and coalesce duplicates.  If new name multiply defined, keep the last
NB. x is list, y is new table or list
4 : 0  NB. debug version
l=. x (#~ ~:@:({."1))@|.@, y
if. 0 e. 1 2 4 8 e.~ 3!:0&> 1 {"1 l do.
  qprintf 'x y '
  13!:8 (4)
end.
l
)
addnames=: (#~ ~:@:({."1))@|.@,
NB. delete name from list.  x is name table, y is list of names
delnames=: [ #~ {."1@[ -.@:e. ]
NB. delete all names in x that DO NOT appear in y
keepnames=: [ #~ {."1@[ e. ]
NB. return 1 if name y is in the namelist x
isnamedefined=: (e. {."1)~"2 _   boxopen

x=. ,:  'conew';verb;    <(<,'@'),<;:'<]'  NB. conew  return class name
x=. x , 'cocurrent';(verb+setlocale);'>'  NB. cocurrent  set locale name
x=. x , 'coclass';(verb+setlocale);'> '  NB. cocurrent  set locale name
x=. x , 'coname';(verb);   <(<'@:'),<(<(<,'@'),<;:'<".'),<(<,'"'),<(<<;._1 ' 0 loc'),<(,'0');_  NB. coname get current name (in loc)  AR of  <@".@:('loc'"_)
x=. x , '".';(verb+sideeffm);'".'  NB. execute has side-effects
x=. x , '$:';(verb+sideeff);''  NB. recursion may change valence, so can't risk it
x=. x , '@';conj;'lintconjatop'
x=. x , '@:';conj;'lintconjat'
x=. x , '.';conj;'lintconjdot'
x=. x , '&';conj;'lintconjbond'
x=. x , '&.';conj;'lintconjunder'
x=. x , '&.:';conj;'lintconjunderinf'
x=. x , '&:';conj;'lintconjappose'
x=. x , '..';conj;'lintconjeven'
x=. x , '.:';conj;'lintconjodd'
x=. x , ':.';conj;'lintconjobverse'
x=. x , '"';conj;'lintconjrank'
x=. x , 'L:';conj;'lintconjlevel'
x=. x , 'S:';conj;'lintconjspread'
x=. x , '::';conj;'lintconjadverse'
x=. x , '^:';conj;'lintconjpower'
x=. x , ';.';conj;'lintconjcut'
x=. x , 'd.';conj;'lintconjderiv'
x=. x , 'D.';conj;'lintconjDeriv'
x=. x , 'T.';conj;'lintconjtaylor'
x=. x , 'H.';conj;'lintconjhyper'
x=. x , 'D:';conj;'lintconjsecant'
x=. x , '`:';conj;'lintconjevokegerund'
x=. x , '@.';conj;'lintconjagenda'
x=. x , '`';conj;'linttie'
x=. x , '!.';conj;'lintfit'
x=. x , ':';conj;'lintcolon'
x=. x , '!:';conj;'lintforeign'
x=. x , '/';adv;'lintadvinsert'
x=. x , '/.';adv;'lintadvoblique'
x=. x , '\';adv;'lintadvprefix'
x=. x , '\.';adv;'lintadvsuffix'
x=. x , 'f.';adv;'lintadvfix'
x=. x , 'M.';adv;'lintadvmemo'
x=. x , '}';adv;'lintadvamend'
x=. x , 't.';adv;'lintadvtaylor'
x=. x , 't:';adv;'lintadvwtaylor'
x=. x , 'b.';adv;'lintboolean'
x=. x , '~';adv;'lintevoke'

lintspecials=: ,&.> {."1 x
lintspecialsi=: lintspecials&i.  NB. faster lookup
lintspecialtv=: }."1 x

NB. List of verbs that don't have a monadic valence
nomonads=: ;:'[: E.'
NB. List of verbs that don't have a dyaddic valence
nodyads=: ;:'[: ~. {: }: L.'

NB. y is an AR.  Result is string form.  But if the result is more than 50 chars, we
NB. return empty; if more than 20 chars, we return the first 20
ARtostring=: 3 : 0"0
if. y = <'' do. ''
else.
  y=. y 5!:0
  y=. 5!:5 <'y'
  if. 50 < #y do.
    ' ... '
  elseif. 20 < #y do.
    enparen (20{.y),'...'
  elseif. do.
    enparen y
  end.
end.
)

NB. called after error. y is the ARs of the operands that were executed
NB. x is 1 (default 1) to include J error info - use only if there has been an error
postmortem=: 3 : 0
1 postmortem y
:
if. x do.
  s=. LF,((<:13!:11''){::9!:8'')
else. s=. ''
end.
s,LF, ; <@ARtostring y
)

NB. Routine to parse and execute a block
NB. y is the table of (line number);(text) of lines to execute
NB. x is the environment:
NB.  table of defined names name;type;value (name ends in _ if global assignment)
NB.   the special name $LOC is the current locale.  If empty, it means we don't know
NB.   the special name $NNU is (sentences producing non-noun result);(sentences that may be nugatory)
NB. Result is new environment, plus error status:
NB.  defined names;
NB.  table of (line number);(error message)
NB. For defined names, type is the type of the word that is put onto the stack:
NB.   one of   noun verb adv conj lpar rpar asgn name mark
NB.  value is the linear form of the value of the name, or empty if name has unknown value
NB. It is assumed that the verb 'findglobalname' has been created, that will test for the existence of a qualified name
parseblock=: 4 : 0
defnames=. x
loc=. 1 {:: ('';<defnames) lookupname <'$LOC'
inplinenos=. > 0 {"1 y
inplines=. 1 {"1 y

NB. initialize the list of error messages for the block
errors=. 0 2$a:

NB. Indicate whether the block is a valid T-block: ends with a noun, or is empty; also whether block contains no sentences
emptyblock=. validtblock=. 1   NB. in case block is empty, that is valid.

NB. In case there are no sentences, set the 'last sentence is nugatory' indicator to false
nugatory=. 0

NB. for each sentence...
s_index=. 0
while. s_index < #inplines do.   NB. for_s. fails under J6.02; break problem
  s=. s_index { inplines
  if. debuglevel > 0 do. smoutput 'Processing: ' , >s end.
NB. split sentence into words, and add end-of-queue indicator.  Remove any trailing comment
  if. 1 < #queue=. mark ; }:^:('NB.' -: 3 {. >@{:) ;: > s do.
    
NB. Initialize the execution stack.  This is type;linear form
    stack=. 4 2 $ mark;''
    
NB. Init where we were when we found the last valid production.  This is the end of the queue when
NB. we matched a rule
    errstartpoint=. _2 {. }. queue
    
NB. initialize the 'duh' indicator.  Every sentence must either contain an assignment, or execute
NB.  some unpredictable verb, unless it is the last sentence of the block
    nugatory=. 1
    
NB. Process the sentence through the stack
    while. do.
      
NB. If the stack contains an executable combination, execute it
NB. If part of the execution has unknown value, produce an unknown result, of type 'noun' for verb executions,
NB. and 'verb' for modifier executions
NB.?lintmsgsoff
      if. debuglevel > 0 do. qprintf 'queue stack ' end.
NB.?lintmsgson
      select.
  NB.?lintonly stack =. (verb,verb,verb,noun);"0<''
          if. (#PTpatterns) > pline=. 1 1 1 1 i.~ * PTpatterns bwand"1 ,>4 1{.stack do.
            exeblock=. (subj=. pline{PTsubj) # , 4 _1 {. stack  NB. the executable part
            exetypes=. > subj # , 4 1 {. stack   NB. the corresponding types
          end.
  NB.?lintonly exeblock =. 3#<'' [ exetypes =. 0 0 0 [ subj =. 0 1 1 1
          pline
          
        case. 0;1 do.  NB. monad
  NB. If the verb doesn't have a monadic form, complain
          if. invmonad bwand 0 { exetypes do.
            errors=. errors , (s_index { inplinenos) ; ('Error, verb does not have ',((*invdyad bwand 0 { exetypes){::'monadic';'any valid'),' valence, after: ' , > {:!.(<'start of line') }.queue)
            nugatory=. 0   NB. Don't confuse things with another emsg
            break.   NB. Stop parsing
  NB. if the desired valence is unsafe, don't execute it, and indicate that
  NB. the sentence is not nugatory
          elseif. (0 { exetypes) bwand sideeffm do.
            nugatory=. 0
            res=. ''
  NB. if any part of the operand is unknown, make the result unknown
          elseif. (<'') e. exeblock do.
            res=. ''
          elseif. do.
            try.
  NB. Result is AR of result of verb execution
              res=. ((0 { exeblock) 5!:0) ((1 { exeblock) 5!:0)
              res=. 5!:1 <'res'
            catch.
              res=. ''  NB. Error, unknown noun result
  NB. reconstruct the linear form of the failing fragment
              errors=. errors , (s_index { inplinenos) ; ('Execution error after: ' , > {:!.(<'start of line') }.queue),postmortem exeblock
            end.
          end.
          if. (0 { exetypes) bwand setlocale do.
            nugatory=. 0
            if. *#res do.
              loc=. res 5!:0  NB.?lintonly loc =. (0;1) {:: , res
              assert. 0 = L. loc
            else.
              errors=. errors , (s_index { inplinenos) ; 'Locale set to unknown value, ignored'
            end.
          end.
          stack=. ((subj i. 1){.stack),(noun;res),((>:subj i: 1)}. stack)
          
        case. 2 do.  NB. dyad
  NB. If the verb doesn't have a dyadic form, complain
          if. invdyad bwand 1 { exetypes do.
            errors=. errors , (s_index { inplinenos) ; ('Error, verb does not have ',((*invmonad bwand 1 { exetypes){::'dyadic';'any valid'),' valence, after: ' , > {:!.(<'start of line') }.queue)
            nugatory=. 0   NB. Don't confuse things with another emsg
            break.   NB. Stop parsing
  NB. if the desired valence is unsafe, don't execute it, and indicate that
  NB. the sentence is not nugatory
          elseif. (1 { exetypes) bwand sideeffd do.
            nugatory=. 0
            res=. ''
  NB. if any part of the operand is unknown, make the result unknown
          elseif. (<'') e. exeblock do.
            res=. ''
          elseif. do.
            try.
  NB. Result is AR of result of verb execution
              res=. ((0 { exeblock) 5!:0) ((1 { exeblock) 5!:0) ((2 { exeblock) 5!:0)
              res=. 5!:1 <'res'
            catch.
              res=. ''  NB. Error, unknown noun result
              errors=. errors , (s_index { inplinenos) ; ('Execution error after: ' , > {:!.(<'start of line') }.queue),postmortem exeblock
            end.
          end.
          if. (1 { exetypes) bwand setlocale do.
            if. *#res do.
              loc=. res 5!:0    NB.?lintonly loc =. (0;1) {:: , res
              assert 0 = L. loc
            else.
              errors=. errors , (s_index { inplinenos) ; 'Locale set to unknown value, ignored'
            end.
          end.
          stack=. ((subj i. 1){.stack),(noun;res),((>:subj i: 1)}. stack)
          
          
        case. 3 do.  NB. adverb execution
  NB. If the modifier is unknown, make the result an unknown unsafe verb, nonnugatory
  NB. Any disallowed valences flagged in the modifier are really to be associated with this derived verb
          if. (<'') = 1 { exeblock do.
            res=. (verb+sideeff+invvalences bwand 1 { exetypes);''
            nugatory=. 0
  NB. Execute our verb that emulates the modifier.  This will return a type;value.  No primitive modifier
  NB. has a side effect until executed as a verb or an explicit definition, so there is no need for nugatory setting
  NB. We know every nonempty modifier has a value which is the AR of a verb to handle applying the modifier
  NB. to its arguments
          else.
            try.
              res=. ((1 { exeblock) 5!:0) 1 { stack
              if. parseerror bwand 0{:: res do.
                errors=. errors , (s_index { inplinenos) ; ('Invalid operands after: ' , > {:!.(<'start of line') }.queue),0 postmortem exeblock
              end.
            catch.
  NB. Error executing modifier; assume verb result
              res=. (verb+sideeff);''
              errors=. errors , (s_index { inplinenos) ; ('Execution error after: ' , > {:!.(<'start of line') }.queue),postmortem exeblock
            end.
          end.
          stack=. ((subj i. 1){.stack),res,((>:subj i: 1)}. stack)
          
        case. 4 do.  NB. conjunction execution
  NB. If the modifier is unknown, make the result an unknown unsafe verb, nonnugatory
  NB. Any disallowed valences flagged in the modifier are really to be associated with this derived verb
          if. (<'') = 1 { exeblock do.
            res=. (verb+sideeff+invvalences bwand 1 { exetypes);''
            nugatory=. 0
  NB. Execute our verb that emulates the modifier.  This will return a type;value.  No primitive modifier
  NB. has a side effect until executed as a verb or an explicit definition, so there is no need for nugatory setting
  NB. We know every nonempty modifier has a value which is the AR of a verb to handle applying the modifier
  NB. to its arguments
          else.
            try.
              res=. ((1 { exeblock) 5!:0) 1 3 { stack
              if. parseerror bwand 0{:: res do.
                errors=. errors , (s_index { inplinenos) ; ('Invalid operands after: ' , > {:!.(<'start of line') }.queue),0 postmortem exeblock
              end.
            catch.
  NB. Error executing modifier; assume verb result
              res=. (verb+sideeff);''
              errors=. errors , (s_index { inplinenos) ; ('Execution error after: ' , > {:!.(<'start of line') }.queue),postmortem exeblock
            end.
          end.
          stack=. ((subj i. 1){.stack),res,((>:subj i: 1)}. stack)
          
        case. 5 do.  NB. Trident N V V or V V V
  NB. If the first operand is [:, this is a hook, execute it as one
          if. (<'[:') -: 0 { exeblock do.
            res=. lintconjat 2 3 { stack
          else.
  NB. It's a real fork.
  NB. Create the flags, including any error or setlocale.  setlocale is an error
  NB. monad error from f h monad or g dyad
  NB. dyad error from f h dyad or g dyad
            if. flags=. (parseerror+setlocale) bwand bwor/ exetypes do.
              flags=. parseerror
            end.
  NB. sideeff flags: monad&dyad, from dyad g; monad, from monad f h, dyad from dyad f  h
            flags=. flags bwor sideeffv bwand bwor/ (0 2 { exetypes) , (bwor _1&bwlsl) sideeffvd bwand 1 { exetypes
  NB. Execute the hook to produce a composite verb; its AR becomes the result
  NB. If operand unknown, make verb unknown, with flags
            if. (<'') e. exeblock do.
              res=. (flags+verb);''
            else.
              res=. (flags+verb) ; < (,'3') ;< exeblock
            end.
          end.
          stack=. ((subj i. 1){.stack),res,((>:subj i: 1)}. stack)
          
        case. 6 do.   NB. bident  A A, C VN, VN C, V V
  NB.?lintonly exetypes =. 0 0 [ exeblock =. '';''
          if. verb bwand bwand/ exetypes do.  NB. V V
  NB. Create the flags, including any error or setlocale.  setlocale is an error
  NB. both errors from f dyad or g monad
            if. flags=. (parseerror+setlocale) bwand bwor/ exetypes do.
              flags=. parseerror
            end.
            flags=. flags bwor 3 * bwor/ _1 0 bwlsl (sideeffvd,sideeffvm) bwand exetypes
  NB. Execute the hook to produce a composite verb; its AR becomes the result
  NB. If operand unknown, make verb unknown, with flags
            if. (<'') e. exeblock do.
              res=. (flags+verb);''
            else.
              res=. (flags+verb) ; < (,'2') ;< exeblock
            end.
          elseif. (adv bwand bwand/ exetypes) +. (conj = +/ conj bwand exetypes) do. NB. A A, C VN, NV C
  NB. This becomes an adverb type.  Its value is the AR of a verb that can do the modifier's work
  NB. on subsequent noun/verb operands
            if. (<'') e. exeblock do.
  NB. If one of the portions is unknown, create an unknown modifier; but remember any invalid valences that it
  NB. is known to create
              res=. (adv+ bwand/ exetypes,invvalences);''
            else.
              res=. (exetypes ;"0 exeblock)&(lintbidentcx`lintbidentxc`lintbidentaa@.(conj i.~ conj bwand exetypes))
              res=. adv ; 5!:1 <'res'
            end.
          elseif. do.
  NB. Invalid bident, warn the user
            errors=. errors , (s_index { inplinenos) ; ('Syntax error after: ' , > {:!.(<'start of line') }.queue),LF,'invalid parts of speech'
            break.
          end.
          stack=. ((subj i. 1){.stack),res,((>:subj i: 1)}. stack)
          
        case. 7 do.  NB. assignment
  NB. The left operand is a name or a noun.  If it is a noun, convert it to a list of names, and remember if
  NB. it started with ` indicating AR assignment.  If the value is unknown, abort further checking
          arassign=. 0
          if. name = ((<0 0) {:: stack) do. nl=. (<0 1) { stack
          else.
  NB. The 'name' is a noun in AR form.
            if. 0 = # (<0 1) {:: stack do.
              errors=. errors , (s_index { inplinenos) ; 'Unknown lhs of assignment after: ' , > {:!.(<'start of line') }.queue
              break.
            end.
            nl=. ((<0 1) { stack) 5!:0  NB.?lintonly nl =. ' '
          select. 3!:0 nl
            case. 2 do.
              if. arassign=. '`' = {. nl do. nl=. }. nl end.
              try.
                nl=. ;: nl
              catch.
                errors=. errors , (s_index { inplinenos) ; 'Syntax error - invalid lhs of assignment after: ' , > {:!.(<'start of line') }.queue
                break.
              end.
            case. 32 do.
  NB. should audit the names here?
            case. do.
              errors=. errors , (s_index { inplinenos) ; 'Syntax error - invalid lhs of assignment after: ' , > {:!.(<'start of line') }.queue
              break.
          end.
        end.
        
NB. Convert each name to <name)[_locale_], expanding object references as needed
        nameloc=. (loc;<defnames) analyzename nl
NB. If a name was unresolvable, give a message
        if. 0 e. #@> nameloc do.
          errors=. errors , (s_index { inplinenos) ; 'Invalid locale names in: ' , ; (0 = #@> nameloc) # nl
          break.
        end.
        
NB. If the assignment is global, append the current locale to all names that don't have a locale
        if. '=:' -: ((<1 1) {:: stack) do. nameloc=. ,&('_',loc,'_')^:('_'~:{:)&.> nameloc end.
        
NB. If there are multiple names, verify that the right side is a noun
        if. (1 < #nameloc) *. noun ~: ((<2 0) {:: stack) do.
          errors=. errors , (s_index { inplinenos) ; 'Syntax error - multiple assignment of non-noun after: ' , > {:!.(<'start of line') }.queue
          break.
        end.
        
NB. create nameloc;(typevalue) for each name.  If single assignment, just keep the type/value.
NB. If multiple assignment, create the (noun) right side; box if open; then
NB. convert each box to boxed type;value (noun type if not AR; if AR, calculate the type).
NB. Associate a type;value with each name
        select. #nameloc
          case. 0 do.
            errors=. errors , (s_index { inplinenos) ; 'Syntax error - empty assignment after: ' , > {:!.(<'start of line') }.queue
            break.
          case. 1 do.
  NB. single assignment - keep type/value
            nameloc=. nameloc ,. (,2) { stack
          case. do.
  NB. multiple assignment - realize the value, split into boxes.  If the value is undefined, create undefined
  NB. values, as nouns or verbs depending on the AR assignment
            if. *#(<2 1) {:: stack do.  NB. value is defined
              try.  NB. there could be a length error
                rhs=. <@:>"_1 ((<2 1) { stack) 5!:0   NB.?lintonly rhs =. a:
                if. arassign do.
  NB. AR assignment - calculate linear value for each AR, and the part of speech
  NB. We have to set all the ARs to 'unknown sideeff' of the appropriate type
                  nameloc=. nameloc ,"0 1 (3 : ('y =. y 5!:0';''''' ;~ (noun,sideeff + adv,conj,verb) {~ 4!:0 <''y''')"0) rhs
                else.
  NB. Not AR assignment, just use values.  RHS must be a noun
                  nameloc=. nameloc ,"0 1 noun ;"0 (3 : '5!:1 <''y'''@>) rhs
                end.
              catch.
                errors=. errors , (s_index { inplinenos) ; ('Execution error after: ' , > {:!.(<'start of line') }.queue),LF,('error in multiple assignment'),LF,((<:13!:11''){::9!:8'')
                nameloc=. nameloc ,"0 1 (arassign { noun,sideeff + verb) ; ''  NB. carry on
              end.
            else. NB. value not defined
              nameloc=. nameloc ,"0 1 (arassign { noun,sideeff + verb) ; ''
            end.
        end.
        
NB. Perform the assignments, prepending the values to the table.  Then remove duplicates from the table
NB. If a name is assigned twice in one line, keep the last one
        defnames=. defnames addnames nameloc
        
NB. Indicate that this sentence had a lasting side-effect
        nugatory=. 0
        
NB. The result of the assignment is simply the value; remove the top 2 stack items
        stack=. 2 }. stack
        
      case. 8 do.  NB. ( x )
        stack=. (<<<0 2) { stack
        
NB. If the stack did not have an executable combination, bring the next word onto the stack.
      case. do. NB. no executable fragment
        if. 0 = #queue do. pline=. _1 break. end.  NB. This is how we end the sentence, with pline set as a flag
        qend=. > qendb=. {: queue
        queue=. }: queue
        
NB. If this is the last word in the queue, it's the mark, keep it
        if. mark = qend do.
          stack=. (mark;'') , stack
NB. If this is an assignment statement, and the new word is a name, this is where we detect that.
NB. We stack the bare name as the value
        elseif. (asgn = (<0 0) {:: stack) *. isname qend do.
          stack=. (name;qend) , stack
NB. If punctuation, keep it
        elseif. qendb e. ;:'()=.=:' do.
          stack=. (qend ;~ (lpar,rpar,2#asgn) {~  (;:'()=.=:') i. qendb) , stack
NB. If self-defining term, keep it as a noun
        elseif. (-. '.:' e.~ {: qend) *. ({. qend) e. '''_0123456789' do.
          stack=. (noun ; < (,'0') ; ". qend) , stack
        elseif. do.
NB. There is either a primitive or a name.  See if it's one we have hardwired, and if so, use the hardwired
NB. type/value
          if. (#lintspecials) > specx=. lintspecialsi qendb do.
            typevalue=. specx { lintspecialtv
NB. If it's a name, convert it to name_locale_ form; then look it up
          elseif. isname qend do.
NB. Convert name to <name[_locale_]
            nameloc=. (loc;<defnames) analyzename <qend
            if. 0 = #>nameloc do.
              errors=. errors , (s_index { inplinenos) ; 'Undefined locale in: ' , qend
              typevalue=. verb;''   NB. Keep plugging, hoping it's a verb
NB. Look up the name using the current locale and path
            elseif. 1 = #typevalue=. (loc;<defnames) lookupname nameloc do.
              errors=. errors , (s_index { inplinenos) ; 'Undefined name: ' , qend
              typevalue=. verb;''   NB. Keep plugging, hoping it's a verb
            end.
NB. if type has multiple bits set, give a warning.  Keep going - it will parse either way
            if. (~: (bwand -)) cavn bwand 0 {:: typevalue do.
              errors=. errors , (s_index { inplinenos) ; 'Name has ambiguous part of speech: ' , qend
            end.
NB. If the value is flagged as 'unparsed', it may contain unsafe sequences, and it hasn't
NB. had its builtins translated.  To get it parsed we wrap it in parentheses and put it back
NB. on the QUEUE, not the stack, so we will get a chance to process every primitive.  This would be
NB. a candidate for memoization, perhaps.
            if. unparsed bwand 0 {:: typevalue do.
NB. The value of an unparsed typevalue is the boxed form of the name.  Add (, put on queue,
NB. and replace the typevalue with )
              queue=. queue , (<,'(') , 1 {:: typevalue
              typevalue=. rpar;''
            end.
NB. Otherwise, it's a primitive; keep it and use its type.  If we know it
NB. is missing a valence, set those flags
          elseif. do.
            typevalue=. (invmonad * #. qendb&e.@> nodyads ;< nomonads) typeval <'t' [ ". 't =. ' , qend
            assert. * (verb+noun) bwand 0 {:: typevalue   NB. we should have accounted for all primitive modifiers
          end.
          
NB. Stack the new type;value
          stack=. typevalue , stack
          
        end.
      end.
      if. pline < 9 do. errstartpoint=. _2 {. }. queue end.
    end.   NB. End of loop processing stack
NB. verify that the sentence has a valid finish: 1 entity.  Remember if it's a noun
    if. 1 1 -: * (cavn,mark) bwand >(<1 2;0){stack do.
      validtblock=. * noun bwand (<1 0) {:: stack
NB. The parse completes when the queue is empty.  At that point we set pline to _1.  If that didn't happen, we must have
NB. broken out of the loop for some other reason, and we will already have given a message, so don't give the general syntax error
    elseif. pline = _1 do.
      errors=. errors , (s_index { inplinenos) ; 'Syntax error ending with: ' , ;:^:_1 errstartpoint
    end.
    
NB. Verify that the sentence did something unpredictable, unless it is last
    if. nugatory *. s_index < <:#inplines do.
      errors=. errors , (s_index { inplinenos) ; 'Sentence has no effect'
    end.
    emptyblock=. 0
  end.  NB. sentence was empty
  s_index=. >: s_index
NB.?lintmsgsoff
  if. debuglevel > 0 do. qprintf 'Aftersentence?defnames ' end.
NB.?lintmsgson
end.
NB. rewrite the locale in the defined names.  Also write the nonnoun/nugatory info, which indicates when the last line of the block
NB. is a non-noun or is nugatory.  We keep track of which of these continue to be active through processing.  If a nonnoun is
NB. active at the end of a T-block or at the final return, that's an error.  If a nugatory makes it to a T-block or the final return, that's NOT
NB. an error; otherwise it is an error.  We save the status of the last sentence of this block
defnames=. defnames addnames ('$LOC';'$NNU') ,. (<$0) ,. loc ;< ((-. validtblock) , nugatory) <@#"0 (<:s_index) { inplinenos
NB.?lintmsgsoff
if. debuglevel > 0 do. qprintf 'Endofblock?defnames ' end.
NB.?lintmsgson

defnames;<errors
)

NB. Handling of primitives, including synthetic primitives

NB. Bidents

NB. x is A0,:A1, each as a type;value.  Because they are modifiers, each value is the AR of a verb
NB. that can be executed on a type;value
NB. y is type;value of left operand of bident
NB. result is type;value of result
lintbidentaa=: 4 : 0
'`A0 A1'=. 1 {"1 x
A1 A0 y
)
NB. x is C0,:x1, each as type;value.  The value of C is AR of a verb that can be executed on two type/values
NB. y is type;value of left operand of bident
NB. result is type;value of result
lintbidentcx=: 4 : 0
((<0 1){x) 5!:0 y 0} x
)
NB. x is x0,:C1, each as type;value.  The value of C is AR of a verb that can be executed on two type/values
NB. y is type;value of left operand of bident
NB. result is type;value of result
lintbidentxc=: 4 : 0
((<1 1){x) 5!:0 y 1} x
)

NB. Conjunctions
NB. These are monads taking type;value of u,:v
NB. Each returns a type/value, taking care to set the sideeff and setlocale
NB. bits correctly, even if the entity value itself is unknown

NB.  valences are handled just like sideeffects, and will not be mentioned below

NB. Class: @ .  u is AR of the actual conjunction used
lintclass0=: 1 : 0
'typeu typev'=. 0 {"1 y
NB. Create the flags for the result
NB.  setlocale from u
NB.  sideeffm if sideeffm u or sideeffm v
NB.  sideeffd if sideeffm u or sideeffd v
NB.  parseerror if either parseerror, or if setlocale in v
flags=. (setlocale bwand typeu) bwor ((3 * sideeffvm bwand typeu) bwor sideeffv bwand typev) bwor (parseerror bwand typeu bwor typev) bwor (parseerror * * setlocale bwand typev)

NB. If either operand is a noun, produce error result
if. (noun bwand typeu bwor typev) do.
  (flags bwor verb+parseerror);''
  
NB. If either operand unknown, produce 'unknown verb' result
elseif. (<'') e. 1 {"1 y do.
  (flags+verb);''
  
NB. Otherwise, produce the derived verb, return its type;value
elseif. do.
  r=. ((<0 1) { y) 5!:0 (u 5!:0) (((<1 1) { y) 5!:0)
  flags typeval <'r'
end.
)
lintconjatop=: (<,'@') lintclass0
lintconjat=: (<,'@:') lintclass0
lintconjdot=: (<,'.') lintclass0

NB. Class: m&v u&m .  u is AR of the actual conjunction used
lintclass1=: 1 : 0
'typeu typev'=. 0 {"1 y
select. noun bwand typeu,typev
  NB. If both operands are nouns, error
  case. noun,noun do.
    (noun+parseerror);''
  NB. If both operands are verbs, transfer to the verb case
  case. 0 0 do.
    u lintclass2 y
  case. do.
  NB. m&v or u&n.  Create the flags for the result
  NB.  setlocale, parseerror from either
  NB.  sideeffm = sideeffd if sideeffd u in either
    flags=. (bwor   _1 bwlsl sideeffvd&bwand) sideeffvderrloc bwand typeu bwor typev
    if. (<'') e. 1 {"1 y do.
      (flags+verb);''
    else.
      r=. ((<0 1) { y) 5!:0 (u 5!:0) (((<1 1) { y) 5!:0)
      flags typeval <'r'
    end.
end.
)
lintconjbond=: (<,'&') lintclass1

NB. Class: u&v .  u is AR of the actual conjunction used
lintclass2=: 1 : 0
'typeu typev'=. 0 {"1 y
NB. Create the flags for the result
NB.  setlocale from u
NB.  sideeffm if sideeffm u or sideeffm v
NB.  sideeffd if sideeffd u or sideeffm v
NB.  parseerror if either parseerror, or if setlocale in v
flags=. (setlocale bwand typeu) bwor ((3 * sideeffvm bwand typev) bwor sideeffv bwand typeu) bwor (parseerror bwand typeu bwor typev) bwor (parseerror * * setlocale bwand typev)

NB. If either operand is a noun, produce error result
if. (noun bwand typeu bwor typev) do.
  (flags bwor verb+parseerror);''
  
NB. If either operand unknown, produce 'unknown verb' result
elseif. (<'') e. 1 {"1 y do.
  (flags+verb);''
  
NB. Otherwise, produce the derived verb, return its type;value
elseif. do.
  r=. ((<0 1) { y) 5!:0 (u 5!:0) (((<1 1) { y) 5!:0)
  flags typeval <'r'
end.
)
lintconjunder=: (<,'&.') lintclass2
lintconjunderinf=: (<,'&.:') lintclass2
lintconjappose=: (<,'&:') lintclass2
lintconjeven=: (<,'..') lintclass2
lintconjodd=: (<,'.:') lintclass2

NB. Class: :.   u is AR of the actual conjunction used
NB. v is the class(es) u and v may NOT be
lintclass3=: 2 : 0
'typeu typev'=. 0 {"1 y
NB. Flags come from u, or either parseerror
flags=. sideeffverrloc bwand typeu bwor typev bwand parseerror

NB. If u or v haw a wrong type, give error
if. bwor/ v bwand typeu,typev do.
  (flags bwor verb+parseerror);''
  
NB. If either operand unknown, produce 'unknown verb' result
elseif. (<'') e. 1 {"1 y do.
  (flags+verb);''
  
NB. Otherwise, produce the derived verb, return its type;value
elseif. do.
  r=. ((<0 1) { y) 5!:0 (u 5!:0) (((<1 1) { y) 5!:0)
  flags typeval <'r'
end.
)
lintconjobverse=: (<,':.') lintclass3 (noun,noun)
lintconjrank=: (<,'"') lintclass3 0 0
lintconjlevel=: (<,'L:') lintclass3 (noun,verb)
lintconjspread=: (<,'S:') lintclass3 (noun,verb)

NB. Class: ::   u is AR of the actual conjunction used
lintclass4=: 2 : 0
'typeu typev'=. 0 {"1 y
NB. Flags come from either operand
flags=. sideeffverrloc bwand typeu bwor typev

NB. If left operand is a noun, error
if. noun bwand typeu do.
  (flags bwor verb+parseerror);''
  
NB. If right operand is a noun, error in the case of :., but allow if ^:
elseif. noun bwand typeu do.
  if. n do.  NB. :.
    (flags bwor verb+parseerror);''
  else.
NB. If noun operand is unknown, it could be anything, make unsafe
    if. (<'') -: ((<1 1) { y) do.
      (flags bwor verb+sideeff);''
NB. Gerund (boxed) form of ^: is unknown, indicate side effects
NB.?lintmsgsoff
    elseif. 32 = 3!:0 (((<1 1) { y) 5!:0) do.
NB.?lintmsgson
      (flags bwor verb+sideeff);''
NB. If verb operand unknown, make unknown verb
    elseif. (<'') -: ((<1 1) { y) do.
      (flags bwor verb);''
    elseif. do.  NB. Safe to produce the verb
      r=. ((<0 1) { y) 5!:0 (u 5!:0) (((<1 1) { y) 5!:0)
      flags typeval <'r'
    end.
  end.
  
NB. If either operand unknown, produce 'unknown verb' result
elseif. (<'') e. 1 {"1 y do.
  (flags+verb);''
  
NB. Otherwise, produce the derived verb, return its type;value
elseif. do.
  r=. ((<0 1) { y) 5!:0 (u 5!:0) (((<1 1) { y) 5!:0)
  flags typeval <'r'
end.
)
lintconjadverse=: (<,':.') lintclass4 1
lintconjpower=: (<,'^:') lintclass4 0

NB. Class: ;.   u is AR of the actual conjunction used
NB. v is (the types that the two args must NOT be),(flags to install, indicating invalid valences of the derived verbs)
lintclass5=: 2 : 0
'typeu typev'=. 0 {"1 y
NB. Flags come from monadic u
flags=. (2{n) bwor (sideeffvmerrloc bwand typeu) bwor +: typeu bwand sideeffvm

NB. supplied v tells what each operand must NOT be
if. bwor/ (2{.n) bwand (typeu,typev) do.
  (flags bwor verb+parseerror);''
  
NB. If either operand unknown, produce 'unknown verb' result
elseif. (<'') e. 1 {"1 y do.
  (flags+verb);''
  
NB. Otherwise, produce the derived verb, return its type;value
elseif. do.
  r=. ((<0 1) { y) 5!:0 (u 5!:0) (((<1 1) { y) 5!:0)
  flags typeval <'r'
end.
)
lintconjcut=: (<,';.') lintclass5 (0,verb,0)
lintconjderiv=: (<,'d.') lintclass5 (0,verb,invdyad)
lintconjDeriv=: (<,'D.') lintclass5 (0,verb,0)
lintconjtaylor=: (<,'T.') lintclass5 (noun,verb,invdyad)
lintconjhyper=: (<,'H.') lintclass5 (verb,verb,0)
lintconjsecant=: (<,'D:') lintclass5 (noun,verb,invmonad)

NB. Class: @.   u is AR of the actual conjunction used
NB. v is the types that the two args must NOT be
lintclass6=: 2 : 0
'typeu typev'=. 0 {"1 y
NB. Flags indicate always side-effects; errors, loc come from either arg
flags=. sideeff bwor sideeffverrloc bwand typeu bwor typev

NB. supplied v tells what each operand must NOT be
if. bwor/ n bwand (typeu,typev) do.
  (flags bwor verb+parseerror);''
  
NB. If either operand unknown, produce 'unknown verb' result
elseif. (<'') e. 1 {"1 y do.
  (flags+verb);''
  
NB. Otherwise, produce the derived verb, return its type;value
elseif. do.
  r=. ((<0 1) { y) 5!:0 (u 5!:0) (((<1 1) { y) 5!:0)
  flags typeval <'r'
end.
)
lintconjevokegerund=: (<,'`:') lintclass6 (verb,verb)
lintconjagenda=: (<,'@.') lintclass6 (verb,0)

NB. The remaining conjunctions require special coding
linttie=: 3 : 0
NB. If either operand unknown, produce unknown noun
if. (<'') e. 1 {"1 y do.
  noun;''
NB. Otherwise, produce the derived noun, return its type;value
else.
  r=. ((<0 1) { y) 5!:0 ` (((<1 1) { y) 5!:0)
  0 typeval <'r'
end.
)

lintfit=: 3 : 0
NB. If either operand unknown, use the left operand
if. (<'') e. 1 {"1 y do.
  {. y
else.
NB. Otherwise, produce the verb and keep its flags
  r=. ((<0 1) { y) 5!:0 !. (((<1 1) { y) 5!:0)
  (sideeffverrloc bwand (<0 0) {:: y) typeval <'r'
end.
)

lintcolon=: 3 : 0
'typeu typev'=. 0 {"1 y
NB. If either operand is unknown, guess an unknown verb with side effects
if. (<'') e. 1 {"1 y do.
  (verb+sideeff);''
NB. If both operands are verbs, flags come from monad  u and dyad v, with
NB. error and setloc from either
elseif. verb bwand typeu bwand typev do.
  flags=. ((parseerror+setlocale+sideeffvm) bwand typeu) bwor ((parseerror+setlocale+sideeffvd) bwand typev)
  r=. ((<0 1) { y) 5!:0 : (((<1 1) { y) 5!:0)
  flags typeval <'r'
NB. If left operand is not a noun, error
elseif. 0 = noun bwand typeu do.
  (verb+sideeff+parseerror);''
NB. Otherwise, create a side-effectful unknown entity of the correct type, and flag its valences
elseif. do.
  u=. {. , ((<0 1) { y) 5!:0   NB. evaluate left operand, take first number for safety
NB. Evaluate the right operand.  If it is nonnumeric, ignore it and produce an unknown.
  v=. ((<1 1) { y) 5!:0   NB.?lintonly v =. ''
  if. 0 1 4 -.@e.~ 3!:0 v do.
NB. catch the special case of m : ''.  This is how an empty explicit shows up.  If
NB. we have one of those, say that it has no valences.
    ((invmonad * 3 * v -: '')+sideeff+((0 1 2 3 i. u){(noun,adv,conj,verb,verb)));''   NB. 3 4 13, all verbs
NB. If the right value is 0, we know nothing, just produce sideeffectful unknown
  elseif. v = 0 do.
    (sideeff+((0 1 2 3 i. u){(noun,adv,conj,verb,verb)));''   NB. 3 4 13, all verbs
  elseif. do.
NB. If the right operand is numeric nonzero, its value was created when the explicit was
NB. analyzed.  Its 3 bits are monad exists, dyad exists, modifier produces explicit verb
    'modexp mdexist'=. 2 4 #: {. , v
NB. If this verb is dyad-only, shift the existence of the monad up to the dyad
    if. u = 4 do. mdexist=. 2 * 1 bwand mdexist
NB. If this : creates a modifier, and it does not create an explicit verb, we should not
NB. flag invalid valences, since the result, if it is a verb, is bivalent by definition
    elseif. (u e. 1 2) *. -. modexp do. mdexist=. 3
    end.
    
NB. Create the verb, with the invalid valences flagged
    ((invmonad * 3-mdexist)+sideeff+((0 1 2 3 i. u){(noun,adv,conj,verb,verb)));''   NB. 3 4 13, all verbs
  end.
end.
)

NB. The foreigns (by line) that can be executed safely during the scan
okforeignverbs=: ; <@({. ,. }.)@".;._2 (0 : 0)
3   0 1 2 3 4 5
6   0 1 8 9
7   0 1 3
8   0 1 2
9   0 2 6 8 10 12 14 16 18 20 24 36 38 40 42 44 46 48
13  11 12
18  5
128 0 1 3 4 5
)
NB. foreigns (by line) that do not produce side effects, but must not be executed during the scan
unknforeignverbsnosideeff=:  ; <@({. ,. }.)@".;._2 (0 : 0)
1   0 1 4 11 20 30 43 46
2   5 6
4   0 1 3 4
5   1 2 4 5 6 7
7   5 6
9   26 28 32 34
18  0 1
)
lintforeign=: 3 : 0
NB. if not both operands are nouns, create side-effectful error verb
if. 0 = bwand/ noun , 0 {::"1 y  do.
  (verb+sideeff+parseerror);''
NB. if an operand is unknown, create side-effectful unknown verb
elseif. (<'') e. 1 {"1 y do.
  (verb+sideeff);''
NB. If a combination of m,n can be created safely, do so.  It may be any part of speech
NB. Otherwise, see if it creates an adverb
elseif. do.
  m=. ((<0 1) { y) 5!:0
  n=. ((<1 1) { y) 5!:0
NB.?lintonly 'm n' =. 0
NB. If it's a harmless combination, allow it as a verb
  if. (mn=. m,n) e. okforeignverbs do.
    r=. m!:n
    0 typeval <'r'
NB. 18!:2 is allowed only as a monad
  elseif. mn -: 18 2 do.
    r=. m!:n
    sideeffd typeval <'r'
NB. 5!:0 is an adverb, but since who knows what it produces we make it unknown
  elseif. mn -: 5 0 do.
    adv;''
NB. others are verbs, safe except as listed
  elseif. do.
    (verb+sideeff * -. mn e. unknforeignverbsnosideeff);''
  end.
end.
)


NB. Adverbs
NB. These are monads taking type;value of u

NB. Class: /   u is AR of the actual conjunction used
NB. v is 0 to use monadic flags only, 1 to use both, 2 to use dyad
lintaclass0=: 2 : 0
typeu=. 0 {:: y
NB. Flags come from u depending on local v
select. n
  case. 0 do.   NB. result flags of both valences come from monad u
    flags=. (typeu bwand sideeffvmerrloc) bwor +: typeu bwand sideeffvm
  case. 1 do.   NB. result flags of both valences come from corresponding flags of u
    flags=. sideeffverrloc bwand typeu
  case. do.   NB. (must be 2) result flags of both valences come from dyad u
    flags=. (typeu bwand sideeffvderrloc) (bwor _1&bwlsl) typeu bwand sideeffvd
end.

NB. For noun, we produce a side-effectful unknown verb, since we aren't into analyzing gerunds (or names in the case of f., or indices for })
if. noun bwand typeu do.
  (flags bwor verb+sideeff);''
  
NB. If operand unknown, produce 'unknown verb' result
elseif. (<'') e. 1 {"1 y do.
  (flags+verb);''
  
NB. Otherwise, produce the derived verb, return its type;value
elseif. do.
  r=. (1 { y) 5!:0 (u 5!:0)
  flags typeval <'r'
end.
)
lintadvinsert=: (<,'/') lintaclass0 2
lintadvoblique=: (<,'/.') lintaclass0 0
lintadvprefix=: (<,'\') lintaclass0 0
lintadvsuffix=: (<,'\.') lintaclass0 0
lintadvfix=: (<,'f.') lintaclass0 1
lintadvmemo=: (<,'M.') lintaclass0 1
lintadvamend=: (<,'}') lintaclass0 1

NB. Class: t.   u is AR of the actual conjunction used
lintaclass1=: 1 : 0
typeu=. 0 {:: y
NB. Flags come from monad u
flags=. (sideeffvmerrloc bwand typeu) bwor +: typeu bwand sideeffvm

NB. If operand unknown, produce 'unknown verb' result
if. (<'') e. 1 {"1 y do.
  (flags+verb);''
  
NB. Otherwise, produce the derived verb, return its type;value.  We accept noun
NB. operands here because for this numeric adverb we assume no side-effects
else.
  r=. (1 { y) 5!:0  (u 5!:0)
  flags typeval <'r'
end.
)
lintadvtaylor=: (<,'t.') lintaclass1
lintadvwtaylor=: (<,'t:') lintaclass1

lintboolean=: 3 : 0
typeu=. 0 {:: y
NB. For noun op, produce a verb
if. noun bwand typeu do.
  if. (<'') e. 1 {"1 y do.
    (verb);''
  else.
    r=. (1 { y) 5!:0  b.
    0 typeval <'r'
  end.
else.
NB. For verb op, produce a noun
NB. If operand unknown, produce 'unknown noun' result
  if. (<'') e. 1 {"1 y do.
    (noun);''
  else.
    r=. (1 { y) 5!:0  b.
    0 typeval <'r'
  end.
end.
)

lintevoke=: 3 : 0
typeu=. 0 {:: y
NB. For noun op, produce an unknown side-effectful verb
if. noun bwand typeu do.
  (verb+sideeff);''
else.
NB. For verb op, create verb from u, using dyadic flags
  flags=. (sideeffvderrloc bwand typeu) bwor _1 bwlsl typeu bwand sideeffvd
NB. If operand unknown, produce 'unknown noun' result
  if. (<'') e. 1 {"1 y do.
    (flags+verb);''
  else.
    r=. (1 { y) 5!:0  ~
    flags typeval <'r'
  end.
end.
)

lint_z_=: lint_lint_
