NB. eigenpicture window

EP=: 0 : 0
pc ep closeok escclose;
menupop "Examples";
menu default "&Default" "" "" "";
menusep;
menu onezero "&Zero Eigenvalue" "" "" "";
menusep;
menu double "&Double Eigenvalue" "" "" "";
menusep;
menu complex "&Complex Eigenvalues (1)" "" "" "";
menusep;
menu complex2 "C&omplex Eigenvalues (2)" "" "" "";
menupopz;
menupop "Help";
menu about "&About" "" "" "";
menupopz;
bin vh;
groupbox "Matrix";
cc mat edit;
cc matrix static;
bin hs;
cc negate button;cn "Negate";
bin z;
groupboxend;
bin v;cc run button;cn "Run";
bin szzh;
groupbox "Eigenvalues";
cc ev1 static;
cc ev2 static;
groupboxend;
groupbox "Eigenvectors";
cc rv1 static;
cc rv2 static;
groupboxend;
bin zz;
pas 4 4;
)

NB. =========================================================
ep_run=: 3 : 0
wdpclose 'ep'
wdpclose 'epd'
epinit''
wd EP
wd 'pn *',SYSNAME
wd 'set mat text *',":,MATCHAR
wd 'set matrix text *', addLF MATRIX
wd 'setfont mat fixfont'
wd 'setfont matrix fixfont'
wd 'setfont ev1 fixfont'
wd 'setfont ev2 fixfont'
wd 'setfont rv1 fixfont'
wd 'setfont rv2 fixfont'
wd 'set ev1 text;set ev2 text;set rv1 text;set rv2 text'
wd 'pmove 50 20 400 300'
wd 'pshow'
)

NB. =========================================================
ep_close=: 3 : 0
smoutput 'ep_close'
try. wd 'psel epd;pclose' catch. end.
wd 'psel ep;pclose'
)

NB. =========================================================
ep_about_button=: 3 : 0
wd 'mb about About *',topara ABOUT
)

NB. =========================================================
ep_complex_button=: 3 : 0
MATRIX=: 2 2 $ ". MATCHAR=: '-1 2 _1 1'
epdoit''
)

NB. =========================================================
ep_complex2_button=: 3 : 0
MATRIX=: 2 2 $ ". MATCHAR=: '-3 2 _1 1'
epdoit''
)

NB. =========================================================
ep_default_button=: 3 : 0
MATRIX=: 2 2$ ". MATCHAR=: MATDEFAULT
epdoit''
)

NB. =========================================================
ep_double_button=: 3 : 0
MATRIX=: 2 2 $ ". MATCHAR=: '(4-%:3), 1 _3, 4+%:3'
epdoit''
)

NB. =========================================================
ep_negate_button=: 3 : 0
MATCHAR=: mat
if. '-' = {. MATCHAR do.
  MATCHAR=: }.MATCHAR
else.
  MATCHAR=: '-',MATCHAR
end.
MATRIX=: 2 2$ ". MATCHAR
epdoit''
)

NB. =========================================================
ep_onezero_button=: 3 : 0
MATRIX=: 2 2$ ". MATCHAR=: '1 _1 _1 1'
epdoit''
)

NB. =========================================================
ep_run_button=: 3 : 0
x=. ,@". :: 0: mat
if. (4~:$x) +. 0=isnumeric x do.
  info 'Invalid matrix definition'
else.
  if. iscomplex x do.
    info 'Matrix should be real'
  else.
    MATCHAR=: deb mat
    MATRIX=: 2 2$ x
    epdoit''
  end.
end.
)

NB. =========================================================
ep_mat_button=: ep_run_button
ep_cancel=: ep_cancel_button=: ep_close

NB. =========================================================
epdoit=: 3 : 0
FONT=: 0 1 {:: wd'qtstate profont'
FONTSIZE=: getfontsize FONT
calc''
wd 'set mat text *',":,MATCHAR
wd 'set matrix text *', addLF MATRIX
'x1 y1 x2 y2'=. tominus@": each , RV
'e1 e2'=. tominus@": each , EV
wd 'set rv1 text *',x1,LF,x2
wd 'set ev1 text *', e1
wd 'set rv2 text *', y1,LF,y2
wd 'set ev2 text *', e2
epdraw''
glpaint''
)

NB. =========================================================
epinit=: 3 : 0
LASTPTS=: i.0 0
SPOKES=: 2 * >. -: SPOKES NB. should be even
)

NB. =========================================================
ep_run''
