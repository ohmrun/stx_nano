package stx.nano.lift;

class LiftTinkErrorToRejection{
  static public inline function toRejection<E>(self:tink.core.Error):Rejection<E>{
    return Rejection.make(Some(REFUSE(__.digests().e_tink_error(self.message,self.code))),None,self.pos);
  }
  static public inline function except<E>(self:tink.core.Error):Rejection<E>{
    return Rejection.make(Some(REFUSE(__.digests().e_tink_error(self.message,self.code))),None,self.pos);
  }
}