package stx.nano;

import tink.core.Disposable;
import tink.core.Signal in TinkSignal;

@:using(stx.nano.Signal.SignalLift)
@:forward abstract Signal<T>(TinkSignal<T>) from TinkSignal<T> to TinkSignal<T>{
  static public var _(default,never) = SignalLift;
  public function new(self:TinkSignal<T>) this = self;
  static public function lift<T>(self:TinkSignal<T>){
    return new Signal(self);
  }
  static public function make<T>(f:(fire:T->Void)->CallbackLink, ?init:OwnedDisposable->Void):Signal<T>{
    return lift(new TinkSignal(f,init));
  }
  static public function bind_fold<T,Z,E>(self:Signal<T>,fn:T->Z->Signal<Z>,init:Z):Signal<Z>{
    return lift(new TinkSignal(
      (cb) -> {
        return _.flat_map(
          _.lscan(self,
            function(next:T,memo:Signal<Z>):Signal<Z>{
              return _.flat_map(memo,fn.bind(next));
            },
            new TinkSignal(
              cb -> { cb(init); return () -> {}; }
            )
          )
          ,(z:Signal<Z>) -> z
        ).listen(cb);
      }
    ));
  }
  static public function pure<T>(v:T):Signal<T>{
    return lift(new TinkSignal(
      (cb) -> {
        cb(v);
        return () -> {};
      }
    ));
  }
  public function join(that:Signal<T>):Signal<T>{
    return this.join(that);
  }
  static public function fromArray<T>(arr:Array<T>):Signal<T>{
    return make(
      (cb) -> {
        for(v in arr){
          cb(v);
        }
        return () -> {};
      }
    );
  }
  static public function fromFuture<T>(ft:Future<T>):Signal<T>{
    return make(
      (cb) -> ft.handle(
        (x) -> cb(x)
      )
    );
  }
  //TODO optimise this!
  public function map_filter<Ti>(fn:T->Option<Ti>):Signal<Ti>{
    return map(fn).filter(_ -> _.is_defined()).map(_ -> _.fudge());
  }
  public function filter(fn:T->Bool):Signal<T>{
    return lift(this.filter(fn));
  }
  public function map<Ti>(fn:T->Ti):Signal<Ti>{
    return lift(this.map(fn));
  }
  public function tap(fn:T->Void):Signal<T>{
    return map(
      (x) -> {
        fn(x);
        return x;
      }
    );
  }
  public function prj():TinkSignal<T>{
    return this;
  }
}
class SignalLift{
  static function lift<T>(self:TinkSignal<T>){
    return Signal.lift(self);
  }
  static public function flat_map<T,Ti>(self:Signal<T>,fn:T->Signal<Ti>):Signal<Ti>{
    return lift(new TinkSignal(
      (cb) -> {
        var cancelled = false;
        var links     = [];
        links.push(self.handle(
          (t:T) -> {
            trace(t);
            if(!cancelled){
              var sI    = fn(t);
              links.push(sI.handle(
                  (tI:Ti) -> {
                    trace(tI);
                    cb(tI);
                  }
              ));
            }else{
              throw 'stream already cancelled';
            }
          }
        ));
        return () -> {
          cancelled = true;
          for (link in links){
            for (fn in __.option(link)){
              fn.cancel();
            }
          }
        }
      }
    ));
  }
  static public function lscan<T,Z>(self:Signal<T>,fn:T->Z->Z,unit:Z):Signal<Z>{
    return self.map(
      (t:T) -> unit = fn(t,unit)
    );
  }
  static public function next<T>(self:Signal<T>):Future<T>{
    return self.prj().nextTime(`);
  }
}
