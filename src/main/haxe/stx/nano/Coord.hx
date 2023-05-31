package stx.nano;

/**
 * `Extended Set Theory` type coordinate.
 */
enum CoordSum{
  CoField(key:String,?idx:Int);
  CoIndex(idx:Int);
}
/**
 * `Extended Set Theory` type coordinate.
 */
@:using(stx.nano.Coord.CoordLift)
abstract Coord(CoordSum) from CoordSum to CoordSum{
  static public var _(default,never) = CoordLift;
  public inline function new(self:CoordSum) this = self;
  @:noUsing static inline public function lift(self:CoordSum):Coord return new Coord(self);

  static public function make(?key:String,?idx=0){
    return lift(switch(key){
      case null : CoIndex(idx);
      case x    : CoField(key,idx);
    });
  }
  public function prj():CoordSum return this;
  private var self(get,never):Coord;
  private function get_self():Coord return lift(this);

  public var index(get,never):Option<Int>;
  private function get_index():Option<Int>{
    return switch(this){
      case CoField(_,idx) : __.option(idx);
      default             : __.option();
    }
  }
  public var field(get,never):Option<String>;
  private function get_field():Option<String>{
    return switch(this){
      case CoField(str,_) : __.option(str);
      default             : __.option();
    }
  }
}
class CoordLift{
  static public inline function lift(self:CoordSum):Coord{
    return Coord.lift(self);
  }
}