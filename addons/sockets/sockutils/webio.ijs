require 'socket'
require 'strings'
require 'sockets/socklib/sockconnxactn'
NB. causes trouble for quizbowl require 'format/printf'
require 'dll'
coclass 'web'
(copath~ ~.@(('jsocket';'jdefs')&,)@:copath) @: coname ''

registerinit 0
initialize =: 3 : 0
settimeouts 5 10 20
NB. obsolete webinithosts 1
NILRET
)

NB. y is y m d
NB. Result is sequential julian day, beginning of epoch not defined
NB. Works only for 1901-2099
julianday =: 3 : 0
'y m d' =. 3 {. y
NB. Calculate the 1-origin day of the year, plus 365 for each year, plus 1 for each
NB. leap year, minus 1 in Jan-Feb of leap year.
d + (m { 0 0 31 59 90 120 151 181 212 243 273 304 334 365) + (365 * y-1995) + (<.y%4) - (m<3) *. (0=4|y)
)

NB. y is y m d [ optional other stuff ]
NB. Result is day of week (0=Sunday, 6=Saturday)
NB. Works only for 1901-2099.  The phase constant is empirical
dayofweek =: 13 : '7 | 5 + julianday y'

sync_connto =: 5000  NB. Number of milliseconds to wait for a synchronous connect
sync_datato =: 10000 NB. Number of milliseconds to wait for data
async_connto =: 20000  NB. Number of ms to wait for sync connection

NB. y is (connect timeout),(data timeout) for sync connections
settimeouts =: 3 : 0
'sync_connto sync_datato async_connto' =: 1000 * y
NILRET
)

NB. y is a message
NB. We extract Set-cookie headers and add them to the cookie table
setcookie =: 3 : 0
NB. Convert the cookies to name;value;domain/path
)

NB. Initialization stuff
NB. The variables given here are modified by calls from setup code
NB. This kludge should be done by exec, not by load

NB. The proxify verb takes host;path and returns
NB. proxyhost;proxypath
NB. For non-proxy systems, this is the same as the input; for
NB. proxies, this is  proxyaddr:proxyport ; 'http://' , host , path
setproxify =: 3 : 0  NB. Set proxify verb
proxify =: 13 : y
NILRET
)
setproxify 'y'

setproxyauth =: 3 : 0
proxyauth =: y "_
NILRET
)
setproxyauth NIL

NB. **** Routines to format header for HTML 1.0 ***
NB. For all these routines, x is (session;host);proxyhost;path;method and y is data
NB. session is (< ,(<authorization-string) ) [optionally , callback parms ; callback name ; timeout]

NB. Request line
webreqline =: ('%j %j HTTP/1.1\n' vsprintf)@(3 2&{)@[

webhdr =: (LF;CRLF) stringreplace 0 : 0
Host: %j
Connection: close
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7
Accept-Language: en-us,en;q=0.5
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.10) Gecko/20100914 Firefox/3.6.10 ( .NET CLR 3.5.30729; .NET4.0E)
)
NB. We check the gzip library to verify that it matches the version we expect.
NB. If it does, we allow gzip encoding
webhdr =: webhdr , 3 : 0 ''
try.
  verstg =. 'zlib1 zlibVersion >+ i' cd ''  NB. This will fail if zlib not found
  if. '1' = memr verstg,0,1,2 do.
    'Accept-Encoding: gzip',CRLF
  else.
    ''
  end.
catch.
  ''
end.
)

NB. longform webhostline =: ('Host: %j\nConnection: close\nUser-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows 98; T312461)\nAccept: */*\n' vsprintf)@:<@:({.~ ':443'&(E. i. 1:))@:((0;1)&{::)@[
NB. obsolete webhostline =: ('Host: %j\nConnection: close\nUser-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows 98; T312461)\n' vsprintf)@:<@:({.~ ':443'&(E. i. 1:))@:((0;1)&{::)@[
webhostline =: (webhdr vsprintf)@:<@:({.~ ':443'&(E. i. 1:))@:((0;1)&{::)@[

NB. Date line.  If there is no data, the date must be omitted
webdate =: 3 : 0  ^: (*@:#)@]
tod =. <. 6!:0 NIL  NB. clear frac seconds
carry =. 3000 12 , ((1{tod){0 , daysinmonth 0{tod), 24 60 60
NB. gmtod =. carry (] + [ ((1&|.@]) - *) <)^:_ (0 0 0 4 0 0 + tod)
gmtod =. 0 1 1 4 0 0 +&.(carry&#.)&.(-&0 1 1 0 0 0) tod
'Date: %j, %.2d %j %j %.2d:%.2d:%.2d GMT\n'&sprintf ((dayofweek 3 {. gmtod) { 7 3$'SunMonTueWedThuFriSat') ; (2{gmtod) ; ((<: (1{gmtod)){12 3$'JanFebMarAprMayJunJulAugSepOctNovDec') ; (<"0) 0 3 4 5 { gmtod
)

webauth =: 13 : '0 {:: > 0 { (0;0) {:: x'

webcontenttype =: ('Content-Type: application/x-www-form-urlencoded',CR,LF)"_ ^: (*@#) @]

webcontentlength =: ('Content-Length: %j\n' vsprintf)@# ^: (*@:#) @]

webdata =: '\n%j' vsprintf @ < @ ]

NB. x is host;path  y is directory;filename of a cookie (directory ends with \)
NB. Result is a box of list of list of boxed strings to use, name=value pairs
NB. cookies are stored in IE5 format
webanalyzecookie =: 4 : 0 "1
'host path' =. x
host =. ':' taketo host  NB. ignore port if given
iecookie =. (<;.2~ (|.!.0)@(('*',LF)&E.))  1!:1 < ; y  NB. Cut on *LF
NB. Cookies seem to be name;value;domain/path;secure;4 items of Greek;'*'
NB. All we need is name;value;domain/path
usecookie =. 3&{. @ (< onpiecesusingtail) @> iecookie
NB. Convert the domain/path to domain and path
usecookie =. (0 1&{ , '/'&(i.~ ({. ; }.) ])@(2&{::))"1 usecookie
NB. Throw out domain names that don't match.  Names match if the
NB. name in the cookie is a suffix of the name, and either matches
NB. the whole name or starts with a dot.
NB.  This is according to the RFC.  But for the time being, don't require exact match
NB.  since thestreet.com doesn't start with a dot
NB. exactmatch: usecookie =. host (((-: +. '.'&=@{.@] *. (({.~ -@#) -: ])) 2&{::)"_ 1 usedtocull) usecookie
usecookie =. host (((-: +. (({.~ -@#) -: ])) 2&{::)"_ 1 usedtocull) usecookie
NB. Throw out paths that don't match.  The cookie path must match a prefix
NB. of the requested path (up to the last '/')
usecookie =. (path (>:@i: {. [) '/') ((([ -: (# ux_vy {.)) 3&{::)"_ 1 usedtocull) usecookie
NB. Return name;value;domain;path from the cookie
usecookie
)

NB. y is path, result is boxed names of cookie files with that path
webcookiefn =: 3 : 0
0 {"1 (1!:0) ((TRADEPATH,'Cookies\'),'default@') , ('/' taketo {. y) , '*.*'
)

NB. This is a web header-line function, with the same arguments as the others
webcookie =: 4 : 0
'sesshost path' =. 0 2 { x
host =. 1 {:: sesshost
cookies =. ; (host;path) (<@webanalyzecookie (TRADEPATH,'Cookies\')&;)"_ 0 butifnull ('') webcookiefn path
if. 0 = #cookies do. '' return. end.
'Cookie: $Version="1";%S\n'&sprintf < ,&';'&.> cookies
)

NB. *** End of header routines

zlibinarea =: mema 500000  NB. Reserve 500K for input
zlibarea =: mema 1000000   NB. Reserve 1MB for decompressing streams
zstream =: mema 14*4   NB. Allocate an area to use for z_stream
NB. y is string, result is 1 if the string contains <HTML> and </HTML>
NB. obsolete stringhashtml =: (rxcomp '<[hH][tT][mM][lL]>[][:' , ((#~ >:@('\'&=))(}. a.) -. '][:-') , '-]*</[hH][tT][mM][lL]>')&stringhasregexp
stringhashtml =: (rxcomp '(?is)<html[ >].*</html>' [ rxutf8 :: 0: 0)&stringhasregexp
NB. y is network data
NB. Result is return code ; stripped data ; stripped header
NB. If the data is HTTP, we remove the header and convert CR to LF
striphttp =: 3 : 0
NB. debug striphttp_debug_   =: y
if. 'HTTP' -: 4 {. y do.  NB. Additional work if HTTP
  NB. Extract content-length and verify it matches
  NB. If chunked encoding, handle chunking
  NB. Extract return code, discarding Informational responses
  while. do.
    ehx =. (CR,LF,CR,LF) (E. i. 1:) y
    bhdr =. <;._2 hdr =. crlftolf (ehx+2) {. y
    NB. Extract return code, exit loop of not Informational
    if. -. 100 199 brackets rc =. 555&". ' ' taketo ' ' takeafter 0{:: bhdr do. break. end.
    y =. (ehx+4) }. y
  end.
  if. 200 = rc do.
    rc =. 0  NB. RC 200 is OK
    if. tenc =. (<'Transfer-Encoding:') ([ -: <.&# {. ])&> usedtocull  bhdr
      'CHUNKED' -: toupper ' ' -.~ (#'Transfer-Encoding:') }. > {. tenc
    do.
      NB. Chunked transfer: reconstitute the unchunked data
      chunkx =. 0 2$0
      hptr =. ehx+4
      while. do.
        NB. start at hptr, find next CR.  Protect against error if hptr is past data
        chln =. 2 + #chdr =. (,. hptr,100) ({.~ CR&(i.&1@:=));.0 :: (''"_) y
        csz =. ({.~ ';'&(i.&1@:=)) chdr
        if. 0 = #csz do. rc =. 558 break. end.  NB. No len, error
        if. *./ '0' = csz do. break. end.  NB. Len 0, that's end-of-data
        if. -. *./ csz e. ' 0123456789abcdefABCDEF' do. rc =. 559 break. end.  NB. Invalid chunk len
        ckln =. 0&". '16b' , tolower csz  NB. len of chunk
        chunkx =. chunkx , (hptr+chln),ckln
        if. (#y) < hptr =. hptr + ckln + chln + 2 do. rc =. 560 break. end.  NB. insufficient data
      end.
      body =. chunkx substr endtoend y
    else.
      NB. Not chunked.  The entire body is the data.  Verify that the length is correct
      body =. (ehx+4) }. y
      if. 0 = #lenrcd =. (<'Content-Length:') ([ -: <.&# {. ])&> usedtocull bhdr do.
        NB. Unknown length.  Verify that it at least contains valid HTML
        NB. But YAHOO seems to omit the Content-Length when it gzips, so omit the audit in that case
        if. bhdr e.~ <'Content-Encoding: gzip' do.
        elseif. -. stringhashtml body do.
          NB. YAHOO sometimes just sends an empty page.  Don't bother with a message for that.
          NB. And, Google sometimes sends the head with no body.  Don't message that either.
          NB. In other cases, give a message
          if. (0=#body) +: (body (] -: ({.~ -@#)) '</head>') do.
            display 'ill-formed HTML'
            y550__   =: body
            y550hdr__   =: bhdr
          end.
          rc =. 550  NB. Ill-formed HTML
        end.
        NB. Unchunked data with length.  Verify length matches
      elseif. (#body) ~: _1&". ' ' -.~ (#'Content-Length:') }. > {. lenrcd do.
display 'incorrect content length, exp=' , (": _1&". ' ' -.~ (#'Content-Length:') }. > {. lenrcd) , ' actual=' , (":#body)
        rc =. 557  NB. Incorrect length
      end.
    end.
    NB. We have extracted the data.  If it is gzipped, inflate it
    if. bhdr e.~ <'Content-Encoding: gzip' do.
      NB. The data was compressed.  Inflate it using zlib
NB. typedef struct z_stream_s {
NB.     Bytef    *next_in;  /* next input byte */ body
NB.     uInt     avail_in;  /* number of bytes available at next_in */ #body
NB.     uLong    total_in;  /* total nb of input bytes read so far */ 0
NB.
NB.     Bytef    *next_out; /* next output byte should be put there */ zlibarea
NB.     uInt     avail_out; /* remaining free space at next_out */ #zlibarea
NB.     uLong    total_out; /* total nb of bytes output so far */ 0
NB.
NB.     char     *msg;      /* last error message, NULL if no error */ -
NB.     struct internal_state FAR *state; /* not visible by applications */ -
NB.
NB.     alloc_func zalloc;  /* used to allocate the internal state */ 0
NB.     free_func  zfree;   /* used to free the internal state */ 0
NB.     voidpf     opaque;  /* private data object passed to zalloc and zfree */ -
NB.
NB.     int     data_type;  /* best guess about the data type: binary or text */ -
NB.     uLong   adler;      /* adler32 value of the uncompressed data */ -
NB.     uLong   reserved;   /* reserved for future use */ -
NB. } z_stream;

      NB. Create the z_stream header
      (zlibinarea,(#body),0,  zlibarea,1000000 0   0 0   0 0) memw zstream,0 10 4  NB. fill in 10 ints
      NB. Move the data into the input area
      if. 500000 < #body do. 
        display 'failure in inflate, input exceeds 500KB'
        rc =. 558
      elseif.
      body memw zlibinarea,0,(#body),2
      NB. Initialize the decompressor.  We treat zstream as an int even though it's really a struct *
      0 ~: zrc =. 'zlib1 inflateInit2_ >+ i i i *c i' cd zstream;(16+15);'1.2.5';14*4 do.  NB. z_stream, (gzip format, large temp buffer), version, hdrsize
        display 'failure in inflateinit: ' , ":rc
        rc =. 558
zipbody__   =: body
ziphdr__   =: bhdr
        NB. Decompress the input stream in one go
      elseif. 1 ~: zrc =. 'zlib1 inflate >+ i i i' cd zstream,4 do.  NB. z_stream, Z_FLUSH
        display 'failure in inflate: ' , ":rc
        rc =. 558
      elseif. do. NB. if no error, replace the message body with the decompressed version
        body =. memr zlibarea,0,(memr zstream,20,1,4),2  NB. 
      end.
      NB. Close the decompressor
      'zlib1 inflateEnd >+ i i' cd zstream
    end.
    NB. Convert CRLF to LF
    body =. crtolf crlftolf body
  else.  NB. If error reading the data:
    body =. crtolf crlftolf (ehx+4) }. y
  end.
else.  NB. Some PBS returns don't start HTTP: we use their error format.  If they have
    NB. HTML, we return them as valid, otherwise fail 551
  hdr =. ''
  body =. y
  if. stringhashtml body do.
    if. 'Internal Server Error' +./@:E. 50 {. y do. rc =. 555 else. rc =. 0 end.  NB. Catch errors
  else.
y551__   =: y
    rc =. 551  NB. Invalid data
    NB. Kludge seems that Middleman gets corrupted if connections persist too long.  Till we know what too long is,
    NB. restart it when we get an error
    closemiddleman''
  end.
end.
rc;body;hdr
)

NB. obsolete NB. Reinit host list.  If y is 1, unconditionally; if y is 0, filter the requests
NB. obsolete NB. using a times filter: if more than 2 errors within 10 minutes, reinit
NB. obsolete webinithosts =: 3 : 0
NB. obsolete if. 1 = y default 1 do.
NB. obsolete NB. Init: init the variables
NB. obsolete   webhosttimes =: 0 $ 0
NB. obsolete   webhosts =: 0 2 $ a:
NB. obsolete else.
NB. obsolete   NB. Normal test: discard old timestamps, add timestamp for now.  If there are enough
NB. obsolete   NB. timestamps, do a reinit
NB. obsolete   if. 3 <: # webhosttimes =: (todsts NIL) ([ , ((mintotime 10)&(>!.0))@:- usedtocull) webhosttimes do.
NB. obsolete     webinithosts 1
NB. obsolete   end.
NB. obsolete end.
NB. obsolete NILRET
NB. obsolete )

NB. obsolete NB. Replacement for sdgethostbyname, uses local list to avoid delays
NB. obsolete NB. webhosts is list of externalname;xx.xx.xx.xx
NB. obsolete webgethostbyname =: 3 : 0
NB. obsolete if. (0&=@# +. '255.255.255.255'&-:) h =. (<y) (<'') (getklu1d) webhosts do.
NB. obsolete   if. 0~:0{::x=. sdgethostbyname y do. x return. end.
NB. obsolete   webhosts =: nubkl webhosts ,~ y ; h =. 2{::x
NB. obsolete end.
NB. obsolete 0 ; AF_INET_jsocket_ ; h
NB. obsolete )
NB. obsolete webgethostbyname =: sdgethostbyname_jsocket_
webinithosts =: ]   NB. delete this
NB. x is (session;host);proxyhost (may be boxed or open); y is data
NB. session is (,<,<cookie) [ , callback x ; callback ; timeout  if this is an async socket]
NB. send y to the host and read the reply (i. e. all
NB. data till socket is closed)
NB. For synchronous sockets, we read the data and the result is   error code ; data [ ; hdr if no error ]
NB. For async sockets, the result is    error code ; the socket number that was opened
NB. Data has CRLF or bare CR converted to LF
webxactn =: 4 : 0
NB. debug debuglogout 'webxactn init'
NB. debug debuglogout 'x=:',5!:5 <'x'
NB. debug debuglogout 'y=:',5!:5 <'y'
NB. debug smoutput y
'host port' =. 2{.<;._1 ':',(1{::x),':80'  NB. default port to 80
callback =. }. (0;0) {:: x  NB. callback x ; callback [ ; timeout ] - if any
NB. debug debuglogout 'webxactn after set callback'
NB. debug debuglogout 'host=:',5!:5 <'host'
NB. debug debuglogout 'port=:',5!:5 <'port'
NB. Convert port to numeric; look up hostname, which we must do before converting to Middleman
NB. connection.  If we get error, set the error info into the port number, which the socket will
NB. immediately pass through
port =. 0 ". port   NB. Numeric from here on
if. 0 ~: 0 {:: h=. gethostbyname host do. port =. 0 2 { h
NB. debug debuglogout 'webxactn after webgethostbyname'
NB. If error looking up name, abort so Middleman won't choke
elseif. '255.255.255.255' -: 2 {:: h do. port =. (<553) 0} 0 2 { h
NB. For SSL sockets (port 443), add the host/port to the data and
NB. replace them with the middleman addresses
elseif. 443 = port do.  NB. SSL port
NB. debug debuglogout 'webxactn SSL socket'
  y =. '0%j:%j*%j\0%j'&sprintf (2{h) , port ; host ; y NB. prefix: 0 (1 to exit), domain:port , 0 , data
NB. debug debuglogout 'webxactn SSL socket after sprintf'
  h =. (<'127.0.0.1') 2} h
  port =. 1993  NB. Middleman port number
  r =. 1 {:: regcreatekey _2147483647;'SOFTWARE\TPOST\Tpost.ini';1
  middleman =. ((0&~:)@(0&{::) {:: (,&(<'D:\Middleman\C2010\Middleman\Debug\SSL_Middleman.exe'))@(1&{)) regqueryvalue r;'Middleman'
  regclosekey r
  if. 0 = taskfindwindow middleman do.  NB. Start Middleman if it's not running
  if. 0 = taskfindwindow 'SSL_Middleman' do.
    winexec middleman  NB. Start up SSL server
    6!:3 (2)  NB. wait for startup
  end.
  end.
end.

sk =. conew 'sockconnxactn'
NB. kludge for timeout value
NB. Send    addr port senddata callbackx callback to delim
if. #r =. create__sk (2{h),port;y;callback default '';'';(sync_datato%1000);'' do.
  NB. If the socket returns data, it is rc;data.  We audit it if it is HTTP data with no I/O error
  if. (0 = 0 {:: r) *. port e. 80 1993 do.
    striphttp 1{::r
  else.
    r
  end.
else.
  NB. If the socket started an async transfer, we are done here and will finish through the callback
  ''
end.

)

NB. x is (session;host);proxyhost;path;method   y is data
NB. Result is formatted HTML 1.0 message
webfmt10 =: 13 : 'x (webreqline , webhostline , webdate , proxyauth , webauth , webcontenttype , webcontentlength , webdata) y'

NB. x is (session;host);proxyhost;path;method   y is data
NB. We format the data as an HTML 1.0 message and then perform the
NB. web transaction
NB. For 1.0, the path is (path , '?' , form_data) and y is null
websend10 =: 13 : '(2 {. x) webxactn x webfmt10 y'

NB. y is character string; result is URL-escaped version, with special
NB. characters replaced by &hh
URLALLOWED =. 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$-_.!*(),''/'
HEXDIGITS=. '0123456789ABCDEF'
URLESCTBL =. ( <@( ( ((,/)@:('%'&,)@:({&HEXDIGITS)@:(16 16&#:)@:(a.&i.)) ` ]) @. (e.&URLALLOWED) ) )"0 a.
urlescape =: ; @: ({&URLESCTBL) @: (a.&i.)

NB. $y is N,2 where first column is name and second column is value
NB. (the columns represent the return from an HTML form)
NB. We create a character-string representation of the form, by
NB. escaping the names and values and putting the result into
NB. name=value&name=value... format.  If the name is blank, leave
NB. out the '='
fmtform =: ; @: ((, (<'&')&,)/) @: (([ , (#&'=')@*@#&.>@[ , ])/"1) @: (urlescape&.>"0) butifnull ''

NB. x is (<session;host);proxyhost;path;method   $y is N,2 form values
NB. Send the form, return the reply
webform =: 13 : 'x websend10 fmtform y'

NB. y is host;path or host/path
NB. Result is host;path
NB. hostpath =: ( ({.~ ; ('/'&,)@:}.@:(}.~)) i.&'/' ) @: ;

NB. The 'session' parm is:
NB. (<,(<cookie string))[,(callback x);(callback verb)[;(timeout)]]
NB.  we use async socket if #x > 1

NB. x is proxyhost;path  y is n,2$ form values
NB. result is path?name=value for all the form values.  Use ? as the prefix character
NB. unless it's there already; then use &
reqenc =: 13 : '(>{:x) ([ , ({&''?&'')@:(''?''&e.)@[ butifnull '''' , ])  fmtform y'
NB. x is session;host;path  y is n,2$ form values
NB. result is proxyhost;encoded path
forminname =: 13 : '(proxify }. x) ( {.@[ , <@reqenc ) y'

NB. u is req type ('GET'/'POST') x is session;host;path  y is n,2$ form values
NB. result is proxyhost;path;req
hostpathreq =: 1 : '<@(2&{.)@[ , forminname , (<u)"_'

NB. x is session;host;path  $y is N,2 form values
NB. Send the form as a GET and return the reply.
NB. Uses old-fashioned 0.9 GET because 1.0 doesn't work right: append the
NB. formatted form to the URL after a ?
NB. 1.1 form: webgetform =: 13 : '((< 2 {. x),(proxify }. x),<''GET'') webform y'
NB. If path contains ?, use & to add on fields
webgetform =: 13 : '(x ''GET'' hostpathreq y) websend10 '''''

NB. x is session;host;path  $y is N,2 form values
NB.  But if the first box is a 1-cell of y is double-boxed, that means put
NB.  the information into the address with ?name=value
NB. session is (,<,<cookie) [ , callback x ; callback ; timeout  if this is an async socket]
NB. host is 'www.site.com' e. g.
NB. path is '/page.html' e. g.
NB. Send the form as a POST and return the reply
NB. y is n,2 $ fields; split into (double-boxed fields);(single-boxed fields)
NB.  with the double-boxing removed if present
sepfields =: (>&.>@(#~ -.) ,&< #~) (1: >: L.@{."1)
webpostform =: ( ('POST' hostpathreq    0&{::) (websend10  fmtform) 1&{::@] )  sepfields

NB. obsolete NB. x is session;host  y is data to send to start
NB. obsolete NB. session is dummy ; callback x ; callback ; timeout ; delim
NB. obsolete NB. Send the data, wait for the reply
NB. obsolete webrawtcp =: 13 : '((< x),(proxify }. x)) webxactn y'
NB. obsolete 
NB. y is from;to;subject;text
NB. Result is formatted string to send as mail data
NB. We install message headers, extend any lines beginning with '.', and append
NB. the ending line
formatformail =: 3 : 0"1
'from to subject text' =. y
NB. Insert '.' in any position of 'LF.'; append end delimiter
text =. (CR,LF,'.',CR,LF) ,~ (1 j. (LF,'.') E. text) #!.'.' text
headers =. (webdate text) , ('From: <',from,'>',CR,LF) , ((*#subject) # 'Subject: ',subject,CR,LF) , ('To: ' , to,CR,LF)
headers , (CR,LF) , text
)

NB. export entry points to _z_ locale
publishentrypoints 'webgetform webpostform striphttp julianday dayofweek formatformail'
