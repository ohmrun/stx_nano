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
  
  @:noUsing static public function lift<T>(self:CellDef<T>){
    return new Cell(self);
  }
  @:noUsing static public function make<T>(fn:() -> T){
    return lift({
        pop : fn
      }
    );
  }
  static public function many<T>(self:Cluster<() -> T>):Cell<Cluster<T>>{
    return lift({
      pop : () -> {
        final out = [];
        for(x in self){
          out.push(x());
        }
        return Cluster.lift(out);
      }
    });
  }
  public function toString():String return '@:[' + Std.string(this.pop())+']';
  
  @:noUsing @:from static inline public function pure<T>(v:T):Cell<T> {
    return make(() -> v);
  }
}