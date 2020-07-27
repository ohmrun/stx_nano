package stx.nano;

enum ResSum<T,E>{
  Accept(t:T);
  Reject(e:Err<E>);
}

@:using(stx.nano.Res.ResLift)
abstract Res<T,E>(ResSum<T,E>) from ResSum<T,E> to ResSum<T,E>{
  public function new(self) this = self;
  static public var _(default,never) = ResLift;

  @:noUsing static public function lift<T,E>(self:ResSum<T,E>):Res<T,E> return new Res(self);
  @:noUsing static public function accept<T,E>(t:T):Res<T,E>                    return lift(Accept(t));
  @:noUsing static public function reject<T,E>(e:Err<E>):Res<T,E>               return lift(Reject(e));

  public function prj():ResSum<T,E> return this;
  private var self(get,never):Res<T,E>;
  
  private function get_self():Res<T,E> return lift(this);

  @:from static public function fromOutcome<T,E>(self:Outcome<T,Err<E>>):Res<T,E>{
    var ocd : ResSum<T,E> = switch(self){
      case Success(ok) : Accept(ok);
      case Failure(no) : Reject(no);
    }
    return lift(ocd);
  }
  @:to public function toOutcome():Outcome<T,Err<E>>{
    return switch(this){
      case Accept(ok) : Success(ok);
      case Reject(no) : Failure(no);
    }
  }
  @:noUsing static public function bind_fold<T,E,Z>(arr:Array<T>,fn:T->Z->Res<Z,E>,init:Z):Res<Z,E>{
    return arr.lfold(
      (next:T,memo:Res<Z,E>) -> memo.fold(
        (ok)  -> fn(next,ok),
        (no)  -> __.reject(no)
      ),
      __.accept(init)
    );
  }
}
class ResLift{
  static public function errata<T,E,EE>(self:Res<T,E>,fn:Err<E>->Err<EE>):Res<T,EE>{
    return Res.lift(
      self.fold(
        (t) -> __.accept(t),
        (e) -> __.reject(fn(e))
      )
    );
  }
  static public function errate<T,E,EE>(self:Res<T,E>,fn:E->EE):Res<T,EE>{
    return errata(self,(e) -> e.map(fn));
  }
  static public function zip<T,TT,E>(self:ResSum<T,E>,that:ResSum<TT,E>):Res<Couple<T,TT>,E>{
    return switch([self,that]){
      case [Reject(e),Reject(ee)]     : Reject(e.next(ee));
      case [Reject(e),_]              : Reject(e);
      case [_,Reject(e)]              : Reject(e);
      case [Accept(t),Accept(tt)]     : Accept(__.couple(t,tt));
    }
  }
  static public function map<T,E,TT>(self:ResSum<T,E>,fn:T->TT):Res<TT,E>{
    return flat_map(self,(x) -> Accept(fn(x)));
  }
  static public function flat_map<T,E,TT>(self:ResSum<T,E>,fn:T->ResSum<TT,E>):Res<TT,E>{
    return Res.lift(fold(self,(t) -> fn(t),(e) -> Reject(e)));
  }
  static public function fold<T,E,TT>(self:ResSum<T,E>,fn:T->TT,er:Err<E>->TT):TT{
    return switch(self){
      case Accept(t) : fn(t);
      case Reject(e) : er(e);
    }
  }
  static public function fudge<T,E>(self:ResSum<T,E>):T{
    return fold(self,(t) -> t,(e) -> throw(e));
  }
  static public function elide<T,E>(self:ResSum<T,E>):Res<Dynamic,E>{
    return fold(self,
      (t) -> Reject((t:Dynamic)),
      (e) -> Accept(e)
    );
  }
  static public function value<T,E>(self:ResSum<T,E>):Option<T>{
    return fold(self,
      Some,
      (_) -> None  
    );
  }
  static public function report<T,E>(self:ResSum<T,E>):Report<E>{
    return fold(self,
      (_) -> Report.unit(),
      Report.pure
    );
  }
}