package stx.nano.lift;

class LiftTinkErrorToRefuse{
  static public inline function toRefuse<E>(self:tink.core.Error):Refuse<E>{
    return Refuse.make(Some(INTERNAL(__.digests().e_tink_error(self.message,self.code))),None,self.pos);
  }
  static public inline function except<E>(self:tink.core.Error):Refuse<E>{
    return Refuse.make(Some(INTERNAL(__.digests().e_tink_error(self.message,self.code))),None,self.pos);
  }
}