package stx.nano;

@:using(stx.nano.Upshot.UpshotLift)
@:using(stx.nano.Upshot.UpshotSumLift)
enum UpshotSum<T,E>{
  Accept(t:T);
  Reject(e:Refuse<E>);
}
class UpshotSumLift{
  static public function toString<T,E>(self:UpshotSum<T,E>):String{
    return UpshotLift.toString(self);
  }
}
@:using(stx.nano.Upshot.UpshotLift)
abstract Upshot<T,E>(UpshotSum<T,E>) from UpshotSum<T,E> to UpshotSum<T,E>{
  public inline function new(self) this = self;
  static public var _(default,never) = UpshotLift;

  private var self(get,never):Upshot<T,E>;
  private function get_self():Upshot<T,E> return lift(this);
  
  @:noUsing static public inline function lift<T,E>(self:UpshotSum<T,E>):Upshot<T,E> return new Upshot(self);
  @:noUsing static public function accept<T,E>(t:T):Upshot<T,E>                    return lift(Accept(t));
  @:noUsing static public function reject<T,E>(e:Refuse<E>):Upshot<T,E>               return lift(Reject(e));

  @:noUsing static public function fromReport<E>(self:Report<E>):Upshot<Nada,E>{
    return lift(self.fold(
      (ok:Refuse<E>)   -> reject(ok),
      ()              -> accept(Nada)
    ));
  }
  public function prj():UpshotSum<T,E> return this;

  @:from static public function fromOutcome<T,E>(self:Outcome<T,Refuse<E>>):Upshot<T,E>{
    var ocd : UpshotSum<T,E> = switch(self){
      case Success(ok) : Accept(ok);
      case Failure(no) : Reject(no);
    }
    return lift(ocd);
  }
  @:to public function toOutcome():Outcome<T,Refuse<E>>{
    return switch(this){
      case Accept(ok) : Success(ok);
      case Reject(no) : Failure(no);
    }
  }
  @:noUsing static public function bind_fold<T,E,Z>(arr:Iter<T>,fn:T->Z->Upshot<Z,E>,init:Z):Upshot<Z,E>{
    return arr.lfold(
      (next:T,memo:Upshot<Z,E>) -> memo.fold(
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
  @:to public function toIterable():Iterable<T>{
    return {
      iterator : iterator
    };
  }
  public function iterator():Iterator<T>{
    var done = false;
    return {
      hasNext : () -> {
        return this.fold(
          ok  -> !done,
          (e) -> throw e
        );
      },
      next : () -> {
        done = true;
        return this.fold(
          ok  -> ok,
          e   -> throw e
        );
      }
    }
  }
}
class UpshotLift{
  @:nb("toString() isn't called in the normal way.","//T:{ toString : () -> String }")
  static public function toString<T,E>(self:Upshot<T,E>):String{
    return self.fold(
      (x) -> 'Accept(${x})',
      (e) -> 'Reject(${e.toString()})'
    );
  }
  static public inline function errata<T,E,EE>(self:Upshot<T,E>,fn:Refuse<E>->Refuse<EE>):Upshot<T,EE>{
    return Upshot.lift(
      self.fold(
        (t) -> Upshot.accept(t),
        (e) -> Upshot.reject(fn(e))
      )
    );
  }
  static public inline function errate<T,E,EE>(self:Upshot<T,E>,fn:E->EE):Upshot<T,EE>{
    return errata(self,
      (e) -> e.errate(fn)
    );
  }
  static public inline function zip<T,TT,E>(self:UpshotSum<T,E>,that:UpshotSum<TT,E>):Upshot<Couple<T,TT>,E>{
    return zip_with(self,that,Couple.make);
  }
  static public inline function zip_with<T,TT,Z,E>(self:UpshotSum<T,E>,that:UpshotSum<TT,E>,with:T->TT->Z):Upshot<Z,E>{
    return switch([self,that]){
      case [Reject(e),Reject(ee)]     : Reject(e.concat(ee));
      case [Reject(e),_]              : Reject(e);
      case [_,Reject(e)]              : Reject(e);
      case [Accept(t),Accept(tt)]     : Accept(with(t,tt));
    }
  }
  static public inline function map<T,E,TT>(self:UpshotSum<T,E>,fn:T->TT):Upshot<TT,E>{
    return flat_map(self,(x) -> Accept(fn(x)));
  }
  static public inline function flat_map<T,E,TT>(self:UpshotSum<T,E>,fn:T->UpshotSum<TT,E>):Upshot<TT,E>{
    return Upshot.lift(fold(self,(t) -> fn(t),(e) -> Reject(e)));
  }
  static public inline function adjust<T,E,TT>(self:UpshotSum<T,E>,fn:T->UpshotSum<TT,E>):Upshot<TT,E>{
    return flat_map(self,fn);
  }
  static public inline function fold<T,E,TT>(self:UpshotSum<T,E>,fn:T->TT,er:Refuse<E>->TT):TT{
    return switch(self){
      case Accept(t) : fn(t);
      case Reject(e) : er(e);
    }
  }
  static public inline function fudge<T,E>(self:UpshotSum<T,E>):T{
    return fold(self,(t) -> t,(e) -> throw(e));
  }
  static public inline function elide<T,E>(self:UpshotSum<T,E>):Upshot<Dynamic,E>{
    return fold(self,
      (t) -> Reject((t:Dynamic)),
      (e) -> Accept(e)
    );
  }
  static public inline function option<T,E>(self:UpshotSum<T,E>):Option<T>{
    return fold(self,
      Some,
      (_) -> None  
    );
  }
  static public inline function report<T,E>(self:UpshotSum<T,E>):Report<E>{
    return fold(self,
      (ok) -> Report.unit(),
      (er) -> Report.pure(er)
    );
  }
  static public inline function usher<T,E,Z>(self:UpshotSum<T,E>,fn:Option<Decline<E>>->Z):Z{
    return report(self).usher(fn);
  }
  static public inline function rectify<T,E>(self:UpshotSum<T,E>,fn:Refuse<E>->UpshotSum<T,E>):UpshotSum<T,E>{
    return fold(
      self,
      (ok)  -> Upshot.accept(ok),
      (no)  -> fn(no)
    );
  }
  static public inline function recover<T,E>(self:UpshotSum<T,E>,fn:Refuse<E>->T):T{
    return fold(
      self,
      (v) -> v,
      (e) -> fn(e)
    );
  }
  static public function effects<T,E>(self:UpshotSum<T,E>,success:T->Void,failure:Refuse<E>->Void):Upshot<T,E>{
    return fold(
      self,
      (ok) -> {
        success(ok);
        return Upshot.accept(ok);
      },
      (e) -> {
        failure(e);
        return Upshot.reject(e);
      }
    );
  }
  static public inline function is_ok<T,E>(self:UpshotSum<T,E>):Bool{
    return fold(
      self,
      (_) -> true,
      (_) -> false
    );
  }
  static public function toPledge<T,E>(self:UpshotSum<T,E>):Pledge<T,E>{
    return Pledge.fromUpshot(self);
  }
  static public function pledge<T,E>(self:UpshotSum<T,E>):Pledge<T,E>{
    return Pledge.fromUpshot(self);
  }
  static public function point<T,E>(self:UpshotSum<T,E>,fn:T->Report<E>):Report<E>{
    return fold(
      self,
      (ok)  -> fn(ok),
      e     -> e.report()
    );
  }
  static public function toChunk<T,E>(self:UpshotSum<T,E>):Chunk<T,E>{
    return switch(self){
      case Accept(null) : Tap;
      case Accept(v)    : Val(v);
      case Reject(e)    : End(e);
      case null         : Tap; 
    }
  }
}