package stx.nano;

class Json{
  /**
   * Alias for `haxe.Json.stringify` with captured error.
   * @param v 
   * @param replacer 
   * @return -> Dynamic, ?space:String):Upshot<String,Dynamic>
   */
  @:noUsing static public function encode(v:Dynamic,replacer: (key:Dynamic, value:Dynamic) -> Dynamic, ?space:String):Upshot<String,Dynamic>{
    var out = null;
    var err = null;
    try{
      out = haxe.Json.stringify(v,replacer,space);
    }catch(e:Dynamic){
      err = Refuse.make(__.option(e),None,__.here());
    }
    return err == null ? __.accept(out) : __.reject(err);
  }
  /**
   * Alias for `haxe.Json.parse` with captured error.
   * @param str 
   * @return Upshot<Dynamic,Dynamic>
   */
  @:noUsing static public function decode(str:String):Upshot<Dynamic,Dynamic>{
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