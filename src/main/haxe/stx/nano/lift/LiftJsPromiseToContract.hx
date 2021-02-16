package stx.nano.lift;

class LiftJsPromiseToContract{
  #if js
  static public function toContract<T,E>(self:js.lib.Promise<T>):Contract<T,E>{
    return Contract.fromJsPromise(self);
  }
  #end
}