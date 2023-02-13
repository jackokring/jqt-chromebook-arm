NB. parse

NB. =========================================================
NB. parse script
NB. return boxed list:  header,defs
parse=: 3 : 0
dat=. remtws each y
cmt=. 4{.each dat
ndx=. cmt i. <'NB.%'
if. ndx=#dat do.
  smoutput 'no NB.% comment in script'
  return.
end.
len=. 1 + +/ *./\ (ndx+1) }. cmt e. 'NB.-';'NB.+'
hdr=. cleanentry 4}.each fixcontinue len{.ndx}.dat
msk=. (4{.each dat)=<'NB.*'
dat=. parse1 each msk <;.1 dat
nms=. (<0 1)&{:: each dat
nms=. nms -. getassigns y
if. #nms do.
  smoutput 'names documented but not assigned:',;' ',each nms
end.
(<hdr),dat
)

NB. =========================================================
parse1=: 3 : 0
r=. NTC ,. splithdr 0 pick {.y
y=. }.y
y=. y #~ *./\ (4{.each y) e. 'NB.-';'NB.+'
y=. 4 }.each fixcontinue y
msk=. y e. Tags,each ':'
desc=. cleanentry (msk i.1) {. y
r=. r,'desc';desc
r=. r,parsetag &> msk <;.1 y
r #~ 0<#&>{:"1 r
)

NB. =========================================================
parsetag=: 3 : 0
hdr=. 0 pick y
ndx=. hdr i.':'
tag=. ndx{.hdr
bal=. cleanentry }. y
tag;bal
)
