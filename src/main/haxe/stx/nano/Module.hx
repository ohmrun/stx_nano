package stx.nano;

#if tink_core
import tink.core.Future;
#end
class Module extends Clazz{
  #if tink_core
  public function Ft() return new Ft();
  #end
  public function Map() return new Map();
}
#if tink_core
private class Ft extends Clazz{
  public function bind_fold<T,TT>(arr:Array<T>,fn:T->TT->Future<TT>,init:TT):Future<TT>{
    return arr.lfold(
      (next,memo:Future<TT>) -> memo.flatMap(
        (tt) -> fn(next,tt)
      ),
      Future.sync(init)
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
}
#end

private class Map extends Clazz{
  public function String<T>():haxe.ds.Map<String,T>{
    return new haxe.ds.Map();
  }
}