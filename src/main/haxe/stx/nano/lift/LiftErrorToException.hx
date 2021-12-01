package stx.nano.lift;

class LiftErrorToException{
  static public function except<E>(self:Error<E>):Exception<E>{
    return self.map(EXCEPT);
  }
}