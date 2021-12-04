package stx.nano.lift;

class LiftRejectionToRes{
  static inline public function toRes<T,E>(self:Rejection<E>):Res<T,E>{
    return Reject(self);
  }
  static inline public function reject<T,E>(self:Rejection<E>):Res<T,E>{
    return Reject(self);
  }
}