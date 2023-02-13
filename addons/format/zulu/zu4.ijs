NB. zu4.ijs, for zulu.ijs written by Ian Clark
NB. Sat 08 Oct 2011 18:55:00
NB. Makes interconversions of form: *4* out of *2*
NB. Fix (f.) is used to allow ancillary verbs to be erased.

ZU4_z_=: 0

cocurrent 'z'	NB. c/f BASIC VERBS - ALWAYS LOADED INTO _z_ LOCALE

3 : 0''
try.
  b4a=: a2b f.
  o4a=: a2o f.
  f4a=: a2f f.
  x4a=: a2x f.
catch. end.
i.0 0
)

b4b=: b2b f.
o4b=: b2o f.
f4b=: b2f f.
x4b=: b2x f.

b4o=: o2b f.
o4o=: o2o f.
f4o=: o2f f.
x4o=: o2x f.

b4f=: f2b f.
o4f=: f2o f.
f4f=: f2f f.
x4f=: f2x f.

b4x=: x2b f.
o4x=: x2o f.
f4x=: x2f f.
x4x=: x2x f.

ZU4_z_=: 1
