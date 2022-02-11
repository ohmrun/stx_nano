package stx;

#if (sys || hxnodejs)
  import sys.FileSystem;
  import sys.io.File;
#end


typedef Clump<E>      = stx.sys.fs.Clump<E>;
typedef Catalog<T>    = stx.sys.fs.Catalog<T>;

class Sys{
  static public function sys(wildcard:Wildcard){
    return new Module();
  }
}
class Module extends Clazz{
  public function fs() return new Fs();
  public function dir() return new Dir();
  public function env(key:String):Option<String>{
    return __.option(std.Sys.getEnv(key));
  }
  public function args(){
    return std.Sys.args();
  }
  public function cwd()
    return {
       get : ()           -> std.Sys.getCwd(),
       put : (str:String) -> { std.Sys.setCwd(str); }
    }
  public inline function println(str:String):Void{
    std.Sys.println(str);
  }
  public inline function print(str:String){
    std.Sys.print(str);
  }
  public inline function exit(code){
    std.Sys.exit(code);
  }
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