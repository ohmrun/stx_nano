package stx.nano;

typedef CatalogDef<T> = Dynamic<T>;

@:pure abstract Catalog<T>(CatalogDef<T>) from CatalogDef<T> to CatalogDef<T>{
  public function new(self) this = self;
  static public function lift<T>(self:CatalogDef<T>):Catalog<T> return new Catalog(self);

  @:arrayAccess
  public function get(key:String){
    return (this:haxe.DynamicAccess<T>).get(key);
  }
  public function prj():CatalogDef<T> return this;
  private var self(get,never):Catalog<T>;
  private function get_self():Catalog<T> return lift(this);
}