NB. url
NB.
NB. this builds the url resource dictionary

NB. =========================================================
NB. build url dictionary
url=: 3 : 0
s=. '/Type /Filespec'
s=. s,LF,'/FS /URL'
s=. s,LF,'/F (',Data,')'
dict s
)