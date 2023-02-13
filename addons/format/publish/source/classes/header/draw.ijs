NB. draw

NB. =========================================================
draw=: 3 : 0
if. (Dxywh -: Sxywh) +: Tag -: 'h0' do.
  setsxywhP Sxywh - 0 0 0,PARASPACE * Height
end.
drawpara 1
)
