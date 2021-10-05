package stx.sys.fs;

class Register<E>{

  public final root : Res<String,E>;
  public final file : String;

  public function new(root,file){
    this.root     = root;
    this.register = register;
  }
  public var node(get,null) : Res<String,E>;
  private function get_node(){
    return root.map(fld -> '${fld}${__.sep()}${file}');
  }
}