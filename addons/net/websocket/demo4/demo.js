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
// draw

"use strict";

var drags=" draggable='true' ondragstart='dragstart(event)'";
var drops=" ondrop='drop(event)' ondragend='dragend(event)' ondragover='dragover(event)'";

// ----------------------------------------------------------------------
function drawcube(e) {
 var main = getid("main");
 if (!e) return main.innerHTML = "";
 var h = "<div id='cubepane'><table>" + slices() +
  "<tr>" + maketab(e) + makebutton_cls() + "</tr><tr>" +
  makebutton_rws() + "</tr></table></div>";
 main.innerHTML = h;
 resizer();
}

// ----------------------------------------------------------------------
function makebutton_cls() {
 var b = Axis.order[1];
 var h = "<td id='tabcls'" + drops + ">";
 for (var i = 0; i < b.length; i++) {
  if (i) h += "<br/>";
  h += "<button id='btncls_" + i + "' class='btncls'" +
   drags + ">" + Axis.names[b[i]] + "</button>";
 }
 return h + "</td>";
}

// ----------------------------------------------------------------------
function makebutton_rws() {
 var b = Axis.order[0];
 var h = "<td id='tabrws' colspan=2" + drops + ">";
 for (var i = 0; i < b.length; i++) {
  h += "<button id='btnrws_" + i + "' class='btnrws'" +
   drags + ">" + Axis.names[b[i]] + "</button>";
 }
 return h + "</td>";
}

// ---------------------------------------------------------------------
function makebutton_slice(i, j, k) {
 var n = "ndx_" + i;
 var s = "sel" + n;
 Cube.slices.push(s);
 var h = "<button id=btn" + n + " class='btnslice'" +
  drags + ">" + Axis.names[j] + ":</button>" +
  makedropdown(s, "listslice", Axis.labels[j], k);
 return h;
}

// ----------------------------------------------------------------------
function makedropdown(id, cls, src, sel) {
 var c = cls.length ? " class='" + cls + "'" : "";
 var h = "<select id='" + id + "'" + c + "onchange='selectslice(this)'>";
 for (var i = 0, n = src.length; i < n; i++)
  h += "<option " + ((sel === i) ? "selected" : "") + ">" + src[i] + "</option>"
 h += "</select>"
 return h;
}

// ----------------------------------------------------------------------
function maketab(e) {
 return "<td><div id='cubetab'>" + e + "</div></td>";
}

// ---------------------------------------------------------------------
function selectslice(e) {
 var p = Number(e.id.slice(7));
 var n = e.selectedIndex;
 Axis.order[3][p] = n;
 showtable();
}

// ---------------------------------------------------------------------
function slices() {
 Cube.slices = [];
 var h = "<tr><td colspan=2>" +
 "<div id='tabndx'" + drops + ">";
 var ind = Axis.order[2];
 var sel = Axis.order[3];
 for (var i = 0; i < ind.length; i++)
  h += makebutton_slice(i, ind[i], sel[i]);
 h += "</div></td></tr>";
 return h;
}
// drag

// ----------------------------------------------------------------------
function dragstart(e) {
 var d = e.target.id + " " + e.x + " " + e.y;
 e.dataTransfer.setData("text", d);
 showtarget(true);
}

// ----------------------------------------------------------------------
function dragend(e) {
 showtarget(false);
}

// ----------------------------------------------------------------------
function dragover(e) {
 e.preventDefault();
}

// ----------------------------------------------------------------------
function drop(e) {
 e.preventDefault();
 var dat = e.dataTransfer.getData("text").split(" ");
 if (70 > Math.abs(e.x - dat[1]) && 20 > Math.abs(e.y - dat[2]))
  return;

 var txt = dat[0];
 var src = txt.slice(3, 6);
 var srx = Number(txt.slice(7));
 var tgt = e.target.id.slice(3, 6);

 if (src === tgt)
   return dropsame(src,srx);

 var rws = Axis.order[0];
 var cls = Axis.order[1];
 var ndx = Axis.order[2];
 var sel = Axis.order[3];

 var mov;

 if (src === "rws") {
  mov = rem1(rws, srx);
  if (rws.length === 0)
   if (tgt === "ndx" && ndx.length > 0) {
    rws.push(remlast(ndx));
    remlast(sel);
   }
  else
   rws.push(remlast(cls));
 } else if (src === "cls") {
  mov = rem1(cls, srx);
  if (cls.length === 0)
   if (tgt === "ndx" && ndx.length > 0) {
    cls.push(remlast(ndx));
    remlast(sel);
   }
  else
   cls.push(remlast(rws));
 } else if (src === "ndx") {
  mov = rem1(ndx, srx);
  rem1(sel, srx);
 }

 if (tgt === "rws")
  rws.push(mov);
 else if (tgt === "cls")
  cls.push(mov);
 else if (tgt === "ndx") {
  ndx.push(mov);
  sel.push(0);
 }

 Axis.order = [rws, cls, ndx, sel];
 showtable();
}

// ----------------------------------------------------------------------
function dropsame(src,ndx) {
 if (src === "rws")
  movelast(Axis.order[0],ndx);
 else if (src === "cls")
  movelast(Axis.order[1],ndx);
 else if (src === "ndx") {
  movelast(Axis.order[2],ndx);
  movelast(Axis.order[3],ndx);
 }
 showtable();
}

// ----------------------------------------------------------------------
function showtarget(e) {
  var s=e ? "#f4f4f8" : "";
  ["tabcls","tabrws","tabndx"].map(function(e){getid(e).style.background=s;})
}

// ----------------------------------------------------------------------
function movelast(a, i) {
 if (i<a.length-1) {
  var m=rem1(a,i);
  a.push(m);
 }
 return a;
}

// ----------------------------------------------------------------------
function rem1(a, i) {
 return a.splice(i, 1)[0];
}

// ----------------------------------------------------------------------
function remlast(a) {
 return a.splice(a.length - 1, 1)[0];
}
