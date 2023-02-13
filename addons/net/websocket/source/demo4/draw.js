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
