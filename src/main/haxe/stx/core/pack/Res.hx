package stx.core.pack;

typedef ResSum<T,E> = OutcomeSum<T,Err<E>>;

@:using(stx.core.pack.Res.ResLift)
abstract Res<T,E>(ResSum<T,E>) from ResSum<T,E> to ResSum<T,E>{
  public function new(self) this = self;
  static public var _(default,never) = ResLift;

  @:noUsing static public function lift<T,E>(self:OutcomeSum<T,Err<E>>):Res<T,E> return new Res(self);
  @:noUsing static public function success<T,E>(t:T):Res<T,E>                    return lift(Success(t));
  @:noUsing static public function failure<T,E>(e:Err<E>):Res<T,E>               return lift(Failure(e));

  public function prj():ResSum<T,E> return this;
  private var self(get,never):Res<T,E>;
  
  private function get_self():Res<T,E> return lift(this);

  @:from static public function fromOutcome<T,E>(self:Outcome<T,Err<E>>):Res<T,E>{
    var ocd : OutcomeSum<T,Err<E>> = self;
    return lift(ocd);
  }
  @:to public function toOutcome():Outcome<T,Err<E>>{
    return Outcome.lift(this);
  }
}
class ResLift{
  static public function errata<T,E,EE>(self:Res<T,E>,fn:Err<E>->Err<EE>):Res<T,EE>{
    return Res.lift(
      self.fold(
        (t) -> __.success(t),
        (e) -> __.failure(fn(e))
      )
    );
  }
  static public function zip<T,TT,E>(self:ResSum<T,E>,that:ResSum<TT,E>):Res<Couple<T,TT>,E>{
    return switch([self,that]){
      case [Failure(e),Failure(ee)]     : Failure(e.next(ee));
      case [Failure(e),_]               : Failure(e);
      case [_,Failure(e)]               : Failure(e);
      case [Success(t),Success(tt)]     : Success(__.couple(t,tt));
    }
  }
  static public function map<T,E,TT>(self:ResSum<T,E>,fn:T->TT):Res<TT,E>{
    return flat_map(self,(x) -> Success(fn(x)));
  }
  static public function flat_map<T,E,TT>(self:ResSum<T,E>,fn:T->ResSum<TT,E>):Res<TT,E>{
    return Res.lift(fold(self,(t) -> fn(t),(e) -> Failure(e)));
  }
  static public function fold<T,E,TT>(self:ResSum<T,E>,fn:T->TT,er:Err<E>->TT):TT{
    return switch(self){
      case Success(t) : fn(t);
      case Failure(e) : er(e);
    }
  }
  static public function fudge<T,E>(self:ResSum<T,E>):T{
    return fold(self,(t) -> t,(e) -> throw(e));
  }
  static public function elide<T,E>(self:ResSum<T,E>):Res<Dynamic,E>{
    return fold(self,
      (t) -> Failure((t:Dynamic)),
      (e) -> Success(e)
    );
  }
}