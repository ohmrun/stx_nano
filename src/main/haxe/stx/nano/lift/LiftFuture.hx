package stx.nano.lift;

class LiftFuture{
  #if tink_core
  static public function fudge<T>(self:Future<T>):T{
    var val = null;
    self.handle(
      (x) -> val = x
    );
    return val;
  }
  
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
  public function zip<Ti,Tii>(self:Future<Ti>,that:Future<Tii>):Future<Couple<Ti,Tii>>{
    
    var left    = None;
    var right   = None;
    var trigger = Future.trigger();
    var on_done = function(){
      switch([left,right]){
        case [Some(l),Some(r)]  : trigger.trigger(__.couple(l,r));
        default                 :
      }
    }
    var l_handler = function(l){
      left = Some(l);
      on_done();
    }
    var r_handler = function(r){
      right = Some(r);
      on_done();
    }

    self.handle(l_handler);
    that.handle(r_handler);

    return trigger.asFuture();
  }
  #end
}