// log

"use strict"

var Dlog = [];
var DlogMax = 100;
var DlogPos = 0;

// ---------------------------------------------------------------------
function dlog_add(t) {
 t = t.trim();
 if (t.length===0) return;
 var p = Dlog.indexOf(t);
 if (p >= 0) Dlog.splice(p, 1);
 if (Dlog.length == DlogMax)
  Dlog.splice(0, 1);
 Dlog.push(t);
 DlogPos = Dlog.length;
}

// ---------------------------------------------------------------------
function dlog_scroll(m) {
 var n, p;
 n = Dlog.length;
 if (n == 0) return;
 p = Math.max(0, Math.min(n - 1, DlogPos + m));
 if (p == DlogPos) return;
 DlogPos = p;
 tcmprompt("   " + Dlog[p]);
}
// term

"use strict";

var tcm;
var cmdlist=[];

// ----------------------------------------------------------------------
function clearterm() {
 tcm.getDoc().setValue("");
 tcmprompt("   ");
 tcm.focus();
}

// ----------------------------------------------------------------------
function docmd(cmd, show) {
 cmd = cmd.trim();
 dlog_add(cmd);
 if (show) tcmappend(cmd + "\n");
 ws.send(cmd);
}

// ----------------------------------------------------------------------
function docmds(cmds, show) {
 cmdlist=cmds.map(function(e){return [e,show];});
 docmdnext();
}

// ----------------------------------------------------------------------
function docmdnext() {
 if (cmdlist.length === 0) return;
 var t = cmdlist.shift();
 if (t.length===0)
  tcmappend("\n   ");
 else
  docmd.apply(null,t);
}

// ----------------------------------------------------------------------
function initterm() {
 tcm=CodeMirror(getid("term"), {
  cursorScrollMargin: 18,
  electricChars: false,
  lineWrapping: false,
  readOnly:true,
  styleActiveLine: true
 });

 var keys = {};
 keys["Enter"]=tcmenter;
 keys["Shift-Ctrl-Down"] = tcmlogdown;
 keys["Shift-Ctrl-Up"] = tcmlogup;
 tcm.setOption("extraKeys", keys);
}

// ----------------------------------------------------------------------
function tcmappend(t) {
 tcm.setCursor(tcm.lineCount())
 tcm.replaceSelection(t, "end");
 tcm.focus();
}

// ----------------------------------------------------------------------
function tcmenter() {
 var n, t;
 n = tcm.getCursor().line
 t = tcm.getLine(n);
 if (n === tcm.lastLine()) {
  tcmappend("\n");
  docmd(t, false);
 } else
  tcmprompt(t);
}

// ----------------------------------------------------------------------
function tcmlogdown() {
 dlog_scroll(1);
}

// ----------------------------------------------------------------------
function tcmlogup() {
 dlog_scroll(-1);
}

// ---------------------------------------------------------------------
function tcmprompt(t) {
 var n, doc, len;
 var doc=tcm.getDoc();
 n = tcm.lineCount() - 1;
 len = tcm.getLine(n).length;
 doc.setSelection({line:n,ch:0},{line:n,ch:len})
 tcm.replaceSelection(t)
 tcm.setCursor(tcm.lineCount())
 tcm.scrollIntoView(n, 0)
}

// ---------------------------------------------------------------------
function tcmreturn(e) {
 if (e.length===0) return;
 var t=Number(e[0]);
 if (t !== 3)
  tcmappend(e.slice(1));
 if (t===0)
  docmdnext();
}
// main

"use strict";

var resizetimer, ws;

// ----------------------------------------------------------------------
function connect() {
 if ("WebSocket" in window) {
  ws = new WebSocket("ws://localhost:5023/");
  ws.onopen = function(e) {showstate(true);};
  ws.onclose = function(e) {showstate(false);};
  ws.onmessage = function(e) {tcmreturn(e.data);};
  ws.onerror = function(e) {console.log(e);};
  tcm.options.readOnly=false;
  tcm.focus();
 } else alert("WebSockets not supported on your browser.");
}

// ----------------------------------------------------------------------
function disconnect() {
 tcmprompt("");
 tcm.options.readOnly=true;
 ws.close();
}

// ----------------------------------------------------------------------
function example1() {
 var t=[
  ";/i.2 3 4","",
  "0 1 0 2 1 0 </. 10*i.6","",
  "(# ; ~. ; |. ; 2&# ; 3#,:) 'chatham'","",
  "load 'stats'","dstat normalrand 1000",""
  ];
 docmds(t,true);
}

// ----------------------------------------------------------------------
function example2() {
 var t=[
  "foo=: 3 : 0","t=. 1 + y","i. t",")","",
  "foo 3","",
  "foo 'a'","",
  "dbg 1       NB. set debug on",
  "foo 'a'","y=. 5","dbrun''","dbg 0","",
  "a=. 1!:1[1","hello","a"
  ];
 docmds(t,true);
}

// ----------------------------------------------------------------------
function getid(e) {
 return document.getElementById(e);
}

// ----------------------------------------------------------------------
function interrupt() {
 tcmprompt("");
 ws.send("interrupt_jws_ 0");
 alert("This interrupts the J websocket server.\n" +
  "You can examine the server state in the J session.\n\n" +
  "To restart, in the J session enter:  restart''\n");
}

// ----------------------------------------------------------------------
function showstate(e) {
 getid("bon").disabled=e;
 var t=["boff","bint","bexample1","bexample2","bclearterm","term"];
 t.map(function f(x){getid(x).disabled=!e});
}

// ---------------------------------------------------------------------
// for debugging
function stringcodes(s) {
 var r = "";
 for (var i = 0; i < s.length; i++)
  r += " " + s.charCodeAt(i);
 return r.substring(1);
}

// ----------------------------------------------------------------------
function resizer() {
 var b=getid("top").getBoundingClientRect().bottom;
 var w=window.innerWidth-30;
 var h=window.innerHeight-b-30;;
 var t=getid("term");
 t.style.width=w + "px";
 t.style.height=h + "px";
 tcm.setSize(w,h);
}

// ----------------------------------------------------------------------
window.onresize = function() {
 clearTimeout(resizetimer);
 resizetimer = setTimeout(resizer, 150);
}

// ----------------------------------------------------------------------
window.onload = function() {
 showstate(false);
 initterm();
 resizer();
}
