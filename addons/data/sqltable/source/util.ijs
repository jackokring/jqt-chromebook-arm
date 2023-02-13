NB. util

NB. =========================================================
NB. private vers
NB.
NB. A2U
NB. U2A
NB. sqtbchk

NB. =========================================================
NB. convert bwteen utf8 strings and latin1 8-bit strings
NB.
NB. depending on whether users will convert strings themselves, uncomment either 2 lines
NB.
NB. U2A=: 3 : '1&u: (u:128)(I.(7&u:y)=u:8364)}7&u:y' NB. latin1 to utf8
NB. A2U=: 3 : '8&u: (u:8364)(I.(u:y)=u:128)}u:y'     NB. utf8 to latin1
U2A=: ]   NB. do nothing becuase users will do conversion
A2U=: ]

NB. =========================================================
NB. utils from Inverted Tables essay
ifa=: <@(>"1)@|:  NB. inverted from atomic
afi=: |:@:(<"_1@>)  NB. atomic from inverted
ttally=: *@# * #@>@{.

NB. =========================================================
NB.sqtbchk
NB.
NB.check sqltable verbs result for errors
NB. export to z locale
sqtbchk_z_=: ] ` (] 13!:8 3:) @. (2 = 3!:0)
