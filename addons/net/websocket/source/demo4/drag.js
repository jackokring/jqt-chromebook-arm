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
