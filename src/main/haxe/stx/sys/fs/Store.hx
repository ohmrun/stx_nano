package stx.sys.fs;


class Store<E> extends Clazz{
  public final root : Res<String,E>;
  public final name : String;

  public var   node(get,null) : Res<String,E>;
  private function get_node(){
    return root.map(fld -> '${fld}${__.sep()}${name}');
  }
  public function new(root,name){
    super();
    this.root = root;
    this.name = name;
  }
  private function init(){
    return root.fold(
      loc -> {
        FileSystem.createDirectory('${loc}${__.sep()}$name');
        return __.report();
      },
      e   -> e.report() 
    );
  }
  public function set(key:String,val:String){
    return new Clump(
      node,
      key
    ).put(val);
  }
  public function get(key){
    return new Clump(node,key).get(); 
  }
  public function exists(key){
    return new Clump(node,key).exists();
  }
}