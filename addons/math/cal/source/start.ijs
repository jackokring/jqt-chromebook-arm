	NB. cal - start.ijs
'==================== [cal] start.ijs ===================='

cocurrent 'cal'

VERSION=: '0.0.0'  NB. overridden by: manifest.ijs

inversion=: inversion3  NB. the best choice to-date

globmake=: 3 : 0
  NB. Init global nouns
  NB. These are NOT "constants" - they may change in-session
  NB. If _cal_ used as a class: created in the numbered locale
ARROWCH=: ARROWCH1	NB. arrow-drawing chars (see consts.ijs)
DASHBOARD=: 0	NB. 1==dashboard enabled
DIRTY=: 0		NB. 1==t-table needs saving
INST=: UNSET	NB. 4-byte code of INSTR
INSTR=: UNSET	NB. current full instruction (including arg: yy)
ITEMNO=: _1	NB. 'exe'# of formula being executed
INVERSION=: ''	NB. inversion heuristics register
LASTINSTR=: UNSET	NB. assigned by: snap (called if changesTtable INST)
LOADFORMAT=: 1	NB. 0=ijs 1=tbx - preferred format to load
LOGINSTR=: ''	NB. internal log of CAL instructions performed
MAXINVERT=: 30	NB. limits backfit cycles
MSLOG=: 0 0$''	NB. accumulates MESSAGE
OVERHELDS=: ''	NB. items recognised by: beval
PAD=: 10		NB. used by: pad
PROTECT=: 1	NB. 1==don't overwrite t-table of same name
PLOT=: 0		NB. plot control parameter
RETURNED=: UNSET	NB. noun returned by i/f call
SAVEFORMAT=: 1	NB. 0=ijs 1=tbx - preferred format to save
STARTED=: 0	NB. 1==start completes ok
STATE=: ''	NB. UU state cache (empty for unset)
TIMEOUT=: 5	NB. seconds (used by: timeout)
TOLERANCE=: 1e_5	NB. default tolerance for comparing physical quantities
TTN=: ,<'tn'	NB. t-table cache for item names (boxed)
WARNPLEX=: 1	NB. 1==run warnplex after each recalc
i.0 0
)

start=: 3 : 0
  NB. start the CAL-engine
  NB. start 0 -- starts with SAMPLE0
  NB. start 1 -- starts with SAMPLE1 …etc.
  NB. start'' -- starts with empty t-table
  NB. start'$' -- starts with builtin SAMPLE
  NB. start'$$' -- starts with builtin|saved SAMPLE
  NB. start path -- starts with t-table: (path)
trace 0
sswInversion=: empty  NB. >>>>> DISABLE inversion heuristics tracing
NB. …switches ALL calls to: ssw within the set of _inver*_ locales
  NB. Create the TP*_z_ nouns (the JAL addon lacks tpathdev)
if. fexist p=. PARENTDIR sl 'tpathdev.ijs' do. loadFixed p
else.     loadFixed PARENTDIR sl 'tpathjal.ijs'
end.
loadFixed TPMC sl 'manifest.ijs'  NB. to get VERSION
  NB. erase unwanted globals loaded by manifest
erase'CAPTION FILES DESCRIPTION RELEASE FOLDER LABCATEGORY PLATFORMS'
  NB. load class UU
loadFixed TPUU sl 'uu.ijs'
uun=: uuconnect''  NB. create instance of class UU
make_CAL'' NB. create semantic fns for tabengine
globmake'' NB. make global nouns
tbx=: SAVEFORMAT&Xtbx   NB. the preferred (global) version of: tbx
file1=: '' NB. unused in start
file=: tbx UNDEF	NB. the loaded filename cache
progress _ NB. init progressbar to idle state
extendedSine EXTENDEDSINE  NB. enable/disable extended trig fns
0 enlog 0  NB. start a new log file
createDirIfAbsent TPTT  NB. establish user's t-table library
createDirIfAbsent TPAR  NB. establish user's t-table archive
  NB. load a starting t-table (picked by y)
select. y
case. '' do. ttnew''  NB. new empty t-table
case. 0 do. ttload 0
  NB. similar cases 1 to 9 handled by (case. do.) below…
case. '$' do. ttload'$'  NB. load SAMPLE, builtin only
case. '$$' do. ttload'$$'  NB. load SAMPLE, builtin or saved
case.   do. ttload y [smoutput '+++ start: loaded by default: ',":y
end.
vchecks''		NB. check integrity of v-buffers
onload_z_=: do	NB. leave it nice for the J IDE
STARTED=: 1	NB. registers successful completion of: start
)

loadFixed=: load&dquote

tt_z_=: tabengine_cal_

ttt_z_=: 3 : 0
z=:  tabengine_cal_ y
zz=: tabengine_cal_ 'CTBU'
(":z),LF,LF,zz
)

uuconnect=: 3 : 0
  NB. Create an instance of class 'uu' and connect to it.
  NB. Setup local verbs that shadow the UU-instantiation verbs.
  NB. Other UU-instantiation connections are called directly
uun=: '' conew 'uu'
uuengine		=: uuengine__uun
uniform		=: uniform__uun
kosher		=: (0&uniform)"1	NB. to convert units to ASCII
uun return.
)

plotDisabled=: default bind 'NOPLOT'

plot=: '' ddefine
  NB. PATCH: report disabled plot/pd for j807 nonavx
if. plotDisabled'' do.
  ssw '>>>{disabled} plot-package called with args:'
  ssw '   (paren crex x) plot (crex y)'
  ssw '... To enable plot-package:'
  ssw '   erase ', quote'NOPLOT_z_'
else.
  require 'plot'
  x plot_z_ y
end.
)

pd=: 3 : 0
  NB. PATCH: report disabled plot/pd for j807 nonavx
if. plotDisabled'' do.
  ssw '>>>{disabled} plot-package called with args:'
  ssw '   pd (crex y)'
  ssw '... To enable plot-package:'
  ssw '   erase ', quote'NOPLOT_z_'
else.
  require 'plot'
  pd_z_ y
end.
)

NB. ======================================================
NB. OPERATIONALLY: CAL MUST NOT START-ON-LOAD.
NB. TABULA STARTS IT WITH AN EXPLICIT CALL: start
NB. ======================================================
