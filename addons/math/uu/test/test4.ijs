smoutput(jpathsep>(4!:4<'zx'){4!:3'');~zx=.'uu test4'
0 :0
Sunday 12 May 2019  16:51:32
-
UU: scientific units conversion package - test4
Hive-off all *_test verbs and inserts from the source code
(from temp 18)
component tests of: format compatible ucode uniform
plus a lot of misc tests as 0:0 inserts.
)

cocurrent 'base' [clear''

format_test=: 3 : 0
assert. '3° 8′ 29″' -: 'dms' formatOUT_uu_ PI
assert. '23:26:24' -: 'hms' formatOUT_uu_ 23.44  NB. [h]
NB. smoutput '--- format_test: ok'
)

format_test''

compatible_test=: 3 : 0
assert. '*' compatible_uu_ ,'m'
assert. '*' compatible_uu_ 'kg'
assert. '!' compatible_uu_ ,'m'
assert. '!' compatible_uu_ 'kg'
assert. (,'*') compatible_uu_ ,'m'
assert. (,'*') compatible_uu_ 'kg'
assert. (,'!') compatible_uu_ ,'m'
assert. (,'!') compatible_uu_ 'kg'
assert. (,'J') compatible_uu_ 'cal'
assert. (,'J') compatible_uu_ 'kcal'
NB. smoutput '--- compatible_test: ok'
)

compatible_test''

ucode_test=: 3 :0
assert. 'm^2/K/s^2'	-: 0 ucode_uu_ 'm² K⁻¹ s⁻²'  NB. SL not: ⁻¹
assert. 'm² K⁻¹ s⁻²'	-: 1 ucode_uu_ 'm² K⁻¹ s⁻²'
assert. 'ft/(s s)'		-: 0 ucode_uu_ 'ft/(s·s)'
assert. 'ft/(s·s)'		-: 1 ucode_uu_ 'ft/(s·s)'
assert. 'm²/K/s²'		-:   ucode_uu_ 'm^2/K/s^2'
NB. smoutput '--- ucode_test: ok'
)

ucode_test''

uniform_test=: 3 : 0
assert. 'm m/K/s/s'	-: 0 uniform_uu_ 'm m/(K s s)'
assert. 'm m/(K s s)'	-: 1 uniform_uu_ 'm m/(K s s)'
assert. 'm m K⁻¹ s⁻¹ s⁻¹'	-: 2 uniform_uu_ 'm m/(K s s)'
assert. 'm·m·K⁻¹·s⁻¹·s⁻¹'	-: 3 uniform_uu_ 'm m/(K s s)'
assert. 'm^2/K/s^2'	-: 0 uniform_uu_ 'm^2/K/s^2'
assert. 'm²/(K s²)'	-: 1 uniform_uu_ 'm^2/K/s^2'
assert. 'm² K⁻¹ s⁻²'	-: 2 uniform_uu_ 'm^2/K/s^2'
assert. 'm²·K⁻¹·s⁻²'	-: 3 uniform_uu_ 'm^2/K/s^2'
assert. 'ft/s^2'		-: 0 uniform_uu_ 'ft/s^2'
assert. 'ft/s²'		-: 1 uniform_uu_ 'ft/s^2'
assert. 'ft s⁻²'		-: 2 uniform_uu_ 'ft/s^2'
assert. 'ft·s⁻²'		-: 3 uniform_uu_ 'ft/s^2'
NB. smoutput '--- uniform_test: ok'
)

uniform_test''

0 :0
'degC' give_deg 373.15
'deg C' give_deg 373.15
'Celsius' give_deg 373.15
'C' give_deg 273.15
'C' give_deg 373.15
'F' give_deg 273.15
'F' give_deg 373.15
'Ro' give_deg 273.15
'Ro' give_deg 373.15
'N' give_deg 273.15
'N' give_deg 373.15
'De' give_deg 273.15
'De' give_deg 373.15
'Re' give_deg 273.15
'Re' give_deg 373.15
'K' give_deg 273.15
'K' give_deg 373.15
'Ab' give_deg 273.15  NB. _. (no such scale)
'Ab' give_deg 373.15  NB. _. (no such scale)
)

0 :0
deg4rad PI        NB. 180°
amin4rad PI%60    NB. 180'
asec4rad PI%3600  NB. 180"
)

0 :0
fmt=: formatOLD
fmt=: formatOUT
'Celsius' fmt 373.15
'able' fmt 99
'able' fmt __
'able' fmt UNDEFINED
'hms' fmt 1
'hms' fmt (s4h 4)+(s4min 2)+1  NB. 04:02:01
'dms' fmt PI
'dms' fmt (rad4deg 3)+(rad4amin 5)+(rad4asec 2)  NB. 3° 5' 2"
VEX
)


NB. main.ijs

0 :0
deslash'ft/s^2'
)

0 :0
note 440           NB. A (concert-pitch is 440 Hz)
note 194.18        NB. G (earth-rotation musical note)
)

NB. pp_encoding.ijs

0 :0
make_unitc''		NB. 1st pass
dip 0=uvalc
2 make_unitc''	NB. 2nd pass
3 make_unitc''	NB. 3rd pass
4 make_unitc''	NB. 4th pass
)

0 :0
	units	nominal units in UUC, e.g. [Ohm]
	unitv	units on which UUC defn is based
	unitx	unitv expanded into fundamental units
	uvalu	conversion factor explicit in UUC
	uvalx	conversion factor to go with unitx
	uvalc	conversion factor to go with unitc
	unitc	pp-coded units, expandcode must match unitx
)

0 :0
qtcode4i 59
VIEWTABLE=: 10  NB. number of lines in viewtable output
smoutput vt 59
dip uvalx ~: uvalc
)

0 :0
trv 1  NB. trace: qtcode4i qtcode4anyunit qtcode4bareunit scale4bareunit
trv '+cnvCunit'
-
qtcode4bareunit 'acre'    NB. │4046.86│4│
-
cocurrent 'uu'
erase 'foo_uu_ foo_z_ foo__'
foo_z_=: scale4bareunit_uu_
foo_z_=: cnvCunit_uu_
foo_z_=: qtcode4bareunit_uu_
redux 10  NB. foo_z_=: cnvCunit_uu_
redux 11  NB. foo_z_=: qtcode4anyunit_uu_
redux 12  NB. foo_z_=: [: uuOLD '1 ' , ]
redux 13  NB. foo_z_=: convert_uu_
redux 14  NB. (test of SI-conformance levels)
redux 15  NB. foo_z_=: [: uuNEW '1 ' , ]
)

0 :0
'ft/s^2' uu '1 Å h⁻²'
x_uu_=:'ft/s^2' [ y_uu_=: '1 Å h⁻²'
        uu '100 degC'
        uu '212 degF'
        uu '373.15 K'
 'degF' uu '100 degC'
 'degC' uu '212 degF'
 'degF' uu '212 degF'
 'degC' uu '100 degC'
)
