package stx.sys.fs;

class Clump<E> extends Clazz{
  public final root : Res<String,E>;
  public final file : String;

  public var   node(get,null) : Res<String,E>;
  private function get_node(){
    return root.map(fld -> '${fld}${__.sep()}${file}');
  }
  public function new(root,file){
    super();
    this.root = root;
    this.file = file;
  }
  public function put(data:String):Alert<E>{
    return init().so(
      () -> {
        File.saveContent(node.fudge(),data);
        return __.report();
      }
    ).alert();
  }
  public function get():Pledge<Option<String>,E>{
    return node.toPledge().adjust(
      node -> FileSystem.exists(node).if_else(
        () -> __.accept(__.option(File.getContent(node))),
        () -> __.accept(__.option(null))
      )
    );
  }
  public function exists(){
    return node.map(x -> FileSystem.exists(x)).fold(b -> b,(_) -> false);
  }
  private function init(){
    return root.fold(
      loc -> {
        FileSystem.createDirectory(loc);
        return __.report();
      },
      e   -> e.report() 
    );
  }
}