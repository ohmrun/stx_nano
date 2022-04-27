package stx.nano.lift;

class LiftError{
  static public function fault<E>(self:Error<E>):Fault{
    return Fault.lift(self.pos.defv(null));
  }
  static public function report<E>(error:Refuse<E>):Report<E>{
    return Reported(error);
  }
  static public function toTinkError<E>(self:Error<E>,code=500):tink.core.Error{
    return tink.core.Error.withData(code, 'TINK_ERROR', Iter.lift(self), self.pos.defv(null));
  }
}