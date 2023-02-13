NB. Directory mirroring
NB. We check a remote directory and make sure that the local
NB. directory matches it.  The remote directory may be on a server.
require 'sockets/socklib/sockconnxactn'
require 'strings'
coclass 'dirmirror'

MINXFERRATEUP =: 1 % 10000  NB. secs/byte min to allow for a timeout.  Measured empirically from RCHS server
MINXFERRATEDOWN =: 1 % 25000  NB. secs/byte min to allow for a timeout.  Measured empirically from RCHS server

NB. parse remote name
NB. if the name is a remote dir, we return <domain\dirname\
NB. if the name is not remote, we return empty string
NB. y has been through fmtdirname
parseremote =: 3 : 0@:>
if. y (] -: ({.~ #))'fileserv:' do.
  NB. remote, which must be domain[:port]\dir\
  NB. drop leading slashes and return as domain\dir
  < (}.~ '\'&(i.&0@:=)) (#'fileserv:') }. y
else.
  NB. not remote, just return empty
  ''
end.
)

destroy =: 3 : 0
codestroy''
)

NB. Mirror directory
NB. y is password;(remote dir);(local dir);< (list of filespecs);(erase missing files bool,writetoremote bool,lenonly bool[,timeout[,debug]]);callback x;callback...
NB. default for filespecs is '*.*'
NB. default for flags/callback is 0 0 0;'';''
NB. filenameonly means that we copy a file only if its length changes; we ignore the data
NB. If callback is given, we drive the callback when finished
NB. (and process remote ops asynchronously)
NB. The remote dir may be fileserv:\\, in which case we use
NB. the file server to process it
NB. The final result, which is either passed to the callback or returned
NB. synchronously, is 0 if the operation was successful, nonzero on failure, and the list of files written (full filenames)
NB. If async, the call to mirror returns empty
create =: 3 : 0
continue =: 1   NB. default to finish operation
'password rem loc filespecs' =: 4 {. y
'erase cbx cb' =: defx =. (4 }. y) default 0;'';''
'erase writeremote lenonly timeout debugmode' =: erase default 0 0 0 10 0
debugfileserv =: 0 >. <: debugmode  NB. debugmode 2 = file server too
if. timeout = 0 do. timeout =: 10 end.  NB. timeout of 0 means use default 
rem =: fmtdirname rem
loc =: fmtdirname loc
if. 0 = #filespecs do. filespecs =: '*.*' end.
filespecs =: boxopen filespecs  NB. in case just one type, be forgiving
NB. Step 1 - get list of files
NB. if the remote is on a fileserver, use server
if. debugmode do. smoutput  'dirmirror started at ' , , 'q</>r<0>5.0,q</>r<0>3.0,q< >r<0>3.0,q<:>r<0>3.0,q<:>r<0>3.0,r<0>6.3' 8!:2 tod NIL end.
if. #rloc =: parseremote rem do.
  NB. Use async request only if the call to us is async
  NB. If we are ignoring the checksums, don't ask for them
if. debugmode do. smoutput 'fileserv';(lenonly{'LSX';'LS'),password;rloc,<filespecs end.
  rc =. ('';((*#cb) # inthislocale 'lsxcb');timeout;debugfileserv) fileservreq (lenonly{'LSX';'LS'),password;rloc,<filespecs
else.
NB. if not on server, get list of remote files
  rc =. 0 ;< 1!:0"0 endtoend rem ,&.> filespecs 
end.
NB. Now, if the operation ended synchronously (either with no callback
NB. or because it was not on a server), continue processing in the first callback
if. #rc do.
  '' lsxcb rc
else.
  ''
end.
)

NB. abort the operation.  This is used when a file is modified while an async mirror is
NB. in progress; we must abort the sync to make sure a deleted file is not rewritten eg
abort =: 3 : 0
if. debugmode do. smoutput 'abort command received' end.
continue =: 0
)


NB. Step 2 - process erase (if any) and read the data for any files we need
NB. This passes control to the next callback, even on error, so the final end of
NB. the operation never happens here
NB. x is (original x);(original y)
NB.   i. e. ((erase missing files bool);callback x;callback) ; ((remote filespec);(local dir);password)
NB. y is rc ; table of name;date;size;permissions;dirflgs[;checksum]
NB.   the checksum is present only if it is a remote file
lsxcb =: 4 : 0
'rc rfiles' =: res =. y   NB. save rc; this will be the return if error
if. debugmode do. smoutput 'lsxcb';<y end.
if. continue *. 0 = rc do.
  NB. If there is no error, process the file list that was received

  NB. Remove directories from the list of files in the remote
  rfiles =: -.@finfoisdir usedtocull ifany rfiles
  
  NB. Get the list of files in the local directory that match the spec
  locfiles =: 1!:0"0 endtoend  loc ,&.> filespecs
  if. debugmode do. smoutput 'locfiles';<locfiles end.
  NB. If there are matched local directories, remove those names from both the local
  NB. and remote lists
  if. #ldir =. 0 {"1 finfoisdir usedtocull locfiles do.
    locfiles =: ldir delkl locfiles
    rfiles =: ldir delkl rfiles
  end.

  NB.if 'erase' was specified, erase any nondirectory target files that
  NB. were not on the source
  if. erase do.
    if. writeremote do.
      if. #erafiles =. (0 {"1 locfiles) delkl rfiles do.
        if. #rloc do.
          NB. If target is on server, send the erase command
          res =. ('';((*#cb) # inthislocale 'eracb');timeout) fileservreq 'RM';password;rloc,< 0 {"1 erafiles
        else.
          NB. If target is not on server, erase straightway
          1!:55 rem ,&.> 0 {"1 erafiles
        end.
      end.
    else.
      NB. Get list of matching files on the local directory; remove directories; remove files in remote
      erafiles =. (0 {"1 rfiles) delkl locfiles
if. debugmode do. smoutput 'erafiles';<erafiles end.
      NB. Erase local files not present on remote
      1!:55 ifany loc ,&.> 0 {"1 erafiles
    end.
  end.
else. locfiles =: 0 6$a:   NB. In case of error, define this value
end.
NB. If this is async remote read, we will have no result and will await a callback.
NB. Otherwise drive the callback
if. #res do.
  '' eracb res
else.
  ''
end.
NB.?lintsaveglobals
)

NB. Step 3 - transfer the data for the files that must be written
NB. This passes control to the next callback, even on error, so the final end of
NB. the operation never happens here
NB. x is (original x);(original y);remote fileinfo
NB.   i. e. ((erase missing files bool,wremote bool);callback x;callback) ; ((remote filespec);(local dir);password)
NB. y is rc ; table of name;date;size;permissions;dirflgs;checksum
NB.   the checksum is present only if it is a remote file and we are not using filenames only
eracb =: 4 : 0
if. debugmode do. smoutput 'eracb';y end.
if. continue *. 0 = 0 {:: res =. y do. NB. save rc; this will be the return if error
  NB. If we are writing to the remote, transfer any files with changed checksums
  if. writeremote do.
    if. #rloc do.
      NB. The remote is on a server.  Find the files with changed checksums (if any) and send them.
      locfiles =: ((] ,. ((, <@fileserv_checksum_sockfileserver_@(1!:1))~^:(-.lenonly)  <@(1!:4))"0@(loc&(,&.>))) (0 {"1 locfiles))
      locfiles =: locfiles -. ((}:^:lenonly 0 2 5){"1 rfiles)
      if. #locfiles do.
        NB. There are new files to write.  Up the timeout to accommodate the minimum transfer rate
        to =. timeout >. MINXFERRATEUP * +/ 1 ocol locfiles
        res =. (x;((*#cb) # inthislocale 'getcb');to) fileservreq 'PUT';password;rloc,< (] ,. <@(1!:1)@(loc&(,&.>))) 0 {"1 locfiles
      else.
        res =. 0 ; ''   NB. if no files to write, skip to the callback
      end.
    else.
      NB. The remote is not on a server.  Just copy the files
      ((1!:1)@(loc&(,&.>)) 1!:2 rem&(,&.>))"0  (0) {"1 locfiles
      NB. Give result that will suppress any further copying
      res =. 0 ; ''
    end.
  else.
    NB. If we are reading from the remote, transfer any files with changed checksums
    NB. From now on we are interested only in local files that are on the remote
    locfiles =: (0 {"1 rfiles) keepkl locfiles
    NB. if remote is on fileserver, the list of files will contain checksums.
    NB. Remove any files for which the length and checksum match the remote
    if. #rloc do.
      rfiles =: (}:^:lenonly 0 2 5){"1 rfiles  NB. Strip to name;len;checksum
      NB. Read local files and convert to length[;checksum]
      if. #locfiles do.
        rfiles =: rfiles -. (] ,. ((, <@fileserv_checksum_sockfileserver_@(1!:1))~^:(-.lenonly)  <@(1!:4))"0@(loc&(,&.>))) (0 {"1 locfiles)
      end.
    else.
      rfiles =: 0 2{"1 rfiles
      NB. If remote is not on a server, we still don't want to copy files with unchanged length, if we
      NB. are doing length-only comparison.
      if. lenonly *. *#locfiles do.
        rfiles =: rfiles -. (0 2{"1 locfiles)
      end.
    end.
    NB. Now rfiles is name;length[;checksum]

    NB. If there are no files left to fetch, indicate good return
    if. 0 = #rfiles do.
      res =. 0 ;< 0 2$a:  NB. Good return, no files
    else.
      NB. There are files to read.  If the remote is on a server, read through the server
      if. #rloc do.
        to =. timeout >. MINXFERRATEDOWN * +/ 1 ocol rfiles
if. debugmode do. smoutput 'fileserv';'GET';password;rloc,< 0 {"1 rfiles end.
        res =. ('';((*#cb) # inthislocale 'getcb');to;debugfileserv) fileservreq 'GET';password;rloc,< 0 {"1 rfiles
      else.
        NB. If not using a server, just read all the file data and pass it on
        res =. 0 ;< rem (] ,. <@(1!:1)@(,&.>)) 0 {"1 rfiles
      end.
    end.
  end.
end.
NB. If this is async remote read, we will have no result and will await a callback.
NB. Otherwise drive the callback
if. #res do.
  '' getcb res
else.
  ''
end.
)

NB. Step 4 - write the new files
NB. y is rc ; table of file info including file data
NB. We write out the files
getcb =: 4 : 0
if. debugmode do. smoutput 'getcb';y end.
'rc rfiles' =: ret =. y   NB. save rc; this will be the return if error
if. continue *. 0 = rc do.
  NB. If we are writing to the remote, we never have anything to do here
  if. -. writeremote do.
    NB. Write out the file data to the local directory
    if. #rfiles do.
      (1!:2 <@((>loc)&,))&>~/"1 rfiles
      ret =. 0 ;< loc ,&.> 0{"1 rfiles
    else.
      ret =. 0 ;< 0$a:
    end.
  else.
    ret =. 0 ;< loc ,&.> 0{"1 locfiles
  end.
end.
NB. We finally have it all done.  Drive the user's callback, if any, with the return data
if. #cb do.
  cbx cb~ ret
  destroy''
  ''
else.
  destroy''
  ret
end.
NB. Result is data, if synchronous, empty if not
)
