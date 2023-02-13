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
