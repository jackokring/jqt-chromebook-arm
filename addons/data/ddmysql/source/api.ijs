NB. api

3 : 0''
select. UNAME
case. 'Linux' do. libmysql=: 'libmysqlclient.so.18'
case. 'Darwin' do. libmysql=: 'libmysqlclient.dylib'
case. 'Win' do. libmysql=: 'libmysql.dll'
case. do. libmysql=: ''
end.
i.0 0
)

MYSQL_OK=: 0
PREFETCH_ROWS=: IFWIN{1000 255     NB. windows crashes if > 255

NB. status return codes
MYSQL_NO_DATA=: 100
MYSQL_DATA_TRUNCATED=: 101

CURSOR_TYPE_NO_CURSOR=: 0
CURSOR_TYPE_READ_ONLY=: 1
CURSOR_TYPE_FOR_UPDATE=: 2
CURSOR_TYPE_SCROLLABLE=: 4

MYSQL_TIMESTAMP_NONE=: _2
MYSQL_TIMESTAMP_ERROR=: _1
MYSQL_TIMESTAMP_DATE=: 0
MYSQL_TIMESTAMP_DATETIME=: 1
MYSQL_TIMESTAMP_TIME=: 2

NOT_NULL_FLAG=: 1
PRI_KEY_FLAG=: 2
UNIQUE_KEY_FLAG=: 4
MULTIPLE_KEY_FLAG=: 8
BLOB_FLAG=: 16
UNSIGNED_FLAG=: 32
ZEROFILL_FLAG=: 64
BINARY_FLAG=: 128

MYSQL_TYPE_DECIMAL=: 0
MYSQL_TYPE_TINY=: 1
MYSQL_TYPE_SHORT=: 2
MYSQL_TYPE_LONG=: 3
MYSQL_TYPE_FLOAT=: 4
MYSQL_TYPE_DOUBLE=: 5
MYSQL_TYPE_NULL=: 6
MYSQL_TYPE_TIMESTAMP=: 7
MYSQL_TYPE_LONGLONG=: 8
MYSQL_TYPE_INT24=: 9
MYSQL_TYPE_DATE=: 10
MYSQL_TYPE_TIME=: 11
MYSQL_TYPE_DATETIME=: 12
MYSQL_TYPE_YEAR=: 13
MYSQL_TYPE_NEWDATE=: 14
MYSQL_TYPE_VARCHAR=: 15
MYSQL_TYPE_BIT=: 16

MYSQL_TYPE_NEWDECIMAL=: 246
MYSQL_TYPE_ENUM=: 247
MYSQL_TYPE_SET=: 248
MYSQL_TYPE_TINY_BLOB=: 249
MYSQL_TYPE_MEDIUM_BLOB=: 250
MYSQL_TYPE_LONG_BLOB=: 251
MYSQL_TYPE_BLOB=: 252
MYSQL_TYPE_VAR_STRING=: 253
MYSQL_TYPE_STRING=: 254
MYSQL_TYPE_GEOMETRY=: 255

STMT_ATTR_UPDATE_MAX_LENGTH=: 0
STMT_ATTR_CURSOR_TYPE=: 1
STMT_ATTR_PREFETCH_ROWS=: 2

3 : 0''
if. IF64 do.
  if. IFUNIX do.
NB. MYSQL_FIELD
    SZ_MYSQL_FIELD=: 128
    MYSQL_FIELD_name=: 0
    MYSQL_FIELD_org_name=: 8
    MYSQL_FIELD_table=: 16
    MYSQL_FIELD_org_table=: 24
    MYSQL_FIELD_db=: 32
    MYSQL_FIELD_catalog=: 40
    MYSQL_FIELD_def=: 48
    MYSQL_FIELD_length=: 56
    MYSQL_FIELD_max_length=: 64
    MYSQL_FIELD_name_length=: 72
    MYSQL_FIELD_org_name_length=: 76
    MYSQL_FIELD_table_length=: 80
    MYSQL_FIELD_org_table_length=: 84
    MYSQL_FIELD_db_length=: 88
    MYSQL_FIELD_catalog_length=: 92
    MYSQL_FIELD_def_length=: 96
    MYSQL_FIELD_flags=: 100
    MYSQL_FIELD_decimals=: 104
    MYSQL_FIELD_charsetnr=: 108
    MYSQL_FIELD_type=: 112
    MYSQL_FIELD_extension=: 120

NB. MYSQL_BIND
    SZ_MYSQL_BIND=: 112
    MYSQL_BIND_length=: 0
    MYSQL_BIND_is_null=: 8
    MYSQL_BIND_buffer=: 16
    MYSQL_BIND_error=: 24
    MYSQL_BIND_row_ptr=: 32
    MYSQL_BIND_buffer_length=: 64
    MYSQL_BIND_offset=: 72
    MYSQL_BIND_length_value=: 80
    MYSQL_BIND_param_number=: 88
    MYSQL_BIND_pack_length=: 92
    MYSQL_BIND_buffer_type=: 96
    MYSQL_BIND_error_value=: 100
    MYSQL_BIND_is_unsigned=: 101
    MYSQL_BIND_long_data_used=: 102
    MYSQL_BIND_is_null_value=: 103
    MYSQL_BIND_extension=: 104

NB. MYSQL_TIME
    SZ_MYSQL_TIME=: 40
    MYSQL_TIME_year=: 0
    MYSQL_TIME_month=: 4
    MYSQL_TIME_day=: 8
    MYSQL_TIME_hour=: 12
    MYSQL_TIME_minute=: 16
    MYSQL_TIME_second=: 20
    MYSQL_TIME_second_part=: 24
    MYSQL_TIME_neg=: 32
    MYSQL_TIME_time_type=: 36

  else.

NB. win64
NB. sizeof ( long ) = 4

NB. MYSQL_FIELD
    SZ_MYSQL_FIELD=: 120
    MYSQL_FIELD_name=: 0
    MYSQL_FIELD_org_name=: 8
    MYSQL_FIELD_table=: 16
    MYSQL_FIELD_org_table=: 24
    MYSQL_FIELD_db=: 32
    MYSQL_FIELD_catalog=: 40
    MYSQL_FIELD_def=: 48
    MYSQL_FIELD_length=: 56
    MYSQL_FIELD_max_length=: 60
    MYSQL_FIELD_name_length=: 64
    MYSQL_FIELD_org_name_length=: 68
    MYSQL_FIELD_table_length=: 72
    MYSQL_FIELD_org_table_length=: 76
    MYSQL_FIELD_db_length=: 80
    MYSQL_FIELD_catalog_length=: 84
    MYSQL_FIELD_def_length=: 88
    MYSQL_FIELD_flags=: 92
    MYSQL_FIELD_decimals=: 96
    MYSQL_FIELD_charsetnr=: 100
    MYSQL_FIELD_type=: 104
    MYSQL_FIELD_extension=: 112

NB. MYSQL_BIND
    SZ_MYSQL_BIND=: 104
    MYSQL_BIND_length=: 0
    MYSQL_BIND_is_null=: 8
    MYSQL_BIND_buffer=: 16
    MYSQL_BIND_error=: 24
    MYSQL_BIND_row_ptr=: 32
    MYSQL_BIND_buffer_length=: 64
    MYSQL_BIND_offset=: 68
    MYSQL_BIND_length_value=: 72
    MYSQL_BIND_param_number=: 76
    MYSQL_BIND_pack_length=: 80
    MYSQL_BIND_buffer_type=: 84
    MYSQL_BIND_error_value=: 88
    MYSQL_BIND_is_unsigned=: 89
    MYSQL_BIND_long_data_used=: 90
    MYSQL_BIND_is_null_value=: 91
    MYSQL_BIND_extension=: 96

NB. MYSQL_TIME
    SZ_MYSQL_TIME=: 36
    MYSQL_TIME_year=: 0
    MYSQL_TIME_month=: 4
    MYSQL_TIME_day=: 8
    MYSQL_TIME_hour=: 12
    MYSQL_TIME_minute=: 16
    MYSQL_TIME_second=: 20
    MYSQL_TIME_second_part=: 24
    MYSQL_TIME_neg=: 28
    MYSQL_TIME_time_type=: 32
  end.

else.

NB. MYSQL_FIELD
  SZ_MYSQL_FIELD=: 84
  MYSQL_FIELD_name=: 0
  MYSQL_FIELD_org_name=: 4
  MYSQL_FIELD_table=: 8
  MYSQL_FIELD_org_table=: 12
  MYSQL_FIELD_db=: 16
  MYSQL_FIELD_catalog=: 20
  MYSQL_FIELD_def=: 24
  MYSQL_FIELD_length=: 28
  MYSQL_FIELD_max_length=: 32
  MYSQL_FIELD_name_length=: 36
  MYSQL_FIELD_org_name_length=: 40
  MYSQL_FIELD_table_length=: 44
  MYSQL_FIELD_org_table_length=: 48
  MYSQL_FIELD_db_length=: 52
  MYSQL_FIELD_catalog_length=: 56
  MYSQL_FIELD_def_length=: 60
  MYSQL_FIELD_flags=: 64
  MYSQL_FIELD_decimals=: 68
  MYSQL_FIELD_charsetnr=: 72
  MYSQL_FIELD_type=: 76
  MYSQL_FIELD_extension=: 80

NB. MYSQL_BIND
  SZ_MYSQL_BIND=: 64
  MYSQL_BIND_length=: 0
  MYSQL_BIND_is_null=: 4
  MYSQL_BIND_buffer=: 8
  MYSQL_BIND_error=: 12
  MYSQL_BIND_row_ptr=: 16
  MYSQL_BIND_buffer_length=: 32
  MYSQL_BIND_offset=: 36
  MYSQL_BIND_length_value=: 40
  MYSQL_BIND_param_number=: 44
  MYSQL_BIND_pack_length=: 48
  MYSQL_BIND_buffer_type=: 52
  MYSQL_BIND_error_value=: 56
  MYSQL_BIND_is_unsigned=: 57
  MYSQL_BIND_long_data_used=: 58
  MYSQL_BIND_is_null_value=: 59
  MYSQL_BIND_extension=: 60

NB. MYSQL_TIME
  SZ_MYSQL_TIME=: 36
  MYSQL_TIME_year=: 0
  MYSQL_TIME_month=: 4
  MYSQL_TIME_day=: 8
  MYSQL_TIME_hour=: 12
  MYSQL_TIME_minute=: 16
  MYSQL_TIME_second=: 20
  MYSQL_TIME_second_part=: 24
  MYSQL_TIME_neg=: 28
  MYSQL_TIME_time_type=: 32
end.
''
)

NB. =========================================================

mysql_affected_rows=: (libmysql, ' mysql_affected_rows > x x' ) &cd
mysql_autocommit=: (libmysql, ' mysql_autocommit > i x i' ) &cd
mysql_commit=: (libmysql, ' mysql_commit > i x' ) &cd
mysql_rollback=: (libmysql, ' mysql_rollback > i x' ) &cd
mysql_character_set_name=: (libmysql, ' mysql_character_set_name > x x' ) &cd
mysql_close=: (libmysql, ' mysql_close > n x' ) &cd
mysql_errno=: (libmysql, ' mysql_errno > i x' ) &cd
mysql_error=: (libmysql, ' mysql_error > x x' ) &cd
mysql_fetch_field_direct=: (libmysql, ' mysql_fetch_field_direct > x x i' ) &cd
mysql_fetch_lengths=: (libmysql, ' mysql_fetch_lengths > x x' ) &cd
mysql_fetch_row=: (libmysql, ' mysql_fetch_row > x x' ) &cd
mysql_field_count=: (libmysql, ' mysql_field_count > i x' ) &cd
mysql_free_result=: (libmysql, ' mysql_free_result > n x' ) &cd
mysql_get_client_info=: (libmysql, ' mysql_get_client_info > x' ) &cd
mysql_get_host_info=: (libmysql, ' mysql_get_host_info > x x' ) &cd
mysql_get_server_info=: (libmysql, ' mysql_get_server_info > x x' ) &cd
mysql_init=: (libmysql, ' mysql_init > x x' ) &cd
mysql_num_fields=: (libmysql, ' mysql_num_fields > i x' ) &cd
mysql_real_connect=: (libmysql, ' mysql_real_connect > x x *c *c *c *c i *c x' ) &cd
mysql_real_escape_string=: (libmysql, ' mysql_real_escape_string > x *c *c x' ) &cd
mysql_real_query=: (libmysql, ' mysql_real_query > i x *c x' ) &cd
mysql_set_character_set=: (libmysql, ' mysql_set_character_set > i x *c' ) &cd
mysql_sqlstate=: (libmysql, ' mysql_sqlstate > x x' ) &cd
mysql_stmt_affected_rows=: (libmysql, ' mysql_stmt_affected_rows > x x' ) &cd
mysql_stmt_attr_get=: (libmysql, ' mysql_stmt_attr_get > i x i *x' ) &cd
mysql_stmt_attr_set=: (libmysql, ' mysql_stmt_attr_set > i x i *x' ) &cd
mysql_stmt_bind_param=: (libmysql, ' mysql_stmt_bind_param > i x x' ) &cd
mysql_stmt_bind_result=: (libmysql, ' mysql_stmt_bind_result > i x x' ) &cd
mysql_stmt_close=: (libmysql, ' mysql_stmt_close > i x' ) &cd
mysql_stmt_errno=: (libmysql, ' mysql_stmt_errno > i x' ) &cd
mysql_stmt_error=: (libmysql, ' mysql_stmt_error > x x' ) &cd
mysql_stmt_execute=: (libmysql, ' mysql_stmt_execute > i x' ) &cd
mysql_stmt_fetch=: (libmysql, ' mysql_stmt_fetch > i x' ) &cd
mysql_stmt_fetch_column=: (libmysql, ' mysql_stmt_fetch_column > i x x i x' ) &cd
mysql_stmt_free_result=: (libmysql, ' mysql_stmt_free_result > i x' ) &cd
mysql_stmt_init=: (libmysql, ' mysql_stmt_init > x x' ) &cd
mysql_stmt_param_count=: (libmysql, ' mysql_stmt_param_count > x x' ) &cd
mysql_stmt_param_metadata=: (libmysql, ' mysql_stmt_param_metadata > x x' ) &cd
mysql_stmt_prepare=: (libmysql, ' mysql_stmt_prepare > i x *c x' ) &cd
mysql_stmt_reset=: (libmysql, ' mysql_stmt_reset > i x' ) &cd
mysql_stmt_result_metadata=: (libmysql, ' mysql_stmt_result_metadata > x x' ) &cd
mysql_stmt_sqlstate=: (libmysql, ' mysql_stmt_sqlstate > x x' ) &cd
mysql_store_result=: (libmysql, ' mysql_store_result > x x' ) &cd
mysql_use_result=: (libmysql, ' mysql_use_result > x x' ) &cd
