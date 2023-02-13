NB. make

NB. =========================================================
make=: 4 : 0
r=. i. 0 3
'clr fnt'=. x
ind=. (0 _1;1);<_1;_1

NB. ---------------------------------------------------------
while. #y do.
  'top y'=. tagsplit y
  'off tag prm val'=. {. top
  if. off ~: 1 do.
    throw '201 Problem in make - invalid text tags'
  end.
  bal=. > {: {: top
  top=. (<'') (<_1 _1) } top
  top=. (1;'') (<0 _1;0 1) } top

NB. ---------------------------------------------------------
  select. tag
  case. ,'b' do.
    r=. r,(clr,fontbold fnt) make top
  case. ,'i' do.
    r=. r,(clr,fontitalic fnt) make top
  case. 'link' do.
    newurl val
    clk=. colorindex LCOLOR
    r=. r,(clk,fnt) make top
  case. 'style' do.
    throw '101 Tag not supported: <style>'
  case. '' do.
    bal=. val
  case. do.
    throw '101 Tag not supported: ',wraptag tag
  end.

NB. ---------------------------------------------------------
  if. #bal do.
    r=. r,clr;fnt;bal
    bal=. ''
  end.

end.
r
)
