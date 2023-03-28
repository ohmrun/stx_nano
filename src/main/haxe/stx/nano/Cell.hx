package stx.nano;

/**
 * typedef for Lazy read-only value
 * @see Cell
 */
typedef CellDef<T> = {
  final pop: () -> T;
}
/**
 * Abstract Lazy read-only value.
 */
@:forward abstract Cell<T>(CellDef<T>) {
  public var value(get, never):T;
  public function get_value(){
    return this.pop();
  }
  inline function new(self) this = self;
  
  @:noUsing static public function lift<T>(self:CellDef<T>){
    return new Cell(self);
  }
  @:stx.code.construct.make
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
 
  /**
   * pure constructor
   * @param v 
   * @return Cell<T>
   */
  @:stx.code.construct.pure
  @:noUsing @:from static inline public function pure<T>(v:T):Cell<T> {
    return make(() -> v);
  }
}