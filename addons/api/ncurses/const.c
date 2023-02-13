// export CFLAGS="-D_POSIX_SOURCE -I/usr/include/ncursesw -D_XOPEN_SOURCE_EXTENDED"
// gcc -m64 -o foo $(CFLAGS) const.c
// cc -m64 -o foo.exe $(CFALGS) const.c

#include <stdio.h>
#include <curses.h>

#define offsetof(TYPE, MEMBER)  __builtin_offsetof (TYPE, MEMBER)

#define pvalue(a) printf( #a " = %d\n", a)
#define psizeof(a) printf("sizeof ( "#a " ) = %d\n", sizeof ( a ))
#define psizeofstruc(a) printf("sz_" #a "=: %d\n", sizeof ( a ))
#define poffset(TYPE, MEMBER) printf(#TYPE "_" #MEMBER "=: %d\n", offsetof ( TYPE , MEMBER ))

int main( int argc,  char *argv[] )
{
psizeof(short);
psizeof(int);
psizeof(long);

psizeof(chtype);
psizeof(attr_t);
psizeof(wchar_t);

printf("\nNB. cchar_t\n");
#if defined(_WIN32) || defined(__WIN__)
psizeof(cchar_t);
#else
psizeofstruc(cchar_t);
poffset(cchar_t,attr);
poffset(cchar_t,chars);
#endif

return 0;
}
