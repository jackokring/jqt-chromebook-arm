NB. util

h0=: '% '&, @ (,&LF2)
h1=: '# '&, @ (,&LF2)
h2=: '## '&, @ (,&LF2)
h3=: '### '&, @ (,&LF2)
tr=: '<tr>'&, @ (,&('</tr>',LF))

NB. markdown anchor
anchor=: '[' , ] , '](#' , ,&')'

NB. markdown anchor script
anchorscript=: '[' , ] , '](' , ,&'.htm)'@(i.&'.' {. ])

NB. first 1's in mask
firstones=: > |.!.0

NB. apply verb with mask, preserving header
fmask=: 1 : (':';'((x i. 1) {. y),;x <@u;. 1 y')

NB. add LF2 if nonempty
lf2sep=: , LF2 #~ 0<#

NB. separate names in map:
mapsep=: 2 }. ;@:(', '&,&.>)

NB. remove trailing whitespace
remtws=: #~ [: (+./\.) -.@(e.&(' ',TAB))

NB. add '.' if needed
termstop=: ,'.'-.{:

NB. uppercase first letter
upper1=: toupper@{. , }.

NB. =========================================================
NB. add desc to definition
adddesc=: 3 : 0
if. -. (<'desc') e. {."1 y do.
  y=. (3{.y),('desc';upper1 termstop (<2 1) pick y),3}.y
end.
y
)

NB. =========================================================
NB. cleanentry
NB. argument is boxed list of lines
NB. remove leading, trailing empty lines
NB. returns text string. not LF terminated
cleanentry=: 3 : 0
dat=. y #~ (*./\b) +: *./\.b=. 0=#&> y
}: ; dat ,each LF
)

NB. =========================================================
fixblocks=: 3 : 0
len=. 0 i.~ (4<#&>y) *. (<'NB.- ') = 5 {.each y
t=. ('NB.-|' , 4&}.) each len{.y
t=. (<'NB.-')([,],[) t
t,len}.y
)

NB. =========================================================
fixcontinue=: 3 : 0
if. 0=#y do. '' return. end.
b=. firstones (4<#&>y) *. (<'NB.- ') = 5 {.each y
t=. b fixblocks fmask y
b=. firstones (<'NB.+') = 4 {.each t
b fixverbatim fmask t
)

NB. =========================================================
fixverbatim=: 3 : 0
len=. 0 i.~ (<'NB.+') = 4 {.each y
cmt=. <'NB.+~~~'
cmt,(len{.y),cmt,len}.y
)

NB. =========================================================
getassigns=: 3 : 0
txt=. ; y ,each LF
rx=. Rxnna_jregex_,'([[:alpha:]][[:alnum:]_]*) *=:'
hit=. rx rxmatches txt
if. 0=#hit do. '' return. end.
({:"2 hit) rxfrom txt
)

NB. =========================================================
hdef=: 3 : 0
'name type'=. y
'## ',name,' (',(>TypeNames {~ Types i.type),') ## {.hdef #',name,'}',LF2
)

NB. =========================================================
NB. nbsp: replace spaces
nbsp=: 3 : 0
n=. (y=' ') i. 0
(;n#<'&nbsp;'), n}. y
)

NB. =========================================================
pandoc=: 3 : 0
'src tgt'=. y
shell 'pandoc "',src,'" -c "joxygen.css" -s -t html5 -V lang=en -f markdown-auto_identifiers -o "',tgt,'"'
)

NB. =========================================================
NB. chop: NB.*foo n some text
splithdr=: 3 : 0
y=. 4}.y
x=. y i. ' '
nam=. x {. y
y=. dlb (x+1) }. y
typ=. {. y
if. -. typ e. Types do.
  smoutput 'type not recognized: ',nam,' ',typ
end.
cap=. dltb }.y
nam;typ;cap
)

NB. =========================================================
NB. chop: scriptid - script desc
splitname=: 3 : 0
x=. y i. '-'
(dltb x {. y);dltb (x+1) }. y
)
