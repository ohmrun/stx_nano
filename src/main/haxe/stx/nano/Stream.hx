package stx.nano;

import tink.core.Callback;
import tink.core.Disposable;
import tink.core.Signal in TinkSignal;


typedef StreamDef<T,E> = Signal<Chunk<T,E>>;

@:using(stx.nano.Stream.StreamLift)
@:forward(handle) abstract Stream<T,E>(StreamDef<T,E>) from StreamDef<T,E>{
  public function new(self) this = self;
  static public function lift<T,E>(self:StreamDef<T,E>):Stream<T,E> return new Stream(self);
  
  static public function fromArray<T,E>(self:Array<T>):Stream<T,E>{
    return lift(Signal.fromArray(self.map(Val).snoc(End())));
  }
  static public function fromFuture<T,E>(self:Future<T>):Stream<T,E>{
    return fromThunkFuture(() -> self);
  }
  static public function fromThunkFuture<T,E>(self:Void->Future<T>):Stream<T,E>{
    return lift(
      Signal.make(
        (cb) -> {
          return self().handle(
            x -> {
              cb(Val(x));
              cb(End());
            }
          );
        }
      )
    );
  }
  static public function pure<T,E>(self:T):Stream<T,E>{
    return lift(
      Signal.make(
        cb -> {
          cb(Val(self));
          cb(End());
          return () -> {};
        }
      )
    );
  }
  static public function unit<T,E>():Stream<T,E>{
    return lift(
      Signal.make(
        (cb:Chunk<T,E>->Void) -> {
          cb(End());
          return () -> {};
        }  
      )
    );
  }
  static public function make<T,E>(f:(fire:Chunk<T,E>->Void)->CallbackLink, ?init:OwnedDisposable->Void):Stream<T,E>{
    return lift(new TinkSignal(f,init));
  }
  public function map<Ti>(fn:T->Ti):Stream<Ti,E>{
    return this.map(
      (chunk) -> chunk.map(fn)  
    );
  }
  public function prj():StreamDef<T,E> return this;
  private var self(get,never):Stream<T,E>;
  private function get_self():Stream<T,E> return lift(this);
}
class StreamLift{
  static function lift<T,E>(self:StreamDef<T,E>):Stream<T,E>{
    return Stream.lift(self);
  }
  static public function seq<T,E>(self:Stream<T,E>,that:Stream<T,E>):Stream<T,E>{
    var ended = false;
    return lift(Signal.make(
      (cb) -> {
        var cbII = null;
        var cbI  = self.handle(
          (chunk) -> chunk.fold(
              val -> cb(Val(val)),
              end -> __.option(end).fold(
                err -> cb(End(err)),
                ()  -> {
                  cbII = that.handle(
                    (chunk) -> chunk.fold(
                      (val) -> {
                        if(!ended){
                          cb(Val(val));
                        }else{
                          cb(End(__.fault().any("already ended")));
                        }
                      },
                      (end) -> {
                        ended = true;
                        cb(End(end));
                      },
                      ()    -> {}
                    )
                  );
                }
              ),
              () -> {}
            )
        );
        return () -> {
          __.option(cbI).defv(new SimpleLink(()->{})).cancel();
          __.option(cbII).defv(new SimpleLink(()->{})).cancel();
        }
      }
    ));
  }
  static public function flat_map<T,Ti,E>(self:Stream<T,E>,fn:T->Stream<Ti,E>){
    var cancelled = false;
    var streams   = [];
    var id        = Math.random();
    return lift(
      new TinkSignal(
        (cb) -> {
          //trace(id);
          self.handle(
            (chunk) -> chunk.fold(
              val -> {
                if(!cancelled){
                  //trace(val);
                  //trace("ADDED STREAM");
                  streams.push(fn(val));
                }
              },
              end -> __.option(end).fold(
                err -> {
                  //trace('CANCELLED $err');
                  //cancelled = true;
                  streams   = [];
                  cb(End(err));
                },
                () -> {
                  //trace('SEQ ${streams.length}');
                  streams.lfold1(seq).defv(Stream.unit()).handle(
                    chunk -> {
                      //trace(chunk);
                      cb(chunk);
                    }
                  );
                }
              ),
              () -> {
                
              }
            )
          );
          return () -> {};
        }
      )
    );
  }
  static public function next<T,E>(self:Stream<T,E>):Future<Chunk<T,E>>{
    return self.prj().nextTime();
  }
}