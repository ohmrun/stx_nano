package stx.nano;

class JunctionCtr<T> extends Clazz{
  public function At(v:Register):Junction<T>{
    return Junction.fromRegister(v);
  }
  public function Of<I>(v:APP<I,T>):Junction<T>{
    return Junction.fromT(v.reply());
  }
}
enum JunctionSum<T>{
  There(r:Register);
  Whole(v:T);
}
@:transitive
@:using(stx.nano.Junction.JunctionLift)
abstract Junction<T>(JunctionSum<T>) from JunctionSum<T> to JunctionSum<T>{
  static public var _(default,never) = JunctionLift;
  public inline function new(self:JunctionSum<T>) this = self;
  @:noUsing static inline public function lift<T>(self:JunctionSum<T>):Junction<T> return new Junction(self);

  public function prj():JunctionSum<T> return this;
  private var self(get,never):Junction<T>;
  private function get_self():Junction<T> return lift(this);
  @:from static public inline function fromRegister<T>(r:Register):Junction<T>{
    return lift(There(r));
  }
  @:from static public inline function fromT<T>(r:T):Junction<T>{
    return lift(Whole(r));
  }
}
class JunctionLift{
  static public inline function lift<T>(self:JunctionSum<T>):Junction<T>{
    return Junction.lift(self);
  }
}