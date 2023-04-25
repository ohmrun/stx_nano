package stx.nano;

class Json{
  static public function encode(v:Dynamic,replacer: (key:Dynamic, value:Dynamic) -> Dynamic, ?space:String):Upshot<String,Dynamic>{
    var out = null;
    var err = null;
    try{
      out = haxe.Json.stringify(v,replacer,space);
    }catch(e:Dynamic){
      err = Refuse.make(__.option(e),None,__.here());
    }
    return err == null ? __.accept(out) : __.reject(err);
  }
  static public function decode(str:String):Upshot<Dynamic,Dynamic>{
    var out = null;
    var err = null;
    try{
      out = haxe.Json.parse(str);
    }catch(e:Dynamic){
      err = Refuse.make(__.option(e),None,__.here());
    }
    return err == null ? __.accept(out) : __.reject(err);
  }
}