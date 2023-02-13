NB. defs

ShowFrames=: 0

getPDFreader=: 3 : 0
if. 0~: 4!:0 <'PDFReader_j_' do.
  ''
else.
  PDFReader_j_
end.
)

NB. =========================================================
Padchar=: 'W' NB. pad/spacer for PDF output W=widest
Txm_port=: '1 0 0 1 '
Txm_land=: '0 1 -1 0 '

NB. =========================================================
NB. page sizes:
PSletter=: 612 792    NB. 72 * 8.5 11
PSa4=: 595.28 841.89  NB. 72 * 210 297 % 25.4

NB. =========================================================
setdefaults=: 3 : 0
locS=: locP=: coname''
buf=: ''
GroupNum=: _1
Level=: ''
Locales=: ''
Localex=: ''
Plots=: ''
Sections=: ''
SectionNum=: _1 NB. top level section number
Urls=: UrlIds=: ''
XObjects=: ''
)

NB. =========================================================
pageinit=: 3 : 0
'Px Py Pw Ph'=: Pxywh=: 0 0,PAGESIZE
'Lm Tm Rm Bm'=: PAGEMARGINS
setframe Pxywh shrinkmargins PAGEMARGINS
setdraw Fxywh
)
