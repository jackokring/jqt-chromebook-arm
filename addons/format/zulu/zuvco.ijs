NB. zuvco.ijs, for zulu.ijs written by Ian Clark
NB. Sat 08 Oct 2011 18:55:00
NB. PATCH interconversions of form: *2* (c/f: zuv.ijs)

ZUVCO_z_=: 0

require 'format/zulu/zuv'	NB. conversion verbs (unpatched)

cocurrent 'z'	NB. c/f BASIC VERBS - ALWAYS LOADED INTO _z_ LOCALE

	NB. Adverbs to fix bad conversions of trivial stringlists
	NB. "trivial" means: having 0 or 1 string entries
	NB. Use '''' here to avoid dependency on global noun (eg MT)
nul1=: 1 : 'if. 0=#y do.     '''' else.   u y end.'
fix1=: 1 : 'if. 0=#y do.     '''' else. >@u y end.'	NB. for: *2f
nul2=: 1 : 'if. 0=#y do. 0 0$'''' else.   u y end.'
fix2=: 1 : 'if. 0=#y do. 0 0$'''' else. >@u y end.'	NB. for: *2x

3 : 0 ''
	NB. Provided patches not already applied...
	NB. patch verbs of form: *2*
if. (,'>') -: 5!:5<'b2x' do.	NB. check b2x is unpatched
  o2bOLD=. o2b f.	NB. TRANSIENT
  f2bOLD=. f2b f.	NB. TRANSIENT
  b2x=: > nul2
  o2b=: o2bOLD f. nul1
  o2x=: o2bOLD f. fix2
  f2b=: f2bOLD f. nul1
  f2x=: f2bOLD f. fix2
else. smoutput '>>> zuvco: patches already applied to b2x etc.'
end.
i.0 0
)

NB. b2x=: >	NB. INSERT DELIBERATE ERROR TO TEST zutest <<<<<<<<

ZUVCO_z_=: 1
