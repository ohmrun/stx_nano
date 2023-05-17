package stx.nano;


import haxe.Json;
import haxe.io.Bytes;

// #if stx_log
//   using stx.Log;
// #end
/**
 * `stx` version of `haxe.Resource`
 * *will* throw an error if resource not found on construction.
 */
abstract Resource(StdString){
  static public function exists(str:String){
    return haxe.Resource.listNames().any(
      (x:String) -> x == str
    );
  }
  public inline function new(str:String,?pos:Pos){
    if(!exists(str)){
      if(pos == null){
        throw('E_ResourceNotFound($str)');
      }else{
        var error = __.fault(pos).explain(_ -> _.e_resource_not_found(str));
        // #if stx_log
        // __.log().info('resource "$str" not found.');
        // #end
        throw error;
      }
    }
    this = str;
  }
  /**
   * Produce a `String` of this resource.
   * @return StdString
   */
  public function string():StdString{
    return haxe.Resource.getString(this);
  }
  /**
   * Produce `Bytes` of this resource.
   * @return Bytes
   */
  public function bytes():Bytes{
    return haxe.Resource.getBytes(this);
  }
  /**
   * Produces a `Dynamic` value by parsing the resource as json.
   * @return Dyn
   */
  public function json():Dyn{
    return try{
      Json.parse(string());
    }catch(e:Dynamic){
      throw('ERROR parsing $this: $e');
    }
  }
}