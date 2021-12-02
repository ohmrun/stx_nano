package stx.nano.lift;

class LiftError{
  static public function report<E>(error:Exception<E>):Report<E>{
    return Reported(error);
  }
  static public function toTinkError<E>(self:Error<E>,code=500):tink.core.Error{
    return tink.core.Error.withData(code, 'TINK_ERROR', self.content(), self.pos.defv(null));
  }
}