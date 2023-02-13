	NB. uu - formatin.ijs
'==================== [uu] formatIN.ijs =================='
0 :0
Monday 6 May 2019  03:42:54
-
defines formatIN - input-counterpart to: format
-
cloned into: tempuu 44 pre-purge of FahR etc: 15 November 2018
NOTE: tempuu 44 has useful test expressions purged from here.
)

cocurrent 'uu'
	
registerIN=: 3 : 0
  NB. for use in take_ verbs only
  NB. reports the last take_* verb to be entered
NB. msg '+++ registerIN: (y)'
VEXIN=: y
)

formatIN=: 3 : 0
msg '+++ formatIN: ENTERED, y=[(y)]'
  NB. y is right arg of uu_uu - the input string for conversion
blink 0	NB. turn blink-1 OFF to start with
VEXIN=: '<UNSET>'
z=. daisychainIN y
msg '--- formatIN: EXITS, last take_ verb: (VEXIN) kuy=(kuy) -returns z=(z)'
z return.
)

make_daisychainIN=: 3 : 0
  NB. makes the daisychain for: formatIN
  NB. NOTE: take_ verbs are all MONADIC
>z=. 'take_' nl 3
]z=. (; z,each <' ::'),'takerr'
daisychainIN=: 13 : ('(',z,')y')
i.0 0
)

takerr=: 3 : 0
msg '>>> takerr: none chime: x=(x) y=(y)'
sw'(y) (BADUNITS)'
)

take_0_angle=: 3 : 0
registerIN 'take_0_angle'
blink'green'
  NB. inputs angle y (degrees); outputs laundered y
  NB. since angle is scalable, does not need to convert to rad
  NB. Ensure postfixed 'deg' hasn't run-into the value…
yb=. (bris y) rplc 'deg' ; ' deg'
]unit=. deb unitsOf yb
assert. (unit-:'deg')or(unit-:'rad')
yb return.
)

take_0_dms=: 3 : 0
registerIN 'take_0_dms'
blink'green'
  NB. inputs angle y (deg amin asec); outputs fractional y in [deg]
  NB. since angle is scalable, does not need to convert to rad
  NB. Ensure postfixed 'deg' 'amin' 'asec' haven't run-into their values…
z=. ;: (bris y) rplc 'deg' ; ' deg' ; 'amin' ; ' amin' ; 'asec' ; ' asec'
assert. (t=. ;:'deg asec amin') -: 3{.sortd z
'd m s'=. ".each z-.t
' deg',~ ": d + (m%60) + (s%3600) return.
)

take_1_hms=: 3 : 0
registerIN 'take_1_hms'
blink'green'
  NB. inputs time: y in format: 'hh:mm:ss'; outputs y in [s]
assert. 2= +/CO=y  NB. must contain 2 colons
z=. CO cut y-.SP
'h m s'=. ".each z
' s',~ ": (h*3600) + (m*60) + s return.
)

take_8_misc=: 3 : 0
registerIN'take_8_misc'
blink 'blue'
  NB. picks up miscellaneous forms
if. isUndefined y do. 'UNDEFINED' return. end.
if. SIC>0 do. infinity=. '∞' else. infinity=. 'infinity' end.
if. y=__ do. '-',infinity return.
elseif. y=_ do. infinity return.
end.
assert. 0  NB. force error if has not already return.ed
)

take_9_general=: 3 : 0
registerIN'take_9_general'
blink'white'
  NB. chimes if nothing else does
  NB. Verb names are sorted --> this comes last of all
z=. y	NB. FOR THE PRESENT: DOES NOTHING <<<<<<<<<<<<<<<<<<
msg '... take_9_general: y=(y) --> z=(z)'
z return.
)

make_daisychainIN''