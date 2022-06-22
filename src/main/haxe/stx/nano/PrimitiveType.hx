package stx.nano;

enum PrimitiveTypeSum{
  PTBool;
  PTInt;
  PTUint;
  PTFloat;
  PTInt64;
  PTText;
}
@:using(stx.nano.PrimitiveType.PrimitiveTypeLift)
abstract PrimitiveType(PrimitiveTypeSum) from PrimitiveTypeSum to PrimitiveTypeSum{
  static public var _(default,never) = PrimitiveTypeLift;
  public inline function new(self:PrimitiveTypeSum) this = self;
  @:noUsing static inline public function lift(self:PrimitiveTypeSum):PrimitiveType return new PrimitiveType(self);

  public function prj():PrimitiveTypeSum return this;
  private var self(get,never):PrimitiveType;
  private function get_self():PrimitiveType return lift(this);
}
class PrimitiveTypeLift{
  static public inline function lift(self:PrimitiveTypeSum):PrimitiveType{
    return PrimitiveType.lift(self);
  }
}