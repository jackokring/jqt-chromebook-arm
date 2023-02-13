NB. =========================================================
NB. Verbs exported to z locale

appenddsv_z_=: appenddsv_pdsv_
delimitarray_z_=: delimitarray_pdsv_
fixdsv_z_=: fixdsv_pdsv_
joindsv_z_=: joindsv_pdsv_
makedsv_z_=: makedsv_pdsv_
makenum_z_=: makenum_pdsv_
makenumcol_z_=: makenumcol_pdsv_
readdsv_z_=: readdsv_pdsv_
writedsv_z_=: writedsv_pdsv_

NB.*assign2hdr v Assigns columns in table of boxed literals to noun
NB. form: [hdr] assign2hdr array
NB. returns: empty
NB. y is: an array of boxed literals
NB. x is: optional list of boxed literals to assign columns of y to.
NB.       default is to use first line of y as header.
NB. Converts column to numeric if conversion is possible for whole column
assign2hdr_z_=: 3 : 0
  'hdr dat'=. split y
  hdr assign2hdr dat
:
  hdr111=. uniqify_pdsv_ coerce2Name_pdsv_&.> x
  dat111=. |: makenumcol y
  idx111=. I. 2 ~: (3!:0)&> {."1 dat111
  erase 'x y'
  ((<<<idx111){hdr111)=: <"1 (<<<idx111) { dat111
  (idx111{hdr111)=: idx111 { dat111
  EMPTY
)
