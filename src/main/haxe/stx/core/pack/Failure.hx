package stx.core.pack;

enum FailureSum<T>{
  ERR_OF(v:T);
  ERR(spec:FailCode);
}
abstract Failure<T>(FailureSum<T>) from FailureSum<T> to FailureSum<T>{
  public function new(self) this = self;
  static public function lift<T>(self:FailureSum<T>):Failure<T> return new Failure(self);


  public function prj():FailureSum<T> return this;
  private var self(get,never):Failure<T>;
  private function get_self():Failure<T> return lift(this);

  public function fold<Z>(val:T->Z,def:FailCode->Z):Z{
    return switch(this){
      case ERR_OF(v) : val(v);
      case ERR(e)    :  def(e);
    }
  }
}