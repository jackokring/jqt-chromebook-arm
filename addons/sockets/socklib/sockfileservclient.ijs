NB. File-server requests
NB. We translate requests into file-server form, and convert the
NB. returned byte-stream into tables etc.  Transfers can be either sync or async

require 'strings'
require 'sockets/socklib/sockconnxactn'
coclass 'fileservclient'

MINXFERRATEUP =: 1 % 10000  NB. secs/byte min to allow for a timeout.  Measured empirically from RCHS server
MINXFERRATEDOWN =: 1 % 25000  NB. secs/byte min to allow for a timeout.  Measured empirically from RCHS server

NB. Make a request of the server
NB. y is command;password;(remote dirspec string & 0 or more dir\);parms varying with command
NB. x is callbackx ; callback ; timeout (sync/10 sec if omitted) [;debug]
NB. Result, either immediately or through the callback, is rc ; cmd-dependent format
NB. fileservreq_fileservclient_ 'GET';'read';'127.0.0.1:8080\';<<'*.txt'
fileservreq =: 3 : 0
('';'';10;0) fileservreq y
:
'ucbx ucb to debugmode' =. x default '';'';10;0
y =. y default '';'';'';''
NB. Turn the remote filespec into domain, port, and boxed path
rf =. '/\' xlatechars 2 {:: y    NB. the filespec
NB. Domain runs to '\', and may contain ':' port (else we use port 0 and hope somebody defaults it)
NB. After the '\' is the path
domain =. ('\'&taketo)@(,&'\') rf  NB. not including \
path =. fmtdirname (>:#domain) }. rf  NB. 0 or more dir\, boxed
port =. {. 0 ". ':' takeafter domain
domain =. ':' taketo domain
NB. The callback x will be used whether we are sync or async
cbinfo =. (cbx =. (0{y);(ucbx,&< ucb);debugmode) ; (*#1 {:: x) # (inthislocale 'respcb')
NB. Translate the domain name to internet address

NB. Create the data stream for the fileserver request in 'dstream'
NB. This depends on the request type
cparm =. 3 {:: y   NB. command-dependent parm.
select. 0{y
case. ;: 'GET LS LSX' do.  NB. parms are (list of boxed filenames to get/lookup; '*.*' if none)
  dstream =. (0{::y) , ' ' , (;:^:_1 '"'&enclosing&.> path , (<'*.*')&[^:(0=#) boxopen cparm) , CRLF
fcase. 'TS' do.  NB. like PUT, but we force only 1 file max
  cparm =. 2 {. , cparm
case. ;: 'PUT APPEND' do.  NB. parms are (possibly table of) filename;data
  NB. Get filename ; length
  fnl =. (0 {"1 cparm) ,. ":@#&.> 1 {"1 cparm
  dstream =. (0{::y) , ' ' , (;:^:_1 '"'&enclosing&.> path , , fnl) , CRLF , ; 1 {"1 cparm
case. ;: 'RM RENAME' do.  NB. parms are list of filenames
  dstream =. (0{::y) , ' ' , (;:^:_1 '"'&enclosing&.> path , boxopen cparm) , CRLF
case. ;: 'MKDIR RMDIR' do.  NB. no parms
  dstream =. (0{::y) , ' ' , (;:^:_1 '"'&enclosing&.> path) , CRLF
case. ;: 'RESTART' do.  NB. no parms
  dstream =. (0{::y) , ' ' , CRLF
case. do. 13!:8 (3)    NB. Domain error on invalid command
  NB.?lintonly dstream =. ''
end.
NB. Turn the data stream into a formatted fileserver request
NB. Send the request to the fileserver and await response
NB. Have the domain name translated (by boxing it)
to =. to >. MINXFERRATEUP * #dstream  NB. Give enought time to upload request
o =. conew 'sockconnxactn'
res =. create__o (<domain);port;(((1{y),<0) fileserv_addreqhdr_sockfileserver_ dstream);cbinfo,(to,debugmode);''

NB. If synchronous request, go through the callback to format the reply
if. 0 = #1 {:: cbinfo do. cbx respcb res else. '' end.
NB. Return the formatted result (rc;data) if sync; otherwise empty
)

NB. Callback, also called directly for sync operations
NB. x is (<command) ; (previous callback info if any) ; debugmode
NB. y is rc ; data from server
NB. We format the data according to the command; then if there is a callback, we
NB. drive the callback, otherwise return the formatted result
respcb =: 4 : 0
if. 2 {:: x do. smoutput 'fileserv respcb';y end.
if. 0 = 0 {:: res =. y do.
  if. 0 = 0 {:: 'rc data' =. res =. fileserv_decrsphdr_sockfileserver_ 1{:: y do.
    NB. Perform command-dependent analysis of return data
    select. 0 {:: x
    case. ;: 'PUT APPEND RM' do.  NB. No data
    case. 'LS' do.  NB. Data is TABdelimed table, return as boxed table of name;date;size;codes;permissions
      NB. Convert date, size to numeric
      if. #data do.
        res =. 0 ;< 0&".&.> onitemm (<a:;1 2) (<;._2~  e.&(CR,TAB));._2 data
      else.  NB. If no data, return empty table, length depending on command
        res =. 0 ;< 0 5 $ a:
      end.
    case. 'LSX' do. NB. Data is TABdelimed table, return as boxed table of name;date;size;codes;permissions;cksum
      NB. Convert date, size, cksum to numeric
      if. #data do.
        res =. 0 ;< 0&".&.> onitemm (<a:;1 2 5) (<;._2~  e.&(CR,TAB));._2 data
      else.  NB. If no data, return empty table, length depending on command
        res =. 0 ;< 0 6 $ a:
      end.
    case. 'GET' do. 
      NB. First, the file table, each file fn<TAB>length<CRLF>
      NB. Then a CRLF to end the table, then all the files following
      NB. Return table of name;data
      if. #data do.
        NB. Extract the header
        hdr =. (CRLF,CRLF) (] {.~  2 + i.&1@:E.) data
        NB. Turn it into a table
        htbl =. (<;._2~  e.&(CR,TAB));._2 hdr
        NB. Column 0 is the name.  Column 1 is the lengths.  Make the lengths numeric, and
        NB. turn them into substring values (start,length).  Skip over the header and the CRLF
        NB. following
        stend =. (,.~  (2+#hdr) + |.!.0@:(+/\)) 0&".@> 1 {"1 htbl
        NB. Fetch the strings, box them, and join them to the names.  This is the result
        res =. 0 ;< (0{"1 htbl) ,. (,."1 stend) <;.0 data
      else. NB. No data, return empty table
        res =. 0 ; 0 2$a:
      end.
    case. 'TS' do.
      res =. 0 ; data  NB. data will tell whether we got the file or not
    case. ;: 'RMDIR MKDIR RENAME RESTART' do.
      res =. 0 ; ''
    case. do. 13!:8 (3)    NB. Domain error on invalid command
    end.
  end.
end.
NB. res has the result.  If there is a callback, call it; otherwise return it
'cbx cb' =. 1 {:: x
if. #cb do.
  cbx cb~ res
  NILRET
else.
  res
end.
)

publishentrypoints 'fileservreq'