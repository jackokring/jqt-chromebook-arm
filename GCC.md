# Running GCC
To get a stripped lib opening code with blank read/write use
```
gcc libj.so jeload.c jconsoul.c -ldl
```

# `jeload.c`
This is the main library loading code. DO NOT EDIT.

# `jconsoul.c`
This is where main loads in the library and the IO hook functions are for `char*` IO. I've basically botched it to make the compile happen.
