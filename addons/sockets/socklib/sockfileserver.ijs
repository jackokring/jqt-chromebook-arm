NB. File server
NB. Created when we get a connection on our listening socket
NB. This class does not return an object - the object runs itself &
NB. destroys itself when transaction is complete

NB. This class also includes the utilities to create file-server requests
NB. and responses, and decode same

require 'sockets/socklib/sockconnxactn'
require 'strings'
coclass 'sockfileserver'
coinsert 'sockmux'
SERVERTO =: 5  NB. timeout in seconds
PASSWORDFN =: <'Passwords.txt'
LOGFILE =: <'Logfile.txt'
HIDDENFILES =: PASSWORDFN,LOGFILE  NB. Files we will not alter or disclose without execute privilege

NB. Create socket. x is the socket that has been created for this connection
NB. y is root of file system that is visible to this server
NB. Return 0 if successful
create =: 4 : 0
convstate =: 0  NB. 0=waiting for hdr 1=waiting for data 2=sending
recvdata =: senddata =: ''  NB. Init nothing received and no data to send in reply
filesystemroot =: fmtdirname {. y  NB. Root of the file system.  Set before first logadd
commactive =: 1   NB. Set socket active
NB.?lintonly 'sock errto recvdata' =: 0;0;''
if. 0 ~: r =. x create_sockmux_ f. SERVERTO + todsts NIL do.
  destroy 'create failed'  NB. Couldn't create socket object, abort
  r return.
else.
  logadd 'created for ' , (2 {:: sdgetpeername_jsocket_ sock) , ' at ' , , 'q</>r<0>5.0,q</>r<0>3.0,q< >r<0>3.0,q<:>r<0>3.0,q<:>r<0>3.0,r<0>6.3' 8!:2 tod NIL
end.
NB. Wait for data to move
0
)

destroy =: 3 : 0
logadd ifany y
destroy_sockmux_ f. ''
)

errhand =: 3 : 0
destroy 'Error ' , (":y) , ' during connection handshake'
)

NB. Check timeout.  Current time is in y.  If time has expired, signal ETIMEDOUT
NB. We just listen forever, no timeout
checkto =: 3 : 0
NB. If we have had socket activity, extend the timeout period
if. commactive do.
  errto =: SERVERTO + y
  commactive =: 0
end.
NB. After a period of inactivity, pull the plug
if. y > errto do.
  'rc d' =. sdrecv_jsocket_ sock,128 0
  destroy 'timed out' , ' at ' , , ('q</>r<0>5.0,q</>r<0>3.0,q< >r<0>3.0,q<:>r<0>3.0,q<:>r<0>3.0,r<0>6.3' 8!:2 tod NIL) , 'convstate=' , (":convstate) , ' recvdata=' , recvdata , 'final rd rc=' , (":rc) , ' final rd data=' , d
end.
''
)

NB. y is data line.  Add it to the execution log
logadd =: 3 : 0
((>coname''),': ',y,CRLF) 1!:3 filesystemroot ,&.> LOGFILE
NILRET
)

NB. send handler.  Called when our socket is allowed to send.  Send the data
NB. that we have calculated.
NB. Result is _1 0 1 to indicate (error-socket closed with callback)/(send finished)/(more to send)
send =: 3 : 0
if. #senddata do.
  'r l' =. senddata sdsend_jsocket_ sock,0
  if. r do.
    destroy 'send error'
    _1 return.
  else.
    commactive =: 1
    senddata =: l }. senddata
    NB. If we have finished sending our reply, we're done
    if. (convstate = 2) *. (0 = #senddata) do.
      NB. Normal completion - close the connection
      destroy 'finished'
      _1 return.   NB. Make sure this connection is off the readable list
    end.
  end.
end.
*#senddata
)

NB. recv handler.  Called when there is data for our socket.  We read the data and
NB. then inspect it depending on our transfer state
NB. State 0 - waiting for header
NB. State 1 - waiting for body
NB. State 2 - sending reply
recv =: 3 : 0
NB. Read the data
'r d' =. sdrecv_jsocket_ sock,30000 0
NB. The client should not be the first to close; but if it is, we should
NB. stop processing the socket.  We may be in the middle of sending something
NB.?lintonly 'rc msglen password compression' =: 0;10;'';0
if. 0 = #d do. destroy 'client closed connection'
else.
  commactive =: 1
  NB. Append to our inbound data buffer
  recvdata =: recvdata , d
  NB. Validate the request, depending on the receive state.  We read until
  NB. we get end-of-header; then until conn closes
  if. convstate = 0 do.
    NB. If we have the full header, examine it & move on to nextstate
    if. (#recvdata) > hlen =. (CRLF,CRLF) (#@[ + i.&1@:E.) recvdata do.
      'rc msglen password compression' =: fileserv_decreqhdr hlen {. recvdata
      if. rc ~: 0 do.
        destroy 'invalid hdr (rc=' , (": rc) , ') Data=(' , (hlen {. recvdata) , ')'
      else.
        NB. Discard header, advance to next state
        recvdata =: hlen }. recvdata
        convstate =: 1
      end.
    elseif. 100000 < #recvdata do.  NB. Long header must be spam
      destroy 'hdr too long, connection closed'
    end.
  end.
  NB. If we are waiting for end-of-data, advance if we get it
  if. convstate = 1 do.
    if. msglen <: #recvdata do.
      NB. The entire request has been received.  Process it.  The result
      NB. of processing is the return code and the return data
      NB. Get command
      cmdline =. CRLF dropafter recvdata
      logadd _2 }. cmdline   NB. Log the command
      cmdword =. toupper ' ' taketo cmdline
      if. (<cmdword) -.@e. cmdlist do.
        logadd 'Invalid command'
        'rc respdata' =. 500;'Invalid command ', cmdline
      else.
      NB. If command is valid, call the command processor
        try.
          NB. If we have #recvdata > msglen, and no CRLF found (i. e. ill-formed msg)
          NB. we could have negative len and startpos after the end; turn that into
          NB. 0-leb request
          rembody =. (0 >. -~/\ (#cmdline),msglen) substr recvdata
          'rc respdata' =. ('cmdproc_',cmdword)~ cmdline;rembody
          logadd 'Return code: ' , ":rc
        catch.
          'rc respdata' =. 520;'Command crashed: ',cd =. 13!:12''
          logadd 'Crash: ',cd
        end.
      end.
      NB. Send the reply called for
      senddata =: rc fileserv_addrsphdr respdata
      convstate =: 2  NB. Go into reply state before we request send
      reqwrite''
    end.
  end.
end.
NB.?lintsaveglobals
''
)

NB. Command processors

NB. y is command line, ending with CRLF
NB. first word is command, others are quote-delimited operands
NB. return boxed list of operands, with quotes removed
parsecmd =: 3 : 0
NB. If it doesn't end with CRLF, it's an error
if. CRLF -.@-: _2 {. y do.
  0$a:
else.
  cmdwd =. ' ' taketo y
  ops =. ' ' takeafter y
  NB. return the command, and every other quoted string
  cmdwd ; _2 {.\ '"' (= <;._1 ]) ' ' takeafter y
end.
)

DEFAULTPWS =: ; ,&LF&.> 'Read:';'Write:';'Execute:'
NB. y is name of dir; password.  filesystemroot is assumed
NB. Result is highest level allowed (0=r, 1=w, 2=x)
checkpassword =: 3 : 0
'dir pw' =. y
dir =. fmtdirname dir  NB. clean and boxed, and ending with \
NB. Loop through the password files.  A password entry can be omitted, which matches nothing;
NB. or empty, which means inherit from the previous level.
NB. We stop looking when there is no inheritance
inheritkeys =. ;: 'Read Write Execute'
keyslist =. 0 2$a:
NB. Init authorized for nothing
authlevel =. _1
NB. Loop till we have examined all directories or there is no inheritance.
whilst. #inheritkeys do.
  NB. Read the password file
  pwfile =. 1!:1 :: (DEFAULTPWS"_) filesystemroot ,&.> dir ,&.> PASSWORDFN
  NB. Extract the keyword;value pairs
  pwkeys =. (':' (taketo ; takeafter) (CRLF,' ') -.~ ]);._2 pwfile , LF
  NB. Keep the keys that we are looking for (not the inheritance lines)
  keyslist =. keyslist , inheritkeys keepkl (<'') 1 delkl_colsu pwkeys
NB. obsolete   NB. If read/write keys omitted, increase auth level accordingly
NB. obsolete   authlevel =. authlevel >. <: 0 i:~ 0 , (;: 'Read Write') e. keyskl pwkeys
  NB. Keep any inheritance strings that have empty records here
  inheritkeys =. inheritkeys setintersect (<'') 1 allgetkl_colsuv 0 pwkeys
  NB. Look at the next directory up in the hierarchy.  If we are at the top now, quit looking
  if. 0=#>dir do. break. end.
  dir =. (}.~ i.&'\')&.|.@}:&.> dir
end.
NB. Find lines that match the given pw; take priority; return highest
authlevel >. >./ (;: 'Read Write Execute') i. (<pw) 1 allgetkl_colsuv 0 keyslist
)

NB. The list of valid commands
cmdlist =: ;: 'GET PUT APPEND TS LS LSX RM MKDIR RMDIR EXE RENAME RESTART'
DIRCHARS =: ''',_-\ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 '
FNCHARS =: DIRCHARS , '.'
WILDCHARS =: FNCHARS,'?*'

NB. GET "directory" "filename"... CRLF
NB. filename may include wildcard at the lowest level
NB. read permission is required
NB. Returned data is sequence of fn<TAB>length<CRLF>data
cmdproc_GETLS =: 4 : 0
ls =. x
'cmd data' =. y
NB. parse & audit command line
if. 3 > # pcmd =. parsecmd cmd do.
  510;'Parameter error'
NB. Verify directory exists
elseif.
NB. cmd, directory, list of filenames
'cmd dir' =. 2 {. pcmd
fn =. 2 }. pcmd
# DIRCHARS -.~ dir =. }: > fmtdirname '/\' xlatechars dir do.
  511;'Invalid directory'
elseif. 1 ~: #dirlist =. 1!:0 dirfn =. }: > fmtdirname ,&dir &.> filesystemroot do.
  512;'Directory not found'
elseif. -. finfoisdir dirlist do.
  513;'Not directory'
elseif.
fullfn =. (dirfn , '\')&,&.> fn =. '/\'&xlatechars&.> fn
# FNCHARS -.~ ; dirnameonly@((dir,'\')&,)&.> fn do.
  514;'Invalid filename: ' , ;:^:_1 ((dir,'\')&,)&.> fn
elseif. # WILDCHARS -.~ ; fn do.
  515;'Invalid filename:' , ; fn
elseif. 0 > authlevel =. checkpassword dir;password do.
  516;'Invalid credentials'
elseif. -. *./ (= {.) dirnameonly&.> fullfn do.
  517;'Heterogeneous files'
NB. All audits OK, read the files and return them
elseif. 0 = #flist =. 1!:0"0 endtoend fullfn do.
  203;''  NB. no files
elseif. 
NB. If we don't have execute privilege, remove password files
0 = #flist =. HIDDENFILES (-.@e.~&:(toupper&.>) 0&{"1) usedtocull^:(authlevel<2) flist do.
  201;''  NB. no files; return empty
NB. Also remove directories if we don't have execute privilege, or if this is not LS
elseif. 0 = #flist =. (-.@finfoisdir) usedtocull^:((ls~:1) +. authlevel<2) flist do.
  202;''  NB. no files; return empty
elseif. do.
  flist =. /:~ flist   NB. return files in sorted order
  select. ls
  case. 0 do.
    NB. GET - return data
    totalfn =. (dirnameonly > {. fullfn)&,&.> localfn =. 0 {"1 flist
    NB. First, the file table, each file fn<TAB>length<CRLF>
    NB. Then a CRLF to end the table, then all the files following
    200 ; (;@:(localfn&((,   TAB , CRLF ,~ ":@#)&.>)) , CRLF , ;) <@(1!:1) totalfn
  case. 1 do.
    NB. LS - return directory info
    NB. Each file is fn<TAB>date<TAB>size<TAB>permissions<TAB>flags<CRLF>
    200 ; CRLF tabfmt flist
  case. 2 do.
    NB. LSX - return directory info with checksum
    NB. Each file is fn<TAB>date<TAB>size<TAB>permissions<TAB>flags<TAB>checksum<CRLF>
    totalfn =. (dirnameonly > {. fullfn)&,&.> localfn =. 0 {"1 flist
    200 ; CRLF tabfmt flist ,. <@":@fileserv_checksum@(1!:1) totalfn
  end.
end.
)
cmdproc_GET =: 0&cmdproc_GETLS
cmdproc_LS =: 1&cmdproc_GETLS
cmdproc_LSX =: 2&cmdproc_GETLS

NB. PUT "directory" "filename" ["len" "filename" "len"...] CRLF filedata
NB. APPEND "directory" "filename" ["len" "filename" "len"...] CRLF filedata
NB. RM "directory" "filename" ["filename"...] CRLF
NB. TS "directory" "filename" CRLF filedata
NB. filename may not include wildcard
NB. write permission is required
NB. x encodes RM/TS/PUT/APPEND
cmdproc_PUTRM =: 4 : 0
rm =. x
'cmd data' =. y
NB. parse & audit command line
if. 3 > # pcmd =. parsecmd cmd do.
  510;'Parameter error'
NB. Verify directory exists
elseif. 
'cmd dir' =. 2 {. pcmd
fnl =. 2 }. pcmd
# DIRCHARS -.~ dir =. }: > fmtdirname '/\' xlatechars dir do.
  511;'Invalid directory'
elseif. 1 ~: #dirlist =. 1!:0 dirfn =. }: > fmtdirname ,&dir &.> filesystemroot do.
  512;'Directory not found'
elseif. -. finfoisdir dirlist do.
  513;'Not directory'
elseif.
NB. For PUT/APPEND/TS (i. e. anything with data) split the data into pieces and remove the length fields, and box
if. rm > 0 do.   NB. not RM
  if. 2 < #fnl do.   NB. Multiple files
    NB. Get fn, lengths
    'fnl len' =. <"1 |: _2 ]\ fnl
    data =. data <@substr~ (,.~ +/\@(|.!.0)) {.@(0&".)@> len
  else.   NB. Single file
    fnl =. 1 {. fnl  NB. If length given, ignore it, write all data
    data =. ,<data  NB. Match shape of fnl otherwise
  end.
end.
NB. Now fnl is filename(s), data is data (boxed)
fullfn =. (dirfn , '\')&,&.> fnl =. '/\'&xlatechars&.> fnl
# FNCHARS -.~ ; fnl do.
  515;'Invalid filename: ' , ;:^:_1 fnl
elseif. 1 > authlevel =. checkpassword dir;password do.
  516;'Invalid credentials'
elseif. 
NB. Verify that the file, if it exists, is not a directory
NB. J6.02 bug
t =. #flist =. 1!:0@> endtoend fullfn  NB. set result to 'file exists'
if. #flist do. t =. +./ finfoisdir flist end.
t do.  NB. and if 'directory' 
  517;'Is directory'
elseif. 
NB. If we don't have execute privilege, don't allow password file
(authlevel < 2) *. +./ HIDDENFILES e.~&:(toupper&.>) filenameonly&.> fullfn do.
  518;'Protected'
elseif. do.
  select. rm
  case. 0 do.   NB. RM
    NB. RM - erase the file(s).  OK if is doesn't exist.
    1!:55 :: 0:"0 fullfn
    200;''
  case. 1 do.
    NB. TS - write the file only if nonexistent, error if multiple files
    if. 1 < #fnl do.
      519 ; 'Multiple filespecs'
    elseif. 0 ~: #flist do.
      NB. TS for file that exists: return success with the file data, with leading '*'
      200 ; '*' , 1!:1 {. fullfn
    elseif. do.
      NB. TS for nonexistent file, write the data
      data (>@[ 1!:2 ])"0 fullfn  NB. Write the file
      200;''  NB. success
    end.
  case. do.   NB. PUT/APPEND
    data (>@[ 1!:rm ])"0 fullfn  NB. Write/append the file
    200;''  NB. success
  end.
end.
)
cmdproc_RM =: 0&cmdproc_PUTRM
cmdproc_TS =: 1&cmdproc_PUTRM
cmdproc_PUT =: 2&cmdproc_PUTRM
cmdproc_APPEND =: 3&cmdproc_PUTRM

NB. RENAME "directory" "fnfrom" "fnto" CRLF
NB. no wildcards allowed
NB. write permission is required
NB. nothing returned
cmdproc_RENAME =: 3 : 0
'cmd data' =. y
NB. parse & audit command line
if. 4 ~: # pcmd =. parsecmd cmd do.
  510;'Parameter error'
NB. Verify directory exists
elseif.
NB. cmd, directory, fns
'cmd dir' =. 2 {. pcmd
fn =. 2 3 { pcmd
# DIRCHARS -.~ dir =. }: > fmtdirname '/\' xlatechars dir do.
  511;'Invalid directory'
elseif. 1 ~: #dirlist =. 1!:0 dirfn =. }: > fmtdirname ,&dir &.> filesystemroot do.
  512;'Directory not found'
elseif. -. finfoisdir dirlist do.
  513;'Not directory'
elseif.
fullfn =. ((>dirfn) , '\')&,&.> fn =. '/\'&xlatechars&.> fn
# FNCHARS -.~ ; dirnameonly@((dir,'\')&,)&.> fn do.
  514;'Invalid filename:' , ; ((dir,'\')&,)&.> fn
elseif. # FNCHARS -.~ ; fn do.
  515;'Invalid filename:' , ; fn
elseif. 1 > authlevel =. checkpassword dir;password do.
  516;'Invalid credentials'
elseif. -. *./ (= {.) dirnameonly&.> fullfn do.
  517;'Heterogeneous files'
elseif. (1 , -:&toupper&>/ fullfn) -.@-: *@#@> dirf =. 1!:0&.> fullfn do.
  518;'Existence error'
elseif. +./ finfoisdir ; dirf do.
  519;'Is directory'
elseif. (authlevel<2) *. +./ HIDDENFILES (e.~&:(toupper&.>) 0&{"1) ; dirf do.
  520;'Protected file'
elseif. do.
  NB. All audits OK, do the rename
  renamefile~/ fullfn  NB. y (from) to x (to)
  200;''
end.
)

NB. MKDIR "directory"
NB. We create the directory as long as it doesn't exist
NB. Requires execute privilege
cmdproc_MKDIR =: 3 : 0
'cmd data' =. y
NB. parse & audit command line
if. 2 ~: # pcmd =. parsecmd cmd do.
  510;'Parameter error'
elseif. 
NB. Verify directory does not exist
'cmd dir' =. 2 {. pcmd
# DIRCHARS -.~ dir =. }: > fmtdirname '/\' xlatechars dir do.
  511;'Invalid directory'
elseif. 0 ~: #dirlist =. 1!:0 dirfn =. }: > fmtdirname ,&dir &.> filesystemroot do.
  512;'Exists'
elseif. 2 > authlevel =. checkpassword dir;password do.
  516;'Invalid credentials'
elseif. do.
  1!:5 <dirfn
  200;''
end.
)

NB. RMDIR "directory"
NB. We delete the directory, recursively.
NB. Requires execute privilege
cmdproc_RMDIR =: 3 : 0
'cmd data' =. y
NB. parse & audit command line
if. 2 ~: # pcmd =. parsecmd cmd do.
  510;'Parameter error'
elseif. 
NB. Verify directory exists
'cmd dir' =. 2 {. pcmd
# DIRCHARS -.~ dir =. }: > fmtdirname '/\' xlatechars dir do.
  511;'Invalid directory'
elseif. 1 ~: #dirlist =. 1!:0 dirfn =. }: > fmtdirname ,&dir &.> filesystemroot do.
  200;'Does not exist'
elseif. dirfn <:&# > filesystemroot do.
  512;'Is root'
elseif. 2 > authlevel =. checkpassword dir;password do.
  516;'Invalid credentials'
elseif. do.
  rmdashr <dirfn
  200;''
end.
)

NB. Recursive delete.  We recur on subdirectories, then delete all files, then
NB. delete this directory
rmdashr =: 3 : 0"0
files =. 1!:0 '\*' ,~ dir =. > y
rmdashr ifany (dir,'\')&,&.> 0 {"1 finfoisdir usedtocull files
1!:55 dir&,&.> a: ,~ '\'&,&.> 0 {"1 -.@:finfoisdir usedtocull files
NILRET
)

NB. RESTART
NB. We reload the app from the name we found it in, in the root directory
NB. Requires execute privilege in the root directory
NB. This does not rerun the startup verbs - it just reloads the executing code.
cmdproc_RESTART =: 3 : 0
'cmd data' =. y
NB. parse & audit command line
if. 2 > authlevel =. checkpassword '';password do.
  516;'Invalid credentials'
elseif. do.
  NB.?lintmsgsoff
  0!:0 ,&APPFILENAME_base_&.> filesystemroot
  NB.?lintmsgson
  200;''
end.
)

NB. Verbs to create and use the transfer format
NB. These verbs create a message or parse a message

NB. Add request header to a message
NB. y is message body
NB. x is parms:
NB. password;compression
NB. Result is header followed by message.  We always add a Content-Length field.
fileserv_addreqhdr =: 4 : 0
'pw comp' =. x default '';0
NB. Start with an HTTP request-type
h =. 'GET /index.html/ HTTP/1.1' , CRLF
NB. Continue with an HTTP header
h =. h , 'Content-Length: ' , (":#y) , CRLF
NB. Always send Password - it's our unique field
NB. obsolete if. #pw do.
h =. h , 'X-QBPassword: ' , pw , CRLF
NB. Append other things to pacify gateways
h =. h , 'Cache-Control: no-cache' , CRLF
h =. h , 'Content-Encoding: quizbowl' , CRLF
h =. h , 'Host: www.quizbowlmanager.com' , CRLF
NB. obsolete end.
NB. Our actual request data follows thhe double CRLF
h,CRLF,y
)

NB. Analyze request header
NB. y is header (ends with CRLFCRLF)
NB. Result is rc;length;password;compression
NB. rc is 0 if ok
fileserv_decreqhdr =: 3 : 0
NB. Assume good return
rc =. 0
NB. Split on LF; remove CRLF
lines =. (<'') -.~ <@(-.&CRLF);._2 y , LF
NB. Split each line into name;value
namval =. (({.~ ; (}.~ 2&+)) ': '&(i.&1@:E.))@> lines
NB. get password if any.  If none, reject the command
if. #pwfields =. (<'X-QBPassword') keepkl namval do.
  pw =. (<'X-QBPassword') '' getklu_defu_colsv (0;1) pwfields
else.
  'pw rc' =. '';1
end.
NB. No compression for now
comp =. 0
NB. Get length (required)
if. 0 = len =. {. 0 ". (<'Content-Length') '' getklu_defu_colsv (0;1) namval do.
  rc =. 1
end.
NB. To avoid spam, reject any message that uses headers we don't support
NB. No - we can't - proxies may insert header fields
NB. obsolete if. # (keyskl namval) -. ('Content-Length';'Password';'Compression') do.
NB. obsolete   rc =. 2
NB. obsolete end.
rc;len;pw;comp
)

NB. Add response header to a message
NB. x is retcode
NB. y is message body
NB. Result is nnn HTTP CRLF;hdr incl length;body
fileserv_addrsphdr =: 4 : 0
NB. The reason-phrase depends on the return value.  If the return-value is OK (200-205), use 'OK';
NB. otherwise use y
if. >/ x >: 200 206 do. rp =. ' OK'
else. rp =. ' ' , ({.~ CRLF&(i.&1@:E.)) y
end.
h =. 'Content-Length: ' , (":#y) , CRLF
'HTTP/1.1 ' , (":x) , rp , CRLF , h , CRLF , y
)

NB. Analyze response
NB. y is data read
NB. result is rc;data
NB. We check for length
fileserv_decrsphdr =: 3 : 0
NB. Strip header
msghdr =. ( {.~ (CRLF,CRLF)&(#@[ + (i.&1@:E.)) ) y
NB. Get rc line from header
msgrc =. 2 {. <;._1 ' ' , ({.~ CRLF&(i.&1@:E.)) msghdr
if. msgrc -.@e. (<'HTTP/1.1'),.('200';'201';'202';'203';'204';'205') do.
  NB. If not valid response, return error
  (({.!.999) 999 ". 1 {:: msgrc);y 
elseif.
  NB. Get the Content-Length from the header
  NB. Split on LF; remove CRLF
  lines =. <@(-.&CRLF);._2 msghdr
  NB. Split each line into name;value
  namval =. (({.~ ; (}.~ >:)) ': '&(i.&1@:E.))@> lines
  len =. {. 0 ". pw =. (<'Content-Length') '' getklu_defu_colsv (0;1) namval
  len ~: y -&# msghdr do.
  998 ; ''
elseif. do.
  0 ; (#msghdr) }. y
end.
)

NB. Calculate checksum for a file.
NB. y is string, result is checksum (numeric)
fileserv_checksum =: 3 : 0"1
128!:3 y
)
