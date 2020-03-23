package stx.core.pack;

@:using(stx.core.pack.Outcome.OutcomeLift)
@:using(stx.core.pack.Res.ResLift)
abstract Res<T,E>(ResSum<T,E>) from ResSum<T,E> to ResSum<T,E>{
  public function new(self) this = self;
  static public var _(default,never) = ResLift;

  static public function lift<T,E>(self:OutcomeSum<T,Err<E>>):Res<T,E> return new Res(self);
  static public function success<T,E>(t:T):Res<T,E>                    return lift(Success(t));
  static public function failure<T,E>(e:Err<E>):Res<T,E>               return lift(Failure(e));

  public function prj():ResSum<T,E> return this;
  private var self(get,never):Res<T,E>;
  
  private function get_self():Res<T,E> return lift(this);

  @:from static public function fromOutcome<T,E>(self:Outcome<T,Err<E>>):Res<T,E>{
    var ocd : OutcomeSum<T,Err<E>> = self;
    return lift(ocd);
  }

}
class ResLift{
  static public function errata<T,E,EE>(fn:Err<E>->Err<EE>,self:Res<T,E>):Res<T,EE>{
    return Outcome.lift(
      self.fold(
        (t) -> Success(t),
        (e) -> Failure(fn(e))
      )
    );
  }
  static public function zip<T,TT,E>(that:ResSum<TT,E>,self:ResSum<T,E>):Res<Couple<T,TT>,E>{
    return switch([self,that]){
      case [Failure(e),Failure(ee)]     : Failure(e.next(ee));
      case [Failure(e),_]               : Failure(e);
      case [_,Failure(e)]               : Failure(e);
      case [Success(t),Success(tt)]     : Success(__.couple(t,tt));
    }
  }
}