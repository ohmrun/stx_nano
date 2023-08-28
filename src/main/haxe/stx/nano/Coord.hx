package stx.nano;

/**
 * `Extended Set Theory` type coordinate.
 */
enum CoordSum{
  CoField(key:String,?idx:Null<Int>);
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

  @:from static public function fromInt(self:Int){
    return make(null,self);
  }
  @:from static public function fromString(self:Int){
    return make(self);
  }
  static public function make(?key:String,?idx=null){
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
  @:op(A == B)
  public function equals(that:Coord){
    return switch([this,that]){
      case [CoField(strI,null),CoField(strII,null)]  : strI == strII;
      case [CoField(strI,null),CoField(strII,idxII)] : strI == strII;
      case [CoField(strI,idxI),CoField(strII,null)]  : strI == strII;
      case [CoField(strI,idxI),CoField(strII,idxII)] : strI == strII && idxI == idxII;
      case [CoIndex(idxI),CoIndex(idxII)]            : idxI == idxII;
      default                                        : false;
    }
  }
}
class CoordLift{
  static public inline function lift(self:CoordSum):Coord{
    return Coord.lift(self);
  }
  static public function is_field(self:CoordSum):Bool{
    return switch(self){
      case CoField(_,_) : true;
      default           : false;
    }
  }
}