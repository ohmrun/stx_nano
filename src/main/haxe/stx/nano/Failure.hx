package stx.nano;

@:using(stx.nano.Failure.FailureLift)
enum FailureSum<T>{
  ERR_OF(v:T);
  ERR(spec:FailCode);
}
@:using(stx.nano.Failure.FailureLift)
abstract Failure<T>(FailureSum<T>) from FailureSum<T> to FailureSum<T>{
  static public var _(default,never) = FailureLift;
  public function new(self) this = self;
  @:noUsing static public inline function lift<T>(self:FailureSum<T>):Failure<T> return new Failure(self);

  @:from static public function fromFailCode<T>(code:FailCode):Failure<T>{
    return ERR(code);
  }
  @:from static public function fromErrOf<T>(v:T):Failure<T>{
    return ERR_OF(v);
  }
  public function prj():FailureSum<T> return this;
  private var self(get,never):Failure<T>;
  private function get_self():Failure<T> return lift(this);
}
class FailureLift{
  static public function fold<T,Z>(self:Failure<T>,val:T->Z,def:FailCode->Z):Z{
    return switch(self){
      case ERR_OF(v) :  val(v);
      case ERR(e)    :  def(e);
    }
  }
  static public function fold_filter<T>(self:Failure<T>,val:T->Bool,def:FailCode->Bool):Option<Failure<T>>{
    return fold(
      self,
      (x) -> val(x).if_else(
        () -> Option.pure(ERR_OF(x)),
        () -> Option.unit()
      ),
      x -> def(x).if_else(
        () -> Option.pure(ERR(x)),
        () -> Option.unit()
      )
    );
  }
  static  public function value<T>(self:Failure<T>):Option<T>{
    return fold(
      self,
      Some,
      (_) -> None
    );
  }
  static public function toString<T>(self:Failure<T>):String{
    return fold(
      self,
      (v) -> Std.string(v),
      (n) -> n.toString()
    );
  }
}