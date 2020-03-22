package stx.core.pack;

abstract Res<T,E>(ResDef<T,E>) from ResDef<T,E> to ResDef<T,E>{
  public function new(self) this = self;
  static public function _() return Constructor.ZERO;

  static public function lift<T,E>(self:ResDef<T,E>):Res<T,E>             return _().lift(self);
  static public function success<T,E>(t:T):Res<T,E>                       return _().success(t);
  static public function failure<T,E>(e:Err<E>):Res<T,E>                  return _().failure(e);

  public function errata<EE>(fn:Err<E>->Err<EE>):Res<T,EE>                return _()._.errata(fn,this);
  public function map<TT>(fn:T->TT):Res<TT,E>                             return _()._.map(fn,this);
  public function flat_map<TT>(fn:T->Res<TT,E>):Res<TT,E>                 return _()._.flat_map(fn,this);
  public function fold<Z>(fn:T->Z,er:Err<E>->Z):Z                         return _()._.fold(fn,er,self);
  public function zip<TT>(that:Res<TT,E>):Res<Couple<T,TT>,E>             return _()._.zip(that,self);
  
  public function fudge():T                                               return _()._.fudge(self);
  public function elide():Res<Dynamic,E>                                  return _()._.elide(this);

  public function prj():ResDef<T,E> return this;
  private var self(get,never):Res<T,E>;
  
  private function get_self():Res<T,E> return lift(this);

  @:from static public function fromOutcome<T,E>(self:Outcome<T,Err<E>>):Res<T,E>{
    var ocd : OutcomeSum<T,Err<E>> = self;
    return lift(ocd);
  }

}
class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();

  public function lift<T,E>(self:OutcomeSum<T,Err<E>>):Res<T,E> return new Res(self);
  public function success<T,E>(t:T):Res<T,E>                    return lift(Success(t));
  public function failure<T,E>(e:Err<E>):Res<T,E>               return lift(Failure(e));
}
class Destructure extends stx.core.pack.outcome.Destructure{
  public function errata<T,E,EE>(fn:Err<E>->Err<EE>,self:Res<T,E>):Res<T,EE>{
    return Outcome.lift(
      self.fold(
        (t) -> Success(t),
        (e) -> Failure(fn(e))
      )
    );
  }
  public function zip<T,TT,E>(that:ResDef<TT,E>,self:ResDef<T,E>):Res<Couple<T,TT>,E>{
    return switch([self,that]){
      case [Failure(e),Failure(ee)]     : Failure(e.next(ee));
      case [Failure(e),_]               : Failure(e);
      case [_,Failure(e)]               : Failure(e);
      case [Success(t),Success(tt)]     : Success(__.couple(t,tt));
    }
  }
}