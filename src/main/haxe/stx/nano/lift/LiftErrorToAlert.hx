package stx.nano.lift;

class LiftErrorToAlert{
  static public function alert<E>(self:Error<E>):Alert<E>{
    return self.errate(__.decline).report().alert();
  }
}