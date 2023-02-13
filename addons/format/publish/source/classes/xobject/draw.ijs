NB. xobject
NB.
NB. this build a pair of objects:
NB.   resource dictionary
NB.   image xobject

NB. =========================================================
NB. build xobject for image
xobject=: 3 : 0
('xobject',Type)~''
)

NB. =========================================================
NB. build XObject
xobjectbmp=: 3 : 0
dat=. read''
'rws cls'=. Shape
dat=. toascii85 rgb2alf ,dat
s=. '/Type /XObject'
s=. s,LF,'/Subtype /Image'
s=. s,LF,'/Width ',":cls
s=. s,LF,'/Height ',":rws
s=. s,LF,'/ColorSpace /DeviceRGB'
s=. s,LF,'/BitsPerComponent 8'
s=. s,LF,'/Length ',":#dat
s=. s,LF,'/Filter /ASCII85Decode'
s=. dict s
s=. s,'stream',LF,dat,LF,'endstream',LF
)

NB. =========================================================
NB. build XObject
xobjectjpg=: 3 : 0
dat=. read''
'rws cls'=. Shape
dat=. ,dat
s=. '/Type /XObject'
s=. s,LF,'/Subtype /Image'
s=. s,LF,'/Width ',":cls
s=. s,LF,'/Height ',":rws
s=. s,LF,'/ColorSpace /DeviceRGB'
s=. s,LF,'/BitsPerComponent 8'
s=. s,LF,'/Length ',":#dat
s=. s,LF,'/Filter /DCTDecode'
s=. dict s
s=. s,'stream',LF,dat,'endstream',LF
)
