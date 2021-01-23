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
      __.crack(__.fault(pos).of(E_ResourceNotFound,str));
    }
    this = str;
  }
  public function string():StdString{
    return haxe.Resource.getString(this);
  }
  public function bytes():Bytes{
    return haxe.Resource.getBytes(this);
  }
  public function json():Any{
    return Json.parse(string());
  }
}