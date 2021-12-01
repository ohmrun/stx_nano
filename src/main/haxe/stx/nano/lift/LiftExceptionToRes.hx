package stx.nano.lift;

class LiftExceptionToRes{
  static inline public function toRes<T,E>(self:Exception<E>):Res<T,E>{
    return Reject(self);
  }
  static inline public function reject<T,E>(self:Exception<E>):Res<T,E>{
    return Reject(self);
  }
}