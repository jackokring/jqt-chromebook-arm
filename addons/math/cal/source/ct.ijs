	NB. cal - ct.ijs
'==================== [cal] ct.ijs ===================='
0 :0
Wednesday 5 June 2019  22:03:36
-
ct=="see t-table" -generates display layout for the t-table
)

cocurrent 'cal'

  NB. NEW ct -- returns "unicode" table
  NB.  CAL instruction CTAB returns ct output unaltered,
  NB.  CAL instruction CTBU returns (lit) utf-8 LF-separated string.
  NB. Some work-nouns will be redundant in distributed version
ct=: 3 : 0
  NB. y is diagnostic mode: y=='' for operational use
  NB. returns "no t-table" message if no t-table loaded…
if. NaNoun'CAPT' do. ,:40 message'' return. end.
  NB. If no items return trivial display of just CAPT
if. 2>nn=. #ii=. items'' do. ,:CAPT return. end.
wc=. uucp"1                       NB. (string) y as wc chars
fmt=. ":"0                        NB. simple format for v-caches
ufmt=. [: wc&uniform"1 >          NB. SI-compliant unicode for UNIT*
SEP1=. '|' $~ nn,2                NB. column-separator
SEP2=. ' * ' $~ nn,3              NB. column-separator
SEP3=. ' = ' $~ nn,3              NB. column-separator
arrw=. wc arrowch arrowgen''      NB.0 wcchar array of arrows
lnos=. >brace each ii             NB.0 braced line nos
hold=. HOLD fl vhold              NB.0 vhold as col of HOLD symbols
altd=. ALTERED fl CH              NB.0 CH as col of ALTERED symbols
sicn=. ufmt UNITN                 NB. SI-levelled col of nominal units
sics=. ufmt UNITS                 NB. SI-levelled col of SI-units
fact=. rjust fmt vfact            NB.0 col of factors
quan=. rjust fmt vquan            NB.0 col of nominal values
siqn=. rjust fmt vsiqn            NB.0 col of SI-values
un=. >UNITN                       NB.0 nominal units (x-arg for uu)
us=. >UNITS                       NB.0 col of SI-units
uuqy=. siqn ,.SP ,.us             NB.0 SI-qty (y-arg for uu)
qtys=. mjust wc un uu__uun uuqy   NB.0 qtys using un&uu
nams=. >uucp each TTN             NB.0 item names in unicode
  NB. NB.0 are the only nouns needed for (default) y==''
  NB. consider not assigning the others to reduce execution time
 lin0=. sw' +++ (CAPT) in diagnostic mode y=(y)'
select. y
case. 0 do.  NB. simply-formatted v-caches
 lin0=. sw'y=(y)       lnos       fact       quan     siqn sics'
 z=. arrw ,.lnos ,.hold ,.altd ,.fact ,.SP ,.quan ,.SP ,.siqn ,.SP ,.sics
case. 1 do.  NB. (quan) x(un) y(uuqy) -args for uu -->(qtys)
 lin0=. sw'y=(y)       lnos ------quan un-- ----uuqy-----  -----qtys--------'
 z=. arrw ,.lnos ,.SP ,.quan ,.SP ,.un ,.SP ,.uuqy ,.SP ,.qtys
case. 2 do.  NB. c/f 1 but different arrangement
 lin0=. sw'y=(y)       lnos       qtys        ||      quan un        siqn us'
 z=. arrw ,.lnos ,.hold ,.altd ,.qtys ,.SEP1 ,.quan ,.SP ,.un ,.SP ,.siqn ,.SP ,.us
case. 3 do.  NB. boxed list of columns
 z=. ,.each vhold ; CH ; vquan ; qtys ; un ; us ; nams
NB.  z=. }.each z  NB. drop item {0} from each column
 return.
case.   do.  NB. OPERATIONAL USE
 lin0=. CAPT
 z=. arrw ,.lnos ,.hold ,.altd ,.SP ,.qtys ,.SP ,.SP ,.nams
end.
lin0 , z #~ force0 -.vhidd        NB. remove hidden lines ALSO {0}
)

onload 'sm ct '''''