package stx.nano;

enum FailureSum<T>{
  ERR_OF(v:T);
  ERR(spec:FailCode);
}
@:using(stx.nano.Failure.FailureLift)
abstract Failure<T>(FailureSum<T>) from FailureSum<T> to FailureSum<T>{
  static public var _(default,never) = FailureLift;
  public function new(self) this = self;
  static public function lift<T>(self:FailureSum<T>):Failure<T> return new Failure(self);


  public function prj():FailureSum<T> return this;
  private var self(get,never):Failure<T>;
  private function get_self():Failure<T> return lift(this);
}
class FailureLift{
  static public function fold<T,Z>(self:Failure<T>,val:T->Z,def:FailCode->Z):Z{
    return switch(self){
      case ERR_OF(v) : val(v);
      case ERR(e)    :  def(e);
    }
  }
  static  public function value<T>(self:Failure<T>):Option<T>{
    return fold(
      self,
      Some,
      (_) -> None
    );
  }
}