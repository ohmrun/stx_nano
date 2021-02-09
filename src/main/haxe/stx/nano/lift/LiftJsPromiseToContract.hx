package stx.nano.lift;

class LiftJsPromiseToContract{
  #if js
  static public function toJsPromise<T,E>(self:Contract<T,E>):js.lib.Promise<Res<Option<T>,E>>{
    return Contract._.toJsPromise(self);
  }
  #end
}