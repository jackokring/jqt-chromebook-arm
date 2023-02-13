NB. zutest.ijs, for zulu.ijs written by Ian Clark
NB. Sat 08 Oct 2011 18:55:00
NB. TESTING all interconversions of form: *2* (only)

ZUTEST_z_=: 0

load 'format/zulu/zulun'
load 'format/zulu/zun'
load 'format/zulu/zu'
	NB. --use: load, not: require
	NB. we must ensure nouns are present in original form

cocurrent 'zulu'	NB. WITHIN: SANDBOX ...

zutest=: 3 : 0
	NB. Comprehensive test of all interconversions
	NB. If any interconversions fail	--> smoutput a failure warning.
	NB. If x is 1 or 1j1			-->output a confirmation line
	NB. else if x is 0 or 0j1		-->keep silent.
1 zutest y
:
	NB. check all conversion of all data
	NB. y=.'zulu'	NB. the longer 'zulu' family
	NB. y=.'zu'	NB. the shorter 'zu' family
	NB. x=1 means sess=:smoutput -else sess=:empty
if. {.+.x do. sess=.smoutput  else. sess=.empty  end.
eqv=. ' -: '
ok=. 1
for_c. 'bofx' do.
  for_d. 'bofx' do.
    lb=. xx=. UNSET
	NB. complex x means test: a2* not: *2*
    if. x=+x do. z2z=. d,'2',c  else.  z2z=. 'a2',c  end.
	NB. if (z2z) doesn't exist then abort the test
    if. 3~: 4!:0<z2z do.
      sess '>>> abort test of absent ',z2z
      1 return.	NB. simulate ok=1
    end.
    exp=. y,c,eqv,xx=. z2z,' ',y,d	NB. testex, eg 'zuo -: b2o zub'
    lb=. > (". :: 0: exp){ 'FAILED';'ok'		NB. literal format
    sess exp,TAB,TAB,'NB. ',lb		NB. lb is result: 'FAILED' | 'ok'
    if. -. b=. (lb -: 'ok') do.				NB. report nature of failure...
        try. yy=. ".xx
	catch. yy=. '(failed)'
	end.
	sess (crr y,c) ; (crr y,d) ; xx ; cr'yy'
    end.
    ok=. ok *. b			NB. accumulate failures (ok=0)
  end.
end.
	NB. TO REPORT A FAILURE, USE 1!:2 not smoutput or sess
if. ok=0 do.
	(0 0 $ 1!:2&2) '>>> zulu: zutest FAILS with: ',y
end.
ok	NB. RETURN THE TEST FLAG
)


NB. =========================================================
	NB. ON LOADING THIS SCRIPT: RUN zutest IN SILENT MODE
	NB. inside the zulu locale itself ...
NB. =========================================================

ok1=. ;  0 zutest each ;:'zu z1 z0'
ok2=. ;0j1 zutest each ;:'zu z1 z0'	NB. for conversions: a2*
ZUTEST_z_=: ok1 , ok2


NB. =========================================================
	NB. MANUAL TESTS USING: zutest
	NB. If, when loaded, the script reports failure,
	NB. run individual lines below using Ctrl+R
	NB. to discover which conversions give errors.
NB. =========================================================
0 : 0
	NB. Run the following test lines using: {Ctrl}+R ...
phonetic 'The quick brown fox'
1 zutest each ;:'zu z1 z0'
1j1 zutest each ;:'zu z1 z0'
	NB. INDIVIDUAL TESTS
	NB. (real part of x-arg) -: 1 means: sess=: smoutput
	NB. (real part of x-arg) -: 0 means: sess=: empty
	NB. THESE TESTS REPORT ON EACH VERB INDIVIDUALLY ...
1 zutest 'zulu'
1 zutest 'zu'
1 zutest 'z1'
1 zutest 'z0'
	NB. complex x-arg means call: a2* instead of: *2*
1j1 zutest 'zulu'
1j1 zutest 'zu'
1j1 zutest 'z1'
1j1 zutest 'z0'
)
