package stx.nano.lift;

class LiftJsPromiseToContract{
  #if js
  static public function toContract<T,E>(self:js.lib.Promise<T>,?pos:Pos):Contract<T,E>{
    return Contract.fromJsPromise(self,pos);
  }
  #end
}