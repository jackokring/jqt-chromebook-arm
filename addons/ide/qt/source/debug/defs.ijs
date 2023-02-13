NB. defs
NB.
NB. STATE=0   normal
NB.       1   cutback
NB.       2   step forward
NB.       3   step into
NB.       4   step out
NB.       5   jdb_run to cursor

NB. =========================================================

ERM_j_=: ''   NB. last error message stored in j

ERRORS=: '';(9!:8''),<'Unknown Error'
ERRORCODES=: (i.#ERRORS) -. 0 18   NB. exclude none and stop

IFDISSECT=: 'true' -: 0 1&{::@:wd ::0: 'qtstate debugdissect' NB. if include dissect

NB. smallest sizes (MINWIDTH so all buttons are displayed):
MINWIDTH=: 540
MINHEIGHT=: 500

MNUV=: ;: 'm n u v m. n. u. v.'
MNUVXY=: ;: 'm n u v x y m. n. u. v. x. y.'
NVX=: ;: 'n v x n. v. x.'

PTOP=: 1 NB. default ptop
NULL=: $0
STACKPOS=: 0 NB. stack position
SMBOTH=: 0  NB. rep is both monadic and dyadic
STOPNONE=: '';0;0;NULL;NULL          NB. jdb_empty stop line
SHOWWID=: 80
jdb_vSHOWWID=: SHOWWID"_

TABCURRENT=: ''  NB. current tab name
TYPES=: 'acv'    NB. type ids

STOPNONE=: '';0;0;NULL;NULL          NB. jdb_empty stop line
TYPES=: 'acv'    NB. type ids

NB. =========================================================
jdb_debuginit=: 3 : 0
jdb_stopwrite STOPS=: i.0 5    NB. stop settings as table; clear them in the session too
DISSECTOPTIONS=:0 5$a:  NB. dissectoptions;name;locale;valence;lines
'HWNDP' jdb_default ''
if. 0>4!:0 <'WINPOS' do.
  WINPOS=: 0 ". (<0 1) >@{ jdb_wd 'qtstate debugpos'
end.
jdb_debugreset''
)

NB. =========================================================
jdb_debugreset=: 3 : 0
CODELINES=: ''
CURRENTLINE=: 0
ERRMSG=: ''
ERRNUM=: 0
GDEFS=: ''        NB. global non-noun definitions in current line
HWNDPX=: ''       NB. last parent window handle
LDEFS=: ''        NB. local non-noun definitions in current line
LOCALE=: <'base'  NB. current locale
LOCALNAMES=: ''   NB. local names
LOCALTYPES=: ''   NB. local name;type as found in session
LOCALVALS=: ''    NB. corresponding local values
LXS=: ''          NB. current latent expression
MOVELINE=: 0      NB. current line number
NAME=: ''         NB. current name
NUMLINES=: 0      NB. number of lines in current definition
SCROLL=: 0        NB. scrolled lines in first panel
STACK=: i.0 9     NB. current stack
SMNAMES=: i.0 2   NB. names in stop manager (name,locale)
SMLOCALE=: ''     NB. selected locale
SSTACKS=: ''      NB. stop stacks
SSNAMES=: ''      NB. stop names
STACKLOCALS=: ''  NB. stack locals
STATE=: 0         NB. state
STOPLAST=: ''     NB. last stop setting as string
WATCH=: ''        NB. watch
)
