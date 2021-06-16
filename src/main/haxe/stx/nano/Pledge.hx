package stx.nano;

typedef PledgeDef<T,E> = Future<Res<T,E>>;

@:using(stx.nano.Pledge.PledgeLift)
@:forward abstract Pledge<T,E>(PledgeDef<T,E>) from PledgeDef<T,E> to PledgeDef<T,E>{
  static public var _(default,never) = PledgeLift;
  public function new(self) this = self;
  static public function lift<T,E>(self:PledgeDef<T,E>):Pledge<T,E> return new Pledge(self);

  @:noUsing static public function make<T,E>(ch:Res<T,E>):Pledge<T,E>{
    return new Future(
      (f) -> {
        f(ch);
        return null;
      }
    ); 
  }
  @:noUsing static public inline function accept<T,E>(ch:T):Pledge<T,E>       return make(__.accept(ch));
  @:noUsing static public inline function reject<T,E>(e:Err<E>):Pledge<T,E>   return make(__.reject(e));

  @:noUsing static public function bind_fold<T,Ti,E>(it:Array<T>,fm:T->Ti->Pledge<Ti,E>,start:Ti):Pledge<Ti,E>{
    return new Pledge(__.nano().Ft().bind_fold(
      it,
      function(next:T,memo:Res<Ti,E>):Future<Res<Ti,E>>{
        return memo.fold(
          (v) -> fm(next,v).prj(),
          (e) -> make(__.reject(e))
        );
      },
      __.accept(start)
    ));
  }
  @:noUsing static public function seq<T,E>(iter:Array<Pledge<T,E>>):Pledge<Array<T>,E>{
    return bind_fold(
      iter,
      (next:Pledge<T,E>,memo:Array<T>) -> 
        next.map(
          (a) -> memo.snoc(a)
        )
      ,
      []
    );
  }
  @:noUsing static public function lazy<T,E>(fn:Void->T):Pledge<T,E>{
    return lift(Future.irreversible(
      (f) -> f(__.accept(fn()))
    ));
  }
  @:noUsing static public function fromLazyError<T,E>(fn:Void->Err<E>):Pledge<T,E>{
    return fromLazyRes(
      () -> __.reject(fn())
    );
  }
  #if tink_core
  @:noUsing static public function fromTinkPromise<T,E>(promise:Promise<T>):Pledge<T,E>{
    return lift(
      promise.map(
        (outcome) -> switch(outcome){
          case tink.core.Outcome.Success(s) : __.accept(s);
          case tink.core.Outcome.Failure(f) : __.reject(Err.fromTinkError(f));
        }
      )
    );
  }
  @:noUsing static public inline function fromTinkFuture<T,E>(future:Future<T>):Pledge<T,E>{
    return lift(future.map(__.accept));
  }
  #end
  @:noUsing static public function fromLazyRes<T,E>(fn:Void->Res<T,E>):Pledge<T,E>{
    return Future.irreversible(
      (f) -> f(fn())
    );
  }

  @:noUsing static public function err<T,E>(e:Err<E>):Pledge<T,E>{
    return make(__.reject(e));
    return make(__.reject(e));
  }
  @:noUsing static public function fromRes<T,E>(chk:Res<T,E>):Pledge<T,E>{
    return Future.irreversible(
      (cb) -> cb(
        chk
      )
    );
  }
  @:noUsing static public function fromOption<T,E>(m:Option<T>):Pledge<T,E>{
    final val = m.fold((x)->__.accept(x),()->__.reject(__.fault().err(E_UnexpectedNullValueEncountered)));
    return fromRes(val);
  } 
  #if stx_arw
    public function toProduce(){
      return stx.arw.Produce.fromPledge(this);
    }
  #end
  public function prj():PledgeDef<T,E> return this;
  private var self(get,never):Pledge<T,E>;
  private function get_self():Pledge<T,E> return lift(this);

  public function map<Ti>(fn:T->Ti):Pledge<Ti,E>{
    return _.map(this,fn);
  }
  public function flat_map<Ti>(fn:T->Pledge<Ti,E>):Pledge<Ti,E>{
    return _.flat_map(this,fn);
  }
  #if js
  @:noUsing static public function fromJsPromise<T,E>(self:js.lib.Promise<T>,?pos:Pos):Pledge<T,E>{
    var t = Future.trigger();
    self.then(
      ok -> {
        t.trigger(__.accept(ok));
      },
      (no:Dynamic) -> {
        switch(std.Type.typeof(no)){
          case TClass(js.lib.Error) :
            var e : js.lib.Error = no; 
            t.trigger(__.reject(__.fault(pos).any(e.message)));
          default : 
            t.trigger(__.reject(__.fault(pos).any(no)));
        }
      }
    ).catchError(
      (e) -> {
        var e1 : js.lib.Error = e; 
            t.trigger(__.reject(__.fault(pos).any(e1.message)));
      }
    );
    return lift(t.asFuture());
  }
  #end
  
}
// @:allow(stx.nano.Pledge) private class PledgeCls<T,E>{
//   private final forward : Future<Res<T,Err<E>>>;

//   public function new(forward){
//     this.forward = forward;
//   }
//   public function prj():PledgeCls<T,E> return this;
  
//   public function map<Ti>(fn:T->Ti):Pledge<Ti,E>{
//     return _.map(this.forward,fn);
//   }
//   public function flat_map<Ti>(fn:T->Pledge<Ti,E>):Pledge<Ti,E>{
//     return _.flat_map(this.forward,fn);
//   }
//   public function zip<Tii>(that:Pledge<Tii,E>):Pledge<Couple<T,Tii>,E>{
//     return _.zip(this,that);
//   }
//   public function fold<Ti,E>(val:T->Ti,ers:Null<Err<E>>->Ti):Future<Ti>{
//     return _.fold(this,val,ers);
//   }
// }
class PledgeLift{
  #if js
  static public function toJsPromise<T,E>(self:Pledge<T,E>):js.lib.Promise<Res<T,E>>{
    var promise = new js.lib.Promise(
      (resolve,reject) -> {
        try{
          self.handle(
            (res) -> {
              res.fold(
                (v) -> {
                  resolve(__.accept(v));
                },
                (e) -> {
                  reject(__.reject(e));
                }
              );
            }
          );
        }catch(e:Err<Dynamic>){
          reject(__.reject(e));
        }catch(e:Dynamic){
          reject(__.reject(__.fault().any(Std.string(e))));
        }
      }
    );
    return promise;
  }
  static public function toJsPromiseError<T,E>(self:Pledge<T,E>):js.lib.Promise<T>{
    return toJsPromise(self).then(
      (res) -> new js.lib.Promise(
        (resolve,reject) -> res.fold(
          resolve,
          reject
        )
      ) 
    );
  }
  #end
  static private function lift<T,E>(self:Future<Res<T,E>>):Pledge<T,E>{
    return Pledge.lift(self);
  }
  static public function zip<Ti,Tii,E>(self:Pledge<Ti,E>,that:Pledge<Tii,E>):Pledge<Couple<Ti,Tii>,E>{
    var out = __.nano().Ft().zip(self.prj(),that.prj()).map(
      (tp) -> tp.fst().zip(tp.snd())
    );
    return out;
  }
  
  static public function map<T,Ti,E>(self:Pledge<T,E>,fn:T->Ti):Pledge<Ti,E>{
    return lift(self.prj().map(
      (x) -> x.fold(
        (s) -> __.accept(fn(s)),
        __.reject
      )
    ));
  }
  static public function flat_map<T,Ti,E>(self:Pledge<T,E>,fn:T->Pledge<Ti,E>):Pledge<Ti,E>{
    var ft : Future<Res<T,E>> = self.prj();
    return ft.flatMap(
      function(x:Res<T,E>):PledgeDef<Ti,E>{
        return x.fold(
          (v)   -> fn(v).prj(),
          (err) -> Pledge.fromRes(__.reject(err)).prj()
        );
      }
    );
  }
  static public function flat_fold<T,Ti,E>(self:PledgeDef<T,E>,val:T->Future<Ti>,ers:Err<E>->Future<Ti>):Future<Ti>{
    return self.flatMap(
      (res:Res<T,E>) -> res.fold(val,ers)
    );
  }
  static public function fold<T,Ti,E>(self:Pledge<T,E>,val:T->Ti,ers:Null<Err<E>>->Ti):Future<Ti>{
    return self.prj().map(Res._.fold.bind(_,val,ers));
  }
  static public function recover<T,E>(self:Pledge<T,E>,fn:Err<E>->Res<T,E>):Pledge<T,E>{
    return lift(fold(
      self,
      (x) -> __.accept(x),
      (e) -> fn(e)
    ));
  }
  static public function adjust<T,Ti,E,U>(self:Pledge<T,E>,fn:T->Res<Ti,E>):Pledge<Ti,E>{
    return lift(fold(
      self,
      (x) -> fn(x),
      (v) -> __.reject(v)
    ));
  }
  static public function rectify<T,Ti,E,U>(self:Pledge<T,E>,fn:Err<E>->Res<T,E>):Pledge<T,E>{
    return lift(self.prj().map(
      (res:Res<T,E>) -> res.rectify(fn)
    ));
  }
  static public function receive<T,E>(self:Pledge<T,E>,fn:T->Void):Future<Option<Err<E>>>{
    return self.prj().map(
      (res) -> res.fold(
        (v) -> {
          fn(v);
          return None;
        },
        __.option
      )
    );
  }
  static public function fudge<T,E>(self:Pledge<T,E>):Res<T,E>{
    var out = null;
    self.prj().handle(
      (v) -> {
        out = v;
      }
    );
    if(out == null){
      throw __.fault().err(E_ValueNotReady);
    }
    return out;
  }
  static public function point<T,E>(self:PledgeDef<T,E>,fn:T->Report<E>):Alert<E>{
    return Alert.lift(
      self.map(
        (res:Res<T,E>) -> res.fold(
          (x) -> fn(x),
          (e) -> e.report()
      )
    ));
  }
  static public function errata<T,E,EE>(self:Pledge<T,E>,fn:Err<E>->Err<EE>):Pledge<T,EE>{
    return self.prj().map(
      (chk) -> chk.errata(fn)
    );
  }
  static public inline function errate<T,E,EE>(self:Pledge<T,E>,fn:E->EE):Pledge<T,EE>{
    return errata(self,(x) -> x.map(fn));
  }
  static public function each<T,E>(self:Pledge<T,E>,fn:T->Void,?err:Err<E>->Void){
    self.prj().handle(
      (res) -> res.fold(
        fn,
        (e)  -> {
          __.option(err).fold(
            (f) -> f(e),
            ()  ->  __.crack(e)
          );
        }
      )
    );
  }
  static public function tap<T,E>(self:Pledge<T,E>,fn:Res<T,E>->?Pos->Void,?pos:Pos):Pledge<T,E>{
    return lift(self.prj().map(
      (x:Res<T,E>) -> {
        fn(x,pos);
        return x;
      }
    ));
  }
  static public function command<T,E>(self:Pledge<T,E>,fn:T->Alert<E>):Pledge<T,E>{
    return self.flat_map(
      (t:T) -> fn(t).resolve(t)
    );
  }
  static public function execute<T,E>(self:Pledge<T,E>,fn:Void->Alert<E>):Pledge<T,E>{
    return self.flat_map(
      (t:T) -> fn().resolve(t)
    );
  }
  static public function anyway<T,E>(self:PledgeDef<T,E>,fn:Report<E>->Alert<E>):Pledge<T,E>{
    return self.flatMap(
      (res) -> res.fold(
        (ok)  -> fn(__.report()).flat_fold(
          (err) -> __.reject(err),
          ()    -> __.accept(ok)
        ),
        (err) -> fn(err.report()).flat_fold(
          (err0) -> __.reject(err.merge(err0)),
          ()     -> __.reject(err)
        ) 
      )
    );
  }
  #if tink_core
  static public function toTinkPromise<T,E>(self:Pledge<T,E>):tink.core.Promise<T>{
    return fold(
      self,
      ok -> tink.core.Outcome.Success(ok),
      no -> tink.core.Outcome.Failure(no.toTinkError())
    );
  }
  #end 
}