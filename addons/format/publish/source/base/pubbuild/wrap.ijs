NB. wrap

NB. =========================================================
wrapbody=: 3 : 0
z=. ": 1 + #y
r=. '%PDF-1.4',LF
r=. r, '%', (a. {~128 + a. i. 'elmo'),LF

NB. ---------------------------------------------------------
NB. note the xref section must have exactly 20 characters
NB. per line - otherwise Adobe rebuilds the xref when
NB. the file is loaded
s=. 'xref',LF,'0 ',z,LF
s=. s,(10#'0'),' 65535 f ',LF
for_i. i.#y do.
  s=. s,(_10 {.!.'0' ": #r),' 00000 n ',LF
  c=. LF,(>i{y)
  r=. r,(":1+i),' 0 obj',c,'endobj',LF,LF
end.

NB. ---------------------------------------------------------
hdr=. 'trailer',LF,'<<',LF,'/Size '
ftr=. '/Info 1 0 R',LF,'/Root 2 0 R',LF,'>>',LF,'startxref',LF
tr=. hdr, z, LF, ftr
r,s,LF,tr,(":#r),LF,'%%EOF'
)

NB. =========================================================
wrapstream=: 3 : 0
if. PDFCompress do.
  s=. '<< /Length ',(":#y),' /Filter /FlateDecode >> stream',LF
  s,(9 compress_ppubzlib_ y),LF,'endstream',LF
else.
  y=. addLF y
  s=. '<< /Length ',(":#y),' >> stream',LF
  s,y,'endstream',LF
end.
)

NB. =========================================================
wraptext=: 3 : 0
y=. addLF y
'BT',LF,y,'ET',LF
)
