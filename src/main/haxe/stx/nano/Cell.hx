package stx.nano;

typedef CellDef<T> = {
  final pop: () -> T;
}
@:forward abstract Cell<T>(CellDef<T>) {
  public var value(get, never):T;
  public function get_value(){
    return this.pop();
  }
  inline function new(self) this = self;
  
  static public function lift<T>(self:CellDef<T>){
    return new Cell(self);
  }
  static public function make<T>(fn:() -> T){
    return lift({
        pop : fn
      }
    );
  }
  public function toString():String return '@:[' + Std.string(this.pop())+']';
  
  @:noUsing @:from static inline public function pure<T>(v:T):Cell<T> {
    return make(() -> v);
  }
}