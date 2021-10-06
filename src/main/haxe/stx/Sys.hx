package stx;

import sys.FileSystem;
import sys.io.File;

typedef Clump<E>      = stx.sys.fs.Clump<E>;
typedef Catalog<T>    = stx.sys.fs.Catalog<T>;


class Sys{
  static public function sys(wildcard:Wildcard){
    return new Module();
  }
  static public function env(key:String):Option<String>{
    return __.option(std.Sys.getEnv(key));
  }
}
private class Module extends Clazz{
  public function fs() return new Fs();
  public function dir() return new Dir();
}
private class Fs extends Clazz{
  public function exists(str:String):Bool{
    return FileSystem.exists(str);
  }
  public function get(str:String):String{
    return File.getContent(str);
  }
  public inline function set(key:String,val:String):Void{
    File.saveContent(key,val);
  }
}
private class Dir extends Clazz{
  public function put(path:String){
    FileSystem.createDirectory(path);
  }
}