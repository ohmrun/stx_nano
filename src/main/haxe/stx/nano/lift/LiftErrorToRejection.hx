package stx.nano.lift;

class LiftErrorToRejection{
  static public function except<E>(self:Error<E>):Rejection<E>{
    return Rejection.lift(self.errate(REJECT));
  }
}