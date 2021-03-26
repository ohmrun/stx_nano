package stx.nano.lift;

class LiftJsPromiseToPledge{
  #if js
  static public function toPledge<T,E>(self:js.lib.Promise<T>,?pos:Pos):Pledge<T,E>{
    return Pledge.fromJsPromise(self,pos);
  }
  #end
}