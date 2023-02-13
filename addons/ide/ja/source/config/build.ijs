NB. build

cf=. (jpath '~Ja/config/') , ]
ca=. (jpath '~addons/ide/ja/config/') , ]
cA=. (jpath '~Addons/ide/ja/config/') , ]

mkdir_j_ ca''
mkdir_j_ cA''

NB. ---------------------------------------------------------
fl=. cutopen 0 : 0
dirmatch.cfg
launch.cfg
userkeys.cfg
)

(ca fcopynew cf) each fl
(cA fcopynew cf) each fl
