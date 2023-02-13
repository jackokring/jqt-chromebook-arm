// gcc -m64 -o foo $(mysql_config --cflags) mysqlconst.c
// cc -m64 -o foo.exe $(mysql_config --cflags) mysqlconst.c

#include <stdio.h>
#if (defined(_WIN32) || defined(_WIN64)) && !defined(__WIN__)
#include <winsock2.h>				/* For windows */
#endif
#include <mysql.h>

#define offsetof(TYPE, MEMBER)  __builtin_offsetof (TYPE, MEMBER)

#define pvalue(a) printf( #a " = %d\n", a)
#define psizeof(a) printf("sizeof ( "#a " ) = %d\n", sizeof ( a ))
#define psizeofstruc(a) printf("SZ_" #a "=: %d\n", sizeof ( a ))
#define poffset(TYPE, MEMBER) printf(#TYPE "_" #MEMBER "=: %d\n", offsetof ( TYPE , MEMBER ))

int main( int argc,  char *argv[] )
{
psizeof(short);
psizeof(int);
psizeof(long);

printf("\nNB. MYSQL_FIELD\n");
psizeofstruc(MYSQL_FIELD);
poffset(MYSQL_FIELD,name);
poffset(MYSQL_FIELD,org_name);
poffset(MYSQL_FIELD,table);
poffset(MYSQL_FIELD,org_table);
poffset(MYSQL_FIELD,db);
poffset(MYSQL_FIELD,catalog);
poffset(MYSQL_FIELD,def);
poffset(MYSQL_FIELD,length);
poffset(MYSQL_FIELD,max_length);
poffset(MYSQL_FIELD,name_length);
poffset(MYSQL_FIELD,org_name_length);
poffset(MYSQL_FIELD,table_length);
poffset(MYSQL_FIELD,org_table_length);
poffset(MYSQL_FIELD,db_length);
poffset(MYSQL_FIELD,catalog_length);
poffset(MYSQL_FIELD,def_length);
poffset(MYSQL_FIELD,flags);
poffset(MYSQL_FIELD,decimals);
poffset(MYSQL_FIELD,charsetnr);
poffset(MYSQL_FIELD,type);
poffset(MYSQL_FIELD,extension);

printf("\nNB. MYSQL_BIND\n");
psizeofstruc(MYSQL_BIND);
poffset(MYSQL_BIND,length);
poffset(MYSQL_BIND,is_null);
poffset(MYSQL_BIND,buffer);
poffset(MYSQL_BIND,error);
poffset(MYSQL_BIND,row_ptr);
poffset(MYSQL_BIND,buffer_length);
poffset(MYSQL_BIND,offset);
poffset(MYSQL_BIND,length_value);
poffset(MYSQL_BIND,param_number);
poffset(MYSQL_BIND,pack_length);
poffset(MYSQL_BIND,buffer_type);
poffset(MYSQL_BIND,error_value);
poffset(MYSQL_BIND,is_unsigned);
poffset(MYSQL_BIND,long_data_used);
poffset(MYSQL_BIND,is_null_value);
poffset(MYSQL_BIND,extension);

printf("\nNB. MYSQL_TIME\n");
psizeofstruc(MYSQL_TIME);
poffset(MYSQL_TIME,year);
poffset(MYSQL_TIME,month);
poffset(MYSQL_TIME,day);
poffset(MYSQL_TIME,hour);
poffset(MYSQL_TIME,minute);
poffset(MYSQL_TIME,second);
poffset(MYSQL_TIME,second_part);
poffset(MYSQL_TIME,neg);
poffset(MYSQL_TIME,time_type);

return 0;
}
