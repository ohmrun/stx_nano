package stx.nano.lift;

import haxe.io.Path;

class LiftPath{
  static public function into(path:Path,v:OneOrMany<String>):Path{
    var base = Path.addTrailingSlash(path.toString());
    var rest = v.toArray().join(__.sep());
    var next = '$base$rest';
    return new Path(next); 
  }
  static public function toArray(path:Path){
    var base = path.toString();
    if(StringTools.startsWith(base,__.sep())){
      base = base.substr(1);
    }
    var next = base.split(__.sep());
    return next;
  }
}