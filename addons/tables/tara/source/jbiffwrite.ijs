NB. =========================================================
NB. Cover for writing one or more arrays to sheets in an Excel workbook
NB. written by Ric Sherlock

coclass 'biffwrite'
coinsert 'biffbook'

NB. ---------------------------------------------------------
NB.*writexlsheets v Write arrays to sheets of Excel workbook
NB. returns: numeric 1 if successful.
NB. form: ([<sheetname(s)>],.<sheetcontent(s)>) writesheets <filename>
NB. y is: literal filename of workbook to create
NB. x is: One of;
NB.     * literal (data to write in topleft cell of Sheet1)
NB.     * numeric matrix (data to write to Sheet1)
NB.     * boxed (numeric/literal/mixed) matrix (data to write to Sheet1)
NB.     * 2-item/column vector/matrix,
NB.          Sheetnames in 1st item/col (literal)
NB.          Associated data formats (above) for sheetnames
NB. if <sheetname(s)> not given then defaults used
writexlsheets=: 4 : 0
  try.
    locs=. '' NB. store locales created
    if. 0=#x do. empty'' return. end. NB. if empty xarg then return.
    (msg=. 'too many levels of boxing') assert 2>:L. x
    msg=. 'error in left argument'
    shts=. makexarg x
    shtnme=. ((0 < #) {:: 'Sheet1'&;) (<0 0) {:: shts
    locs=. locs,bi=. ('Arial';220;shtnme) conew 'biffbook'
    shtdat=. (<0 1){:: shts
    msg=. 'error writing data for ',shtnme
    bi writeshtdat shtdat NB. write data for first worksheet
    shts=. }.shts         NB. drop first sheet from list
    msg=. 'error creating/writing later sheets'
    if. #shts do. bi addsheets"1 shts end. NB. add and write to rest of sheets
    binary=. save__bi y
    success=. destroy__bi ''
    (*#binary){:: success;binary
  catch.
    for_l. |.locs do. NB. housekeeping
      destroy__l ''
      locs=. locs -. l
    end.
    0 [ smoutput 'writexlsheets: ',msg
  end.
)

NB. ---------------------------------------------------------
NB. utils
mfv1=: ,:^:(#&$ = 1:)       NB. makes 1-row matrix from vector
mfva=: ,:^:([: 2&> #@$)^:_  NB. makes a matrix from an atom or vector
ischar=: 3!:0 e. 2 131072 262144"_
firstones=: > 0: , }:
lastones=: > 0: ,~ }.
NB. indices=: $ #: I.@,   NB. get row,.col indices of 1s in matrix
indices=: 4:$.$.       NB. get row,.col indices of 1s in matrix
isrowblks=: >/@(+/^:(#&$)"_1) NB. are blocks row oriented

NB. isdata v Verb decides on type of x argument to writesheets
NB. returns 0 for array of names and data, 1 for single data matrix.
isdata=: 3 : 0
  if. 1< lvls=. L. y do. 0 return. NB. if 1<L.x must be multiple sheets
  elseif. 0= lvls do. 1 return. NB. if not boxed then must be data for single sheet
  elseif. 2< cols=. {:$ y do. 1 return. NB. if more than 2 items/cols then data for one sheet
  elseif. (-. *./(ischar&> +. a:&=) {."1 y) *. 2 = cols do. 1 return. NB. if 2 cols and not all 1st col contents are either literal or empty then must be data for one sheet
  elseif. 1< #@$ &> {:"1 y do. 0 return. NB. if any last col contents have rank greater than 1 then must be multiple sheets
  elseif. do. 1 NB. else assume that boxed data for one sheet
  end.
)

NB. makexarg v Ensures that xarg to writesheets has right form.
NB. returns: 2-item/column vector/array.
NB.       {."1 are sheetnames, {:"1 are boxed rank-2 arrays of sheetdata
makexarg=: 3 : 0
  if. isdata y do.
    if. 2= 3!:0 y do. y=. <y end.
    y=. a:,. <mfva y
  else.
    if. 2>{:$ y do. NB. if only 1 item/col add empty column of sheetnames
      y=. a:,.y
    end.
    if. #idx=. (I. b=. ischar &>{:"1 y) do.  NB. sheets with unboxed string data
      upd=. ({."1 ,. <&.>@({:"1)) b#y NB. boxed versions
      y=. upd idx }y
    end.
    if. #idx=. (I. b=. 2> #@$&>{:"1 y) do.  NB. sheets with unboxed string data
      upd=. ({."1 ,. mfva&.>@({:"1)) b#y NB. boxed versions
      y=. upd idx }y
    end.
  end.
  mfv1 y
)

NB. addsheets v Creates new sheet and writes data to it
NB. form: <wkbklocale> addSheets <sheetname>;<array>
addsheets=: 4 : 0
  'shtnme shtdat'=. y
  addsheet__x shtnme
  x writeshtdat shtdat
)

NB. writeshtdat v Writes array to current worksheet
NB. form: <wkbklocale> writeShtdat <array>
NB. Writes blocks of string data and numeric data separately
writeshtdat=: 4 : 0
  if. 0=L.y do.
    writenumber__x 0 0;y
  else.
    as=. ischar &> y
    blks=. blocks as
    tls=. {.0 2|: blks
    dat=. blks <;.0 y NB. blocks of char
    writestring__x"1 (<"1 tls),.dat
    blks=. blocks -.as
    tls=. {.0 2|: blks
    dat=. blks ([:<>);.0 y  NB. blocks of non-char
    writenumber__x"1 (<"1 tls),.dat
  end.
)

NB. ---------------------------------------------------------
NB. Find rectangular blocks of same type.
NB. 2d solution based on algorithm by RE Boss
NB. http://www.jsoftware.com/pipermail/programming/2008-June/011077.html

NB. blocks per row; top left in first and bottom right in last column!
tlc=: [: I. firstones      NB. column indices of toplefts
brc=: [: I. lastones       NB. column indices of bottomrights
tlbrc=: <@(tlc ,. brc)"1   NB. box by row
bpr=: i.@# ,:"0 1&.> tlbrc NB. laminate row indices

mtch=: 4 : 0
  's t'=. <"0 x (](#~; (#~-.)) e.~&:(<@{:"2))&> {.y
  t=. t((,&.>{:)`[)@.(1=#@])y
  s=. x([:(<@{:"2 ({:@{.@{:(<0 1)} {.)/.]) ,)&> s
  s;t
)

NB. rowwise blocks (topleft,:bottomright)
blcks=: [:|:"2 [:; [:mtch/ bpr

tlshape=: ([,: (-~>:))/"_1 NB. converts tl,:br to tl,:shape
blocks=: tlshape@:blcks  NB. rowwise merged blocks

NB. =========================================================
NB.  publish in z locale
writexlsheets_z_=: writexlsheets_biffwrite_
