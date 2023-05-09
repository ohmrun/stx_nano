package sys.stx.fs;

import haxe.Constraints;

abstract class Catalog<V> implements haxe.Constraints.IMap<String,V> {
  public final path : Way;

  public function new(path){
    this.path     = path;
  }
  abstract public function encode(t:V):String;
  abstract public function decode(str:String):V;

	public function get(k:String):Null<V>{
    final a = path.snoc(k).toOsString();
    return exists(k).if_else(
      () -> decode(Sys.fs().get(a)),
      () -> null
    );
  }
	public function set(k:String, v:V):Void{
    final a = path.snoc(k).toOsString();
    Sys.fs().set(k,encode(v));
  }
	public function exists(k:String):Bool{
    final a = path.snoc(k).toOsString();
    return Sys.fs().exists(k);
  }
	public function remove(k:String):Bool{
    var result = exists(k);
    FileSystem.deleteFile(path.snoc(k).toOsString());
    return result;
  }
	public function keys():Iterator<String>{
    return FileSystem.readDirectory(path.toOsString()).iterator();
  }
	public function iterator():Iterator<V>{
    return keys().toIter().map((x:String) -> this.get(x)).iterator();
  }
	public function keyValueIterator():KeyValueIterator<String, V>{
    return keys().toIter().map( x -> { key : x, value : this.get(x)}).iterator();
  }
	public function copy():IMap<String, V>{
    var n = new haxe.ds.StringMap();
    for(k => v in this){
      n.set(k,v);
    }
    return n;
  }
	public function toString():String{
    return 'CATALOG';
  }
	public function clear():Void{
    for(key in this.keys()){
      remove(key);
    }
  }
  static public function Unit(path):Catalog<String>{
    return new sys.stx.fs.catalog.Unit(path);
  }
}