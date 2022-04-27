package stx.nano.lift;

class LiftErrorToRefuse{
  static public inline function except<E>(self:Error<E>):Refuse<E>{
    return Refuse.lift(self.errate(EXTERIOR));
  }
}