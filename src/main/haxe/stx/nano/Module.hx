package stx.nano;

#if tink_core
import tink.core.Future;
import tink.core.Future;
#end
class Module extends Clazz{
  public function embed(){
    return new stx.pico.Embed();
  }
  #if tink_core
  public function Ft() return new Ft();
  public function Future() return new Ft();
  #end
  public function Map() return new Map();

  public function command<T>(fn:T->Void):T->T{
    return (v:T) -> {
      fn(v);
      return v;
    }
  }
}
#if tink_core
private class Ft extends Clazz{
  public function bind_fold<T,TT>(arr:Iter<T>,fn:T->TT->Future<TT>,init:TT):Future<TT>{
    //trace("bind_fold");
    return arr.lfold(
      (next:T,memo:Future<TT>) -> {
        trace(next);
        return memo.flatMap(
          (tt) -> {
            //trace(tt);
            final result = fn(next,tt);
            return result;
          }
        );
      },
      Future.irreversible((cb) -> cb(__.tracer()(init)))
    );
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
  public function tryAndThenCancelIfNotAvailable<T>(ft:Future<T>):Option<T>{
    var output : Option<T>   = None;
 
    var canceller = ft.handle(
      (x) -> output = Some(x)
    );
    if(!output.is_defined()){
      canceller.cancel();
    }
    return output;
  }
  public function squeeze<T>(ft:Future<T>):Option<T>{
    return tryAndThenCancelIfNotAvailable(ft);
  }
  public function option<T>(ft:Future<T>):Option<T>{
    var output    : Option<T>   = None;
    var finished  : Bool        = false;
    ft.handle(
      (x) -> {
        if (!finished) {
          output = Some(x);
        }
      }
    );
    finished = true;
    return output;
  }
}
private class Sig{
  
}
#end

private class Map extends Clazz{
  public function String<T>():haxe.ds.Map<String,T>{
    return new haxe.ds.Map();
  }
  
}