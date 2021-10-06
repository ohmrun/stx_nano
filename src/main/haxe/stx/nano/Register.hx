package stx.nano;

typedef RegisterDef<T> = Dynamic<T>;

@:pure abstract Register<T>(RegisterDef<T>) from RegisterDef<T> to RegisterDef<T>{
  public function new(self) this = self;
  static public function lift<T>(self:RegisterDef<T>):Register<T> return new Register(self);

  @:arrayAccess
  public function get(key:String){
    return (this:haxe.DynamicAccess<T>).get(key);
  }
  public function prj():RegisterDef<T> return this;
  private var self(get,never):Register<T>;
  private function get_self():Register<T> return lift(this);
}