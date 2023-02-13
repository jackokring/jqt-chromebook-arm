NB. section make

Headers=: ;: 'h1 h2 h3 h4 h5 h6'

NB. =========================================================
make=: 3 : 0
max=. BMLEVEL >. TOCLEVEL
lvlheaders=. 'h0';(#Level) {. Headers
subheaders=. (#Level) }. max {. Headers

NB. ---------------------------------------------------------
while. #y do.

  'top y'=. tagsplit y
  'off tag prm val'=. {. top
  bal=. > {: {: top

NB. ---------------------------------------------------------
  select. tag
  case. lvlheaders do.
    a=. new 'header'
    add__a top
  case. subheaders do.
    ndx=. (1{"1 y) i. <tag
    top=. top, ndx {. y
    bal=. ''
    y=. ndx }. y
    a=. new 'section'
    make__a top
  case. Headers do.
    a=. new 'header'
  case. 'group/' do.
    new 'group'
  case. 'newpage/' do.
    new 'page'
  case. 'toc' do.
    if. #val do.
      a=. new 'text'
      set__a 'fontp';FONTC0
      set__a prm
      add__a val
    end.
    a=. new 'toc'
    set__a prm
  case. 'image' do.
    if. '.jpf' -: deb _4 {. val do.
      a=. newplot''
    else.
      a=. newxobject''
    end.
    add__a val
    b=. new 'image'
    set__b prm
    add__b a
  case. 'para' do.
    a=. new 'text'
    set__a prm
    add__a val
  case. 'pre' do.
    a=. new 'pre'
    add__a val
  case. 'skip' do.
    a=. new 'skip'
    add__a val
  case. 'table' do.
    a=. new 'table'
    add__a top
  case. '' do.
    bal=. val
  case. do.
    throw '101 Invalid tag: ',wraptag tag
  end.

NB. ---------------------------------------------------------
  bal=. trimWS bal
  if. #bal do.
    a=. new 'text'
    add__a bal
    bal=. ''
  end.

end.
)
