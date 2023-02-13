NB. math_uu repo - run
0 :0
Saturday 11 May 2019  08:39:01
-
open BUILTFILE
)

cocurrent 'base'

NB.=================================
GIT=. '~Gitruu'  NB. for JAL release
NB.=================================

BUILTFILE_z_=: GIT,'/uu.ijs'
TESTFILE_z_=: GIT,'/test/*.ijs'
NB. TESTFILE_z_=: '~TestUU/*.ijs'

NB. ---------------------------------------------------------

clear 'uu'
load BUILTFILE

smoutput sw'+++ run.ijs: BUILTFILE=[(BUILTFILE)] loaded ok'

loadall TESTFILE

smoutput sw'--- run.ijs: TESTFILE=[(TESTFILE)] completed ok'

onload_z_=: do  NB. restore for ad-hoc edits of /source/*.ijs