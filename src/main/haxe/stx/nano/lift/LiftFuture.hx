package stx.nano.lift;

class LiftFuture{
  static public function fudge<T>(self:Future<T>):T{
    var val = null;
    self.handle(
      (x) -> val = x;
    );
    return val;
  }
}