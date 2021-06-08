package stx.nano;

import tink.core.Noise;

@:using(stx.nano.Res.ResLift)
@:using(stx.nano.Res.ResSumLift)
enum ResSum<T,E>{
  Accept(t:T);
  Reject(e:Err<E>);
}
class ResSumLift{
  static public function toString<T,E>(self:ResSum<T,E>):String{
    return Res._.toString(self);
  }
}
@:using(stx.nano.Res.ResLift)
abstract Res<T,E>(ResSum<T,E>) from ResSum<T,E> to ResSum<T,E>{
  public function new(self) this = self;
static public var _(default,never) = ResLift;

  private var self(get,never):Res<T,E>;
  private function get_self():Res<T,E> return lift(this);
  
  @:noUsing static public inline function lift<T,E>(self:ResSum<T,E>):Res<T,E> return new Res(self);
  @:noUsing static public function accept<T,E>(t:T):Res<T,E>                    return lift(Accept(t));
  @:noUsing static public function reject<T,E>(e:Err<E>):Res<T,E>               return lift(Reject(e));

  @:noUsing static public function fromReport<E>(self:Report<E>):Res<Noise,E>{
    return lift(self.fold(
      (ok:Err<E>) -> reject(ok),
      ()   -> accept(Noise)
    ));
  }
  public function prj():ResSum<T,E> return this;

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
        (no)  -> reject(no)
      ),
      accept(init)
    );
  }
  @:to public function toStringable():Stringable{
    return {
      toString : _.toString.bind(this)
    }
  }
}
class ResLift{
  @:nb("toString() isn't called in the normal way.","//T:{ toString : () -> String }")
  static public function toString<T,E>(self:Res<T,E>):String{
    return self.fold(
      (x) -> 'Accept(${x})',
      (e) -> 'Reject(${e.toString()})'
    );
  }
  static public inline function errata<T,E,EE>(self:Res<T,E>,fn:Err<E>->Err<EE>):Res<T,EE>{
    return Res.lift(
      self.fold(
        (t) -> Res.accept(t),
        (e) -> Res.reject(fn(e))
      )
    );
  }
  static public inline function errate<T,E,EE>(self:Res<T,E>,fn:E->EE):Res<T,EE>{
    return errata(self,(e) -> e.map(fn));
  }
  static public inline function zip<T,TT,E>(self:ResSum<T,E>,that:ResSum<TT,E>):Res<Couple<T,TT>,E>{
    return switch([self,that]){
      case [Reject(e),Reject(ee)]     : Reject(e.merge(ee));
      case [Reject(e),_]              : Reject(e);
      case [_,Reject(e)]              : Reject(e);
      case [Accept(t),Accept(tt)]     : Accept(Couple.make(t,tt));
    }
  }
  static public inline function map<T,E,TT>(self:ResSum<T,E>,fn:T->TT):Res<TT,E>{
    return flat_map(self,(x) -> Accept(fn(x)));
  }
  static public inline function flat_map<T,E,TT>(self:ResSum<T,E>,fn:T->ResSum<TT,E>):Res<TT,E>{
    return Res.lift(fold(self,(t) -> fn(t),(e) -> Reject(e)));
  }
  static public inline function adjust<T,E,TT>(self:ResSum<T,E>,fn:T->ResSum<TT,E>):Res<TT,E>{
    return flat_map(self,fn);
  }
  static public inline function fold<T,E,TT>(self:ResSum<T,E>,fn:T->TT,er:Err<E>->TT):TT{
    return switch(self){
      case Accept(t) : fn(t);
      case Reject(e) : er(e);
    }
  }
  static public inline function fudge<T,E>(self:ResSum<T,E>):T{
    return fold(self,(t) -> t,(e) -> throw(e));
  }
  static public inline function elide<T,E>(self:ResSum<T,E>):Res<Dynamic,E>{
    return fold(self,
      (t) -> Reject((t:Dynamic)),
      (e) -> Accept(e)
    );
  }
  static public inline function value<T,E>(self:ResSum<T,E>):Option<T>{
    return fold(self,
      Some,
      (_) -> None  
    );
  }
  static public inline function report<T,E>(self:ResSum<T,E>):Report<E>{
    return fold(self,
      (_) -> Report.unit(),
      Report.pure
    );
  }
  static public inline function rectify<T,E>(self:ResSum<T,E>,fn:Err<E>->ResSum<T,E>):ResSum<T,E>{
    return fold(
      self,
      (ok)  -> Res.accept(ok),
      (no)  -> fn(no)
    );
  }
  static public inline function recover<T,E>(self:ResSum<T,E>,fn:Err<E>->T):T{
    return fold(
      self,
      (v) -> v,
      (e) -> fn(e)
    );
  }
  static public function effects<T,E>(self:ResSum<T,E>,success:T->Void,failure:Err<E>->Void):Res<T,E>{
    return fold(
      self,
      (ok) -> {
        success(ok);
        return Res.accept(ok);
      },
      (e) -> {
        failure(e);
        return Res.reject(e);
      }
    );
  }
  static public inline function ok<T,E>(self:ResSum<T,E>):Bool{
    return fold(
      self,
      (_) -> true,
      (_) -> false
    );
  }
  static public function toPledge<T,E>(self:ResSum<T,E>):Pledge<T,E>{
    return Pledge.fromRes(self);
  }
  static public function point<T,E>(self:ResSum<T,E>,fn:T->Report<E>):Report<E>{
    return fold(
      self,
      (ok)  -> fn(ok),
      e     -> e.report()
    );
  }
}