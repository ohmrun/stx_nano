package stx.nano.lift;

class LiftErrorToReport{
  static public function report<E>(self:Error<E>):Report<E>{
    return Report.pure(self);
  }
}