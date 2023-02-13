NB. init
NB.
NB. main definitions:
NB.*print v print text
NB.*printfile v print file
NB.*print2 v print text in 2-up mode
NB.*printfile2 v print file in 2-up mode
NB.
NB. utilities:
NB. printopts v print options
NB.
NB. DEFFONT     default print font (if config not available)
NB. DEFFONT2    default print2 font (if config not available)
NB.
NB. TOPM BOTM LEFTM RIGHTM FOOTM        - print margins
NB. TOPM2 BOTM2 LEFTM2 RIGHTM2 FOOTM2   - print2 margins

coclass 'jprint'
coinsert^:IFQT 'qtprinter'

PATHSEP=: '/'
PRINTERFONT=: (('Linux';'Darwin';'Android';'Win') i. <UNAME){:: 'Serif 12' ; '"Lucida Grande" 12' ; (IFQT{::'Serif 12';'"Droid Serif" 12') ; '"Courier New" 12'
P2UPFONT=: (('Linux';'Darwin';'Android';'Win') i. <UNAME){:: 'Serif 7.5 bold' ; '"Lucida Grande" 7.5 bold' ; (IFQT{::'Serif 7.5 bold';'"Droid Serif" 7.5 bold') ; '"Courier New" 7.5 bold'
PRINTOPT=: ''

NB. default fonts (if configure font not available or not set)
DEFFONT=: (('Linux';'Darwin';'Android';'Win') i. <UNAME){:: 'Serif 10 bold' ; '"Lucida Grande" 10 bold' ; (IFQT{::'Serif 10 bold';'"Droid Serif" 10 bold') ; '"Courier New" 10 bold'
DEFFONT2=: (('Linux';'Darwin';'Android';'Win') i. <UNAME){:: 'Serif 7 bold' ; '"Lucida Grande" 7 bold' ; (IFQT{::'Serif 7 bold';'"Droid Serif" 7 bold') ; '"Courier New" 7 bold'

NB. margins for print are inches from page edge:
TOPM=: 0.4
BOTM=: 0.75
FOOTM=: 0.4
LEFTM=: 0.5
RIGHTM=: 0.5

NB. margins for print2 are fractions of page:
TOPM2=: 0.015
BOTM2=: 0.03
LEFTM2=: 0.015
FOOTM2=: 0.015

NB. scale from twip to pixels
SCALE=: 1 1
OFFSET=: 0 0

NB. kludg
NB. correction factor for glzqextent
CF=: 1
NB. mono font used for calibrating CF
CFFONT=: (('Linux';'Darwin';'Android';'Win') i. <UNAME){:: 'Monospace 12' ; 'Monaco 12' ; (IFQT{::'monospace 12';'"Droid Sans Mono" 12') ; '"Lucida Console" 12'
