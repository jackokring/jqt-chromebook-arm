NB. zudiag.ijs - written by Ian Clark
NB. Sat 08 Sep 2012 21:00:00
NB. Diagnoses state of zulu installation

ZUDIAG_z_=: 0

present=. 3 : 'y,'':'',":0<: 4!:0<y'

ZUTAGS=. 'ZU4 ZUANY ZUERASE ZULUN ZUN ZUPHON ZUTEST ZUV ZUVCO ZUDIAG'

(0 0 $ 1!:2&2) log ZUTAGS

vns=. 'b4b o4b f4b x4b b4o o4o f4o x4o b4f o4f f4f x4f b4x o4x f4x x4x'
vns=. vns,' b2b b2o b2f b2x o2b o2o o2f o2x f2b f2o f2f f2x x2b x2o x2f x2x'
vns=. vns,' a2b a2o a2f a2x'
vns=. vns,' b4a o4a f4a x4a'
vns=. vns,' nul1 fix1 nul2 fix2'

(0 0 $ 1!:2&2) 'converter verbs in _z_ ...'
(0 0 $ 1!:2&2) list present each ;:vns

(0 0 $ 1!:2&2) 'names_zulu_ ...'
(0 0 $ 1!:2&2) names_zulu_''

ZUDIAG_z_=: 1
