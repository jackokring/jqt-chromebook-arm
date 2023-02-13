NB. zfns
NB.
NB. publish       main definition
NB. publishload   load scripts in master.ijs

NB. =========================================================
publish_z_=: publish_ppublish_

NB. =========================================================
publishload_z_=: 3 : 0
if. -. 1 e. '/\' e. y do.
  loc=. locS_ppublish_
  y=. MasterPath__loc,y
end.
load y
)