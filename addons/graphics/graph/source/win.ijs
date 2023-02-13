NB. window commands

NB. =========================================================
NB. popen       open graphics window
NB. y = 'parentid';'parentname';initial pixel size
popen=: 3 : 0
'pid pnm siz'=. 3 {. boxopen y
pnm=. pnm, (0=#pnm) # pid
wd 'pc ',pid,';pn *',pnm
wd 'minwh 200 200;cc g isigraph flush'
wd 'pas 0 0;pcenter;ptop'
HWNDP=: wd 'qhwndp'
HWNDC=: wd 'qhwndc g'
gdaddid (,pid);HWNDP;coname''
if. #siz do.
  fx=. 0 ". wd 'qform'
  wh=. _2 {. 0 ". wd 'qchildxywh g'
  del=. siz - wh
  wd 'pmove ',":fx + 0 0,del
else.
  fx=. 0 ". wd 'qform'
  wd 'pmove 300 10 ',": 2 }. fx
end.
(pid,'_g_paint')=: ppaint
(pid,'_cancel')=: pclose
(pid,'_close')=: pclose
wdfit''
)

NB. =========================================================
pclose=: destroy

NB. =========================================================
pshow=: 3 : 0
ppaint''
glpaint''
wd 'pshow'
)

NB. =========================================================
NB. ppaint v painter
ppaint=: 3 : 0
initdef''
initwin''
glclear''
for_d. GDCMD do.
  'f v'=. d
  f~v
end.
)
