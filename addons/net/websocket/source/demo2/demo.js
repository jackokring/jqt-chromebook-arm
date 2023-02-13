// demo

"use strict";

var resizetimer, returner, ws;

// ----------------------------------------------------------------------
function connect() {
 if ("WebSocket" in window) {
  ws = new WebSocket("ws://localhost:5022/");
  ws.onopen = function(e) {showstate(true);};
  ws.onclose = function(e) {showstate(false);writetab("")};
  ws.onmessage = function(e) {onmessage(e.data);};
  ws.onerror = alert;
 } else alert("WebSockets not supported on your browser.");
}

// ----------------------------------------------------------------------
function example1() {
 var q='select * from customers';
 getid("query").value=q;
 send(writetab,"showselect '" + q + "'");
}

// ----------------------------------------------------------------------
function example2() {
 var q='select trackid,name,composer from tracks where name like "%ball%"';
 getid("query").value=q;
 send(writetab,"showselect '" + q + "'");
}

// ----------------------------------------------------------------------
function getid(e) {
 return document.getElementById(e);
}

// ----------------------------------------------------------------------
function interrupt() {
 send(null,"interrupt_jws_ 0");
 alert("This interrupts the J websocket server.\n" +
  "You can examine the server state in the J session, e.g.\n" +
  "   names''         form query handlers\n" +
  "   showtables''    called by the showtable button\n\n" +
 "To restart, in the J session enter:  restart''\n");
}

// ----------------------------------------------------------------------
function onmessage(e) {
 if (returner)
  returner(e);
}

// ----------------------------------------------------------------------
// for development - reloads the J application script
function reloadJ() {
 send(null,"reloadJ_jws_ 0");
}

// ----------------------------------------------------------------------
function runquery() {
 var q=getid("query").value;
 if (q.length)
  send(writetab,"showselect '" + q + "'");
 return false;
}

// ----------------------------------------------------------------------
function send(fn,msg) {
 returner=fn;
 ws.send(msg);
 return false;
}

// ----------------------------------------------------------------------
function showstate(e) {
 getid("bon").disabled=e;
 var t=["boff","bint","bshowtables","bexample1","bexample2","brunquery","query"];
 t.map(function f(x){getid(x).disabled=!e});
 if (!e) getid("query").value="";
}

// ----------------------------------------------------------------------
function showtables() {
 send(writetab,"showtables 0");
}

// ----------------------------------------------------------------------
function writetab(e) {
 getid("tab").innerHTML = e;
}

// ----------------------------------------------------------------------
function resizer() {
 var b=getid("top").getBoundingClientRect().bottom;
 var w=window.innerWidth;
 var h=window.innerHeight;
 var t=getid("tab");
 t.style.width=(w-30) + "px";
 t.style.height=(h-b-30) + "px";
}

// ----------------------------------------------------------------------
window.onresize = function() {
 clearTimeout(resizetimer);
 resizetimer = setTimeout(resizer, 150);
}

// ----------------------------------------------------------------------
window.onload = function() {
 showstate(false);
 resizer();
}
