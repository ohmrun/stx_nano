package stx.sys;

#if sys
class Env extends Clazz{
  static public function get(str:String):Option<String>{
    return __.option(Sys.getEnv(str)); 
  }
}
#end