package stx.nano.lift;

class LiftTinkErrorToRejection{
  static public inline function toRejection<E>(self:tink.core.Error):Rejection<E>{
    return Rejection.make(Some(REFUSE(Digest.fromString(self.message))),None,self.pos);
  }
  static public inline function except<E>(self:tink.core.Error):Rejection<E>{
    return Rejection.make(Some(REFUSE(Digest.fromString(self.message))),None,self.pos);
  }
}