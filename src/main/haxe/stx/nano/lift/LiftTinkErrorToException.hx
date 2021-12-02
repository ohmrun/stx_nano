package stx.nano.lift;

class LiftTinkErrorToException{
  static public inline function toException<E>(self:tink.core.Error):Exception<E>{
    return Exception.make(Some(REFUSE(Digest.fromString(self.message))),None,self.pos);
  }
  static public inline function except<E>(self:tink.core.Error):Exception<E>{
    return Exception.make(Some(REFUSE(Digest.fromString(self.message))),None,self.pos);
  }
}