package sys.stx.fs;

class Clump<T>{

  final catalog : Catalog<T>;
  final name    : String;

  public function new(catalog:Catalog<T>,name:String){
    this.catalog  = catalog;
    this.name     = name; 
  }
  public function put(data:T):Void{
    this.catalog.set(this.name,data);
  }
  public function get():T{
    return this.catalog.get(name);
  }
  public function exists(){
    return this.catalog.exists(name);
  }
}