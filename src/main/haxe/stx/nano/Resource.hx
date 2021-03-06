package stx.nano;


import haxe.Json;
import haxe.io.Bytes;

abstract Resource(StdString){
  static public function exists(str:String){
    return haxe.Resource.listNames().any(
      (x:String) -> x == str
    );
  }
  public inline function new(str:String,?pos:Pos){
    if(!exists(str)){
      if(pos == null){
        throw('E_Undefined($str)');
      }else{
        var error = __.fault(pos).code(E_Undefined);
        throw error;
      }
    }
    this = str;
  }
  public function string():StdString{
    return haxe.Resource.getString(this);
  }
  public function bytes():Bytes{
    return haxe.Resource.getBytes(this);
  }
  public function json():Dyn{
    return try{
      Json.parse(string());
    }catch(e:Dynamic){
      throw('ERROR parsing $this: $e');
    }
  }
}