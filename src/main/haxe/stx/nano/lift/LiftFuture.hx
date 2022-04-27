package stx.nano.lift;

class LiftFuture{
  static public function fudge<T>(self:Future<T>):T{
    var val = null;
    self.handle(
      (x) -> val = x
    );
    return val;
  }
  #if tink_core
  static public function option<T>(future:tink.core.Future<T>):Option<T>{
    var result    = None;
    var cancelled = false;
    future.handle(
      (x) -> {
        cancelled = true;
        result    = Some(x);
      }
    );
    return result;
  }
  #end
}