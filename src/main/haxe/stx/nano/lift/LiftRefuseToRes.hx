package stx.nano.lift;

class LiftRefuseToRes{
  static inline public function toUpshot<T,E>(self:Refuse<E>):Upshot<T,E>{
    return Reject(self);
  }
  static inline public function reject<T,E>(self:Refuse<E>):Upshot<T,E>{
    return Reject(self);
  }
}