NB. other  crc32 128!:3
coclass 'biffmd4'

md4=: crc32_md4=: 3 : 0
z=. 2&(3!:4) 4# ((_2&ic)@((4&{.)`(_4&{.)@.('a'~:{.2 ic a.i.'a'))@(3&ic))^:IF64 @: (128!:3) y
assert. 16=#z
z
)

coclass 'biffsheet'
coinsert 'biff'

NB. =========================================================
NB. Methods related to comments and MSO objects.
NB. ported from CPAN Spreadsheet::WriteExcel
NB. portion Copyrighted by John McNamara, jmcnamara@cpan.org
NB.

NB.
NB. filename embedchart rowcol xy_offset xy_scale
NB.
NB. TODO.
NB.
embedchart=: 4 : 0
chart=. y
'rowcol xy_offset xy_scale'=. x
if. 2 131072 262144 e.~ 3!:0 rowcol do. rowcol=. A1toRC rowcol end.
charts_array=: charts_array, rowcol ; chart ; xy_offset ; xy_scale
)

NB.
NB. filename insertimage rowcol xy_offset xy_scale
NB.
NB. Insert an image into the worksheet.
NB.
insertimage=: 4 : 0
img=. y
'rowcol xy_offset xy_scale'=. x
if. 2 131072 262144 e.~ 3!:0 rowcol do. rowcol=. A1toRC rowcol end.
NB. image_id type width height will be filled when saving workbook
if. 32=3!:0 img do.
NB. img is filename
  if. -.fexist img do. 'file not exist' 13!:8 (3) end.
  images_array=: images_array, rowcol ; (>img) ; xy_offset ; xy_scale ; (16#{.a.) ; 0 ; 0 ; 0 0
else.
NB. img is data
  img=. (1&u: ::]) img  NB. force single byte
  assert. 2=3!:0 img
  images_array=: images_array, rowcol ; img ; xy_offset ; xy_scale ; (16#{:a.) ; 0 ; 0 ; 0 0
end.
''
)

NB. string writecomment rowcol ; opt_name ; opt_value .....
NB.
NB. Write a comment to the specified row and column (zero indexed).
NB. opt and default
NB. author ''
NB. color _1
NB. start_cell _1 _1
NB. start_col _1
NB. start_row _1
NB. visible _1
NB. width 128
NB. height 74
NB. x_offset _1
NB. x_scale 1
NB. y_offset _1
NB. y_scale 1
NB. return ''
writecomment=: 4 : 0

rowcol=. >@{. y=. boxopen y
opt=. }.y
string=. x
if. 2 131072 262144 e.~ 3!:0 rowcol do. rowcol=. A1toRC rowcol end.

NB.  Check for pairs of optional arguments, i.e. an odd number of args.
if. 2|#,opt do. 'Uneven number of additional arguments' 13!:8 (3) end.

NB.  Check that row and col are valid and store max and min values
NB. if. check_dimensions rowcol do. _2 return. end.

NB.  We have to avoid duplicate comments in cells or else Excel will complain.
comments_array=: comments_array, comment_params (rowcol ; string), opt
''
)

NB.
NB. prepare_images
NB.
NB. Turn the HoH that stores the images into an array for easier handling.
NB.
prepare_images=: 3 : 0

NB. We sort the images by row and column but that isn't strictly required.
if. #images_array do.
  images_array=: images_array{~ /: > {.("1) images_array
end.
#images_array
)

NB.
NB. prepare_comments
NB.
NB. Turn the HoH that stores the comments into an array for easier handling.
NB.
prepare_comments=: 3 : 0

NB. We sort the comments by row and column but that isn't strictly required.
if. #comments_array do.
  comments_array=: comments_array{~ /: > {.("1) comments_array
end.
#comments_array
)

NB.
NB. prepare_charts
NB.
NB. Turn the HoH that stores the charts into an array for easier handling.
NB.
prepare_charts=: 3 : 0

NB. We sort the charts by row and column but that isn't strictly required.
if. #charts_array do.
  charts_array=: charts_array{~ /: > {.("1) charts_array
end.
#charts_array
)

NB. TODO
store_filtermode=: ''"_
store_autofilterinfo=: ''"_
store_autofilters=: ''"_

NB.
NB. store_images
NB.
NB. Store the collections of records that make up images.
NB.
store_images=: 3 : 0

recordtype=. 16b00ec                NB. Record identifier

spid=. {.object_ids

NB. Skip this if there aren't any images.
if. 0=#images_array do. '' return. end.

z=. ''
for_i. i.#images_array do.
  'rowcol name xy_offset xy_scale checksum image_id type widthheight'=. i{images_array
  'width height'=. widthheight
  'scale_x scale_y'=. xy_scale
  width=. <.width * (0~:scale_x){1, scale_x
  height=. <.height * (0~:scale_y){1, scale_y

NB. Calculate the positions of image object.
  vertices=. position_object rowcol, xy_offset, width, height

  if. 0=i do.
NB. Write the parent MSODRAWIING record.
    dg_length=. 72 + 84* #images_array
    spgr_length=. 48 + 84* #images_array

    dg_length=. dg_length + 120* #charts_array
    spgr_length=. spgr_length + 120* #charts_array

    dg_length=. dg_length + 96* filter_count
    spgr_length=. spgr_length + 96* filter_count

    dg_length=. dg_length + 92* #comments_array
    spgr_length=. spgr_length + 92* #comments_array

    data=. store_mso_dg_container dg_length
    data=. data, store_mso_dg }.object_ids
    data=. data, store_mso_spgr_container spgr_length
    data=. data, store_mso_sp_container 40
    data=. data, store_mso_spgr ''
    data=. data, store_mso_sp 0, spid, 16b0005
    spid=. >:spid
    data=. data, store_mso_sp_container 76
    data=. data, store_mso_sp 75, spid, 16b0a00
    spid=. >:spid
    data=. data, store_mso_opt_image image_id
    data=. data, store_mso_client_anchor 2 ; vertices
    data=. data, store_mso_client_data ''

    z=. z, biffappend data,~ toHeader recordtype, #data

  else.
NB. Write the child MSODRAWIING record.
    data=. store_mso_sp_container 76
    data=. data, store_mso_sp 75, spid, 16b0a00
    spid=. >:spid
    data=. data, store_mso_opt_image image_id
    data=. data, store_mso_client_anchor 2 ; vertices
    data=. data, store_mso_client_data ''

    z=. z, biffappend data,~ toHeader recordtype, #data

  end.

  z=. z, store_obj_image i+1
end.

object_ids=: spid 0}object_ids
z
)

NB.
NB. store_charts
NB.
NB. Store the collections of records that make up charts.
NB.
store_charts=: 3 : 0

recordtype=. 16b00ec                NB. Record identifier

spid=. {.object_ids

NB. Number of objects written so far.
num_objects=. #images_array

NB. Skip this if there aren't any charts.
if. 0=#charts_array do. '' return. end.

z=. ''
for_i. i.#charts_array do.
  'rowcol name xy_offset xy_scale'=. i{charts_array
  'width height'=. 526 319
  'scale_x scale_y'=. xy_scale
  width=. <.width * (0~:scale_x){1, scale_x
  height=. <.height * (0~:scale_y){1, scale_y

NB. Calculate the positions of chart object.
  vertices=. position_object rowcol, xy_offset, width, height

  if. (0=i) *. 0=num_objects do.
NB. Write the parent MSODRAWIING record.
    dg_length=. 72 + 120* #charts_array
    spgr_length=. 48 + 120* #charts_array

    dg_length=. dg_length + 96* filter_count
    spgr_length=. spgr_length + 96* filter_count

    dg_length=. dg_length + 92* #comments_array
    spgr_length=. spgr_length + 92* #comments_array

    data=. store_mso_dg_container dg_length
    data=. data, store_mso_dg }.object_ids
    data=. data, store_mso_spgr_container spgr_length
    data=. data, store_mso_sp_container 40
    data=. data, store_mso_spgr ''
    data=. data, store_mso_sp 0, spid, 16b0005
    spid=. >:spid
    data=. data, store_mso_sp_container 112
    data=. data, store_mso_sp 201, spid, 16b0a00
    spid=. >:spid
    data=. data, store_mso_opt_chart ''
    data=. data, store_mso_client_anchor 0 ; vertices
    data=. data, store_mso_client_data ''

    z=. z, biffappend data,~ toHeader recordtype, #data

  else.
NB. Write the child MSODRAWIING record.
    data=. store_mso_sp_container 112
    data=. data, store_mso_sp 201, spid, 16b0a00
    spid=. >:spid
    data=. data, store_mso_opt_chart ''
    data=. data, store_mso_client_anchor 0 ; vertices
    data=. data, store_mso_client_data ''

    z=. z, biffappend data,~ toHeader recordtype, #data

  end.

  z=. z, store_obj_chart num_objects+i+1
  store_chart_binary name
end.

NB. Simulate the EXTERNSHEET link between the chart and data using a formula
NB. such as '=Sheet1!A1'.
NB. TODO. Won't work for external data refs. Also should use a more direct
NB.       method.
NB.
formula=. '=', sheetname, '!A1'
NB. TODO formula
NB. store_formula formula

object_ids=: spid 0}object_ids
z
)

NB.
NB. store_chart_binary
NB.
NB. Add a binary chart object extracted from an Excel file.
NB.
store_chart_binary=: 3 : 0

if. _1-: z=. fread y do. 'Couldn''t open file in add_chart_ext' 13!:8 (3) end.
z=. biffappend z
)

NB.
NB. store_filters
NB.
NB. Store the collections of records that make up filters.
NB.
store_filters=: 3 : 0

recordtype=. 16b00ec                NB. Record identifier

spid=. {.object_ids

NB. Number of objects written so far.
num_objects=. (#images_array) + #charts_array

NB. Skip this if there aren't any filters.
if. 0=filter_count do. '' return. end.

'row1 row2 col1 col2'=. filter_area

z=. ''
for_i. i.filter_count do.

  vertices=. (col1 +i), 0, row1, 0, (col1 +i +1), 0, (row1 +1), 0

  if. (0=i) *. 0=num_objects do.
NB. Write the parent MSODRAWIING record.
    dg_length=. 72 + 96* filter_count
    spgr_length=. 48 + 96* filter_count

    dg_length=. dg_length + 92* #comments_array
    spgr_length=. spgr_length + 92* #comments_array

    data=. store_mso_dg_container dg_length
    data=. data, store_mso_dg }.object_ids
    data=. data, store_mso_spgr_container spgr_length
    data=. data, store_mso_sp_container 40
    data=. data, store_mso_spgr ''
    data=. data, store_mso_sp 0, spid, 16b0005
    spid=. >:spid
    data=. data, store_mso_sp_container 88
    data=. data, store_mso_sp 201, spid, 16b0a00
    spid=. >:spid
    data=. data, store_mso_opt_filter ''
    data=. data, store_mso_client_anchor 1 ; vertices
    data=. data, store_mso_client_data ''

    z=. z, biffappend data,~ toHeader recordtype, #data

  else.
NB. Write the child MSODRAWIING record.
    data=. store_mso_sp_container 88
    data=. data, store_mso_sp 201, spid, 16b0a00
    spid=. >:spid
    data=. data, store_mso_opt_filter ''
    data=. data, store_mso_client_anchor 1 ; vertices
    data=. data, store_mso_client_data ''

    z=. z, biffappend data,~ toHeader recordtype, #data

  end.

  z=. z, store_obj_filter (num_objects+i+1), col1 +i
end.

NB. Simulate the EXTERNSHEET link between the filter and data using a formula
NB. such as '=Sheet1!A1'.
NB. TODO. Won't work for external data refs. Also should use a more direct
NB.       method.
NB.
formula=. '=', sheetname, '!A1'
z=. z, store_formula formula

object_ids=: spid 0}object_ids
z
)

NB.
NB. store_comments
NB.
NB. Store the collections of records that make up cell comments.
NB.
NB. NOTE: We write the comment objects last since that makes it a little easier
NB. to write the NOTE records directly after the MSODRAWIING records.
NB.
store_comments=: 3 : 0

recordtype=. 16b00ec                NB. Record identifier

spid=. {.object_ids

NB. Number of objects written so far.
num_objects=. (#images_array) + filter_count + #charts_array

NB. Skip this if there aren't any comments.
if. 0=#comments_array do. '' return. end.

z=. ''
for_i. i.#comments_array do.
  'rowcol str author visible color vertices'=. i{comments_array
  formats=. 0 5 ,: (#str), 0
  if. (0=i) *. 0=num_objects do.
NB. Write the parent MSODRAWIING record.
    dg_length=. 72 + 92* #comments_array
    spgr_length=. 48 + 92* #comments_array

    data=. store_mso_dg_container dg_length
    data=. data, store_mso_dg }.object_ids
    data=. data, store_mso_spgr_container spgr_length
    data=. data, store_mso_sp_container 40
    data=. data, store_mso_spgr ''
    data=. data, store_mso_sp 0, spid, 16b0005
    spid=. >:spid
    data=. data, store_mso_sp_container 84
    data=. data, store_mso_sp 202, spid, 16b0a00
    spid=. >:spid
    data=. data, store_mso_opt_comment visible
    data=. data, store_mso_client_anchor 3 ; vertices
    data=. data, store_mso_client_data ''

    z=. z, biffappend data,~ toHeader recordtype, #data

  else.
NB. Write the child MSODRAWIING record.
    data=. store_mso_sp_container 84
    data=. data, store_mso_sp 202, spid, 16b0a00
    spid=. >:spid
    data=. data, store_mso_opt_comment visible
    data=. data, store_mso_client_anchor 3 ; vertices
    data=. data, store_mso_client_data ''

    z=. z, biffappend data,~ toHeader recordtype, #data

  end.

  z=. z, store_obj_comment num_objects+i+1
  z=. z, store_mso_drawing_text_box ''
  z=. z, store_txo #str
  z=. z, store_txo_continue_1 str
  z=. z, store_txo_continue_2 formats
end.

NB. Write the NOTE records after MSODRAWIING records.
for_i. i.#comments_array do.
  'rowcol str author visible color vertices'=. i{comments_array
  z=. z, store_note rowcol ; (num_objects+i+1) ; author ; visible
end.
z
)

NB.
NB. store_mso_dg_container
NB.
NB. Write the Escher DgContainer record that is part of MSODRAWING.
NB.
store_mso_dg_container=: 3 : 0

type=. 16bf002
version=. 15
'' add_mso_generic type, version, 0, y
)

NB.
NB. store_mso_dg
NB.
NB. Write the Escher Dg record that is part of MSODRAWING.
NB.
store_mso_dg=: 3 : 0

type=. 16bf008
version=. 0
'instance num_shapes max_spid'=. y
data=. toDWORD0 num_shapes, max_spid
data add_mso_generic type, version, instance, #data
)

NB.
NB. store_mso_spgr_container
NB.
NB. Write the Escher SpgrContainer record that is part of MSODRAWING.
NB.
store_mso_spgr_container=: 3 : 0

type=. 16bf003
version=. 15
'' add_mso_generic type, version, 0, y
)

NB.
NB. store_mso_sp_container
NB.
NB. Write the Escher SpContainer record that is part of MSODRAWING.
NB.
store_mso_sp_container=: 3 : 0

type=. 16bf004
version=. 15
'' add_mso_generic type, version, 0, y
)

NB.
NB. store_mso_spgr
NB.
NB. Write the Escher Spgr record that is part of MSODRAWING.
NB.
store_mso_spgr=: 3 : 0

type=. 16bf009
version=. 1
data=. toDWORD0 0 0 0 0
data add_mso_generic type, version, 0, #data
)

NB.
NB. store_mso_sp
NB.
NB. Write the Escher Sp record that is part of MSODRAWING.
NB.
store_mso_sp=: 3 : 0

type=. 16bf00a
version=. 2
'instance spid options'=. y
data=. toDWORD0 spid, options
data add_mso_generic type, version, instance, #data
)

NB.
NB. store_mso_opt
NB.
NB. Write the Escher Opt record that is part of MSODRAWING.
NB.
store_mso_opt=: 3 : 0

type=. 16bf00b
version=. 3
instance=. 9

length=. 54   NB. Bytes to follow

'spid visible color'=. 3{.y, 16b50

NB. Use the visible flag if set by the user or else use the worksheet value.
NB. Note that the value used is the opposite of store_note.

if. _1~:visible do.
  hidden=. (0=visible) { 16b0000 16b0002
else.
  hidden=. (0=comments_visible) { 16b0000 16b0002
end.

data=. toDWORD0 spid
data=. data, toBYTE 16b00, 16b00, 16bbf, 16b00, 16b08, 16b00, 16b08, 16b00, 16b58, 16b01, 16b00, 16b00, 16b00, 16b00, 16b81, 16b01
data=. data, toBYTE color
data=. data, toBYTE 16b00, 16b00, 16b08, 16b83, 16b01, 16b50, 16b00, 16b00, 16b08, 16bbf, 16b01, 16b10, 16b00, 16b11, 16b00, 16b01, 16b02, 16b00, 16b00, 16b00, 16b00, 16b3f, 16b02, 16b03, 16b00, 16b03, 16b00, 16bbf, 16b03
data=. data, toWORD0 hidden
data=. data, toBYTE 16b0a, 16b00

assert. length = #data
data add_mso_generic type, version, instance, #data
)

NB.
NB. store_mso_opt_image
NB.
NB. Write the Escher Opt record that is part of MSODRAWING.
NB.
store_mso_opt_image=: 3 : 0

type=. 16bf00b
version=. 3
instance=. 3

length=. 6 * instance   NB. Bytes to follow

spid=. y

data=. toWORD0 16b4104                 NB. Blip -> pib
data=. data, toDWORD0 spid
data=. data, toWORD0 16b01bf           NB. Fill Style -> fNoFillHitTest
data=. data, toDWORD0 16b00010000
data=. data, toWORD0 16b03bf           NB. Group Shape -> fPrint
data=. data, toDWORD0 16b00080000

assert. length = #data
data add_mso_generic type, version, instance, #data
)

NB.
NB. store_mso_opt_chart
NB.
NB. Write the Escher Opt record that is part of MSODRAWING.
NB.
store_mso_opt_chart=: 3 : 0

type=. 16bf00b
version=. 3
instance=. 9

length=. 6 * instance   NB. Bytes to follow

data=. toWORD0 16b007f                  NB. Protection -> fLockAgainstGrouping
data=. data, toDWORD0 16b01040104

data=. data, toWORD0 16b00bf            NB. Text -> fFitTextToShape
data=. data, toDWORD0 16b00080008

data=. data, toWORD0 16b0181            NB. Fill Style -> fillColor
data=. data, toDWORD0 16b0800004e

data=. data, toWORD0 16b0183            NB. Fill Style -> fillBackColor
data=. data, toDWORD0 16b0800004d

data=. data, toWORD0 16b01bf            NB. Fill Style -> fNoFillHitTest
data=. data, toDWORD0 16b00110010

data=. data, toWORD0 16b01c0            NB. Line Style -> lineColor
data=. data, toDWORD0 16b0800004d

data=. data, toWORD0 16b01ff            NB. Line Style -> fNoLineDrawDash
data=. data, toDWORD0 16b00080008

data=. data, toWORD0 16b023f            NB. Shadow Style -> fshadowObscured
data=. data, toDWORD0 16b00020000

data=. data, toWORD0 16b03bf            NB. Group Shape -> fPrint
data=. data, toDWORD0 16b00080000

assert. length = #data
data add_mso_generic type, version, instance, #data
)

NB.
NB. store_mso_opt_filter
NB.
NB. Write the Escher Opt record that is part of MSODRAWING.
NB.
store_mso_opt_filter=: 3 : 0

type=. 16bf00b
version=. 3
instance=. 5

length=. 6 * instance   NB. Bytes to follow

data=. toWORD0 16b007f                  NB. Protection -> fLockAgainstGrouping
data=. data, toDWORD0 16b01040104

data=. data, toWORD0 16b00bf            NB. Text -> fFitTextToShape
data=. data, toDWORD0 16b00080008

data=. data, toWORD0 16b01bf            NB. Fill Style -> fNoFillHitTest
data=. data, toDWORD0 16b00010000

data=. data, toWORD0 16b01ff            NB. Line Style -> fNoLineDrawDash
data=. data, toDWORD0 16b00080000

data=. data, toWORD0 16b03bf            NB. Group Shape -> fPrint
data=. data, toDWORD0 16b000a0000

assert. length = #data
data add_mso_generic type, version, instance, #data
)

NB.
NB. store_mso_opt_comment
NB.
NB. Write the Escher Opt record that is part of MSODRAWING.
NB.
store_mso_opt_comment=: 3 : 0

type=. 16bf00b
version=. 3
instance=. 3

length=. 6 * instance   NB. Bytes to follow

visible=. y

NB. Use the visible flag if set by the user or else use the worksheet value.
NB. Note that the value used is the opposite of store_note.
if. _1~:visible do.
  hidden=. (0=visible) { 16b0000 16b0002
else.
  hidden=. (0=comments_visible) { 16b0000 16b0002
end.

data=. toWORD0 16b0080            NB. Text -> lTxid
data=. data, toDWORD0 0
data=. data, toWORD0 16b03be            NB. Group Shape -> fHidden
data=. data, toWORD0 hidden, 16b0002
data=. data, toWORD0 16b03bf            NB. Group Shape -> fPrint
data=. data, toWORD0 16b0002, 16b0002

assert. length = #data
data add_mso_generic type, version, instance, #data
)

NB.
NB. store_mso_client_anchor
NB.
NB. Write the Escher ClientAnchor record that is part of MSODRAWING.
NB.
store_mso_client_anchor=: 3 : 0

type=. 16bf010
version=. 0

'flag vertices'=. y
'col_start x1 row_start y1 col_end x2 row_end y2'=. vertices
NB. col_start Col containing upper left corner of object
NB. x1 Distance to left side of object

NB. row_start Row containing top left corner of object
NB. y1 Distance to top of object

NB. col_end Col containing lower right corner of object
NB. x2 Distance to right side of object

NB. row_end Row containing bottom right corner of object
NB. y2 Distance to bottom of object

data=. toWORD0 flag, col_start, x1, row_start, y1, col_end, x2, row_end, y2

data add_mso_generic type, version, 0, #data
)

NB.
NB. store_mso_client_data
NB.
NB. Write the Escher ClientData record that is part of MSODRAWING.
NB.
store_mso_client_data=: 3 : 0

type=. 16bf011
version=. 0
'' add_mso_generic type, version, 0, 0
)

NB.
NB. store_obj_comment
NB.
NB. Write the OBJ record that is part of cell comments.
NB.
store_obj_comment=: 3 : 0

recordtype=. 16b005d        NB. Record identifier
length=. 16b0034            NB. Bytes to follow

obj_id=. y                  NB. Object ID number.
obj_type=. 16b0019          NB. Object type (comment).

options=. 16b4011
reserved=. 16b0000

NB. Add ftCmo (common object data) subobject
sub_recordtype=. 16b0015             NB. ftCmo
sub_data=. toWORD0 obj_type, obj_id, options
sub_data=. sub_data, toDWORD0 reserved, reserved, reserved
assert. 16b0012 = #sub_data
data=. sub_data,~ toHeader sub_recordtype, #sub_data

NB. Add ftNts (note structure) subobject
sub_recordtype=. 16b000d             NB. ftNts
sub_data=. toDWORD0 5#reserved
sub_data=. sub_data, toWORD0 reserved
assert. 16b0016 = #sub_data
data=. data, sub_data,~ toHeader sub_recordtype, #sub_data

NB. Add ftEnd (end of object) subobject
sub_recordtype=. 16b0000                 NB. ftNts
data=. data, toHeader sub_recordtype, 0

assert. length = #data
NB. Pack the record.
z=. biffappend data,~ toHeader recordtype, length
)

NB.
NB. store_obj_image
NB.
NB. Write the OBJ record that is part of image records.
NB.
store_obj_image=: 3 : 0

recordtype=. 16b005d        NB. Record identifier
length=. 16b0026            NB. Bytes to follow

obj_id=. y                  NB. Object ID number.
obj_type=. 16b0008          NB. Object type (Picture).

options=. 16b6011
reserved=. 16b0000

NB. Add ftCmo (common object data) subobject
sub_recordtype=. 16b0015             NB. ftCmo
sub_data=. toWORD0 obj_type, obj_id, options
sub_data=. sub_data, toDWORD0 reserved, reserved, reserved
assert. 16b0012 = #sub_data
data=. sub_data,~ toHeader sub_recordtype, #sub_data

NB. Add ftCf (Clipboard format) subobject
sub_recordtype=. 16b0007             NB. ftCf
sub_data=. toWORD0 16bffff
assert. 16b0002 = #sub_data
data=. data, sub_data,~ toHeader sub_recordtype, #sub_data

NB. Add ftPioGrbit (Picture option flags) subobject
sub_recordtype=. 16b0008                  NB. ftPioGrbit
sub_data=. toWORD0 16b0001
assert. 16b0002 = #sub_data
data=. data, sub_data,~ toHeader sub_recordtype, #sub_data

NB. Add ftEnd (end of object) subobject
sub_recordtype=. 16b0000                 NB. ftNts
data=. data, toHeader sub_recordtype, 0

assert. length = #data
NB. Pack the record.
z=. biffappend data,~ toHeader recordtype, length
)

NB.
NB. store_obj_chart
NB.
NB. Write the OBJ record that is part of chart records.
NB.
store_obj_chart=: 3 : 0

recordtype=. 16b005d        NB. Record identifier
length=. 16b001a            NB. Bytes to follow

obj_id=. y                  NB. Object ID number.
obj_type=. 16b0005          NB. Object type (chart).

options=. 16b6011
reserved=. 16b0000

NB. Add ftCmo (common object data) subobject
sub_recordtype=. 16b0015             NB. ftCmo
sub_data=. toWORD0 obj_type, obj_id, options
sub_data=. sub_data, toDWORD0 reserved, reserved, reserved
assert. 16b0012 = #sub_data
data=. sub_data,~ toHeader sub_recordtype, #sub_data

NB. Add ftEnd (end of object) subobject
sub_recordtype=. 16b0000                 NB. ftNts
data=. data, toHeader sub_recordtype, 0

assert. length = #data
NB. Pack the record.
z=. biffappend data,~ toHeader recordtype, length
)

NB.
NB. store_obj_filter
NB.
NB. Write the OBJ record that is part of filter records.
NB.
store_obj_filter=: 3 : 0

recordtype=. 16b005d        NB. Record identifier
length=. 16b0046        NB. Bytes to follow

'obj_id col'=. y        NB. Object ID number.
obj_type=. 16b0014        NB. Object type (combo box).

options=. 16b2101
reserved=. 16b0000

NB. Add ftCmo (common object data) subobject
sub_recordtype=. 16b0015             NB. ftCmo
sub_data=. toWORD0 obj_type, obj_id, options
sub_data=. sub_data, toDWORD0 reserved, reserved, reserved
assert. 16b0012 = #sub_data
data=. sub_data,~ toHeader sub_recordtype, #sub_data

NB. Add ftSbs Scroll bar subobject
sub_recordtype=. 16b000c             NB. ftSbs
sub_data=. toBYTE 16b00, 16b00, 16b00, 16b00, 16b00, 16b00, 16b00, 16b00, 16b64, 16b00, 16b01, 16b00, 16b0a, 16b00, 16b00, 16b00, 16b10, 16b00, 16b01, 16b00
assert. 16b0014 = #sub_data
data=. data, sub_data,~ toHeader sub_recordtype, #sub_data

NB. Add ftLbsData (List box data) subobject
sub_recordtype=. 16b0013             NB. ftLbsData
NB. Special case (undocumented).

NB. If the filter is active we set one of the undocumented flags.

if. col e. >{.("1) filter_cols do.
  sub_data=. toBYTE 16b00, 16b00, 16b00, 16b00, 16b01, 16b00, 16b01, 16b03, 16b00, 16b00, 16b0a, 16b00, 16b08, 16b00, 16b57, 16b00
else.
  sub_data=. toBYTE 16b00, 16b00, 16b00, 16b00, 16b01, 16b00, 16b01, 16b03, 16b00, 16b00, 16b02, 16b00, 16b08, 16b00, 16b57, 16b00
end.

assert. 16b1fee = #sub_data
data=. data, sub_data,~ toHeader sub_recordtype, #sub_data

NB. Add ftEnd (end of object) subobject
sub_recordtype=. 16b0000                 NB. ftNts
data=. data, toHeader sub_recordtype, 0

assert. length = #data
NB. Pack the record.
z=. biffappend data,~ toHeader recordtype, length
)

NB.
NB. store_mso_drawing_text_box
NB.
NB. Write the MSODRAWING ClientTextbox record that is part of comments.
NB.
store_mso_drawing_text_box=: 3 : 0

recordtype=. 16b00ec                NB. Record identifier
length=. 16b0008                NB. Bytes to follow

data=. store_mso_client_text_box ''

assert. length = #data
z=. biffappend data,~ toHeader recordtype, length
)

NB.
NB. store_mso_client_text_box
NB.
NB. Write the Escher ClientTextbox record that is part of MSODRAWING.
NB.
store_mso_client_text_box=: 3 : 0

type=. 16bf00d
version=. 0

'' add_mso_generic type, version, 0, 0
)

NB.
NB. store_txo
NB.
NB. Write the worksheet TXO record that is part of cell comments.
NB.
store_txo=: 3 : 0

recordtype=. 16b01b6               NB. Record identifier
length=. 16b0012                   NB. Bytes to follow
'string_len format_len rotation'=. 3{.y
format_len=. (2>#y){format_len, 16          NB. default format_len rotation: 16 0
NB. string_len Length of the note text.
NB. format_len Length of the format runs.
NB. rotation Options
grbit=. 16b0212                  NB. Options
reserved=. 16b0000                  NB. Options

NB. Pack the record.
data=. toWORD0 grbit, rotation
data=. data, toDWORD0 reserved
data=. data, toWORD0 reserved, string_len, format_len
data=. data, toDWORD0 reserved

assert. length = #data
z=. biffappend data,~ toHeader recordtype, length
)

NB.
NB. store_txo_continue_1
NB.
NB. Write the first CONTINUE record to follow the TXO record. It contains the
NB. text data.
NB.
store_txo_continue_1=: 3 : 0

recordtype=. 16b003c         NB. Record identifier
string=. y                   NB. Comment string.
if. encoding=. 2~: 3!:0 string do.  NB. Encoding of the string.
  string=. toucode0 string
end.
NB. Split long comment strings into smaller continue blocks if necessary.
NB. We can't let add_continue handled this since an extra
NB. encoding byte has to be added similar to the SST block.
NB.
NB. We make the limit size smaller than the add_continue size and even
NB. so that UTF16 chars occur in the same block.
NB.
limit=. RECORDLEN-6  NB. 8218
z=. ''
while. limit<#string do.
  string=. limit}.string [ tmp_str=. limit{.string
  z=. z, biffappend data,~ toHeader recordtype, #data=. tmp_str,~ toBYTE encoding
end.

NB. Pack the record.
z=. z, biffappend data,~ toHeader recordtype, #data=. string,~ toBYTE encoding
)

NB.
NB. store_txo_continue_2
NB.
NB. Write the second CONTINUE record to follow the TXO record. It contains the
NB. formatting information for the string.
NB.
store_txo_continue_2=: 3 : 0

recordtype=. 16b003c                   NB. Record identifier
formats=. y                   NB. Formatting information

NB. Pack the record.
data=. ''
for_aref. formats do.
  data=. data, toWORD0 aref
  data=. data, toDWORD0 16b0
end.
z=. biffappend data,~ toHeader recordtype, #data
)

NB.
NB. store_note
NB.
NB. Write the worksheet NOTE record that is part of cell comments.
NB.
store_note=: 3 : 0

recordtype=. 16b001c                   NB. Record identifier
length=. 16b000c                   NB. Bytes to follow
'rowcol obj_id author visible'=. y
author=. (''-:author){:: author ; comments_author

NB. Use the visible flag if set by the user or else use the worksheet value.
NB. The flag is also set in store_mso_opt but with the opposite value.
NB.
if. _1~:visible do.
  hidden=. (0=visible) { 16b0002 16b0000
else.
  hidden=. (0=comments_visible) { 16b0002 16b0000
end.

NB. Get the number of chars in the author string (not bytes).
num_chars=. #author

NB. Null terminate the author string.
author=. author, {.a.

NB. Pack the record.
data=. toWORD0 rowcol, hidden, obj_id, num_chars
if. 2= (3!:0) author do.
  data=. data, toBYTE 0
  z=. biffappend (data, author),~ toHeader recordtype, (#data) + #author
else.
  data=. data, toBYTE 1
  z=. biffappend (data, author),~ toHeader recordtype, (#data) + #author=. toucode0 author
end.
z
)

defcommentparams=: 0 : 0
author ''
color _1
start_cell _1 _1
start_col _1
start_row _1
visible _1
width 128
height 74
x_offset _1
x_scale 1
y_offset _1
y_scale 1
)

NB.
NB. comment_params
NB.
NB. This method handles the additional optional parameters to write_comment as
NB. well as calculating the comment object position and vertices.
NB.
comment_params=: 3 : 0

'rowcol string'=. 2{.y

NB. Overwrite the defaults with any user supplied values. Incorrect or
NB. misspelled parameters are silently ignored.
nm=. (<'params_'),&.> {.("1) nmv=. (_2]\ 2}.y),~ ;:;._2 defcommentparams
(, (1&u: :: ])&.> nm)=. ".&.>{:("1) nmv

NB. Ensure that a width and height have been set.
params_width=. (0<:params_width){ params_width, 128
params_height=. (0<:params_height){ params_height, 74

NB. Limit the string to the max number of chars (not bytes).
max_len=. 32767
if. max_len < #string do. string=. max_len{.string end.

NB. Set the comment background color.
color=. params_color
color=. color
color=. (color=16b7fff){ color, 16b50   NB. Default color.
params_color=. color

NB. Convert a cell reference to a row and column.
if. _1 _1-.@-:params_start_cell do.
  if. 2 131072 262144 e.~ 3!:0 params_start_cell do. params_start_cell=. A1toRC params_start_cell end.
  rowcol=. 'params_start_row params_start_col'=. params_start_cell
end.

'row col'=. rowcol

NB. Set the default start cell and offsets for the comment. These are
NB. generally fixed in relation to the parent cell. However there are
NB. some edge cases for cells at the edges.
NB.
if. _1=params_start_row do.
  if. 0=col do. params_start_row=. 0
  elseif. 65533=row do. params_start_row=. 65529
  elseif. 65534=row do. params_start_row=. 65530
  elseif. 65535=row do. params_start_row=. 65531
  elseif. do. params_start_row=. row -1
  end.
end.

if. _1=params_y_offset do.
  if. 0=row do. params_y_offset=. 2
  elseif. 65533=row do. params_y_offset=. 4
  elseif. 65534=row do. params_y_offset=. 4
  elseif. 65535=row do. params_y_offset=. 2
  elseif. do. params_y_offset=. 7
  end.
end.

if. _1=params_start_col do.
  if. 253=col do. params_start_col=. 250
  elseif. 254=col do. params_start_col=. 251
  elseif. 255=col do. params_start_col=. 252
  elseif. do. params_start_col=. col +1
  end.
end.

if. _1=params_x_offset do.
  if. 253=col do. params_x_offset=. 49
  elseif. 254=col do. params_x_offset=. 49
  elseif. 255=col do. params_x_offset=. 49
  elseif. do. params_x_offset=. 15
  end.
end.

NB. Scale the size of the comment box if required.
if. params_x_scale do.
  params_width=. <. params_width * params_x_scale
end.

if. params_y_scale do.
  params_height=. <. params_height * params_y_scale
end.

NB. Calculate the positions of comment object.
vertices=. position_object params_start_col, params_start_row, params_x_offset, params_y_offset, params_width, params_height

(row, col) ; string ; params_author ; params_visible ; params_color ; vertices
)

NB. =========================================================

coclass 'biffbook'
coinsert 'biff'

NB.
NB. Methods related to comments and MSO objects.
NB.

NB.
NB. filename embedchart rowcol xy_offset xy_scale
NB.
NB. TODO.
NB.

embedchart=: 4 : 0
l=. sheeti{sheet
x embedchart__l y
)

NB.
NB. filename insertimage rowcol xy_offset xy_scale
NB.
NB. Insert an image into the worksheet.
NB.
NB. x (row, col) ; (offsetx(in point, 1/72"), offsety(in character)) ; scalex, scaley
NB. y boxed image file name or charachar data of image
NB. return ''
insertimage=: 4 : 0
l=. sheeti{sheet
x insertimage__l y
)

NB. string writecomment rowcol ; opt_name ; opt_value .....
NB.
NB. Write a comment to the specified row and column (zero indexed).
NB. opt and default
NB. author ''
NB. color _1
NB. start_cell _1 _1
NB. start_col _1
NB. start_row _1
NB. visible _1
NB. width 128
NB. height 74
NB. x_offset _1
NB. x_scale 1
NB. y_offset _1
NB. y_scale 1
NB. return ''
writecomment=: 4 : 0
l=. sheeti{sheet
x writecomment__l y
)

NB.
NB. add_mso_drawing_group
NB.
NB. Write the MSODRAWINGGROUP record that keeps track of the Escher drawing
NB. objects in the file such as images, comments and filters.
NB.
add_mso_drawing_group=: 3 : 0

if. 0=mso_size do. '' return. end.

recordtype=. 16b00eb               NB. Record identifier

data=. store_mso_dgg_container ''
data=. data, store_mso_dgg mso_clusters
data=. data, store_mso_bstore_container ''
for_im. images_data do. data=. data, store_mso_images im end.
data=. data, store_mso_opt ''
data=. data, store_mso_split_menu_colors ''

header=. toHeader recordtype, #data

z=. add_mso_drawing_group_continue header, data
NB. header, data    NB. For testing only.
z
)

NB.
NB. add_mso_drawing_group_continue
NB.
NB. See first the Spreadsheet::WriteExcel::BIFFwriter::_add_continue() method.
NB.
NB. Add specialised CONTINUE headers to large MSODRAWINGGROUP data block.
NB. We use the Excel 97 max block size of 8228 - 4 bytes for the header =. 8224.
NB.
NB. The structure depends on the size of the data block:
NB.
NB.     Case 1:  <=   8224 bytes      1 MSODRAWINGGROUP
NB.     Case 2:  <= 2*8224 bytes      1 MSODRAWINGGROUP + 1 CONTINUE
NB.     Case 3:  >  2*8224 bytes      2 MSODRAWINGGROUP + n CONTINUE
NB.
add_mso_drawing_group_continue=: 3 : 0

data=. y
limit=. RECORDLEN  NB. 8228 -4
mso_group=. 16b00eb    NB. Record identifier
continue=. 16b003c    NB. Record identifier
block_count=. 1

NB. Ignore the base class add_continue() method.

NB. Case 1 above. Just return the data as it is.
if. (#data) <: limit do.
  z=. 1&biffappend data
  return.
end.

z=. ''
NB. Change length field of the first MSODRAWINGGROUP block. Case 2 and 3.
data=. (limit+4)}.data [ tmp=. (limit+4){.data
tmp=. (toWORD0 limit) 2 3}tmp
z=. z, 1&biffappend tmp

NB. Add MSODRAWINGGROUP and CONTINUE blocks for Case 3 above.
while. (#data) > limit do.
  if. (block_count = 1) do.
NB. Add extra MSODRAWINGGROUP block header.
    header=. toHeader mso_group, limit
    block_count=. >:block_count
  else.
NB. Add normal CONTINUE header.
    header=. toHeader continue, limit
  end.

  data=. limit}.data [ tmp=. limit{.data
  z=. z, 1&biffappend header, tmp
end.

NB. Last CONTINUE block for remaining data. Case 2 and 3 above.
z=. z, 1&biffappend data,~ toHeader continue, #data

NB. Turn the base class add_continue() method back on.
z
)

NB.
NB. store_mso_dgg_container
NB.
NB. Write the Escher DggContainer record that is part of MSODRAWINGGROUP.
NB.
store_mso_dgg_container=: 3 : 0

type=. 16bf000
version=. 15
data=. ''
length=. mso_size -12    NB. -4 (biff header) -8 (for this).

data add_mso_generic type, version, 0, length
)

NB.
NB. store_mso_dgg
NB.
NB. Write the Escher Dgg record that is part of MSODRAWINGGROUP.
NB.
store_mso_dgg=: 3 : 0

type=. 16bf006
version=. 0

'max_spid num_clusters shapes_saved drawings_saved clusters'=. y

data=. toDWORD0 max_spid, num_clusters, shapes_saved, drawings_saved

data=. data, toDWORD0 ,clusters

data add_mso_generic type, version, 0, #data  NB. Calculate length automatically.
)

NB.
NB. store_mso_bstore_container
NB.
NB. Write the Escher BstoreContainer record that is part of MSODRAWINGGROUP.
NB.
store_mso_bstore_container=: 3 : 0

if. 0=images_size do. '' return. end.

type=. 16bf001
version=. 15
instance=. #images_data    NB. Number of images.
data=. ''
length=. images_size +8 *instance

data add_mso_generic type, version, instance, length
)

NB.
NB. store_mso_images
NB.
NB. Write the Escher BstoreContainer record that is part of MSODRAWINGGROUP.
NB.
store_mso_images=: 3 : 0

'ref_count image_type image size checksum1 checksum2'=. y

blip_store_entry=. store_mso_blip_store_entry ref_count ; image_type ; size ; checksum1

blip=. store_mso_blip image_type ; image ; size ; checksum1 ; checksum2

blip_store_entry , blip
)

NB.
NB. store_mso_blip_store_entry
NB.
NB. Write the Escher BlipStoreEntry record that is part of MSODRAWINGGROUP.
NB.
store_mso_blip_store_entry=: 3 : 0

'ref_count image_type size checksum1'=. y

type=. 16bf007
version=. 2
instance=. image_type
length=. size +61
data=. toBYTE image_type   NB. Win32
data=. data, toBYTE image_type   NB. Mac
data=. data, checksum1           NB. Uid checksum
data=. data, toWORD0 16bff          NB. Tag
data=. data, toDWORD0 size +25     NB. Next Blip size
data=. data, toDWORD0 ref_count    NB. Image ref count
data=. data, toDWORD0 16b00000000    NB. File offset
data=. data, toBYTE 16b00          NB. Usage
data=. data, toBYTE 16b00          NB. Name length
data=. data, toBYTE 16b00          NB. Unused
data=. data, toBYTE 16b00          NB. Unused

NB. for this record, length ~: #data
data add_mso_generic type, version, instance, length
)

NB.
NB. store_mso_blip
NB.
NB. Write the Escher Blip record that is part of MSODRAWINGGROUP.
NB.
store_mso_blip=: 3 : 0

'image_type image_data size checksum1 checksum2'=. y

if. image_type = 5 do. instance=. 16b046a end.   NB. JFIF
if. image_type = 6 do. instance=. 16b06e0 end.   NB. PNG
if. image_type = 7 do. instance=. 16b07a9 end.   NB. BMP 16b07a8 +1 because 2 uid for bmp

NB. BMPs contain an extra checksum for the stripped data.
if. ( image_type = 7) do.
  checksum1=. checksum2, checksum1
end.

type=. 16bf018 + image_type
version=. 16b0000
length=. size +17
data=. checksum1          NB. Uid checksum
data=. data, toBYTE 16bff       NB. Tag
data=. data, image_data            NB. Image

assert. length=#data
data add_mso_generic type, version, instance, length
)

NB.
NB. store_mso_opt
NB.
NB. Write the Escher Opt record that is part of MSODRAWINGGROUP.
NB.
store_mso_opt=: 3 : 0

type=. 16bf00b
version=. 3

data=. toBYTE 16bfb, 16b00, 16b80, 16b00, 16b80, 16b00, 16b18, 16b10, 16b90, 16b00, 16b00, 16b80, 16b0c, 16b10, 16b04, 16b00, 16b00, 16b80
data add_mso_generic type, version, 3, #data
)

NB.
NB. store_mso_split_menu_colors
NB.
NB. Write the Escher SplitMenuColors record that is part of MSODRAWINGGROUP.
NB.
store_mso_split_menu_colors=: 3 : 0

type=. 16bf11e
version=. 0

data=. toBYTE 16bd0, 16b00, 16b00, 16b80, 16bc0, 16b00, 16b00, 16b80, 16b71, 16b00, 16b00, 16b80, 16b7f, 16b00, 16b00, 16b01
data add_mso_generic type, version, 4, #data
)

NB.
NB. calc_sheet_offsets
NB.
NB. Calculate Worksheet BOF offsets records for use in the BOUNDSHEET records.
NB.
calc_sheet_offsets=: 3 : 0

BOF=. 12
EOF=. 4
offset=. datasize

NB. Add the length of the SST and associated CONTINUEs
offset=. offset + calculate_shared_string_sizes ''

NB. Add the length of the SUPBOOK, EXTERNSHEET and NAME records
offset=. offset + calculate_extern_sizes ''

NB. Add the length of the MSODRAWINGGROUP records including an extra 4 bytes
NB. for any CONTINUE headers. See add_mso_drawing_group_continue.
offset=. offset + mso_size + 4 * <.(mso_size -1) % limit

for_wsheet. sheet do.
  offset=. offset + BOF + #name__wsheet   NB. SUSPENSE  byte or characters
end.

offset=. offset + EOF

for_wsheet. sheet do.
NB.   sheetoffset__wsheet=: offset      NB. use original method
  offset=. offset + datasize__wsheet
end.

biffsize=: offset
)

NB.
NB. calc_mso_sizes
NB.
NB. Calculate the MSODRAWINGGROUP sizes and the indexes of the Worksheet
NB. MSODRAWING records.
NB.
NB. In the following SPID is shape id, according to Escher nomenclature.
NB.
calc_mso_sizes=: 3 : 0

msoSize=. 0     NB. Size of the MSODRAWINGGROUP record
start_spid=. 1024  NB. Initial spid for each sheet
max_spid=. 1024  NB. spidMax
num_clusters=. 1     NB. cidcl
shapes_saved=. 0     NB. cspSaved
drawings_saved=. 0     NB. cdgSaved
clusters=. 0 2$''

process_images ''

NB. Add Bstore container size if there are images.
msoSize=. msoSize + (0~:#images_data){0 8

NB. Iterate through the worksheets, calculate the MSODRAWINGGROUP parameters
NB. and space required to store the record and the MSODRAWING parameters
NB. required by each worksheet.

for_wsheet. sheet do.
  if. 'biffsheet' -.@-: >@coinstance wsheet do. continue. end.

  if. 0= num_shapes=. (#images_array__wsheet) + filter_count__wsheet + (prepare_comments__wsheet '') + (prepare_charts__wsheet '') do. continue. end.

NB. Include 1 parent MSODRAWING shape, per sheet, in the shape count.
  shapes_saved=. shapes_saved + num_shapes=. 1 + num_shapes
  msoSize=. msoSize + image_mso_size__wsheet

NB. Add a drawing object for each sheet with comments.
  drawings_saved=. >:drawings_saved

NB. For each sheet start the spids at the next 1024 interval.
  max_spid=. 1024 * 1 + <.(max_spid -1)%1024
  start_spid=. max_spid

NB. Max spid for each sheet and eventually for the workbook.
  max_spid=. max_spid + num_shapes

NB. Store the cluster ids
  i=. num_shapes
  while. i > 0 do.
    num_clusters=. num_clusters + 1
    msoSize=. msoSize + 8
    size=. (i <: 1024) { 1024, i
    clusters=. clusters, drawings_saved, size
    i=. i - 1024
  end.

NB. Pass calculated values back to the worksheet
  object_ids__wsheet=: start_spid, drawings_saved, num_shapes, max_spid -1
end.

NB. Calculate the MSODRAWINGGROUP size if we have stored some shapes.
mso_size=: msoSize + (0~:msoSize){0 86  NB. Smallest size is 86+8=94
mso_clusters=: max_spid ; num_clusters ; shapes_saved ; drawings_saved ; clusters
)

NB.
NB. process_images
NB.
NB. We need to process each image in each worksheet and extract information.
NB. Some of this information is stored and used in the Workbook and some is
NB. passed back into each Worksheet. The overall size for the image related
NB. BIFF structures in the Workbook is calculated here.
NB.
NB. MSO size =.  8 bytes for bstore_container +
NB.            44 bytes for blip_store_entry +
NB.            25 bytes for blip
NB.          =. 77 + image size.
NB.
process_images=: 3 : 0

images_seen=. 0 4$''
imageData=. 0 0$''
image_id=. 1
imageSize=. 0

for_wsheet. sheet do.
  if. 'biffsheet' -.@-: >@coinstance wsheet do. continue. end.
  if. 0=prepare_images__wsheet '' do. continue. end.

  image_msoSize=. 0
  imagesArray=. 0 0$''
  for_imageref. images_array__wsheet do.
NB. For each Worksheet image we get a structure like this
NB. [
NB.   row col,
NB.   name,
NB.   x_offset y_offset,
NB.   scale_x scale_y,
NB. ]
NB. And we add additional information:
NB.   checksum,
NB.   image_id,
NB.   type,
NB.   width height
    if. (16#{.a.)-: 4{::imageref do.
      filename=. 1{imageref
      if. _1-: data=. fread filename do.
        'Couldn''t import file' 13!:8 (3)
      end.
    elseif. (16#{:a.)-: 4{::imageref do.
      data=. 1{:: imageref
    elseif. do.
      'unhandled exception' 13!:8 (3)
    end.

    if. ({.("1)images_seen) -.@e.~ <ck=. image_checksum data do.
NB. match seen images based on checksum.

NB. Slurp the file into a string and do some size calcs.
      size=. #data
      checksum1=. image_checksum data
      checksum2=. checksum1
      ref_count=. 1

NB. Process the image and extract dimensions.
      if. (}.4{.data) -: 'PNG' do.
        'type width height'=. process_png data

      elseif. (2{.data) -: 'BM' do.
        'type width height'=. process_bmp data
NB. The 14 byte header of the BMP is stripped off.
        data=. 14}.data
NB. A checksum of the new image data is also required.
        checksum2=. image_checksum data

NB. Adjust size -14 (header) + 16 (extra checksum).
        size=. size + 2

      elseif. do.
        if. 0 0 0 -: 'type width height'=. process_jfif data do.
          'Unsupported image format for file' 13!:8 (3)
        end.
      end.

NB. Push the new data back into the Worksheet array
      imagesArray=. imagesArray, (_4}.imageref), checksum1 ; image_id ; type ; width, height

NB. Store information required by the Workbook.
      imageData=. imageData, ref_count ; type ; data ; size ; checksum1 ; checksum2

NB. Keep track of overall data size.
NB. Also store new data for use in duplicate images.
      imageSize=. imageSize + size +61  NB. Size for bstore container.
      image_msoSize=. image_msoSize + size +69  NB. Size for dgg container.

      images_seen=. images_seen, checksum1 ; image_id ; type ; width, height
      image_id=. >:image_id
    else.
NB. We've processed this file already.
      index=. ({.("1)images_seen) i. <ck

NB. Increase image reference count.
      imageData=. (>:&.> (<index, 0){imageData) (<index, 0)}imageData

NB. Add previously calculated data back onto the Worksheet array.
NB. image_id, type, width, height

      imagesArray=. imagesArray, (_4}.imageref), index{images_seen
    end.
  end.

NB. Store information required by the Worksheet.
  assert. (#imagesArray) = #images_array__wsheet
  images_array__wsheet=: imagesArray
  image_mso_size__wsheet=: image_msoSize
end.

NB. Store information required by the Workbook.
images_size=: imageSize
images_data=: imageData  NB. Store the data for MSODRAWINGGROUP.
)

NB.
NB. image_checksum
NB.
NB. Generate a checksum for the image using whichever module is available..The
NB. available modules are checked in get_checksum_method. Excel uses an MD4
NB. checksum but any other will do. In the event of no checksum module being
NB. available we simulate a checksum using the image index.
NB.
image_checksum=: 3 : 0

md4_biffmd4_ y
)

NB.
NB. process_jfif
NB.
NB. Extract width and height information from a JFIF file.
NB.
process_jfif=: 3 : 0

type=. 5  NB. Excel Blip type (MSOBLIPTYPE).

if. 1 e. a=. (16bff 16bd8 16bff{a.) E. y do.
  p=. 2+ a i. 1
  try.
    while. do.
      while. -. ((16bff{a.)=p{y) *. (16bff{a.)~:(p+1){y do.
        p=. p+1
      end.
      p=. p+1
      if. (p{y) e. 16bc0 16bc1 16bc2 16bc3 16bc5 16bc6 16bc7 16bc9 16bca 16bcb 16bcd 16bce 16bcf{a. do.
        break.
      end.
      p=. p + (a.i.(p+2){y)+ 256 * a.i.(p+1){y
    end.
    h=. (a.i.(p+5){y)+ 256 * a.i.(p+4){y
    w=. (a.i.(p+7){y)+ 256 * a.i.(p+6){y
    depth=. 8 * a.i.(p+8){y
    type, w, h
  catch.
    0 0 0
  end.
else.
  0 0 0
end.
)

NB.
NB. process_png
NB.
NB. Extract width and height information from a PNG file.
NB.
process_png=: 3 : 0

type=. 6  NB. Excel Blip type (MSOBLIPTYPE).
'width height'=. fromDWORD1 (16+i.8){y

type, width, height
)

NB.
NB. process_bmp
NB.
NB. Extract width and height information from a BMP file.
NB.
NB. Most of these checks came from the old Worksheet::_process_bitmap method.
NB.
process_bmp=: 3 : 0

data=. y
type=. 7 NB. Excel Blip type (MSOBLIPTYPE).

NB. Check that the file is big enough to be a bitmap.
if. (#data) <: 16b36 do.
  'file: doesn''t contain enough data.' 13!:8 (3)
end.

NB. Read the bitmap width and height. Verify the sizes.
'width height'=. fromDWORD0 (18+i.8){data

if. (width > 16bffff) do.
  'file: largest image width width supported is 65k.' 13!:8 (3)
end.

if. (height > 16bffff) do.
  'file: largest image height supported is 65k.' 13!:8 (3)
end.

NB. Read the bitmap planes and bpp data. Verify them.
'planes bitcount'=. fromWORD0 (26+i.4){data

NB. if. (bitcount ~: 24) do.
NB.   'filename isn''t a 24bit true color bitmap.' 13!:8 (3)
NB. end.

if. (planes ~: 1) do.
  'file: only 1 plane supported in bitmap image.' 13!:8 (3)
end.

NB. Read the bitmap compression. Verify compression.
compression=. fromDWORD0 (30+i.4){data

if. (compression ~: 0) do.
  'file: compression not supported in bitmap image.' 13!:8 (3)
end.

type, width, height
)

NB.
NB. end of Methods related to comments and MSO objects.
NB. =========================================================
