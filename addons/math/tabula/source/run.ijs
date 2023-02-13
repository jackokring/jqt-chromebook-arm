NB. math_tabula - run
0 :0
Monday 15 April 2019  04:44:28
-
open BUILTFILE
open TESTFILE
)

NB.==================================
GIT=. '~Gitrtab'  NB. for JAL release
NB.==================================

IDE_z_=: 1  NB. can be assumed if this script is run

cocurrent 'base'

BUILTFILE_z_=: GIT,'/tabula.ijs'
TESTFILE_z_=: GIT,'/test/test.ijs'

NB. ---------------------------------------------------------

clear 'tabby'
load BUILTFILE	
smoutput '--- run.ijs: BUILTFILE loaded: ',BUILTFILE

load TESTFILE
smoutput '--- run.ijs: TESTFILE completed without discrepancies: ',TESTFILE
smoutput 4$LF

onload_z_=: do

NB. check TABBY header for assignment of: startonload
start_tabby_''