// cube

"use strict";

var Axis = {};
var Cube = {};
var resizetimer, returner, ws;

// ----------------------------------------------------------------------
function connect() {
 if ("WebSocket" in window) {
  ws = new WebSocket("ws://localhost:5024/");
  ws.onopen = function(e) {showstate(true);send(initdata, "griddefs 0");};
  ws.onclose = function(e) {showstate(false);drawcube()};
  ws.onmessage = function(e) {onmessage(e.data);};
  ws.onerror = alert;
 } else alert("WebSockets not supported on your browser.");
}

// ----------------------------------------------------------------------
function getid(e) {
 return document.getElementById(e);
}

// ----------------------------------------------------------------------
function initdata(e) {
 var d = JSON.parse(e);
 Axis.names = d[0];
 Axis.labels = d[1];
 Axis.order = d[2];
 showtable();
}

// ----------------------------------------------------------------------
function interrupt() {
 send(null, "interrupt_jws_ 0");
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
 send(null, "reloadJ 0");
}

// ----------------------------------------------------------------------
function send(fn, msg) {
 returner = fn;
 ws.send(msg);
 return false;
}

// ----------------------------------------------------------------------
function showstate(e) {
 getid("bon").disabled = e;
 var t = ["boff", "bint"];
 t.map(function f(x) {getid(x).disabled = !e});
}

// ----------------------------------------------------------------------
function showtable() {
 send(drawcube, "griddata '" + JSON.stringify(Axis.order) + "'");
}

// ----------------------------------------------------------------------
function resizer() {
 var t = getid("cubetab");
 if (!t) return;
 var b = t.getBoundingClientRect().top;
 var w = window.innerWidth - 120;
 var h = window.innerHeight - b - 50;
 var c = getid("cube");
 var cw = c.offsetWidth;
 var ch = c.offsetHeight;
 var sb = 20;
 var sv = (h < ch) ? 2 : (h < ch + sb) ? 1 : 0;
 var sh = (w < cw) ? 2 : (w < cw + sb) ? 1 : 0;
 if (sv === 1 && sh === 1)
  sv = sh = 2;
 t.style.width = (sh === 2) ? w + "px" : "";
 t.style.height = (sv === 2) ? h + "px" : "";
}

// ----------------------------------------------------------------------
window.onresize = function() {
 clearTimeout(resizetimer);
 resizetimer = setTimeout(resizer, 150);
}

// ----------------------------------------------------------------------
window.onload = function() {
 showstate(false);
}
